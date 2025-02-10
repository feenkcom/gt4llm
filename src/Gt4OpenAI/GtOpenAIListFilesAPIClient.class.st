Class {
	#name : #GtOpenAIListFilesAPIClient,
	#superclass : #GtLlmEndpointClient,
	#category : #'Gt4OpenAI-Client'
}

{ #category : #'as yet unclassified' }
GtOpenAIListFilesAPIClient >> request [
	^ self client get: '/files'
]

{ #category : #'as yet unclassified' }
GtOpenAIListFilesAPIClient >> serializationClass [
	^ GtOpenAIFilesGroup
]
