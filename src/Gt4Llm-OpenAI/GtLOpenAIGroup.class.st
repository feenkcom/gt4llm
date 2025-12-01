Class {
	#name : #GtLOpenAIGroup,
	#superclass : #Object,
	#instVars : [
		'client',
		'items'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #'instance creation' }
GtLOpenAIGroup class >> from: aList [
	^ self
		withAll: ((aList at: 'data') collect: [ :aModel | self itemClass from: aModel ])
]

{ #category : #accessing }
GtLOpenAIGroup class >> itemClass [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
GtLOpenAIGroup class >> withAll: aCollection [
	^ self new 
		initializeWith: aCollection
]

{ #category : #accessing }
GtLOpenAIGroup >> add: anItem [
	self items add: anItem
]

{ #category : #accessing }
GtLOpenAIGroup >> addAll: aCollection [
	self items addAll: aCollection
]

{ #category : #accessing }
GtLOpenAIGroup >> addFirst: anItem [
	self items addFirst: anItem
]

{ #category : #accessing }
GtLOpenAIGroup >> addItem: anItem [
	self items add: anItem
]

{ #category : #accessing }
GtLOpenAIGroup >> addItems: aCollection [
	self items addAll: aCollection
]

{ #category : #accessing }
GtLOpenAIGroup >> allButFirst [
	^ self species withAll: self items allButFirst
]

{ #category : #accessing }
GtLOpenAIGroup >> allButLast [
	^ self species withAll: self items allButLast
]

{ #category : #accessing }
GtLOpenAIGroup >> anyOne [
	^ self items anyOne
]

{ #category : #accessing }
GtLOpenAIGroup >> anySatisfy: aBlock [
	^ self items anySatisfy: aBlock
]

{ #category : #accessing }
GtLOpenAIGroup >> asArray [
	^ self items asArray
]

{ #category : #accessing }
GtLOpenAIGroup >> asAsyncStream [
	^ AsyncSequenceStream forCollection: self
]

{ #category : #accessing }
GtLOpenAIGroup >> asBag [
	^ self items asBag
]

{ #category : #converting }
GtLOpenAIGroup >> asBrItemsProvider [
	^ BrSequenceableCollectionItemsProvider forCollection: self
]

{ #category : #accessing }
GtLOpenAIGroup >> asOrderedCollection [
	^ self items asOrderedCollection
]

{ #category : #accessing }
GtLOpenAIGroup >> asSet [
	^ self items asSet
]

{ #category : #accessing }
GtLOpenAIGroup >> asSortedCollection: aBlock [
	^ self items asSortedCollection: aBlock
]

{ #category : #accessing }
GtLOpenAIGroup >> at: anIndex [
	^ self items at: anIndex
]

{ #category : #accessing }
GtLOpenAIGroup >> client [
	^ client
]

{ #category : #accessing }
GtLOpenAIGroup >> client: anObject [
	client := anObject.

	self do: [ :anItem | anItem client: client ]
]

{ #category : #enumerating }
GtLOpenAIGroup >> collect: aBlock [
	^ self items collect: aBlock
]

{ #category : #enumerating }
GtLOpenAIGroup >> collect: aBlock as: aClass [
	^ self items 
		collect: aBlock as: aClass
]

{ #category : #enumerating }
GtLOpenAIGroup >> collect: collectBlock thenReject: selectBlock [
	^ self items collect: collectBlock thenReject: selectBlock
]

{ #category : #enumerating }
GtLOpenAIGroup >> collect: collectBlock thenSelect: selectBlock [
	^ self items collect: collectBlock thenSelect: selectBlock
]

{ #category : #enumerating }
GtLOpenAIGroup >> collectWithIndex: aBlock [
	^ self items collectWithIndex: aBlock
]

{ #category : #enumerating }
GtLOpenAIGroup >> detect: aBlock [ 
	^ self items detect: aBlock 
]

{ #category : #enumerating }
GtLOpenAIGroup >> detect: aBlock ifFound: foundBlock ifNone: exceptionBlock [
	^ self items 
		detect: aBlock ifFound: foundBlock ifNone: exceptionBlock
]

{ #category : #enumerating }
GtLOpenAIGroup >> detect: aBlock ifNone: exceptionBlock [
	^ self items 
		detect: aBlock ifNone: exceptionBlock
]

{ #category : #accessing }
GtLOpenAIGroup >> detectIndex: aBlock [
	^ self items detectIndex: aBlock
]

{ #category : #accessing }
GtLOpenAIGroup >> detectIndex: aBlock ifNone: exceptionBlock [
	^ self items detectIndex: aBlock ifNone: exceptionBlock
]

{ #category : #enumerating }
GtLOpenAIGroup >> detectMax: aBlock [ 
	^ self items detectMax: aBlock 
]

{ #category : #enumerating }
GtLOpenAIGroup >> detectMin: aBlock [ 
	^ self items detectMin: aBlock 
]

{ #category : #accessing }
GtLOpenAIGroup >> do: aBlock [
	^ self items do: aBlock
]

{ #category : #'compatibility - DeepTraverser' }
GtLOpenAIGroup >> dtRawTraverseUsing: aStream [
	self do: [ :each | aStream traverse: each ]
]

{ #category : #'compatibility - DeepTraverser' }
GtLOpenAIGroup >> dtTraverseStartUsing: aStream [
	self do: [ :each | each dtTraverseStartUsing: aStream ]
]

{ #category : #'compatibility - DeepTraverser' }
GtLOpenAIGroup >> dtTraverseUsing: aStream [
	self do: [ :each | each dtTraverseUsing: aStream ]
]

{ #category : #accessing }
GtLOpenAIGroup >> first [
	^ self items first
]

{ #category : #accessing }
GtLOpenAIGroup >> first: aCount [
	^ self species 
		withAll: (self items first: aCount)
]

{ #category : #accessing }
GtLOpenAIGroup >> flatCollect: aBlock [
	^ self items flatCollect: aBlock
]

{ #category : #accessing }
GtLOpenAIGroup >> flatCollect: aBlock as: aClass [
	^ self items flatCollect: aBlock as: aClass
]

{ #category : #accessing }
GtLOpenAIGroup >> groupedBy: aBlock [ 
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
GtLOpenAIGroup >> groupedBy: aBlock having: conditionBlock [ 
	"Override this method here and not reuse the one in collection
	because we want the keys to be groups, not simple collections"
	
	^ (self groupedBy: aBlock) select: conditionBlock
]

{ #category : #testing }
GtLOpenAIGroup >> identityIncludes: anObject [
	^ self items identityIncludes: anObject
]

{ #category : #testing }
GtLOpenAIGroup >> ifEmpty: aBlock [
	^ self items ifEmpty: aBlock
]

{ #category : #testing }
GtLOpenAIGroup >> ifEmpty: emptyBlock ifNotEmpty: notEmptyBlock [
	^ self items ifEmpty: emptyBlock ifNotEmpty: notEmptyBlock
]

{ #category : #testing }
GtLOpenAIGroup >> ifNotEmpty: aBlock [
	^ self items ifNotEmpty: aBlock
]

{ #category : #testing }
GtLOpenAIGroup >> ifNotEmpty: notEmptyBlock ifEmpty: emptyBlock [
	^ self items ifNotEmpty: notEmptyBlock ifEmpty: emptyBlock
]

{ #category : #testing }
GtLOpenAIGroup >> includes: anObject [
	^ self items includes: anObject
]

{ #category : #accessing }
GtLOpenAIGroup >> indexOf: aBlock [
	^ self items indexOf: aBlock
]

{ #category : #initialization }
GtLOpenAIGroup >> initializeWith: aCollection [
	items := aCollection
]

{ #category : #accessing }
GtLOpenAIGroup >> inject: anObject into: aBlock [
	^ self items inject: anObject into: aBlock
]

{ #category : #accessing }
GtLOpenAIGroup >> isCollection [
	^ true
]

{ #category : #testing }
GtLOpenAIGroup >> isEmpty [

	^ self items isEmpty
]

{ #category : #testing }
GtLOpenAIGroup >> isEmptyOrNil [
	^ self items isEmptyOrNil
]

{ #category : #testing }
GtLOpenAIGroup >> isNotEmpty [

	^ self items isNotEmpty
]

{ #category : #accessing }
GtLOpenAIGroup >> items [
	^ items ifNil: [
		items := OrderedCollection new ]
]

{ #category : #accessing }
GtLOpenAIGroup >> last [
	^ self items last
]

{ #category : #accessing }
GtLOpenAIGroup >> last: aCount [
	^ self species 
		withAll: (self items last: aCount)
]

{ #category : #accessing }
GtLOpenAIGroup >> overlappingPairsDo: aBlock [
	^ self items overlappingPairsDo: aBlock
]

{ #category : #printing }
GtLOpenAIGroup >> printOn: aStream [
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
GtLOpenAIGroup >> reject: aBlock [
	^ self species 
		withAll: (self items reject: aBlock)
]

{ #category : #accessing }
GtLOpenAIGroup >> remove: anItem [
	self items remove: anItem
]

{ #category : #accessing }
GtLOpenAIGroup >> removeAll [
	self items removeAll
]

{ #category : #enumerating }
GtLOpenAIGroup >> reversed [
	^ self species 
		withAll: (self items reversed)
]

{ #category : #enumerating }
GtLOpenAIGroup >> select: aBlock [
	^ self species 
		withAll: (self items select: aBlock)
]

{ #category : #accessing }
GtLOpenAIGroup >> size [
	^ self items size
]

{ #category : #sorting }
GtLOpenAIGroup >> sorted: aPredicate [
	^ self species withAll: (self items sorted: aPredicate)
]

{ #category : #accessing }
GtLOpenAIGroup >> withIndexCollect: aBlock [
	^ self items withIndexCollect: aBlock
]

{ #category : #accessing }
GtLOpenAIGroup >> withIndexDo: aBlock [
	^ self items withIndexDo: aBlock
]
