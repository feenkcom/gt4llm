Class {
	#name : #GtLlmToolsGroup,
	#superclass : #GtLlmGroup,
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmToolsGroup class >> leJsonV4Name [

	^ #gtLlmToolsGroup
]

{ #category : #views }
GtLlmToolsGroup >> gtItemsFor: aView [
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
GtLlmToolsGroup >> performToolCall: aToolCall [
	| tool |
	tool := self detect: [ :aTool | aTool name = aToolCall name ].

	^ tool performToolCall: aToolCall
]

{ #category : #accessing }
GtLlmToolsGroup >> serialize [
	^ Character cr join: (self items collect: [ :aTool | '- ' , aTool serialize ])
]
