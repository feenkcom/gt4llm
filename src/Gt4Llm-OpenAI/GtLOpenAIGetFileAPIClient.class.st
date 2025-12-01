Class {
	#name : #GtLOpenAIGetFileAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'file'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIGetFileAPIClient >> file [
	^ file
]

{ #category : #accessing }
GtLOpenAIGetFileAPIClient >> file: anObject [
	file := anObject
]

{ #category : #accessing }
GtLOpenAIGetFileAPIClient >> request [
	^ self client get: '/files/', self file
]

{ #category : #accessing }
GtLOpenAIGetFileAPIClient >> serializationClass [
	^ GtLOpenAIFile
]
