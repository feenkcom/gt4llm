Extension { #name : #GtPharoMethodCoder }

{ #category : #'*Gt4OpenAI' }
GtPharoMethodCoder >> addRenameSuggestionsMenuAddOnsAst: anAst to: coderAddOns from: aCoderViewModel [
	<gtCoderContextMenuAddOns: 10000>
	(self nodeFrom: aCoderViewModel)
		ifNotNil: [ :node | 
			| highlightNode |
			(node isMessage or: [ node isMessageSend or: [ node isMethodPattern ] ])
				ifTrue: [ highlightNode := node isMessageSend ifTrue: [ node message ] ifFalse: [ node ].
					coderAddOns
						addContextMenuItem: (self
								createLabel: 'Suggest renames (OpenAI)'
								description: node selector)
						hover: nil
						leave: nil
						action: [ :aTextualViewModel :anElement | 
							| aChat |
							aChat := self openAITutorChat.
							aChat sendMessage: 'Propose renames for method'.
							(aChat whenReadyFuture
								then: [ | choices |
									aChat messages first isAssistantRole
										ifTrue: [ choices := aChat messages first proposedRenamesForMethod proposals.
											self
												renameNodeProposals: node
												in: aTextualViewModel
												for: anElement
												withPossibilities: choices ]
										ifFalse: [ self error: 'No answer received!' ] ]) await ] ] ]
]
