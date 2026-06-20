"
Reconstruct chat messages from the supplied {{gtClass:GtLRequestHistory}}. 
"
Class {
	#name : #GtLDataSourceMessageConstructor,
	#superclass : #Object,
	#instVars : [
		'requestHistory',
		'messages',
		'chat'
	],
	#category : #'Gt4Llm-DataSource-Model'
}

{ #category : #'as yet unclassified' }
GtLDataSourceMessageConstructor >> addToolsFrom: toolEntities to: message [
	| tools toolMap |

	tools := GtLTools new items: (toolEntities collect:
		[ :toolEntity | | name |
			name := toolEntity function at: 'name'.
			(GtLAbstractFunctionTool allSubclasses detect: [ :toolClass |
				toolClass new name = name ]) new ]).
	message tools: tools.
]

{ #category : #'as yet unclassified' }
GtLDataSourceMessageConstructor >> messages [

]

{ #category : #'as yet unclassified' }
GtLDataSourceMessageConstructor >> parse [

	chat := GtLChat new.
	chat provider: GtLOllamaProvider new.
	requestHistory doWithIndex: [ :requestResponse :index |
		self parseRequestResponse: requestResponse at: index ].
	^ chat
]

{ #category : #'as yet unclassified' }
GtLDataSourceMessageConstructor >> parseAssistantResponse: requestResponse at: index response: response [
	| newMessage |
	newMessage := chat provider assistantMessageClass new.
	newMessage
		requestResponse: requestResponse;
		rawData: requestResponse result.
	chat addAssistantMessage: newMessage.
	^ newMessage
]

{ #category : #'as yet unclassified' }
GtLDataSourceMessageConstructor >> parseRequest: requestResponse at: index [
	| jsonRequest request messagesEntity role message |

	jsonRequest := requestResponse request asGtJson jsonObject.
	request := GtLOpenAiCompletionsRequestEntity rawData: jsonRequest.
	chat provider model ifNil:
		[ chat provider modelName: request model ].
	messagesEntity := request messages at: index.
	role := messagesEntity role.
	role = 'user' ifTrue:
		[ message := self parseUserRequest: requestResponse at: index messagesEntity: messagesEntity ].
	role = 'assistant' ifTrue:
		[ message := self parseAssistantRequest: requestResponse at: index messagesEntity: messagesEntity ].
	role = 'tool' ifTrue:
		[ ^ nil ].
	message ifNil:
		[ self error: 'Unknown role: ', role asString ].
	request tools ifNotNil: [ :toolsEntity |
		self addToolsFrom: toolsEntity to: message ].
	^ message
]

{ #category : #'as yet unclassified' }
GtLDataSourceMessageConstructor >> parseRequestResponse: requestResponse at: index [
	| jsonRequest request messagesEntity role message |

	self parseRequest: requestResponse at: index.
	self parseResponse: requestResponse at: index.
]

{ #category : #'as yet unclassified' }
GtLDataSourceMessageConstructor >> parseResponse: requestResponse at: index [
	| jsonResponse responseEntity response messagesEntity role message |

	jsonResponse := requestResponse response asGtJson jsonObject.
	responseEntity := GtLOllamaCompletionsResponseEntity rawData: jsonResponse.
	response := (GtLOllamaResponse from: requestResponse result)
		requestResponse: requestResponse.
	response hasToolCalls ifTrue:
		[ self parseToolResponse: requestResponse at: index response: response
		"See GtLModelProvider>>#performToolCallsIn:with:" ]
	ifFalse:
		[ self parseAssistantResponse: requestResponse at: index response: response ].
]

{ #category : #'as yet unclassified' }
GtLDataSourceMessageConstructor >> parseToolRequest: requestResponse at: index messagesEntity: messagesEntity [
	| contentEntity type |
	
	contentEntity := messagesEntity content first.
	type := contentEntity type.
	^ type = 'text' ifTrue:
		[ GtLModelUserMessage new 
			string: contentEntity text;
			requestResponse: requestResponse ]
	ifFalse:
		[ self error: 'Unknown type: '. type asString ]
]

{ #category : #'as yet unclassified' }
GtLDataSourceMessageConstructor >> parseToolResponse: requestResponse at: index response: response [
	| toolMessages |

	toolMessages := response toolCalls asArray
			withIndexCollect: [ :aToolCall :anIndex | 
				| toolMessage |
				toolMessage := GtLToolMessage new 
					toolCall: aToolCall;
					requestResponse: (GtLToolPreviousRequestResponse new
						previousRequestResponse: response requestResponse;
						toolCallIndex: anIndex) ].
	toolMessages do: [ :toolMessage |
		chat addToolMessage: toolMessage ].
]

{ #category : #'as yet unclassified' }
GtLDataSourceMessageConstructor >> parseUserRequest: requestResponse at: index messagesEntity: messagesEntity [
	| contentEntity type message |
	
	contentEntity := messagesEntity content first.
	type := contentEntity type.
	type = 'text' ifFalse: [ self error: 'Unknown type: ', type asString ].
	message := GtLModelUserMessage new 
			string: contentEntity text;
			requestResponse: requestResponse.
	chat addUserMessage: message.
	^ message
]

{ #category : #accessing }
GtLDataSourceMessageConstructor >> requestHistory [
	^ requestHistory
]

{ #category : #accessing }
GtLDataSourceMessageConstructor >> requestHistory: aGtLRequestHistory [

	requestHistory := aGtLRequestHistory
]
