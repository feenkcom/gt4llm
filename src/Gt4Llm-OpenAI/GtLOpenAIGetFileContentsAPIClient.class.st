Class {
	#name : #GtLOpenAIGetFileContentsAPIClient,
	#superclass : #GtLAPICommand,
	#instVars : [
		'file'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIGetFileContentsAPIClient >> file [
	^ file
]

{ #category : #accessing }
GtLOpenAIGetFileContentsAPIClient >> file: anObject [
	file := anObject
]

{ #category : #actions }
GtLOpenAIGetFileContentsAPIClient >> perform [
	^ ZnClient new
		url: self client baseUrl / 'files' / self file / 'content';
		setBearerAuthentication: self client apiKey;
		get
]
