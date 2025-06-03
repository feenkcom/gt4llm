Extension { #name : #GtPharoSnippetCoder }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtPharoSnippetCoder >> initializeLlmAddOnsFor: anAst into: addOns [
	<gtAstCoderAddOns: 10>
	GtLlmFeatures isEnabledInCoder ifFalse: [ ^ self ].
	GtLlmConnectionRegistry instance hasConnectableConnection ifFalse: [ ^ self ].
	addOns addStyler: (GtLlmInstructionInPharoCommentStyler new).
	addOns
		addMainAction: 'Open chat' translated
		icon: BrGlamorousVectorIcons chat
		action: [ :aCoderUIModel :anElement | 
			anElement phlow spawnObject: self llmChat ]
"		id: GtSourceCoderProfileActionId".
	"addOns
		addDropDownAction: 'Open chat' translated
		icon: BrGlamorousVectorIcons openAi
		stencil: [ :aCoderUIModel :anElement | 
			BrFrame new fitContent
				addChild: (GtLlmEmbeddedChatElement new chatViewModel: self llmChat asViewModel);
				addAptitude: (BrGlamorousMenuPinnableAptitude new
						withAllPinActions;
						withResizers;
						menuModel: BrMenuExplicit new) ]"
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtPharoSnippetCoder >> initializeLlmAddOnsFor: anAst into: addOns viewModel: aGtPharoSourceCoderViewModel [
	<gtAstCoderAddOns: 10>
	GtLlmFeatures isEnabledInCoder ifFalse: [ ^ self ].
	GtLlmConnectionRegistry instance hasConnectableConnection ifFalse: [ ^ self ].
	addOns addStyler: (GtLlmInstructionInPharoCommentStyler new).
	addOns
		addMainAction: 'Open chat' translated
		icon: BrGlamorousVectorIcons chat
		action: [ :aCoderUIModel :anElement | 
			anElement phlow spawnObject: aGtPharoSourceCoderViewModel llmChat ]
"		id: GtSourceCoderProfileActionId".
]
