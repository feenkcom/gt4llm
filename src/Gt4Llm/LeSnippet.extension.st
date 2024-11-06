Extension { #name : #LeSnippet }

{ #category : #'*Gt4Llm' }
LeSnippet >> tutor [
	^ GtOpenAILepiterSnippetTutor withApiKeyFromFile
		forSnippet: self;
		createAssistant
]
