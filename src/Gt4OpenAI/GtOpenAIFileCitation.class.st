Class {
	#name : #GtOpenAIFileCitation,
	#superclass : #GtLlmEntity,
	#instVars : [
		'fileId',
		'quote'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
GtOpenAIFileCitation class >> serializationProperties [
	^ {#file_id -> #fileId.
		#quote -> #quote}
]

{ #category : #accessing }
GtOpenAIFileCitation >> file [
	^ self fileId ifEmpty: [ nil ] ifNotEmpty: [ self client getFile: self fileId ]
]

{ #category : #accessing }
GtOpenAIFileCitation >> fileId [
	^ fileId
]

{ #category : #accessing }
GtOpenAIFileCitation >> fileId: anObject [
	fileId := anObject
]

{ #category : #accessing }
GtOpenAIFileCitation >> quote [
	^ quote
]

{ #category : #accessing }
GtOpenAIFileCitation >> quote: anObject [
	quote := anObject
]
