Class {
	#name : #GtLlmWardleyMapNodeEditorElement,
	#superclass : #GtWardleyMapNodeEditorElement,
	#instVars : [
		'creator'
	],
	#category : #'Gt4Llm-Examples - Wardley Map'
}

{ #category : #accessing }
GtLlmWardleyMapNodeEditorElement >> createConnectedNodeButton [
	^ GtWardleyMapUtility newButtonElement
		label: 'Add a new connected node';
		action: [ creator
				announce: (GtLlmSendActionToChat
						action: 'Add a new connected node'
						arguments: {self wardleyMapNodeViewModel label}).
			self fireEvent: BrContextMenuHideWish new ]
]

{ #category : #accessing }
GtLlmWardleyMapNodeEditorElement >> createPropertyEditorElements [
	^ super createPropertyEditorElements
		, {self createConnectedNodeButton.
				self explainNodeButton}
]

{ #category : #accessing }
GtLlmWardleyMapNodeEditorElement >> creator [
	^ creator
]

{ #category : #accessing }
GtLlmWardleyMapNodeEditorElement >> creator: anObject [
	creator := anObject
]

{ #category : #accessing }
GtLlmWardleyMapNodeEditorElement >> explainNodeButton [
	^ GtWardleyMapUtility newButtonElement
		label: 'Explain this node';
		action: [ creator
				announce: (GtLlmSendActionToChat
						action: 'Explain a node'
						arguments: {self wardleyMapNodeViewModel label}).
			self fireEvent: BrContextMenuHideWish new ]
]
