Class {
	#name : #GtLConnection,
	#superclass : #Object,
	#instVars : [
		'label',
		'meta',
		'providerClass'
	],
	#category : #Gt4LlmCore
}

{ #category : #comparing }
GtLConnection >> = anotherConnection [
	^ anotherConnection class = self class
		and: [ self model = anotherConnection model
				and: [ self providerClass = anotherConnection providerClass ] ]
]

{ #category : #adding }
GtLConnection >> addOption: anOption withValue: aValue [
	meta at: anOption put: aValue
]

{ #category : #accessing }
GtLConnection >> buildProvider [
	| aProvider |
	aProvider := self providerClass default value.
	meta
		keysAndValuesDo: [ :aKey :aValue | aProvider perform: aKey asSymbol asMutator withArguments: {aValue} ].
	^ aProvider
]

{ #category : #accessing }
GtLConnection >> connectionProviderClass: aClass [
	providerClass := aClass
]

{ #category : #accessing }
GtLConnection >> connectionString [
	^ self label ifNil: [ self model ]
]

{ #category : #accessing }
GtLConnection >> details [
	^ {'Provider' -> self providerClass providerName.
		'Model' -> self model.
		'Label' -> self label}
]

{ #category : #'gt - extensions' }
GtLConnection >> gtActionSpawnProviderFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousVectorIcons playinspect;
		label: 'Provider';
		priority: 10;
		action: [ :aButton | aButton phlow spawnObject: self buildProvider ]
]

{ #category : #'gt - extensions' }
GtLConnection >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 10;
		items: [ self details ];
		column: 'Property' text: #key;
		column: 'Value' text: #value
]

{ #category : #'gt - extensions' }
GtLConnection >> gtDisplayOn: stream [
	stream
		nextPutAll: 'Connection: ';
		nextPutAll: self providerClass providerName;
		space;
		nextPutAll: self model;
		space;
		nextPutAll: (self isConnectable ifTrue: [ 'connectable' ] ifFalse: [ 'not connectable' ])
]

{ #category : #'gt - extensions' }
GtLConnection >> gtOptionsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Options';
		priority: 2;
		items: [ meta associations ];
		column: 'Option' text: [ :aMeta | aMeta key ];
		column: 'Value' text: [ :aMeta | aMeta value ]
]

{ #category : #comparing }
GtLConnection >> hash [
	^ (self class hash hashMultiply bitXor: self model hash hashMultiply)
		bitXor: self providerClass hash hashMultiply
]

{ #category : #initialization }
GtLConnection >> initialize [
	super initialize.
	
	meta := Dictionary new
]

{ #category : #testing }
GtLConnection >> isConnectable [
	^ self providerClass isConnectable
]

{ #category : #accessing }
GtLConnection >> label [
	^ label
]

{ #category : #accessing }
GtLConnection >> label: anObject [
	label := anObject
]

{ #category : #accessing }
GtLConnection >> model [
	^ meta at: #model ifAbsent: [ nil ]
]

{ #category : #accessing }
GtLConnection >> model: anObject [
	self addOption: #model withValue: anObject
]

{ #category : #accessing }
GtLConnection >> providerClass [
	^ providerClass
]

{ #category : #accessing }
GtLConnection >> providerClass: aClass [
	providerClass := aClass
]

{ #category : #accessing }
GtLConnection >> providerName [
	^ self providerClass providerName
]
