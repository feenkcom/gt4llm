Class {
	#name : #GtLDataSourceEncoderDecoderExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-DataSource-Examples'
}

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

	chat := GtLDataSourceEncoderDecoder
		recreateChatFromStream: stream contents readStream
		provider: provider.
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
