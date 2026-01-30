Class {
	#name : #GtLTools,
	#superclass : #Object,
	#traits : 'TGtGroupWithItems',
	#classTraits : 'TGtGroupWithItems classTrait',
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #defaults }
GtLTools class >> gtCodeChange [
	^ self
		withAll: {GtLToolForClassCreation new.
					GtLToolForMethodCompilation new.
					GtLToolForMethodRemoval new.
					GtLToolForClassRemoval new} asOrderedCollection
]

{ #category : #defaults }
GtLTools class >> gtCodeRemoval [
	^ self
		withAll: {GtLToolForClassRemoval new.
					GtLToolForMethodRemoval new} asOrderedCollection
]

{ #category : #defaults }
GtLTools class >> gtExamplesRun [
	^ self
		withAll: {GtLToolForExampleMethodRun new.
				GtLToolForExampleClassesRun new} asOrderedCollection
]

{ #category : #defaults }
GtLTools class >> gtSearch [
	^ self
		withAll: {GtLToolForClassSearch new.
				GtLToolForClassSubclasses new.
				GtLToolForClassLookup new.
				GtLToolForClassReferences new.
				GtLToolForMethodReferences new.
				GtLToolForMethodImplementors new.
				GtLToolForMethodSource new.
				GtLToolForPackageClasses new} asOrderedCollection
]

{ #category : #defaults }
GtLTools class >> leSearch [
	^ self
		withAll: {GtLToolForSearchForLepiterPages new.
					GtLToolForLepiterPageContents new.} asOrderedCollection
]

{ #category : #defaults }
GtLTools class >> sunitRun [
	self 
		deprecated: 'Please use #testRun instead.'
		transformWith: '`@receiver sunitRun' -> '`@receiver testRun'.
	^ self testRun
]

{ #category : #defaults }
GtLTools class >> testRun [
	^ self
		withAll: {GtLToolForTestMethodRun new.
				GtLToolForTestClassesRun new} asOrderedCollection
]

{ #category : #'as yet unclassified' }
GtLTools >> , aCollection [
	self addAll: aCollection
]

{ #category : #views }
GtLTools >> gtItemsFor: aView [
	<gtView>
	items ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Tools';
		items: [ items ];
		column: 'Name' text: [ :each | each name ];
		column: 'Parameters' text: [ :each | ', ' join: each parameters ];
		column: 'Description' text: [ :each | each description ]
]

{ #category : #'as yet unclassified' }
GtLTools >> items: aCollection [
	self removeAll.
	self addAll: aCollection
]

{ #category : #actions }
GtLTools >> performToolCall: aToolCall [
	| tool |
	tool := self detect: [ :aTool | aTool name = aToolCall name ].

	^ tool performToolCall: aToolCall
]

{ #category : #accessing }
GtLTools >> serialize [
	^ Character cr join: (self items collect: [ :aTool | '- ' , aTool serialize ])
]
