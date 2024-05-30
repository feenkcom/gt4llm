Class {
	#name : #GtLlmWardleyMapNodeEditorElement,
	#superclass : #GtWardleyMapNodeEditorElement,
	#instVars : [
		'creator'
	],
	#category : #'Gt4Llm-Examples'
}

{ #category : #accessing }
GtLlmWardleyMapNodeEditorElement >> createConnectedNodeButton [
	^ BrButton new
		aptitude: BrGlamorousButtonWithLabelAptitude;
		beSmallSize;
		label: 'Add connected node';
		action: [ creator
				announce: (GtLlmSendActionToChat
						action: 'Add a new connected node'
						arguments: {self wardleyMapNodeViewModel label}).
			self fireEvent: BrContextMenuHideWish new ]
]

{ #category : #accessing }
GtLlmWardleyMapNodeEditorElement >> createPropertyEditorElements [
	^ super createPropertyEditorElements , {self createConnectedNodeButton}
]

{ #category : #accessing }
GtLlmWardleyMapNodeEditorElement >> creator [
	^ creator
]

{ #category : #accessing }
GtLlmWardleyMapNodeEditorElement >> creator: anObject [
	creator := anObject
]
