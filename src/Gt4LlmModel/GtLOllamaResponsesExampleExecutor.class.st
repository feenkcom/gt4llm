Class {
	#name : #GtLOllamaResponsesExampleExecutor,
	#superclass : #GtLModelExamplesExecutor,
	#category : #'Gt4LlmModel-Examples'
}

{ #category : #asserting }
GtLOllamaResponsesExampleExecutor >> assertRequest: znRequest isSimilarTo: expectedZnRequest [
	"Perform a very basic comparison of the supplied requests"
	| request expectedRequest |

	request := NeoJSONReader fromString: znRequest contents.
	expectedRequest := NeoJSONReader fromString: expectedZnRequest contents.

	self assert: request keys asSet equals: expectedRequest keys asSet.
]

{ #category : #asserting }
GtLOllamaResponsesExampleExecutor >> assertResponseStringContent: responseMessage [
	| responseContent |

	responseContent := responseMessage content.
	self assert: responseContent size equals: 1.
	responseContent first do: [ :jsonObject |
		self assert: (jsonObject at: 'type') equals: 'output_text'.
		self assert: (jsonObject at: 'text') isString ].
]

{ #category : #accessing }
GtLOllamaResponsesExampleExecutor >> provider [

	provider ifNotNil: [ ^ provider ].

	provider := GtLOllamaProvider new 
		responses;
		modelName: 'tinyllama'.
	^ provider.
]
