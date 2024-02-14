Class {
	#name : #GtOpenAIGetFileAPIClient,
	#superclass : #GtOpenAIEndpointClient,
	#instVars : [
		'file'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
GtOpenAIGetFileAPIClient >> file [
	^ file
]

{ #category : #accessing }
GtOpenAIGetFileAPIClient >> file: anObject [
	file := anObject
]

{ #category : #accessing }
GtOpenAIGetFileAPIClient >> request [
	^ self client get: '/files/', self file
]

{ #category : #accessing }
GtOpenAIGetFileAPIClient >> serializationClass [
	^ GtOpenAIFile
]
