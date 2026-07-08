Class {
	#name : #GtLDataSourceOpenAiResponsesResponseParser,
	#superclass : #GtLDataSourceResponseParser,
	#category : #'Gt4Llm-DataSource-Parser'
}

{ #category : #private }
GtLDataSourceOpenAiResponsesResponseParser >> parseAssistantResponse: requestResponse to: index response: response for: aMessageConstructor [
	| newMessage chat assistantRawData |
	
	chat := aMessageConstructor chat.
	newMessage := chat provider assistantMessageClass new.
	assistantRawData := (requestResponse result at: 'output') last.
	newMessage
		requestResponse: requestResponse;
		rawData: assistantRawData.
	chat addAssistantMessage: newMessage.
	^ newMessage
]

{ #category : #api }
GtLDataSourceOpenAiResponsesResponseParser >> parseResponse: requestResponse to: index for: aMessageConstructor [
	| jsonResponse responseEntity response |

	jsonResponse := requestResponse response asGtJson jsonObject.
	responseEntity := GtLOpenAiResponsesResponseEntity rawData: jsonResponse.
	response := (GtLOpenAIResponse from: requestResponse result)
		requestResponse: requestResponse.
	response hasToolCalls ifTrue:
		[ self parseToolResponse: requestResponse to: index response: response for: aMessageConstructor
		"See GtLModelProvider>>#performToolCallsIn:with:" ]
	ifFalse:
		[ self parseAssistantResponse: requestResponse to: index response: response for: aMessageConstructor ].
]

{ #category : #private }
GtLDataSourceOpenAiResponsesResponseParser >> parseToolResponse: requestResponse to: index response: response for: aMessageConstructor [
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
