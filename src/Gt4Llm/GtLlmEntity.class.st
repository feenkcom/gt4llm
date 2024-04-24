Class {
	#name : #GtLlmEntity,
	#superclass : #Object,
	#instVars : [
		'rawData',
		'client'
	],
	#category : #'Gt4Llm-Models'
}

{ #category : #accessing }
GtLlmEntity class >> from: aDictionary [
	| entity |
	(aDictionary isKindOf: self) ifTrue: [ ^ aDictionary ].

	entity := self new.

	entity rawData: aDictionary.

	self serializationProperties
		do: [ :aPair | entity perform: aPair value , ':' withArguments: {aDictionary at: aPair key} ].

	^ entity
]

{ #category : #accessing }
GtLlmEntity class >> serializationProperties [
	^ #()
]

{ #category : #accessing }
GtLlmEntity >> client [
	^ client
]

{ #category : #accessing }
GtLlmEntity >> client: anObject [
	client := anObject
]

{ #category : #accessing }
GtLlmEntity >> gtViewRawDataFor: aView [
	<gtView>
	self rawData ifNil: [^ aView empty ].

	^ aView forward
		title: 'Raw Data';
		priority: 10;
		object: [ self rawData ];
		view: #gtItemsFor:
]

{ #category : #accessing }
GtLlmEntity >> rawData [
	^ rawData
]

{ #category : #accessing }
GtLlmEntity >> rawData: anObject [
	rawData := anObject
]

{ #category : #accessing }
GtLlmEntity >> serialize [
	^ (self class serializationProperties
		collect: [ :aPair | aPair key -> (self perform: aPair value) ]) asDictionary
		reject: #isNil
]
