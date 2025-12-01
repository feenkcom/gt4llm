Class {
	#name : #GtLOpenAIListFilesAPIClient,
	#superclass : #GtLlmEndpointClient,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #'as yet unclassified' }
GtLOpenAIListFilesAPIClient >> request [
	^ self client get: '/files'
]

{ #category : #'as yet unclassified' }
GtLOpenAIListFilesAPIClient >> serializationClass [
	^ GtLOpenAIFilesGroup
]
