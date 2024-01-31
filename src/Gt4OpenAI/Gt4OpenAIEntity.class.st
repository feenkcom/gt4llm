Class {
	#name : #Gt4OpenAIEntity,
	#superclass : #Object,
	#instVars : [
		'rawData'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
Gt4OpenAIEntity class >> from: aDictionary [
	| entity |
	entity := self new.
	
	entity rawData: aDictionary.

	self serializationProperties
		do: [ :aPair | entity perform: aPair value , ':' withArguments: {aDictionary at: aPair key} ].

	^ entity
]

{ #category : #accessing }
Gt4OpenAIEntity class >> serializationProperties [
	^ #()
]

{ #category : #accessing }
Gt4OpenAIEntity >> gtViewRawDataFor: aView [
	<gtView>
	self rawData ifNil: [^ aView empty ].

	^ aView forward
		title: 'Raw Data';
		priority: 10;
		object: [ self rawData ];
		view: #gtItemsFor:
]

{ #category : #accessing }
Gt4OpenAIEntity >> rawData [
	^ rawData
]

{ #category : #accessing }
Gt4OpenAIEntity >> rawData: anObject [
	rawData := anObject
]

{ #category : #accessing }
Gt4OpenAIEntity >> serialize [
	^ (self class serializationProperties
		collect: [ :aPair | aPair key -> (self perform: aPair value) ]) asDictionary
]
