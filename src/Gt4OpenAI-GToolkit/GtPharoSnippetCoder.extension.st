Extension { #name : #GtPharoSnippetCoder }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtPharoSnippetCoder >> initializeLlmAddOnsFor: anAst into: addOns [
	<gtAstCoderAddOns: 10>
	GtLlmFeatures useCoder ifFalse: [ ^ self ].
	addOns addStyler: (GtLlmInstructionInPharoCommentStyler new).
	addOns
		addDropDownAction: 'Open chat' translated
		icon: BrGlamorousVectorIcons openAi
		stencil: [ :aCoderUIModel :anElement | 
			BrFrame new fitContent
				addChild: (GtLlmEmbeddedChatElement new chatViewModel: self llmChat asViewModel);
				addAptitude: (BrGlamorousMenuPinnableAptitude new
						withAllPinActions;
						withResizers;
						menuModel: BrMenuExplicit new) ]
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtPharoSnippetCoder >> llmChat [
	^ "self
		attributeNamed: #llmChat
		ifAbsent: [" self
				attributeNamed: #llmChat
				put: (GtCodeSnippetTutor new chatOnSnippet: self) "]"
]
