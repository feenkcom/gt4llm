Extension { #name : #LePharoSnippet }

{ #category : #'*Gt4LlmCore' }
LePharoSnippet >> gtLlmSnippetContent [
	"Return a copy of my code, diffed and styled as Pharo code"

	^ GtLLepiterSnippetStringContent string: self contentAsString diffKind: #code
]
