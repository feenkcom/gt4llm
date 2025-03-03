Class {
	#name : #GtOpenAIGroup,
	#superclass : #Object,
	#instVars : [
		'client',
		'items'
	],
	#category : #Gt4OpenAI
}

{ #category : #'instance creation' }
GtOpenAIGroup class >> from: aList [
	^ self
		withAll: ((aList at: 'data') collect: [ :aModel | self itemClass from: aModel ])
]

{ #category : #accessing }
GtOpenAIGroup class >> itemClass [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
GtOpenAIGroup class >> withAll: aCollection [
	^ self new 
		initializeWith: aCollection
]

{ #category : #accessing }
GtOpenAIGroup >> add: anItem [
	self items add: anItem
]

{ #category : #accessing }
GtOpenAIGroup >> addAll: aCollection [
	self items addAll: aCollection
]

{ #category : #accessing }
GtOpenAIGroup >> addFirst: anItem [
	self items addFirst: anItem
]

{ #category : #accessing }
GtOpenAIGroup >> addItem: anItem [
	self items add: anItem
]

{ #category : #accessing }
GtOpenAIGroup >> addItems: aCollection [
	self items addAll: aCollection
]

{ #category : #accessing }
GtOpenAIGroup >> allButFirst [
	^ self species withAll: self items allButFirst
]

{ #category : #accessing }
GtOpenAIGroup >> allButLast [
	^ self species withAll: self items allButLast
]

{ #category : #accessing }
GtOpenAIGroup >> anyOne [
	^ self items anyOne
]

{ #category : #accessing }
GtOpenAIGroup >> anySatisfy: aBlock [
	^ self items anySatisfy: aBlock
]

{ #category : #accessing }
GtOpenAIGroup >> asArray [
	^ self items asArray
]

{ #category : #accessing }
GtOpenAIGroup >> asBag [
	^ self items asBag
]

{ #category : #accessing }
GtOpenAIGroup >> asOrderedCollection [
	^ self items asOrderedCollection
]

{ #category : #accessing }
GtOpenAIGroup >> asSet [
	^ self items asSet
]

{ #category : #accessing }
GtOpenAIGroup >> asSortedCollection: aBlock [
	^ self items asSortedCollection: aBlock
]

{ #category : #accessing }
GtOpenAIGroup >> at: anIndex [
	^ self items at: anIndex
]

{ #category : #accessing }
GtOpenAIGroup >> client [
	^ client
]

{ #category : #accessing }
GtOpenAIGroup >> client: anObject [
	client := anObject.

	self do: [ :anItem | anItem client: client ]
]

{ #category : #enumerating }
GtOpenAIGroup >> collect: aBlock [
	^ self items collect: aBlock
]

{ #category : #enumerating }
GtOpenAIGroup >> collect: aBlock as: aClass [
	^ self items 
		collect: aBlock as: aClass
]

{ #category : #enumerating }
GtOpenAIGroup >> collect: collectBlock thenReject: selectBlock [
	^ self items collect: collectBlock thenReject: selectBlock
]

{ #category : #enumerating }
GtOpenAIGroup >> collect: collectBlock thenSelect: selectBlock [
	^ self items collect: collectBlock thenSelect: selectBlock
]

{ #category : #enumerating }
GtOpenAIGroup >> collectWithIndex: aBlock [
	^ self items collectWithIndex: aBlock
]

{ #category : #enumerating }
GtOpenAIGroup >> detect: aBlock [ 
	^ self items detect: aBlock 
]

{ #category : #enumerating }
GtOpenAIGroup >> detect: aBlock ifFound: foundBlock ifNone: exceptionBlock [
	^ self items 
		detect: aBlock ifFound: foundBlock ifNone: exceptionBlock
]

{ #category : #enumerating }
GtOpenAIGroup >> detect: aBlock ifNone: exceptionBlock [
	^ self items 
		detect: aBlock ifNone: exceptionBlock
]

{ #category : #accessing }
GtOpenAIGroup >> detectIndex: aBlock [
	^ self items detectIndex: aBlock
]

{ #category : #accessing }
GtOpenAIGroup >> detectIndex: aBlock ifNone: exceptionBlock [
	^ self items detectIndex: aBlock ifNone: exceptionBlock
]

{ #category : #enumerating }
GtOpenAIGroup >> detectMax: aBlock [ 
	^ self items detectMax: aBlock 
]

{ #category : #enumerating }
GtOpenAIGroup >> detectMin: aBlock [ 
	^ self items detectMin: aBlock 
]

{ #category : #accessing }
GtOpenAIGroup >> do: aBlock [
	^ self items do: aBlock
]

{ #category : #'compatibility - DeepTraverser' }
GtOpenAIGroup >> dtRawTraverseUsing: aStream [
	self do: [ :each | aStream traverse: each ]
]

{ #category : #'compatibility - DeepTraverser' }
GtOpenAIGroup >> dtTraverseStartUsing: aStream [
	self do: [ :each | each dtTraverseStartUsing: aStream ]
]

{ #category : #'compatibility - DeepTraverser' }
GtOpenAIGroup >> dtTraverseUsing: aStream [
	self do: [ :each | each dtTraverseUsing: aStream ]
]

{ #category : #accessing }
GtOpenAIGroup >> first [
	^ self items first
]

{ #category : #accessing }
GtOpenAIGroup >> first: aCount [
	^ self species 
		withAll: (self items first: aCount)
]

{ #category : #accessing }
GtOpenAIGroup >> flatCollect: aBlock [
	^ self items flatCollect: aBlock
]

{ #category : #accessing }
GtOpenAIGroup >> flatCollect: aBlock as: aClass [
	^ self items flatCollect: aBlock as: aClass
]

{ #category : #accessing }
GtOpenAIGroup >> groupedBy: aBlock [ 
	"Override this method here and not reuse the one in collection
	because we want the keys to be groups, not simple collections"
	
	| result |
	result := Dictionary new.
	self do:[:each | 
		| key collection |
		key := aBlock value: each.
		collection := result at: key ifAbsentPut: [ OrderedCollection new].
		collection add: each].
		
	result keysAndValuesDo: [:key :value | 
		result at: key put: (self species withAll: value)].

	^result
]

{ #category : #accessing }
GtOpenAIGroup >> groupedBy: aBlock having: conditionBlock [ 
	"Override this method here and not reuse the one in collection
	because we want the keys to be groups, not simple collections"
	
	^ (self groupedBy: aBlock) select: conditionBlock
]

{ #category : #testing }
GtOpenAIGroup >> identityIncludes: anObject [
	^ self items identityIncludes: anObject
]

{ #category : #testing }
GtOpenAIGroup >> ifEmpty: aBlock [
	^ self items ifEmpty: aBlock
]

{ #category : #testing }
GtOpenAIGroup >> ifEmpty: emptyBlock ifNotEmpty: notEmptyBlock [
	^ self items ifEmpty: emptyBlock ifNotEmpty: notEmptyBlock
]

{ #category : #testing }
GtOpenAIGroup >> ifNotEmpty: aBlock [
	^ self items ifNotEmpty: aBlock
]

{ #category : #testing }
GtOpenAIGroup >> ifNotEmpty: notEmptyBlock ifEmpty: emptyBlock [
	^ self items ifNotEmpty: notEmptyBlock ifEmpty: emptyBlock
]

{ #category : #testing }
GtOpenAIGroup >> includes: anObject [
	^ self items includes: anObject
]

{ #category : #accessing }
GtOpenAIGroup >> indexOf: aBlock [
	^ self items indexOf: aBlock
]

{ #category : #initialization }
GtOpenAIGroup >> initializeWith: aCollection [
	items := aCollection
]

{ #category : #accessing }
GtOpenAIGroup >> inject: anObject into: aBlock [
	^ self items inject: anObject into: aBlock
]

{ #category : #accessing }
GtOpenAIGroup >> isCollection [
	^ true
]

{ #category : #testing }
GtOpenAIGroup >> isEmpty [

	^ self items isEmpty
]

{ #category : #testing }
GtOpenAIGroup >> isEmptyOrNil [
	^ self items isEmptyOrNil
]

{ #category : #testing }
GtOpenAIGroup >> isNotEmpty [

	^ self items isNotEmpty
]

{ #category : #accessing }
GtOpenAIGroup >> items [
	^ items ifNil: [
		items := OrderedCollection new ]
]

{ #category : #accessing }
GtOpenAIGroup >> last [
	^ self items last
]

{ #category : #accessing }
GtOpenAIGroup >> last: aCount [
	^ self species 
		withAll: (self items last: aCount)
]

{ #category : #accessing }
GtOpenAIGroup >> overlappingPairsDo: aBlock [
	^ self items overlappingPairsDo: aBlock
]

{ #category : #printing }
GtOpenAIGroup >> printOn: aStream [
	super printOn: aStream.
	
	aStream 
		<< ' [';
		print: self size;
		<< ' ';
		<< (self size = 1 
			ifTrue: [ 'item' ]
			ifFalse: [ 'items' ]);
		<< ']'
]

{ #category : #enumerating }
GtOpenAIGroup >> reject: aBlock [
	^ self species 
		withAll: (self items reject: aBlock)
]

{ #category : #accessing }
GtOpenAIGroup >> remove: anItem [
	self items remove: anItem
]

{ #category : #accessing }
GtOpenAIGroup >> removeAll [
	self items removeAll
]

{ #category : #enumerating }
GtOpenAIGroup >> reversed [
	^ self species 
		withAll: (self items reversed)
]

{ #category : #enumerating }
GtOpenAIGroup >> select: aBlock [
	^ self species 
		withAll: (self items select: aBlock)
]

{ #category : #accessing }
GtOpenAIGroup >> size [
	^ self items size
]

{ #category : #sorting }
GtOpenAIGroup >> sorted: aPredicate [
	^ self species withAll: (self items sorted: aPredicate)
]

{ #category : #accessing }
GtOpenAIGroup >> withIndexCollect: aBlock [
	^ self items withIndexCollect: aBlock
]

{ #category : #accessing }
GtOpenAIGroup >> withIndexDo: aBlock [
	^ self items withIndexDo: aBlock
]
