Class {
	#name : #GtLlmConnection,
	#superclass : #Object,
	#instVars : [
		'provider',
		'label',
		'meta'
	],
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmConnection >> = anotherConnection [
	^ anotherConnection class = self class
		and: [ self model = anotherConnection model
				and: [ self provider = anotherConnection provider ] ]
]

{ #category : #'as yet unclassified' }
GtLlmConnection >> addOption: anOption withValue: aValue [
	meta at: anOption put: aValue
]

{ #category : #'as yet unclassified' }
GtLlmConnection >> buildProvider [
	| aProvider |
	aProvider := self provider default value.
	meta
		keysAndValuesDo: [ :aKey :aValue | aProvider perform: aKey asSymbol asMutator withArguments: {aValue} ].
	^ aProvider
]

{ #category : #'as yet unclassified' }
GtLlmConnection >> connectionString [
	^ self label ifNil: [ self model ]
]

{ #category : #'as yet unclassified' }
GtLlmConnection >> details [
	^ {'Provider' -> self provider providerName.
		'Model' -> self model.
		'Label' -> self label}
]

{ #category : #'as yet unclassified' }
GtLlmConnection >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 10;
		items: [ self details ];
		column: 'Property' text: #key;
		column: 'Value' text: #value
]

{ #category : #'as yet unclassified' }
GtLlmConnection >> gtDisplayOn: stream [
	stream
		nextPutAll: 'Connection: ';
		nextPutAll: self provider providerName;
		space;
		nextPutAll: self model;
		space;
		nextPutAll: (self isConnectable ifTrue: [ 'connectable' ] ifFalse: [ 'not connectable' ])
]

{ #category : #'as yet unclassified' }
GtLlmConnection >> gtOptionsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Options';
		priority: 2;
		items: [ meta associations ];
		column: 'Option' text: [ :aMeta | aMeta key ];
		column: 'Value' text: [ :aMeta | aMeta value ]
]

{ #category : #comparing }
GtLlmConnection >> hash [
	^ (self class hash hashMultiply bitXor: self model hash hashMultiply)
		bitXor: self provider hash hashMultiply
]

{ #category : #'as yet unclassified' }
GtLlmConnection >> initialize [
	super initialize.
	
	meta := Dictionary new
]

{ #category : #'as yet unclassified' }
GtLlmConnection >> isConnectable [
	^ self provider isConnectable
]

{ #category : #accessing }
GtLlmConnection >> label [
	^ label
]

{ #category : #accessing }
GtLlmConnection >> label: anObject [
	label := anObject
]

{ #category : #accessing }
GtLlmConnection >> model [
	^ meta at: #model ifAbsent: [ nil ]
]

{ #category : #accessing }
GtLlmConnection >> model: anObject [
	self addOption: #model withValue: anObject
]

{ #category : #accessing }
GtLlmConnection >> provider [
	^ provider
]

{ #category : #accessing }
GtLlmConnection >> provider: anObject [
	provider := anObject
]

{ #category : #'as yet unclassified' }
GtLlmConnection >> providerName [
	^ self provider providerName
]
