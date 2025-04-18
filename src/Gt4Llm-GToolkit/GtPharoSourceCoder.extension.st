Extension { #name : #GtPharoSourceCoder }

{ #category : #'*Gt4Llm-GToolkit' }
GtPharoSourceCoder >> addTutorFormatMenuItemsFor: anAst to: coderAddOns from: aCoderViewModel [
	<gtCoderContextMenuAddOns: 5>
	(aCoderViewModel behavior includesBehavior: GtLlmTutor) ifFalse: [ ^ self ].
	(self nodeFrom: aCoderViewModel)
		ifNotNil: [ :node | 
			node isLiteral ifFalse: [ ^ self ].
			(node gtIsFormatComponentIn: aCoderViewModel behavior)
				ifTrue: [ coderAddOns
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
						shortcutKey: GtLlmRenameTutorFormatComponentShortcut new
								combinationForPlatform gtDisplayString ] ]
]

{ #category : #'*Gt4Llm-GToolkit' }
GtPharoSourceCoder >> addTutorFormatRenameShortcutFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 10>
	(self behavior includesBehavior: GtLlmTutor)
		ifFalse: [ ^ self ].
	coderAddOns addShortcut: GtLlmRenameTutorFormatComponentShortcut new
]

{ #category : #'*Gt4Llm-GToolkit' }
GtPharoSourceCoder >> renameFormatComponent: node in: aTextualViewModel for: anElement [
	(GtLlmRenameFormatComponentInMethodController new
		sourceCoderViewModel: aTextualViewModel;
		tutorClass: aTextualViewModel behavior;
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
