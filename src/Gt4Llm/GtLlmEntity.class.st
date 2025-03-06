Class {
	#name : #GtLlmEntity,
	#superclass : #Object,
	#instVars : [
		'rawData',
		'client'
	],
	#category : 'Gt4Llm'
}

{ #category : #accessing }
GtLlmEntity class >> from: aDictionary [
	| entity |
	(aDictionary isKindOf: self) ifTrue: [ ^ aDictionary ].

	entity := self new.

	entity from: aDictionary.

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

{ #category : #'as yet unclassified' }
GtLlmEntity >> deserializeTime: anObject [
	^ (anObject isNil or: [ anObject isKindOf: DateAndTime ])
		ifTrue: [ anObject ]
		ifFalse: [ DateAndTime fromUnixTime: anObject ]
]

{ #category : #'as yet unclassified' }
GtLlmEntity >> from: aDictionary [
	self rawData: aDictionary.

	self class serializationProperties
		do: [ :aPair | 
			self
				perform: (aPair value , ':') asSymbol
				withArguments: {aDictionary at: aPair key asString ifAbsent: [ nil ]} ]
]

{ #category : #accessing }
GtLlmEntity >> gtViewRawDataFor: aView [
	<gtView>
	self rawData ifNil: [^ aView empty ].

	^ aView forward
		title: 'Raw data';
		priority: 10;
		object: [ self rawData ];
		view: #gtItemsFor:
]

{ #category : #'as yet unclassified' }
GtLlmEntity >> merge: anotherEntity [
	self rawData: anotherEntity rawData.

	self class serializationProperties
		do: [ :aPair | 
			| aValue |
			aValue := anotherEntity perform: aPair value.
			aValue
				ifNotNil: [ self perform: (aPair value , ':') asSymbol withArguments: {aValue} ] ]
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
		reject: [ :aValue | aValue isNil ]
]
