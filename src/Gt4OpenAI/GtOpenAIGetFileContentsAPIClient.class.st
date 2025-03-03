Class {
	#name : #GtOpenAIGetFileContentsAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'file'
	],
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAIGetFileContentsAPIClient >> file [
	^ file
]

{ #category : #accessing }
GtOpenAIGetFileContentsAPIClient >> file: anObject [
	file := anObject
]
