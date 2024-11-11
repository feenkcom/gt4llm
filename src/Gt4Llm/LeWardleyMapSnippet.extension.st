Extension { #name : #LeWardleyMapSnippet }

{ #category : #'*Gt4Llm' }
LeWardleyMapSnippet >> tutor [
	^ GtOpenAILepiterWardleyMapSnippetTutor withApiKeyFromFile
		forSnippet: self;
		createAssistant
]
