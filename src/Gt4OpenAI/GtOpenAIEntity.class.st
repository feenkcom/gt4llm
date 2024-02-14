Class {
	#name : #GtOpenAIEntity,
	#superclass : #Object,
	#instVars : [
		'rawData',
		'client'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
GtOpenAIEntity class >> from: aDictionary [
	| entity |
	(aDictionary isKindOf: self) ifTrue: [ ^ aDictionary ].

	entity := self new.

	entity rawData: aDictionary.

	self serializationProperties
		do: [ :aPair | entity perform: aPair value , ':' withArguments: {aDictionary at: aPair key} ].

	^ entity
]

{ #category : #accessing }
GtOpenAIEntity class >> serializationProperties [
	^ #()
]

{ #category : #accessing }
GtOpenAIEntity >> client [
	^ client
]

{ #category : #accessing }
GtOpenAIEntity >> client: anObject [
	client := anObject
]

{ #category : #accessing }
GtOpenAIEntity >> gtViewRawDataFor: aView [
	<gtView>
	self rawData ifNil: [^ aView empty ].

	^ aView forward
		title: 'Raw Data';
		priority: 10;
		object: [ self rawData ];
		view: #gtItemsFor:
]

{ #category : #accessing }
GtOpenAIEntity >> rawData [
	^ rawData
]

{ #category : #accessing }
GtOpenAIEntity >> rawData: anObject [
	rawData := anObject
]

{ #category : #accessing }
GtOpenAIEntity >> serialize [
	^ (self class serializationProperties
		collect: [ :aPair | aPair key -> (self perform: aPair value) ]) asDictionary
		reject: #isNil
]
