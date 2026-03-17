"
Examples for GtPhlowChatTool.
"
Class {
	#name : #GtPhlowChatToolExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtPhlowChatToolExamples >> chatTool [
	<gtExample>
	| aTool anElement |
	aTool := GtPhlowChatTool forChat: GtLChat new.
	anElement := aTool asElementDo: [ :theElement | theElement ].
	self assert: (anElement isKindOf: BlElement).
	self assert: aTool name equals: 'Chat'.
	self assert: aTool object class equals: GtLChat.
	^ aTool
]

{ #category : #examples }
GtPhlowChatToolExamples >> chatToolCollectsToolViews [
	<gtExample>
	| aChat collectedViews titles |
	aChat := GtLChat new.
	collectedViews := GtPhlowViewsCollector new
		pragmaName: #gtLlmView;
		fromObject: aChat;
		collect.
	titles := collectedViews collect: [ :each | each title asString ].
	self assert: collectedViews notEmpty description: 'GtLChat should have methods annotated with gtLlmView'.
	self assert: (titles includes: 'Live').
	self assert: (titles includes: 'Messages').
	^ collectedViews
]

{ #category : #examples }
GtPhlowChatToolExamples >> chatToolElement [
	<gtExample>
	| anElement |
	anElement := GtPhlowChatToolElement new
		chat: GtLChat new.
	self assert: (anElement isKindOf: BlElement).
	self assert: anElement children notEmpty.
	^ anElement
]

{ #category : #examples }
GtPhlowChatToolExamples >> chatToolElementHasTabGroup [
	<gtExample>
	| anElement |
	anElement := (GtPhlowChatTool forChat: GtLChat new)
		asElementDo: [ :theElement | theElement ].
	self assert: (anElement isKindOf: BlElement).
	self assert: anElement children notEmpty.
	^ anElement
]

{ #category : #examples }
GtPhlowChatToolExamples >> chatToolElementWithHeader [
	<gtExample>
	| anElement header |
	anElement := GtPhlowChatToolElement new
		chat: GtLChat new.
	header := anElement childNamed: #header.
	self assert: header notNil.
	self assert: header children notEmpty.
	^ anElement
]

{ #category : #examples }
GtPhlowChatToolExamples >> chatToolElementWithPlayground [
	<gtExample>
	| anElement playground |
	anElement := GtPhlowChatToolElement new
		chat: GtLChat new.
	playground := anElement childNamed: #playgroundPage.
	self assert: playground notNil.
	^ anElement
]
