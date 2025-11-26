Class {
	#name : #GtLGroup,
	#superclass : #Object,
	#instVars : [
		'items'
	],
	#category : #Gt4LlmCore
}

{ #category : #'as yet unclassified' }
GtLGroup class >> withAll: aCollection [
	^ self new 
		initializeWith: aCollection
]

{ #category : #visiting }
GtLGroup >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLlmGroup: self
]

{ #category : #accessing }
GtLGroup >> add: anItem [
	self items add: anItem
]

{ #category : #accessing }
GtLGroup >> addAll: aCollection [
	self items addAll: aCollection
]

{ #category : #accessing }
GtLGroup >> addFirst: anItem [
	self items addFirst: anItem
]

{ #category : #accessing }
GtLGroup >> addItem: anItem [
	self items add: anItem
]

{ #category : #accessing }
GtLGroup >> addItems: aCollection [
	self items addAll: aCollection
]

{ #category : #accessing }
GtLGroup >> allButFirst [
	^ self species withAll: self items allButFirst
]

{ #category : #accessing }
GtLGroup >> allButLast [
	^ self species withAll: self items allButLast
]

{ #category : #accessing }
GtLGroup >> anyOne [
	^ self items anyOne
]

{ #category : #accessing }
GtLGroup >> anySatisfy: aBlock [
	^ self items anySatisfy: aBlock
]

{ #category : #accessing }
GtLGroup >> asArray [
	^ self items asArray
]

{ #category : #accessing }
GtLGroup >> asAsyncStream [
	^ AsyncSequenceStream forCollection: self
]

{ #category : #accessing }
GtLGroup >> asBag [
	^ self items asBag
]

{ #category : #accessing }
GtLGroup >> asBrItemsProvider [
	^ BrSequenceableCollectionItemsProvider forCollection: self
]

{ #category : #accessing }
GtLGroup >> asOrderedCollection [
	^ self items asOrderedCollection
]

{ #category : #accessing }
GtLGroup >> asSet [
	^ self items asSet
]

{ #category : #accessing }
GtLGroup >> asSortedCollection: aBlock [
	^ self items asSortedCollection: aBlock
]

{ #category : #accessing }
GtLGroup >> at: anIndex [
	^ self items at: anIndex
]

{ #category : #enumerating }
GtLGroup >> collect: aBlock [
	^ self items collect: aBlock
]

{ #category : #enumerating }
GtLGroup >> collect: aBlock as: aClass [
	^ self items 
		collect: aBlock as: aClass
]

{ #category : #enumerating }
GtLGroup >> collect: collectBlock thenReject: selectBlock [
	^ self items collect: collectBlock thenReject: selectBlock
]

{ #category : #enumerating }
GtLGroup >> collect: collectBlock thenSelect: selectBlock [
	^ self items collect: collectBlock thenSelect: selectBlock
]

{ #category : #enumerating }
GtLGroup >> collectWithIndex: aBlock [
	^ self items collectWithIndex: aBlock
]

{ #category : #enumerating }
GtLGroup >> detect: aBlock [ 
	^ self items detect: aBlock 
]

{ #category : #enumerating }
GtLGroup >> detect: aBlock ifFound: foundBlock ifNone: exceptionBlock [
	^ self items 
		detect: aBlock ifFound: foundBlock ifNone: exceptionBlock
]

{ #category : #enumerating }
GtLGroup >> detect: aBlock ifNone: exceptionBlock [
	^ self items 
		detect: aBlock ifNone: exceptionBlock
]

{ #category : #accessing }
GtLGroup >> detectIndex: aBlock [
	^ self items detectIndex: aBlock
]

{ #category : #accessing }
GtLGroup >> detectIndex: aBlock ifNone: exceptionBlock [
	^ self items detectIndex: aBlock ifNone: exceptionBlock
]

{ #category : #enumerating }
GtLGroup >> detectMax: aBlock [ 
	^ self items detectMax: aBlock 
]

{ #category : #enumerating }
GtLGroup >> detectMin: aBlock [ 
	^ self items detectMin: aBlock 
]

{ #category : #accessing }
GtLGroup >> do: aBlock [
	^ self items do: aBlock
]

{ #category : #'compatibility - DeepTraverser' }
GtLGroup >> dtRawTraverseUsing: aStream [
	self do: [ :each | aStream traverse: each ]
]

{ #category : #'compatibility - DeepTraverser' }
GtLGroup >> dtTraverseStartUsing: aStream [
	self do: [ :each | each dtTraverseStartUsing: aStream ]
]

{ #category : #'compatibility - DeepTraverser' }
GtLGroup >> dtTraverseUsing: aStream [
	self do: [ :each | each dtTraverseUsing: aStream ]
]

{ #category : #accessing }
GtLGroup >> first [
	^ self items first
]

{ #category : #accessing }
GtLGroup >> first: aCount [
	^ self species 
		withAll: (self items first: aCount)
]

{ #category : #accessing }
GtLGroup >> flatCollect: aBlock [
	^ self items flatCollect: aBlock
]

{ #category : #accessing }
GtLGroup >> flatCollect: aBlock as: aClass [
	^ self items flatCollect: aBlock as: aClass
]

{ #category : #accessing }
GtLGroup >> groupedBy: aBlock [ 
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
GtLGroup >> groupedBy: aBlock having: conditionBlock [ 
	"Override this method here and not reuse the one in collection
	because we want the keys to be groups, not simple collections"
	
	^ (self groupedBy: aBlock) select: conditionBlock
]

{ #category : #testing }
GtLGroup >> identityIncludes: anObject [
	^ self items identityIncludes: anObject
]

{ #category : #testing }
GtLGroup >> ifEmpty: aBlock [
	^ self items ifEmpty: aBlock
]

{ #category : #testing }
GtLGroup >> ifEmpty: emptyBlock ifNotEmpty: notEmptyBlock [
	^ self items ifEmpty: emptyBlock ifNotEmpty: notEmptyBlock
]

{ #category : #testing }
GtLGroup >> ifNotEmpty: aBlock [
	^ self items ifNotEmpty: aBlock
]

{ #category : #testing }
GtLGroup >> ifNotEmpty: notEmptyBlock ifEmpty: emptyBlock [
	^ self items ifNotEmpty: notEmptyBlock ifEmpty: emptyBlock
]

{ #category : #testing }
GtLGroup >> includes: anObject [
	^ self items includes: anObject
]

{ #category : #accessing }
GtLGroup >> indexOf: aBlock [
	^ self items indexOf: aBlock
]

{ #category : #initialization }
GtLGroup >> initializeWith: aCollection [
	items := aCollection
]

{ #category : #accessing }
GtLGroup >> inject: anObject into: aBlock [
	^ self items inject: anObject into: aBlock
]

{ #category : #accessing }
GtLGroup >> isCollection [
	^ true
]

{ #category : #testing }
GtLGroup >> isEmpty [

	^ self items isEmpty
]

{ #category : #testing }
GtLGroup >> isEmptyOrNil [
	^ self items isEmptyOrNil
]

{ #category : #testing }
GtLGroup >> isNotEmpty [

	^ self items isNotEmpty
]

{ #category : #accessing }
GtLGroup >> items [
	^ items ifNil: [
		items := OrderedCollection new ]
]

{ #category : #'private - serialization' }
GtLGroup >> items: aCollection [

	items := aCollection
]

{ #category : #accessing }
GtLGroup >> last [
	^ self items last
]

{ #category : #accessing }
GtLGroup >> last: aCount [
	^ self species 
		withAll: (self items last: aCount)
]

{ #category : #accessing }
GtLGroup >> overlappingPairsDo: aBlock [
	^ self items overlappingPairsDo: aBlock
]

{ #category : #printing }
GtLGroup >> printOn: aStream [
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
GtLGroup >> reject: aBlock [
	^ self species 
		withAll: (self items reject: aBlock)
]

{ #category : #accessing }
GtLGroup >> remove: anItem [
	self items remove: anItem
]

{ #category : #accessing }
GtLGroup >> removeAll [
	self items removeAll
]

{ #category : #accessing }
GtLGroup >> removeLast [
	self items removeLast
]

{ #category : #enumerating }
GtLGroup >> reversed [
	^ self species 
		withAll: (self items reversed)
]

{ #category : #enumerating }
GtLGroup >> select: aBlock [
	^ self species 
		withAll: (self items select: aBlock)
]

{ #category : #accessing }
GtLGroup >> size [
	^ self items size
]

{ #category : #sorting }
GtLGroup >> sorted: aPredicate [
	^ self species withAll: (self items sorted: aPredicate)
]

{ #category : #accessing }
GtLGroup >> withIndexCollect: aBlock [
	^ self items withIndexCollect: aBlock
]

{ #category : #accessing }
GtLGroup >> withIndexDo: aBlock [
	^ self items withIndexDo: aBlock
]
