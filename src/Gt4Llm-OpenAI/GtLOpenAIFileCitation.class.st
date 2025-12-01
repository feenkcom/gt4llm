Class {
	#name : #GtLOpenAIFileCitation,
	#superclass : #GtLEntity,
	#instVars : [
		'fileId',
		'quote',
		'annotation'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIFileCitation class >> leJsonV4Name [

	^ #gtOpenAIFileCitation
]

{ #category : #accessing }
GtLOpenAIFileCitation class >> serializationProperties [
	^ {#file_id -> #fileId.
		#quote -> #quote}
]

{ #category : #accessing }
GtLOpenAIFileCitation >> annotation [
	^ annotation
]

{ #category : #accessing }
GtLOpenAIFileCitation >> annotation: anObject [
	annotation := anObject
]

{ #category : #accessing }
GtLOpenAIFileCitation >> file [
	^ self fileId
		ifEmpty: [ nil ]
		ifNotEmpty: [ self annotation message chat provider getApiFile: self fileId ]
]

{ #category : #accessing }
GtLOpenAIFileCitation >> fileId [
	^ fileId
]

{ #category : #accessing }
GtLOpenAIFileCitation >> fileId: anObject [
	fileId := anObject
]

{ #category : #accessing }
GtLOpenAIFileCitation >> quote [
	^ quote
]

{ #category : #accessing }
GtLOpenAIFileCitation >> quote: anObject [
	quote := anObject
]
