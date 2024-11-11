Extension { #name : #LeTextSnippet }

{ #category : #'*Gt4OpenAI' }
LeTextSnippet >> tutor [
	^ GtOpenAILepiterTextSnippetTutor withApiKeyFromFile
		forSnippet: self;
		createAssistant
]
