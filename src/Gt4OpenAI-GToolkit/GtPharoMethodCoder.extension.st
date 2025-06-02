Extension { #name : #GtPharoMethodCoder }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtPharoMethodCoder >> initializeLlmAddOnsFor: anAst into: addOns viewModel: aGtPharoSourceCoderViewModel [
	<gtAstCoderAddOns: 10>
	GtLlmFeatures isEnabledInCoder ifFalse: [ ^ self ].
	GtLlmConnectionRegistry instance hasConnectableConnection ifFalse: [ ^ self ].
	addOns addStyler: GtLlmInstructionInPharoCommentStyler new.
	addOns
		addMainAction: (GtCoderCustomAction new
				title: 'Open chat';
				stencil: [ :aCoderActionsElement | GtLlmCoderChatButton new chat: aCoderActionsElement coderViewModel llmChat ])
]
