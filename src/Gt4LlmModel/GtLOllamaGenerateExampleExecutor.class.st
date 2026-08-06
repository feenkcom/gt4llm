Class {
	#name : #GtLOllamaGenerateExampleExecutor,
	#superclass : #GtLModelExamplesExecutor,
	#category : #'Gt4LlmModel-Examples'
}

{ #category : #asserting }
GtLOllamaGenerateExampleExecutor >> assertFirstResponseContent: chat [
	| responseMessage jsonDictionary |

	self assertChatResponseOK: chat.

	self isLive ifTrue: [ ^ self ].

	jsonDictionary := NeoJSONReader fromString: expectedResponses first contents.
	responseMessage := chat messages last contentText.
	self assert: responseMessage equals: (jsonDictionary at: 'response').
]

{ #category : #'as yet unclassified' }
GtLOllamaGenerateExampleExecutor >> assertResponseGenerateStringContent: responseMessage [
	| responseContent |

	responseContent := responseMessage requestResponse result.
	self assert: (responseContent at: 'model') isString.
	self assert: (responseContent at: 'response') isString.
	self assert: (responseContent at: 'done').
]

{ #category : #accessing }
GtLOllamaGenerateExampleExecutor >> provider [

	provider ifNotNil: [ ^ provider ].

	provider := GtLOllamaProvider new 
		generate;
		modelName: 'tinyllama'.
	^ provider.
]
