Extension { #name : #GtPharoSourceCoder }

{ #category : #'*Gt4Llm' }
GtPharoSourceCoder >> addTutorFormatMenuItemsFor: anAst to: coderAddOns from: aCoderViewModel [
	<gtCoderContextMenuAddOns: 5>
	(aCoderViewModel behavior includesBehavior: GtOpenAIAnnotatedActionTutor)
		ifFalse: [ ^ self ].
	(self nodeFrom: aCoderViewModel)
		ifNotNil: [ :node | 
			node isLiteral ifFalse: [ ^ self ].
			(node gtIsFormatComponentIn: aCoderViewModel behavior)
				ifTrue: [ coderAddOns
						addContextMenuItem: (self
								createLabel: 'Rename Format Component'
								description: node literalValue)
						hover: (self highlightNodeBlock: node)
						leave: self removeHighlightBlock
						action: [ :aTextualViewModel :element | 
							self
								renameFormatComponent: node
								in: aTextualViewModel
								for: element ]
						shortcutKey: GtRenameInBaselineShortcut new combinationForPlatform
								gtDisplayString ] ]
]

{ #category : #'*Gt4Llm' }
GtPharoSourceCoder >> renameFormatComponent: node in: aTextualViewModel for: anElement [
	(GtLlmRenameFormatComponentInMethodController new
		sourceCoderViewModel: aTextualViewModel;
		tutorClass: aTextualViewModel behavior;
		originalNode: node) executeIn: anElement
]
