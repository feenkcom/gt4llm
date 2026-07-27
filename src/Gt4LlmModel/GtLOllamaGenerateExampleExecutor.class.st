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

{ #category : #api }
GtLOllamaGenerateExampleExecutor >> ollamaGenerateModel: aString responses: aSelector in: exampleObject [
	| provider |

	provider := GtLOllamaProvider new 
		generate;
		modelName: aString.
	model := provider model.
	self configureModelWithResponses: aSelector in: exampleObject.
	^ self newChatFromModel.
]
