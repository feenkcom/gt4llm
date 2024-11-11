Extension { #name : #LeTextSnippet }

{ #category : #'*Gt4Llm' }
LeTextSnippet >> tutor [
	^ GtOpenAILepiterTextSnippetTutor withApiKeyFromFile
		forSnippet: self;
		createAssistant
]
