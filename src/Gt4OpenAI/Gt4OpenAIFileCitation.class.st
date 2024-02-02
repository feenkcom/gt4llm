Class {
	#name : #Gt4OpenAIFileCitation,
	#superclass : #Gt4OpenAIEntity,
	#instVars : [
		'fileId',
		'quote'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
Gt4OpenAIFileCitation class >> serializationProperties [
	^ {#file_id -> #fileId.
		#quote -> #quote}
]

{ #category : #accessing }
Gt4OpenAIFileCitation >> file [
	^ self fileId ifEmpty: [ nil ] ifNotEmpty: [ self client getFile: self fileId ]
]

{ #category : #accessing }
Gt4OpenAIFileCitation >> fileId [
	^ fileId
]

{ #category : #accessing }
Gt4OpenAIFileCitation >> fileId: anObject [
	fileId := anObject
]

{ #category : #accessing }
Gt4OpenAIFileCitation >> quote [
	^ quote
]

{ #category : #accessing }
Gt4OpenAIFileCitation >> quote: anObject [
	quote := anObject
]
