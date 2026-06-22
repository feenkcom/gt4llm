Class {
	#name : #GtLDataSourceOpenAiCompletionsResponseParser,
	#superclass : #GtLDataSourceResponseParser,
	#category : #'Gt4Llm-DataSource-Parser'
}

{ #category : #private }
GtLDataSourceOpenAiCompletionsResponseParser >> parseAssistantResponse: requestResponse at: index response: response for: aMessageConstructor [
	| newMessage chat |
	
	chat := aMessageConstructor chat.
	newMessage := chat provider assistantMessageClass new.
	newMessage
		requestResponse: requestResponse;
		rawData: requestResponse result.
	chat addAssistantMessage: newMessage.
	^ newMessage
]

{ #category : #api }
GtLDataSourceOpenAiCompletionsResponseParser >> parseResponse: requestResponse at: index for: aMessageConstructor [
	| jsonResponse responseEntity response |

	jsonResponse := requestResponse response asGtJson jsonObject.
	responseEntity := GtLOllamaCompletionsResponseEntity rawData: jsonResponse.
	response := (GtLOllamaResponse from: requestResponse result)
		requestResponse: requestResponse.
	response hasToolCalls ifTrue:
		[ self parseToolResponse: requestResponse at: index response: response for: aMessageConstructor
		"See GtLModelProvider>>#performToolCallsIn:with:" ]
	ifFalse:
		[ self parseAssistantResponse: requestResponse at: index response: response for: aMessageConstructor ].
]

{ #category : #private }
GtLDataSourceOpenAiCompletionsResponseParser >> parseToolResponse: requestResponse at: index response: response for: aMessageConstructor [
	| toolMessages chat |

	chat := aMessageConstructor chat.
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
