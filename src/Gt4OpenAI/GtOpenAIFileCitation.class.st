Class {
	#name : #GtOpenAIFileCitation,
	#superclass : #GtLlmEntity,
	#instVars : [
		'fileId',
		'quote',
		'annotation'
	],
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAIFileCitation class >> leJsonV4Name [

	^ #gtOpenAIFileCitation
]

{ #category : #accessing }
GtOpenAIFileCitation class >> serializationProperties [
	^ {#file_id -> #fileId.
		#quote -> #quote}
]

{ #category : #accessing }
GtOpenAIFileCitation >> annotation [
	^ annotation
]

{ #category : #accessing }
GtOpenAIFileCitation >> annotation: anObject [
	annotation := anObject
]

{ #category : #accessing }
GtOpenAIFileCitation >> file [
	^ self fileId
		ifEmpty: [ nil ]
		ifNotEmpty: [ self annotation message chat provider getApiFile: self fileId ]
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
