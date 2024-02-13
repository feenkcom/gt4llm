Class {
	#name : #Gt4OpenAIDeleteFileAPIClient,
	#superclass : #Gt4OpenAIEndpointClient,
	#instVars : [
		'file'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
Gt4OpenAIDeleteFileAPIClient >> file [
	^ file
]

{ #category : #accessing }
Gt4OpenAIDeleteFileAPIClient >> file: anObject [
	file := anObject
]

{ #category : #accessing }
Gt4OpenAIDeleteFileAPIClient >> request [
	^ self client
		delete: 'files/', file
]

{ #category : #accessing }
Gt4OpenAIDeleteFileAPIClient >> serializationClass [
	^ Gt4OpenAIDeletion
]
