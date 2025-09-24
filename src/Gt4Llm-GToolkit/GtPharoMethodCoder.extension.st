Extension { #name : #GtPharoMethodCoder }

{ #category : #'*Gt4Llm-GToolkit' }
GtPharoMethodCoder >> addRenameMethodMenuForAst: anAst to: coderAddOns from: aCoderViewModel [
	<gtCoderContextMenuAddOns: 216>
	GtLlmFeatures isEnabledInCoder ifFalse: [ ^ self ].

	(self nodeFrom: aCoderViewModel)
		ifNotNil: [ :node | 
			node isMethodPattern ifFalse: [ ^ self ].
			(coderAddOns
				addContextMenuItem: 'Propose method renames' asRopedText
				group: BrMenuItemGroupConfiguration llm
				hover: (self highlightNodeBlock: node)
				leave: self removeHighlightBlock
				action: [ :model :element | 
					model llmChat
						sendAction: (GtLlmActionCall action: 'Rename method')
						onAnswer: [ :anAnswer | 
							(GtPossibleRenameMethodController new
								possibilities: (anAnswer codeBlock
										collect: [ :aCodeBlock | (GtPharoParser parse: (aCodeBlock at: 'code')) selector ]);
								originalNode: node;
								sourceCoderViewModel: model) executeIn: element ] ])
					ifNotNil: [ :anAction | anAction priority: 216 ] ]
]

{ #category : #'*Gt4Llm-GToolkit' }
GtPharoMethodCoder >> addReviewMethodMenuForAst: anAst to: coderAddOns from: aCoderViewModel [
	<gtCoderContextMenuAddOns: 215>
	GtLlmFeatures isEnabledInCoder ifFalse: [ ^ self ].
	(coderAddOns
		addContextMenuItem: 'Review method' asRopedText
		group: BrMenuItemGroupConfiguration llm
		hover: nil
		leave: nil
		action: [ :model :element | 
			model llmChat
				sendAction: (GtLlmActionCall action: 'Review method')
				onAnswer: [ :anAnswer | element phlow spawnObject: anAnswer ] ])
			ifNotNil: [ :anAction | anAction priority: 215 ]
]
