Extension { #name : #GtPharoSnippetCoder }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtPharoSnippetCoder >> initializeLlmAddOnsFor: anAst into: addOns viewModel: aGtPharoSourceCoderViewModel [
	"we use the extension from the lepiter snippet menu instead"
	"<gtAstCoderAddOns: 10>"
	GtLlmFeatures isEnabledInCoder ifFalse: [ ^ self ].
	GtLlmConnectionRegistry instance hasConnectableConnection ifFalse: [ ^ self ].
	"addOns addStyler: GtLlmInstructionInPharoCommentStyler new."
	addOns
		addMainAction: (GtCoderCustomAction new
				title: 'Open chat';
				stencil: [ GtLlmCoderChatButton new chat: aGtPharoSourceCoderViewModel llmChat ])
]
