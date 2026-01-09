Class {
	#name : #GtLToolsGroup,
	#superclass : #Object,
	#traits : 'TGtGroupWithItems',
	#classTraits : 'TGtGroupWithItems classTrait',
	#category : #'Gt4LlmCore-Core'
}

{ #category : #defaults }
GtLToolsGroup class >> gtCodeSearch [
	^ self
		withAll: {GtLlmToolForClassSearch new.
				GtLlmToolForClassSubclasses new.
				GtLlmToolForClassLookup new.
				GtLlmToolForClassReferences new.
				GtLlmToolForMethodReferences new.
				GtLlmToolForMethodImplementors new.
				GtLlmToolForMethodSource new}
]

{ #category : #defaults }
GtLToolsGroup class >> gtExamplesRun [
	^ self
		withAll: {	GtLlmToolForExampleMethodRun new.
					GtLlmToolForExampleClassesRun new}
]

{ #category : #accessing }
GtLToolsGroup class >> leJsonV4Name [

	^ #gtLToolsGroup
]

{ #category : #defaults }
GtLToolsGroup class >> leSearch [
	^ self
		withAll: {GtLlmToolForSearchForLepiterPages new.
					GtLlmToolForLepiterPageContents new.}
]

{ #category : #'as yet unclassified' }
GtLToolsGroup >> , aCollection [
	self addAll: aCollection
]

{ #category : #views }
GtLToolsGroup >> gtItemsFor: aView [
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
GtLToolsGroup >> items: aCollection [
	self removeAll.
	self addAll: aCollection
]

{ #category : #actions }
GtLToolsGroup >> performToolCall: aToolCall [
	| tool |
	tool := self detect: [ :aTool | aTool name = aToolCall name ].

	^ tool performToolCall: aToolCall
]

{ #category : #accessing }
GtLToolsGroup >> serialize [
	^ Character cr join: (self items collect: [ :aTool | '- ' , aTool serialize ])
]
