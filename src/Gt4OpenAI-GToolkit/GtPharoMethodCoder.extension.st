Extension { #name : #GtPharoMethodCoder }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtPharoMethodCoder >> actionFormatAddOnFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 10>
	(self behavior includesBehavior: GtLlmAssistant) ifFalse: [ ^ self ].

	coderAddOns addStyler: (GtLlmAssistantFormatStyler new assistant: self behavior new)
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtPharoMethodCoder >> initializeLlmAddOnsFor: anAst into: addOns viewModel: aGtPharoSourceCoderViewModel [
	<gtAstCoderAddOns: 10>
	GtLlmFeatures isEnabledInCoder ifFalse: [ ^ self ].
	GtLlmConnectionRegistry instance hasConnectableConnection ifFalse: [ ^ self ].
	addOns addStyler: (GtLlmInstructionInPharoCommentStyler new).
	addOns
		addMainAction: 'Open chat' translated
		icon: BrGlamorousVectorIcons openAi
		action: [ :aCoderUIModel :anElement | 
			anElement phlow spawnObject: aGtPharoSourceCoderViewModel llmChat ]
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
