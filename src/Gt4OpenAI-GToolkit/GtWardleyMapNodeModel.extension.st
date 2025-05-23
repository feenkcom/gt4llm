Extension { #name : #GtWardleyMapNodeModel }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtWardleyMapNodeModel >> menuItemNodeLlmAddNewConnectedNodeButton [
	<wardleyContextMenuItem: 41>
	^ GtWardleyMapNodeButtonWithLabelMenuItem new
		label: 'Add new connected nodes';
		action: [ :aContextMenuItem :aBrButton :aBrButtonModel :anEvent | 
			aContextMenuItem llm
				sendAction: (GtLlmActionCall
						action: 'Add new connected nodes'
						arguments: {aContextMenuItem wardleyMapNodeViewModel label})
				onAnswer: [ :aMessage | 
					aContextMenuItem wardleyMapViewModel onActionFinished.
					GtWardleyMapUtility
						addModelAsPropositionsFrom: aContextMenuItem wardleyMapViewModel wardleyMapModel
						to: aMessage mapModel ].
			aContextMenuItem wardleyMapViewModel onActionStarted.
			aContextMenuItem editorElement fireEvent: BrContextMenuHideWish new ]
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtWardleyMapNodeModel >> menuItemNodeLlmExplainItButton [
	<wardleyContextMenuItem: 42>
	^ GtWardleyMapNodeButtonWithLabelMenuItem new
		label: 'Explain this node';
		action: [ :aContextMenuItem :aBrButton :aBrButtonModel :anEvent | 
			aContextMenuItem llm
				sendAction: (GtLlmActionCall
						action: 'Explain a node'
						arguments: {aContextMenuItem wardleyMapNodeViewModel label})
				onAnswer: [ :aMessage | 
					aContextMenuItem wardleyMapViewModel onActionFinished.
					aContextMenuItem editorElement phlow spawnObject: aMessage textBlock ].
			aContextMenuItem wardleyMapViewModel onActionStarted.
			aContextMenuItem editorElement fireEvent: BrContextMenuHideWish new ]
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtWardleyMapNodeModel >> menuItemNodeLlmLabel [
	<wardleyContextMenuItem: 40>
	^ GtWardleyMapLabelMenuItem new
		text: 'OpenAI:'
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtWardleyMapNodeModel >> menuItemNodeLlmProposeAlternativeNamesButton [
	<wardleyContextMenuItem: 43>
	^ GtWardleyMapNodeButtonWithLabelMenuItem new
		label: 'Propose alternative names';
		action: [ :aContextMenuItem :aBrButton :aBrButtonModel :anEvent | 
			aContextMenuItem llm
				sendAction: (GtLlmActionCall
						action: 'Propose renames for node'
						arguments: {aContextMenuItem wardleyMapNodeViewModel label})
				onAnswer: [ :aMessage | 
					aContextMenuItem wardleyMapViewModel onActionFinished.
					aContextMenuItem wardleyMapNodeViewModel wardleyMapNodeModel
						addWardleyMapDecoratorModel: (GtWardleyMapRenameProposition new
								options: (aMessage renames at: aContextMenuItem wardleyMapNodeViewModel label)) ].
			aContextMenuItem wardleyMapViewModel onActionStarted.
			aContextMenuItem editorElement fireEvent: BrContextMenuHideWish new ]
]
