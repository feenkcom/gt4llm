Class {
	#name : #GtOpenAIResourceFile,
	#superclass : #Object,
	#instVars : [
		'file',
		'description',
		'remoteId'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
GtOpenAIResourceFile >> description [
	^ description
]

{ #category : #accessing }
GtOpenAIResourceFile >> description: anObject [
	description := anObject
]

{ #category : #accessing }
GtOpenAIResourceFile >> file [
	^ file
]

{ #category : #accessing }
GtOpenAIResourceFile >> file: anObject [
	file := anObject
]

{ #category : #accessing }
GtOpenAIResourceFile >> gtDescriptionFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Description';
		priority: 1;
		text: [ self toFileDescription ]
]

{ #category : #accessing }
GtOpenAIResourceFile >> remoteId [
	^ remoteId
]

{ #category : #accessing }
GtOpenAIResourceFile >> remoteId: anObject [
	remoteId := anObject
]

{ #category : #accessing }
GtOpenAIResourceFile >> toFileDescription [
	^ (self remoteId ifNil: '<unknown ID>')
		, ':
- Name: ' , self file basename
		, '
- Description: ' , self description
]
