Extension { #name : #GtWardleyMapNodeModel }

{ #category : #'*Gt4Llm' }
GtWardleyMapNodeModel >> menuItemNodeLlmAddNewConnectedNodeButton [
	<wardleyContextMenuItem: 41>
	^ GtWardleyMapNodeButtonWithLabelMenuItem new
		label: 'Add a new connected node';
		action: [ :aContextMenuItem :aBrButton :aBrButtonModel :anEvent | 
			aContextMenuItem llmCreator
				announce: (GtLlmSendActionToChat
						action: 'Add a new connected node'
						arguments: {aContextMenuItem wardleyMapNodeViewModel label}).
			aContextMenuItem editorElement fireEvent: BrContextMenuHideWish new ]
]

{ #category : #'*Gt4Llm' }
GtWardleyMapNodeModel >> menuItemNodeLlmExplainItButton [
	<wardleyContextMenuItem: 42>
	^ GtWardleyMapNodeButtonWithLabelMenuItem new
		label: 'Explain this node';
		action: [ :aContextMenuItem :aBrButton :aBrButtonModel :anEvent | 
			aContextMenuItem llmCreator
				announce: (GtLlmSendActionToChat
						action: 'Explain a node'
						arguments: {aContextMenuItem wardleyMapNodeViewModel label}).
			aContextMenuItem editorElement fireEvent: BrContextMenuHideWish new ]
]

{ #category : #'*Gt4Llm' }
GtWardleyMapNodeModel >> menuItemNodeLlmLabel [
	<wardleyContextMenuItem: 40>
	^ GtWardleyMapLabelMenuItem new
		text: 'OpenAI:'
]

{ #category : #'*Gt4Llm' }
GtWardleyMapNodeModel >> menuItemNodeLlmProposeAlternativeNamesButton [
	<wardleyContextMenuItem: 43>
	^ GtWardleyMapNodeButtonWithLabelMenuItem new
		label: 'Propose alternative names';
		action: [ :aContextMenuItem :aBrButton :aBrButtonModel :anEvent | 
			aContextMenuItem llmCreator
				announce: (GtLlmSendActionToChat
						action: 'Rename a node'
						arguments: {aContextMenuItem wardleyMapNodeViewModel label}).
			aContextMenuItem editorElement fireEvent: BrContextMenuHideWish new ]
]
