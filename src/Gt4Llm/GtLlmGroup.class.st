Class {
	#name : #GtLlmGroup,
	#superclass : #Object,
	#instVars : [
		'items'
	],
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmGroup class >> withAll: aCollection [
	^ self new 
		initializeWith: aCollection
]

{ #category : #accessing }
GtLlmGroup >> add: anItem [
	self items add: anItem
]

{ #category : #accessing }
GtLlmGroup >> addAll: aCollection [
	self items addAll: aCollection
]

{ #category : #accessing }
GtLlmGroup >> addFirst: anItem [
	self items addFirst: anItem
]

{ #category : #accessing }
GtLlmGroup >> addItem: anItem [
	self items add: anItem
]

{ #category : #accessing }
GtLlmGroup >> addItems: aCollection [
	self items addAll: aCollection
]

{ #category : #accessing }
GtLlmGroup >> allButFirst [
	^ self species withAll: self items allButFirst
]

{ #category : #accessing }
GtLlmGroup >> allButLast [
	^ self species withAll: self items allButLast
]

{ #category : #accessing }
GtLlmGroup >> anyOne [
	^ self items anyOne
]

{ #category : #accessing }
GtLlmGroup >> anySatisfy: aBlock [
	^ self items anySatisfy: aBlock
]

{ #category : #accessing }
GtLlmGroup >> asArray [
	^ self items asArray
]

{ #category : #accessing }
GtLlmGroup >> asBag [
	^ self items asBag
]

{ #category : #accessing }
GtLlmGroup >> asOrderedCollection [
	^ self items asOrderedCollection
]

{ #category : #accessing }
GtLlmGroup >> asSet [
	^ self items asSet
]

{ #category : #accessing }
GtLlmGroup >> asSortedCollection: aBlock [
	^ self items asSortedCollection: aBlock
]

{ #category : #accessing }
GtLlmGroup >> at: anIndex [
	^ self items at: anIndex
]

{ #category : #enumerating }
GtLlmGroup >> collect: aBlock [
	^ self items collect: aBlock
]

{ #category : #enumerating }
GtLlmGroup >> collect: aBlock as: aClass [
	^ self items 
		collect: aBlock as: aClass
]

{ #category : #enumerating }
GtLlmGroup >> collect: collectBlock thenReject: selectBlock [
	^ self items collect: collectBlock thenReject: selectBlock
]

{ #category : #enumerating }
GtLlmGroup >> collect: collectBlock thenSelect: selectBlock [
	^ self items collect: collectBlock thenSelect: selectBlock
]

{ #category : #enumerating }
GtLlmGroup >> collectWithIndex: aBlock [
	^ self items collectWithIndex: aBlock
]

{ #category : #enumerating }
GtLlmGroup >> detect: aBlock [ 
	^ self items detect: aBlock 
]

{ #category : #enumerating }
GtLlmGroup >> detect: aBlock ifFound: foundBlock ifNone: exceptionBlock [
	^ self items 
		detect: aBlock ifFound: foundBlock ifNone: exceptionBlock
]

{ #category : #enumerating }
GtLlmGroup >> detect: aBlock ifNone: exceptionBlock [
	^ self items 
		detect: aBlock ifNone: exceptionBlock
]

{ #category : #accessing }
GtLlmGroup >> detectIndex: aBlock [
	^ self items detectIndex: aBlock
]

{ #category : #accessing }
GtLlmGroup >> detectIndex: aBlock ifNone: exceptionBlock [
	^ self items detectIndex: aBlock ifNone: exceptionBlock
]

{ #category : #enumerating }
GtLlmGroup >> detectMax: aBlock [ 
	^ self items detectMax: aBlock 
]

{ #category : #enumerating }
GtLlmGroup >> detectMin: aBlock [ 
	^ self items detectMin: aBlock 
]

{ #category : #accessing }
GtLlmGroup >> do: aBlock [
	^ self items do: aBlock
]

{ #category : #'compatibility - DeepTraverser' }
GtLlmGroup >> dtRawTraverseUsing: aStream [
	self do: [ :each | aStream traverse: each ]
]

{ #category : #'compatibility - DeepTraverser' }
GtLlmGroup >> dtTraverseStartUsing: aStream [
	self do: [ :each | each dtTraverseStartUsing: aStream ]
]

{ #category : #'compatibility - DeepTraverser' }
GtLlmGroup >> dtTraverseUsing: aStream [
	self do: [ :each | each dtTraverseUsing: aStream ]
]

{ #category : #accessing }
GtLlmGroup >> first [
	^ self items first
]

{ #category : #accessing }
GtLlmGroup >> first: aCount [
	^ self species 
		withAll: (self items first: aCount)
]

{ #category : #accessing }
GtLlmGroup >> flatCollect: aBlock [
	^ self items flatCollect: aBlock
]

{ #category : #accessing }
GtLlmGroup >> flatCollect: aBlock as: aClass [
	^ self items flatCollect: aBlock as: aClass
]

{ #category : #accessing }
GtLlmGroup >> groupedBy: aBlock [ 
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
GtLlmGroup >> groupedBy: aBlock having: conditionBlock [ 
	"Override this method here and not reuse the one in collection
	because we want the keys to be groups, not simple collections"
	
	^ (self groupedBy: aBlock) select: conditionBlock
]

{ #category : #testing }
GtLlmGroup >> identityIncludes: anObject [
	^ self items identityIncludes: anObject
]

{ #category : #testing }
GtLlmGroup >> ifEmpty: aBlock [
	^ self items ifEmpty: aBlock
]

{ #category : #testing }
GtLlmGroup >> ifEmpty: emptyBlock ifNotEmpty: notEmptyBlock [
	^ self items ifEmpty: emptyBlock ifNotEmpty: notEmptyBlock
]

{ #category : #testing }
GtLlmGroup >> ifNotEmpty: aBlock [
	^ self items ifNotEmpty: aBlock
]

{ #category : #testing }
GtLlmGroup >> ifNotEmpty: notEmptyBlock ifEmpty: emptyBlock [
	^ self items ifNotEmpty: notEmptyBlock ifEmpty: emptyBlock
]

{ #category : #testing }
GtLlmGroup >> includes: anObject [
	^ self items includes: anObject
]

{ #category : #accessing }
GtLlmGroup >> indexOf: aBlock [
	^ self items indexOf: aBlock
]

{ #category : #initialization }
GtLlmGroup >> initializeWith: aCollection [
	items := aCollection
]

{ #category : #accessing }
GtLlmGroup >> inject: anObject into: aBlock [
	^ self items inject: anObject into: aBlock
]

{ #category : #accessing }
GtLlmGroup >> isCollection [
	^ true
]

{ #category : #testing }
GtLlmGroup >> isEmpty [

	^ self items isEmpty
]

{ #category : #testing }
GtLlmGroup >> isEmptyOrNil [
	^ self items isEmptyOrNil
]

{ #category : #testing }
GtLlmGroup >> isNotEmpty [

	^ self items isNotEmpty
]

{ #category : #accessing }
GtLlmGroup >> items [
	^ items ifNil: [
		items := OrderedCollection new ]
]

{ #category : #accessing }
GtLlmGroup >> last [
	^ self items last
]

{ #category : #accessing }
GtLlmGroup >> last: aCount [
	^ self species 
		withAll: (self items last: aCount)
]

{ #category : #accessing }
GtLlmGroup >> overlappingPairsDo: aBlock [
	^ self items overlappingPairsDo: aBlock
]

{ #category : #printing }
GtLlmGroup >> printOn: aStream [
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
GtLlmGroup >> reject: aBlock [
	^ self species 
		withAll: (self items reject: aBlock)
]

{ #category : #accessing }
GtLlmGroup >> remove: anItem [
	self items remove: anItem
]

{ #category : #accessing }
GtLlmGroup >> removeAll [
	self items removeAll
]

{ #category : #accessing }
GtLlmGroup >> removeLast [
	self items removeLast
]

{ #category : #enumerating }
GtLlmGroup >> reversed [
	^ self species 
		withAll: (self items reversed)
]

{ #category : #enumerating }
GtLlmGroup >> select: aBlock [
	^ self species 
		withAll: (self items select: aBlock)
]

{ #category : #accessing }
GtLlmGroup >> size [
	^ self items size
]

{ #category : #sorting }
GtLlmGroup >> sorted: aPredicate [
	^ self species withAll: (self items sorted: aPredicate)
]

{ #category : #accessing }
GtLlmGroup >> withIndexCollect: aBlock [
	^ self items withIndexCollect: aBlock
]

{ #category : #accessing }
GtLlmGroup >> withIndexDo: aBlock [
	^ self items withIndexDo: aBlock
]
