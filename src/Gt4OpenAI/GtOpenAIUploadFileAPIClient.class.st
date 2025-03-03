Class {
	#name : #GtOpenAIUploadFileAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'file',
		'purpose'
	],
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAIUploadFileAPIClient >> file [
	^ file
]

{ #category : #accessing }
GtOpenAIUploadFileAPIClient >> file: anObject [
	file := anObject
]

{ #category : #accessing }
GtOpenAIUploadFileAPIClient >> purpose [
	^ purpose
]

{ #category : #accessing }
GtOpenAIUploadFileAPIClient >> purpose: anObject [
	purpose := anObject
]

{ #category : #accessing }
GtOpenAIUploadFileAPIClient >> serializationClass [
	^ GtOpenAIFile
]
