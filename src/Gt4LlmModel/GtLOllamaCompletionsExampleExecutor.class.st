Class {
	#name : #GtLOllamaCompletionsExampleExecutor,
	#superclass : #GtLModelExamplesExecutor,
	#category : #'Gt4LlmModel-Examples'
}

{ #category : #asserting }
GtLOllamaCompletionsExampleExecutor >> assertFirstResponseContent: chat [
	| responseMessage jsonDictionary |

	self assertChatResponseOK: chat.

	self isLive ifTrue: [ ^ self ].

	jsonDictionary := NeoJSONReader fromString: expectedResponses first contents.
	responseMessage := chat messages last contentText.
	self assert: responseMessage equals: (((jsonDictionary at: 'choices') first
			at: 'message')
			at: 'content').
]

{ #category : #'as yet unclassified' }
GtLOllamaCompletionsExampleExecutor >> provider [

	provider ifNotNil: [ ^ provider ].

	provider := GtLOllamaProvider new 
		completions;
		modelName: 'tinyllama'.
	^ provider.
]
