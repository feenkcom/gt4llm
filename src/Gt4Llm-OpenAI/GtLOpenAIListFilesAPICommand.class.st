Class {
	#name : #GtLOpenAIListFilesAPICommand,
	#superclass : #GtLAPICommand,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #'as yet unclassified' }
GtLOpenAIListFilesAPICommand >> request [
	^ self client get: '/files'
]

{ #category : #'as yet unclassified' }
GtLOpenAIListFilesAPICommand >> serializationClass [
	^ GtLOpenAIFilesGroup
]
