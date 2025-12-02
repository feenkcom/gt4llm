Class {
	#name : #GtLOpenAIGetFileContentsAPICommand,
	#superclass : #GtLAPICommand,
	#instVars : [
		'file'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIGetFileContentsAPICommand >> file [
	^ file
]

{ #category : #accessing }
GtLOpenAIGetFileContentsAPICommand >> file: anObject [
	file := anObject
]

{ #category : #actions }
GtLOpenAIGetFileContentsAPICommand >> perform [
	^ ZnClient new
		url: self client baseUrl / 'files' / self file / 'content';
		setBearerAuthentication: self client apiKey;
		get
]
