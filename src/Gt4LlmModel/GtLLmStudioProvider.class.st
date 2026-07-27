Class {
	#name : #GtLLmStudioProvider,
	#superclass : #GtLModelProvider,
	#category : #'Gt4LlmModel-Model'
}

{ #category : #'as yet unclassified' }
GtLLmStudioProvider >> initialize [
	| client |

	super initialize.
	client := GtLOllamaClient new.
	client baseUrl: 'http://localhost:1234' asZnUrl.
	model 
		provider: self;
		client: client.
	model
		endpointAt: 'availableModels' put: GtLOpenAiV1AvailableModelsEndpoint new.
	self responses.
]
