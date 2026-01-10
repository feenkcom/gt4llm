Class {
	#name : #GtLTools,
	#superclass : #Object,
	#traits : 'TGtGroupWithItems',
	#classTraits : 'TGtGroupWithItems classTrait',
	#category : #'Gt4LlmCore-Core'
}

{ #category : #defaults }
GtLTools class >> gtCodeChange [
	^ self
		withAll: {GtLToolForClassCreation new.
					GtLToolForMethodCompilation new} asOrderedCollection
]

{ #category : #defaults }
GtLTools class >> gtExamplesRun [
	^ self
		withAll: {	GtLlmToolForExampleMethodRun new.
					GtLlmToolForExampleClassesRun new} asOrderedCollection
]

{ #category : #defaults }
GtLTools class >> gtSearch [
	^ self
		withAll: {GtLlmToolForClassSearch new.
				GtLlmToolForClassSubclasses new.
				GtLlmToolForClassLookup new.
				GtLlmToolForClassReferences new.
				GtLlmToolForMethodReferences new.
				GtLlmToolForMethodImplementors new.
				GtLlmToolForMethodSource new} asOrderedCollection
]

{ #category : #defaults }
GtLTools class >> leSearch [
	^ self
		withAll: {GtLlmToolForSearchForLepiterPages new.
					GtLlmToolForLepiterPageContents new.} asOrderedCollection
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
