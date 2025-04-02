Extension { #name : #GtPharoSnippetCoder }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtPharoSnippetCoder >> initializeLlmAddOnsFor: anAst into: addOns [
	"<gtAstCoderAddOns: 10>"
	addOns
		addDropDownAction: 'Open Chat' translated
		icon: BrGlamorousVectorIcons openAi
		stencil: [ :aCoderUIModel :anElement | 
			GtLlmEmbeddedChatElement new
				chatViewModel: self llmChat asViewModel ]
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtPharoSnippetCoder >> llmChat [
	^" self
		attributeNamed: #llmChat
		ifAbsent: [ self
				attributeNamed: #llmChat
				put: "(GtCodeSnippetTutor new chatOnSnippet: self) "]"
]
