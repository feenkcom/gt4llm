Class {
	#name : #Gt4OpenAIGetFileAPIClient,
	#superclass : #Gt4OpenAIEndpointClient,
	#instVars : [
		'file'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
Gt4OpenAIGetFileAPIClient >> file [
	^ file
]

{ #category : #accessing }
Gt4OpenAIGetFileAPIClient >> file: anObject [
	file := anObject
]

{ #category : #accessing }
Gt4OpenAIGetFileAPIClient >> request [
	^ self client get: '/files/', self file
]

{ #category : #accessing }
Gt4OpenAIGetFileAPIClient >> serializationClass [
	^ Gt4OpenAIFile
]
