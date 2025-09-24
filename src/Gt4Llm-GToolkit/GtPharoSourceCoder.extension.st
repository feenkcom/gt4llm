Extension { #name : #GtPharoSourceCoder }

{ #category : #'*Gt4Llm-GToolkit' }
GtPharoSourceCoder >> addAssistantFormatMenuItemsFor: anAst to: coderAddOns from: aCoderViewModel [
	<gtCoderContextMenuAddOns: 5>
	(aCoderViewModel behavior includesBehavior: GtLlmAssistant) ifFalse: [ ^ self ].
	(self nodeFrom: aCoderViewModel)
		ifNotNil: [ :node | 
			node isLiteral ifFalse: [ ^ self ].
			(node gtIsFormatComponentIn: aCoderViewModel behavior)
				ifTrue: [ (coderAddOns
						addContextMenuItem: (self
								createLabel: 'Rename Format'
								description: node literalValue)
						group: BrMenuItemGroupConfiguration llm
						hover: (self highlightNodeBlock: node)
						leave: self removeHighlightBlock
						action: [ :aTextualViewModel :element | 
							self
								renameFormatComponent: node
								in: aTextualViewModel
								for: element ]
						shortcutKey: GtLlmRenameAssistantFormatComponentShortcut new
								combinationForPlatform gtDisplayString)
						ifNotNil: [ :anAction | anAction priority: 5 ] ] ]
]

{ #category : #'*Gt4Llm-GToolkit' }
GtPharoSourceCoder >> addAssistantFormatRenameShortcutFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 10>
	(self behavior includesBehavior: GtLlmAssistant)
		ifFalse: [ ^ self ].
	coderAddOns addShortcut: GtLlmRenameAssistantFormatComponentShortcut new
]

{ #category : #'*Gt4Llm-GToolkit' }
GtPharoSourceCoder >> renameFormatComponent: node in: aTextualViewModel for: anElement [
	(GtLlmRenameFormatComponentInMethodController new
		sourceCoderViewModel: aTextualViewModel;
		assistantClass: aTextualViewModel behavior;
		originalNode: node) executeIn: anElement
]

{ #category : #'*Gt4Llm-GToolkit' }
GtPharoSourceCoder >> renameFormatComponentAt: anIndex in: aCoderViewModel from: anElement [
	(self nodeAt: anIndex)
		ifNotNil: [ :node | 
			self
				renameFormatComponent: node
				in: aCoderViewModel
				for: anElement.
			^ true ].
	^ false
]
