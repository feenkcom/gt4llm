Class {
	#name : #GtLDataSourceEncoderDecoderExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-DataSource-Examples'
}

{ #category : #private }
GtLDataSourceEncoderDecoderExamples >> assertConfiguredChatReconstructionUsingCompletions: completions [
	| provider chat liveTools instructions format storage history request response file result calls rejected |
	provider := completions
		ifTrue: [ GtLOllamaProvider new completions; modelName: 'qwen3.5:9b' ]
		ifFalse: [ GtLOpenAiResponsesProvider new modelName: 'gpt-4.1' ].
	chat := GtLChat new provider: provider.
	liveTools := GtLTools new items: { GtLMagritteToolForMethodsSource new }.
	chat tools: liveTools.
	instructions := chat instructions.
	format := chat format.
	storage := chat objectStorage.
	request := ZnRequest post: 'http://localhost/example'.
	request entity: (ZnStringEntity json: (completions
		ifTrue: [ '{"model":"qwen3.5:9b","tools":[{"type":"function","function":{"name":"historical","description":"recorded","parameters":{"type":"object","properties":{}}}}],"messages":[{"role":"user","content":[{"type":"text","text":"hello"}]}]}' ]
		ifFalse: [ '{"model":"gpt-4.1","tools":[{"type":"function","name":"historical","description":"recorded","parameters":{"type":"object","properties":{}}}],"input":[{"role":"user","content":[{"type":"input_text","text":"hello"}]}]}' ])).
	response := ZnResponse ok: (ZnStringEntity json: (completions
		ifTrue: [ '{"choices":[{"message":{"role":"assistant","content":null,"tool_calls":[{"id":"call","type":"function","function":{"name":"historical","arguments":"{}"}}]},"finish_reason":"tool_calls"}]}' ]
		ifFalse: [ '{"output":[{"type":"function_call","call_id":"call","name":"historical","arguments":"{}"}]}' ])).
	history := GtLRequestHistory new.
	(history addRequest: request response: response) result: response asGtJson jsonObject.
	file := FileSystem memory root / 'chat.jsonl'.
	file writeStreamDo: [ :stream | GtLDataSourceEncoderDecoder saveClientHistory: history toStream: stream ].
	result := GtLDataSourceEncoderDecoder recreateChatFrom: file chat: chat.
	self assert: result == chat.
	self assert: chat tools == liveTools.
	self assert: chat provider == provider.
	self assert: chat instructions == instructions.
	self assert: chat format == format.
	self assert: chat objectStorage == storage.
	calls := chat messages messagesSelect: [ :each | each isToolMessage ].
	self assert: calls size equals: 1.
	self assert: (calls first toolCall tool isKindOf: GtLJsonPlaceholderTool).
	self assert: calls first toolCall tool name equals: 'historical'.
	self assert: calls first tools first name equals: 'historical'.
	rejected := false.
	[ GtLDataSourceEncoderDecoder recreateChatFrom: file chat: chat ] on: AssertionFailure do: [ :error | rejected := true ].
	self assert: rejected.
	^ chat
]

{ #category : #examples }
GtLDataSourceEncoderDecoderExamples >> completionsReconstructionIntoConfiguredChat [
	<gtExample>
	^ self assertConfiguredChatReconstructionUsingCompletions: true
]

{ #category : #examples }
GtLDataSourceEncoderDecoderExamples >> reconstructedCompletionsToolCallsPreserveOutputs [
	<gtExample>
	| history request response stream chat calls tools provider originalToolsSize |
	provider := GtLOllamaProvider new completions; modelName: 'qwen3.5:9b'.
	tools := '[{"type":"function","function":{"name":"recorded","description":"Historical tool","strict":true,"parameters":{"type":"object","properties":{}}}}]'.
	history := GtLRequestHistory new.
	request := ZnRequest post: 'http://localhost:11434/v1/chat/completions'.
	request entity: (ZnStringEntity json: '{"model":"qwen3.5:9b","tools":', tools, ',"messages":[{"role":"user","content":[{"type":"text","text":"hello"}]}]}').
	response := ZnResponse ok: (ZnStringEntity json: '{"choices":[{"message":{"role":"assistant","content":null,"tool_calls":[{"id":"first","type":"function","function":{"name":"recorded","arguments":"{}"}},{"id":"second","type":"function","function":{"name":"recorded","arguments":"{}"}}]},"finish_reason":"tool_calls"}]}').
	(history addRequest: request response: response) result: response asGtJson jsonObject.
	2 timesRepeat: [
		request := ZnRequest post: 'http://localhost:11434/v1/chat/completions'.
		request entity: (ZnStringEntity json: '{"model":"qwen3.5:9b","tools":', tools, ',"messages":[{"role":"tool","tool_call_id":"second","content":"error output"},{"role":"tool","tool_call_id":"first","content":""}]}').
		response := ZnResponse ok: (ZnStringEntity json: '{"choices":[{"message":{"role":"assistant","content":"done"},"finish_reason":"stop"}]}').
		(history addRequest: request response: response) result: response asGtJson jsonObject ].
	stream := String new writeStream.
	GtLDataSourceEncoderDecoder saveClientHistory: history toStream: stream.
	chat := GtLChat new provider: provider.
	originalToolsSize := chat tools size.
	GtLDataSourceEncoderDecoder recreateChatFromStream: stream contents readStream chat: chat.
	calls := chat messages messagesSelect: [ :each | each isToolMessage ].
	self assert: calls size equals: 2.
	calls do: [ :message |
		self assert: message toolCall tool name equals: 'recorded'.
		self assert: message toolCall tool functionOpenAI equals: ((history first request asGtJson jsonObject at: 'tools') first).
		self assert: message toolCall result == message output.
		self assert: message isExecutionStateFinished ].
	self assert: calls first output serializeToOllamaOpenAiResponseOutput equals: ''.
	self assert: (calls at: 2) output serializeToOllamaOpenAiResponseOutput equals: 'error output'.
	self assert: chat tools size equals: originalToolsSize.
	^ chat
]

{ #category : #examples }
GtLDataSourceEncoderDecoderExamples >> reconstructedOpenAiResponsePreservesServerSideCompactions [
	<gtExample>
	| provider history request response requestResponse stream chat flattenedMessages |

	provider := GtLOpenAiResponsesProvider new.
	request := ZnRequest post: 'https://api.openai.com/v1/responses'.
	request entity: (ZnStringEntity json: '{"model":"gpt-4.1","tools":[],"input":[{"role":"user","content":[{"type":"input_text","text":"hello"}]}]}').
	response := ZnResponse ok: (ZnStringEntity json: '{"output":[{"type":"compaction","encrypted_content":"first"},{"type":"message","role":"assistant","content":[{"type":"output_text","text":"answer"}]},{"type":"compaction","encrypted_content":"second"}]}').
	history := GtLRequestHistory new.
	requestResponse := history addRequest: request response: response.
	requestResponse result: response asGtJson jsonObject.
	stream := String new writeStream.
	GtLDataSourceEncoderDecoder saveClientHistory: history toStream: stream.

	chat := GtLChat new provider: provider.
	GtLDataSourceEncoderDecoder
		recreateChatFromStream: stream contents readStream
		chat: chat.
	flattenedMessages := chat messages messagesSelect: [ :each | true ].

	self assert: flattenedMessages size equals: 4.
	self assert: (flattenedMessages at: 1) isUserMessage.
	self assert: (flattenedMessages at: 2) isCompactionMessage.
	self assert: (flattenedMessages at: 3) role equals: 'assistant'.
	self assert: (flattenedMessages at: 4) isCompactionMessage.
	self assert: (flattenedMessages at: 2) rawData equals: ((requestResponse result at: 'output') first).
	self assert: (flattenedMessages at: 4) rawData equals: ((requestResponse result at: 'output') third).
	^ chat
]

{ #category : #examples }
GtLDataSourceEncoderDecoderExamples >> reconstructedPendingToolCall [
	<gtExample>
	| history request response stream chat message |
	request := ZnRequest post: 'https://api.openai.com/v1/responses'.
	request entity: (ZnStringEntity json: '{"model":"gpt-4.1","tools":[{"type":"function","name":"pending","description":"Not executed","parameters":{"type":"object","properties":{}}}],"input":[{"role":"user","content":[{"type":"input_text","text":"hello"}]}]}').
	response := ZnResponse ok: (ZnStringEntity json: '{"output":[{"type":"function_call","call_id":"pending-call","name":"pending","arguments":"{}"}]}').
	history := GtLRequestHistory new.
	(history addRequest: request response: response) result: response asGtJson jsonObject.
	stream := String new writeStream.
	GtLDataSourceEncoderDecoder saveClientHistory: history toStream: stream.
	chat := GtLChat new provider: GtLOpenAiResponsesProvider new.
	GtLDataSourceEncoderDecoder 
		recreateChatFromStream: stream contents readStream 
		chat: chat.
	message := (chat messages messagesSelect: [ :each | each isToolMessage ]) first.
	self assert: message toolCall tool name equals: 'pending'.
	self assert: message toolCall result isNil.
	self assert: message output isNil.
	self assert: message toolCall isFinished not.
	^ chat
]

{ #category : #examples }
GtLDataSourceEncoderDecoderExamples >> reconstructedToolCallsPreserveRecordedOutputs [
	<gtExample>
	| history request response stream chat messages input definitions serialized expected originalToolsSize |
	history := GtLRequestHistory new.
	definitions := '[{"type":"function","name":"recorded","description":"Historical tool","strict":true,"parameters":{"type":"object","properties":{},"required":[],"additionalProperties":false}}]'.
	input := '[{"role":"user","content":[{"type":"input_text","text":"hello"}]}]'.
	request := ZnRequest post: 'https://api.openai.com/v1/responses'.
	request entity: (ZnStringEntity json: '{"model":"gpt-4.1","tools":', definitions, ',"input":', input, '}').
	response := ZnResponse ok: (ZnStringEntity json: '{"output":[{"type":"function_call","call_id":"first","name":"recorded","arguments":"{}"},{"type":"function_call","call_id":"second","name":"recorded","arguments":"{}"}]}').
	(history addRequest: request response: response) result: response asGtJson jsonObject.
	input := '[{"type":"function_call_output","call_id":"second","output":[{"type":"input_text","text":"{\"error\":true}"}]},{"type":"function_call_output","call_id":"first","output":""}]'.
	2 timesRepeat: [
		request := ZnRequest post: 'https://api.openai.com/v1/responses'.
		request entity: (ZnStringEntity json: '{"model":"gpt-4.1","tools":', definitions, ',"input":', input, '}').
		response := ZnResponse ok: (ZnStringEntity json: '{"output":[{"type":"message","role":"assistant","content":[{"type":"output_text","text":"done"}]}]}').
		(history addRequest: request response: response) result: response asGtJson jsonObject ].
	stream := String new writeStream.
	GtLDataSourceEncoderDecoder saveClientHistory: history toStream: stream.
	chat := GtLChat new provider: GtLOpenAiResponsesProvider new.
	originalToolsSize := chat tools size.
	GtLDataSourceEncoderDecoder 
		recreateChatFromStream: stream contents readStream 
		chat: chat.
	messages := chat messages messagesSelect: [ :each | each isToolMessage ].
	self assert: messages size equals: 2.
	messages do: [ :message |
		self assert: (message toolCall tool isKindOf: GtLJsonPlaceholderTool).
		self assert: message toolCall result == message output.
		self assert: message isExecutionStateFinished.
		self assert: message toolCall executionEndTime isNil.
		self assert: message toolCall tool functionOpenAI equals: ((history first request asGtJson jsonObject at: 'tools') first) ].
	self assert: messages first output serializeToOpenAIResponseOutput equals: ''.
	serialized := (messages at: 2) serializeForOpenAIResponsesAPI.
	expected := (history second request asGtJson jsonObject at: 'input') first.
	expected keysAndValuesDo: [ :key :value | self assert: (serialized at: key) equals: value ].
	self assert: chat tools size equals: originalToolsSize.
	^ chat
]

{ #category : #examples }
GtLDataSourceEncoderDecoderExamples >> reconstructionIntoConfiguredChat [
	<gtExample>
	^ self assertConfiguredChatReconstructionUsingCompletions: false
]

{ #category : #examples }
GtLDataSourceEncoderDecoderExamples >> recordedToolOutputPreservesPayloads [
	<gtExample>
	| payloads wrappers |
	payloads := { ''. 'plain text'. { { 'type' -> 'input_image'. 'image_url' -> 'data:image/png;base64,AA==' } asDictionary. { 'type' -> 'input_text'. 'text' -> '{"error":true}' } asDictionary } }.
	wrappers := payloads collect: [ :payload |
		| wrapper |
		wrapper := GtLRecordedToolOutput new model: payload.
		self assert: wrapper serializeToOpenAIResponseOutput equals: payload.
		wrapper ].
	^ wrappers last
]

{ #category : #examples }
GtLDataSourceEncoderDecoderExamples >> recordedToolOutputRejectsConflicts [
	<gtExample>
	| constructor message rejected |
	constructor := GtLDataSourceMessageConstructor new.
	message := GtLToolMessage new toolCall: GtLFunctionToolCall new.
	self assert: message toolCall isFinished not.
	constructor restoreRecordedOutput: 'first' to: message.
	constructor restoreRecordedOutput: 'first' to: message.
	rejected := false.
	[ constructor restoreRecordedOutput: 'different' to: message ] on: AssertionFailure do: [ :error | rejected := true ].
	self assert: rejected.
	self assert: message output serializeToOpenAIResponseOutput equals: 'first'.
	^ message
]

{ #category : #examples }
GtLDataSourceEncoderDecoderExamples >> requestWithoutEntityEncodesWithoutFailure [
	<gtExample>
	| encoderDecoder request json |
	encoderDecoder := GtLDataSourceEncoderDecoder new.
	request := ZnRequest get: 'https://example.com'.
	json := String streamContents: [ :stream |
		encoderDecoder encode: request on: stream ].
	self assert: (json includesSubstring: '"requestLine"').
	self assert: ((json includesSubstring: '"entity"') not).
	^ json
]
