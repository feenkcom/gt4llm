Class {
	#name : #GtLDataSourceOpenAiResponsesResponseParser,
	#superclass : #GtLDataSourceResponseParser,
	#category : #'Gt4Llm-DataSource-Parser'
}

{ #category : #private }
GtLDataSourceOpenAiResponsesResponseParser >> parseAssistantResponse: requestResponse to: inputMessage response: response for: aMessageConstructor [
	| newMessage chat assistantRawData result compactionMessages partitionedCompactionMessages |

	chat := aMessageConstructor chat.
	assistantRawData := requestResponse result.
	result := (GtLModelResponse from: assistantRawData)
		requestResponse: requestResponse.
	compactionMessages := chat provider
		automaticCompactionMessagesFrom: result
		inputMessage: inputMessage.
	partitionedCompactionMessages := chat provider
		partitionAutomaticCompactionMessages: compactionMessages
		from: result
		inputMessage: inputMessage.
	partitionedCompactionMessages first do: [ :each |
		inputMessage ifNotNil: [ each updateDataFromMessage: inputMessage ].
		chat addCompactionMessage: each ].

	newMessage := chat provider assistantMessageClass new.
	newMessage
		requestResponse: requestResponse;
		rawData: assistantRawData.
	chat addAssistantMessage: newMessage.

	partitionedCompactionMessages second do: [ :each |
		inputMessage ifNotNil: [ each updateDataFromMessage: inputMessage ].
		chat addPostExecutionMessage: each ].
	^ newMessage
]

{ #category : #api }
GtLDataSourceOpenAiResponsesResponseParser >> parseResponse: requestResponse message: message for: aMessageConstructor [
	| response |

	response := (GtLOpenAIResponse from: requestResponse result)
		requestResponse: requestResponse.
	response hasToolCalls ifTrue:
		[ self parseToolResponse: requestResponse to: message response: response for: aMessageConstructor
		"See GtLModelProvider>>#performToolCallsIn:with:" ]
	ifFalse:
		[ self parseAssistantResponse: requestResponse to: message response: response for: aMessageConstructor ].
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
