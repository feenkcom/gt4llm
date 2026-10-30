"
Reconstruct chat messages from the supplied {{gtClass:GtLRequestHistory}}. 
"
Class {
	#name : #GtLDataSourceMessageConstructor,
	#superclass : #Object,
	#instVars : [
		'requestHistory',
		'messages',
		'chat',
		'requestParser',
		'responseParser',
		'recordedTools',
		'preserveChatConfiguration'
	],
	#category : #'Gt4Llm-DataSource-Model'
}

{ #category : #'as yet unclassified' }
GtLDataSourceMessageConstructor >> addToolsFrom: toolEntities to: message [
	"Tools may require state that is not present in the datasource, so are replaced with a GtLJsonPlaceholderTool."
	| tools |

	tools := GtLTools new items: (toolEntities collect:
		[ :toolEntity |
			GtLJsonPlaceholderTool new
				entity: toolEntity ]).
	message tools: tools.
]

{ #category : #accessing }
GtLDataSourceMessageConstructor >> chat [
	^ chat
]

{ #category : #accessing }
GtLDataSourceMessageConstructor >> chat: aGtLChat [

	chat := aGtLChat.
	requestParser := self model optionAt: 'dataSourceRequestParser'.
	responseParser := self model optionAt: 'dataSourceResponseParser'.
]

{ #category : #parsing }
GtLDataSourceMessageConstructor >> jsonObjectFrom: aString [
	| text |
	aString ifNil: [ ^ nil ].
	text := aString isString ifTrue: [ aString ] ifFalse: [ aString text ].
	text ifNil: [ ^ nil ].
	^ [ (NeoJSONReader on: text readStream) next ] on: Error do: [ :ex | text ]
]

{ #category : #'as yet unclassified' }
GtLDataSourceMessageConstructor >> messages [

]

{ #category : #accessing }
GtLDataSourceMessageConstructor >> model [

	^ chat provider model
]

{ #category : #parsing }
GtLDataSourceMessageConstructor >> parse [
	"Historical definitions are independent of the tools used for future execution."
	requestHistory do: [ :requestResponse |
		preserveChatConfiguration == true ifFalse: [ self setChatFormatDescriptionsFrom: requestResponse ].
		self readRecordedToolsFrom: requestResponse.
		self parseRequestResponse: requestResponse.
		self restoreRecordedToolsFrom: requestResponse ].
	preserveChatConfiguration == true ifFalse: [ chat tools: self recordedTools ].
	^ chat
]

{ #category : #'as yet unclassified' }
GtLDataSourceMessageConstructor >> parseRequestResponse: requestResponse [
	| message |
	
	message := requestParser parseRequest: requestResponse for: self.
	responseParser parseResponse: requestResponse message: message for: self.
]

{ #category : #accessing }
GtLDataSourceMessageConstructor >> preserveChatConfiguration: aBoolean [
	preserveChatConfiguration := aBoolean
]

{ #category : #parsing }
GtLDataSourceMessageConstructor >> readRecordedToolsFrom: aRequestResponse [
	| json responses |
	json := aRequestResponse request asGtJson jsonObject.
	responses := json includesKey: 'input'.
	json at: 'tools' ifPresent: [ :definitions |
		recordedTools := GtLTools new items: (definitions collect: [ :raw |
			GtLJsonPlaceholderTool new entity: (responses
				ifTrue: [ GtLOpenAiToolEntity rawData: raw ]
				ifFalse: [ GtLOllamaCompletionsToolCallEntity rawData: raw ]) ]) ]
]

{ #category : #accessing }
GtLDataSourceMessageConstructor >> recordedTools [
	^ recordedTools ifNil: [ recordedTools := GtLTools new ]
]

{ #category : #accessing }
GtLDataSourceMessageConstructor >> requestHistory [
	^ requestHistory
]

{ #category : #accessing }
GtLDataSourceMessageConstructor >> requestHistory: aGtLRequestHistory [

	requestHistory := aGtLRequestHistory
]

{ #category : #parsing }
GtLDataSourceMessageConstructor >> restoreRecordedOutput: rawOutput to: aMessage [
	| recorded |
	aMessage toolCall result ifNotNil: [ :existing |
		self assert: existing serializeToOpenAIResponseOutput equals: rawOutput.
		^ self ].
	recorded := GtLRecordedToolOutput new model: rawOutput.
	aMessage toolCall result: recorded.
	aMessage output: recorded.
	aMessage beFinishedExecutionState
]

{ #category : #parsing }
GtLDataSourceMessageConstructor >> restoreRecordedToolsFrom: aRequestResponse [
	"Correlate outputs by id; historical calls must never resolve against live tools."
	| json input toolMessages responses |
	json := aRequestResponse request asGtJson jsonObject.
	responses := json includesKey: 'input'.
	input := json at: 'input' ifAbsent: [ json at: 'messages' ifAbsent: [ ^ self ] ].
	toolMessages := chat messages messagesSelect: [ :each | each isToolMessage ].
	toolMessages do: [ :message |
		message toolCall tool ifNil: [
			message tools: self recordedTools.
			self recordedTools do: [ :tool |
				tool name = message toolCall name ifTrue: [ message toolCall performedByTool: tool ] ] ] ].
	input do: [ :entry |
		| callId output isOutput |
		isOutput := responses
			ifTrue: [ (entry at: 'type' ifAbsent: [ nil ]) = 'function_call_output' ]
			ifFalse: [ (entry at: 'role' ifAbsent: [ nil ]) = 'tool' ].
		isOutput ifTrue: [
			callId := entry at: (responses ifTrue: [ 'call_id' ] ifFalse: [ 'tool_call_id' ]) ifAbsent: [ nil ].
			output := entry at: (responses ifTrue: [ 'output' ] ifFalse: [ 'content' ]).
			callId ifNotNil: [ toolMessages do: [ :message |
				message toolCall id = callId ifTrue: [ self restoreRecordedOutput: output to: message ] ] ] ] ]
]

{ #category : #'as yet unclassified' }
GtLDataSourceMessageConstructor >> setChatFormatDescriptionsFrom: requestResponse [
	| content jsonResponse responseEntity |

	jsonResponse := requestResponse response asGtJson jsonObject.
	responseEntity := GtLApiEntity responseEntityFor: jsonResponse.
	content := responseEntity content.
	(content anySatisfy: [ :contentEntity | | jsonObject |
		jsonObject := self jsonObjectFrom: contentEntity.
		jsonObject isDictionary and:
		[ jsonObject includesKey: 'Markdown' ] ])
			ifTrue: [ chat markdownResponse ].
]
