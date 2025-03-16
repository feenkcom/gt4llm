Class {
	#name : #GtLlmToolsGroup,
	#superclass : #GtLlmGroup,
	#category : #Gt4Llm
}

{ #category : #views }
GtLlmToolsGroup >> gtItemsFor: aView [
	<gtView>
	items ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Items';
		items: [ items ];
		column: 'Index'
			text: [ :each :index | index asRopedText foreground: Color gray ]
			width: 45;
		column: 'Value' text: [ :each | each gtDisplayString ]
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
