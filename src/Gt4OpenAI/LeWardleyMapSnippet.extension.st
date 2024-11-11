Extension { #name : #LeWardleyMapSnippet }

{ #category : #'*Gt4OpenAI' }
LeWardleyMapSnippet >> tutor [
	^ GtOpenAILepiterWardleyMapSnippetTutor withApiKeyFromFile
		forSnippet: self;
		createAssistant
]
