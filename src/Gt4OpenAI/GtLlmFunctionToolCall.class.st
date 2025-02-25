Class {
	#name : #GtLlmFunctionToolCall,
	#superclass : #GtLlmEntity,
	#instVars : [
		'id',
		'arguments',
		'name'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #'as yet unclassified' }
GtLlmFunctionToolCall class >> serializationProperties [
	^ {#id -> #id.
		#function -> #function}
]

{ #category : #accessing }
GtLlmFunctionToolCall >> arguments [
	^ arguments
]

{ #category : #accessing }
GtLlmFunctionToolCall >> arguments: anObject [
	arguments := anObject
]

{ #category : #'as yet unclassified' }
GtLlmFunctionToolCall >> function [
	^ {'name' -> name.
		'arguments' -> (STONJSON toString: arguments)} asDictionary
]

{ #category : #'as yet unclassified' }
GtLlmFunctionToolCall >> function: aDict [
	name := aDict at: 'name'.
	arguments := aDict at: 'arguments'.

	(arguments isKindOf: String)
		ifTrue: [ arguments := STONJSON fromString: arguments ]
]

{ #category : #'as yet unclassified' }
GtLlmFunctionToolCall >> gtArgumentsFor: aView [
	<gtView>
	arguments ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Arguments';
		priority: 1;
		items: [ self arguments associations ];
		column: 'Name' text: #key;
		column: 'Value' text: #value
]

{ #category : #'as yet unclassified' }
GtLlmFunctionToolCall >> humanReadable [
	^ self name , ' '
		, (','
				join: (self arguments associations
						collect: [ :anArgument | anArgument key , ': ' , anArgument value ]))
]

{ #category : #accessing }
GtLlmFunctionToolCall >> id [
	^ id
]

{ #category : #accessing }
GtLlmFunctionToolCall >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtLlmFunctionToolCall >> name [
	^ name
]

{ #category : #accessing }
GtLlmFunctionToolCall >> name: anObject [
	name := anObject
]

{ #category : #'as yet unclassified' }
GtLlmFunctionToolCall >> printOn: aStream [
	super printOn: aStream.

	self name ifNil: [ ^ self ].

	aStream
		nextPut: $(;
		nextPutAll: self name;
		nextPut: $)
]
