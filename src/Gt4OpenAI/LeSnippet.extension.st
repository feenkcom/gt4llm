Extension { #name : #LeSnippet }

{ #category : #'*Gt4OpenAI' }
LeSnippet >> tutor [
	^ GtOpenAILepiterSnippetTutor withApiKeyFromFile
		forSnippet: self;
		createAssistant
]
