Class {
	#name : #GtLOpenAiResponsesExampleExecutor,
	#superclass : #GtLModelExamplesExecutor,
	#category : #'Gt4LlmModel-Examples'
}

{ #category : #asserting }
GtLOpenAiResponsesExampleExecutor >> assertFirstResponseContent: chat [
	| responseMessage jsonDictionary |

	self assertChatResponseOK: chat.

	self isLive ifTrue: [ ^ self ].

	jsonDictionary := NeoJSONReader fromString: expectedResponses first contents.
	responseMessage := chat messages last contentText.
	self assert: responseMessage equals: (((jsonDictionary at: 'choices') first
			at: 'message')
			at: 'content').
]

{ #category : #private }
GtLOpenAiResponsesExampleExecutor >> assertRequest: znRequest isSimilarTo: expectedZnRequest [
	"Perform a very basic comparison of the supplied requests"
	| request expectedRequest |

	request := NeoJSONReader fromString: znRequest contents.
	expectedRequest := NeoJSONReader fromString: expectedZnRequest contents.

	self assert: request keys asSet equals: expectedRequest keys asSet.
]

{ #category : #'as yet unclassified' }
GtLOpenAiResponsesExampleExecutor >> provider [

	provider ifNotNil: [ ^ provider ].

	provider := GtLOpenAiResponsesProvider new 
		responses;
		modelName: 'gpt-5.4'.
	^ provider.
]
