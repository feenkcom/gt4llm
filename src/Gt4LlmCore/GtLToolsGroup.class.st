Class {
	#name : #GtLToolsGroup,
	#superclass : #GtLGroup,
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLToolsGroup class >> leJsonV4Name [

	^ #gtLToolsGroup
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
