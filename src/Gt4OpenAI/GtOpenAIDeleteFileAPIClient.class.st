Class {
	#name : #GtOpenAIDeleteFileAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'file'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
GtOpenAIDeleteFileAPIClient >> file [
	^ file
]

{ #category : #accessing }
GtOpenAIDeleteFileAPIClient >> file: anObject [
	file := anObject
]

{ #category : #accessing }
GtOpenAIDeleteFileAPIClient >> request [
	^ self client
		delete: 'files/', file
]

{ #category : #accessing }
GtOpenAIDeleteFileAPIClient >> serializationClass [
	^ GtOpenAIDeletion
]
