Class {
	#name : #GtOpenAIGetFileContentsAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'file'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
GtOpenAIGetFileContentsAPIClient >> file [
	^ file
]

{ #category : #accessing }
GtOpenAIGetFileContentsAPIClient >> file: anObject [
	file := anObject
]

{ #category : #'as yet unclassified' }
GtOpenAIGetFileContentsAPIClient >> perform [
	^ ZnClient new
		url: self client baseUrl / 'files' / self file / 'content';
		setBearerAuthentication: self client apiKey;
		get
]
