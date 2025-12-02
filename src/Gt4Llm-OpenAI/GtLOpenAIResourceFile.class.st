Class {
	#name : #GtLOpenAIResourceFile,
	#superclass : #Object,
	#instVars : [
		'file',
		'description',
		'remoteId'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #'as yet unclassified' }
GtLOpenAIResourceFile >> contents [
	^ file contents
]

{ #category : #accessing }
GtLOpenAIResourceFile >> description [
	^ description
]

{ #category : #accessing }
GtLOpenAIResourceFile >> description: anObject [
	description := anObject
]

{ #category : #accessing }
GtLOpenAIResourceFile >> file [
	^ file
]

{ #category : #accessing }
GtLOpenAIResourceFile >> file: anObject [
	file := anObject
]

{ #category : #'as yet unclassified' }
GtLOpenAIResourceFile >> filename [
	^ file filename
]

{ #category : #'as yet unclassified' }
GtLOpenAIResourceFile >> gtContentsFor: aView [
	<gtView>
	^ aView forward
		title: 'Contents';
		priority: 5;
		object: [ file ];
		view: #gtContentsFor:
]

{ #category : #accessing }
GtLOpenAIResourceFile >> gtDescriptionFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Description';
		priority: 1;
		text: [ self toFileDescription ]
]

{ #category : #accessing }
GtLOpenAIResourceFile >> remoteId [
	^ remoteId
]

{ #category : #accessing }
GtLOpenAIResourceFile >> remoteId: anObject [
	remoteId := anObject
]

{ #category : #accessing }
GtLOpenAIResourceFile >> toFileDescription [
	^ (self remoteId ifNil: [ '<unknown ID>' ])
		, ':
- Name: ' , self file basename
		, '
- Description: ' , self description
]
