Class {
	#name : #GtLEntity,
	#superclass : #Object,
	#instVars : [
		'rawData',
		'client'
	],
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLEntity class >> from: aDictionary [
	| entity |

	(aDictionary isKindOf: self) ifTrue: [ ^ aDictionary ].

	(self isErrorResult: aDictionary)
		ifTrue: [ self error: (aDictionary at: 'error') ].

	entity := self new.
	entity from: aDictionary.
	^ entity
]

{ #category : #testing }
GtLEntity class >> isErrorResult: aDictionary [
	^ aDictionary size = 1 and: [ aDictionary includesKey: 'error' ]
]

{ #category : #accessing }
GtLEntity class >> leJsonV4AttributeMapping [

	^ OrderedCollection 
		with: #rawData -> #rawData
		with: #client -> #client
]

{ #category : #accessing }
GtLEntity class >> serializationProperties [
	^ #()
]

{ #category : #visiting }
GtLEntity >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLlmEntity: self
]

{ #category : #accessing }
GtLEntity >> client [
	^ client
]

{ #category : #accessing }
GtLEntity >> client: anObject [
	client := anObject
]

{ #category : #accessing }
GtLEntity >> deserializeTime: anObject [
	^ (anObject isNil or: [ anObject isKindOf: DateAndTime ])
		ifTrue: [ anObject ]
		ifFalse: [ DateAndTime fromUnixTime: anObject ]
]

{ #category : #updating }
GtLEntity >> from: aDictionary [
	self rawData: aDictionary.

	self class serializationProperties
		do: [ :aPair | 
			self
				perform: aPair value asSymbol asMutator
				withArguments: {aDictionary at: aPair key asString ifAbsent: [ nil ]} ]
]

{ #category : #accessing }
GtLEntity >> gtViewRawDataFor: aView [
	<gtView>
	self rawData ifNil: [^ aView empty ].

	^ aView forward
		title: 'Raw data';
		priority: 10;
		object: [ self rawData ];
		view: #gtItemsFor:
]

{ #category : #updating }
GtLEntity >> merge: anotherEntity [
	self rawData: anotherEntity rawData.

	self class serializationProperties
		do: [ :aPair | 
			| aValue |
			aValue := anotherEntity perform: aPair value.
			aValue
				ifNotNil: [ self perform: (aPair value , ':') asSymbol withArguments: {aValue} ] ]
]

{ #category : #accessing }
GtLEntity >> rawData [
	^ rawData
]

{ #category : #accessing }
GtLEntity >> rawData: anObject [
	rawData := anObject
]

{ #category : #accessing }
GtLEntity >> serialize [
	^ (self class serializationProperties
		collect: [ :aPair | aPair key -> (self perform: aPair value) ]) asDictionary
		reject: [ :aValue | aValue isNil ]
]
