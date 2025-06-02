Extension { #name : #GtPharoMethodCoder }

{ #category : #'*Gt4Llm-GToolkit' }
GtPharoMethodCoder >> addReviewMethodMenuForAst: anAst to: coderAddOns from: aCoderViewModel [
	<gtCoderContextMenuAddOns: 215>
	| theNodes |
	GtLlmFeatures isEnabledInCoder ifFalse: [ ^ self ].
	theNodes := self extractableNodesFrom: aCoderViewModel.
	coderAddOns
		addContextMenuItem: 'Review method' asRopedText
		group: BrMenuItemGroupConfiguration llm
		hover: nil
		leave: nil
		action: [ :model :element | 
			model llmChat
				sendAction: (GtLlmActionCall action: 'Review method')
				onAnswer: [ :anAnswer | element phlow spawnObject: (GtLlmAnswer new message: anAnswer) ] ]
]
