Extension { #name : #LePlainTextSnippet }

{ #category : #'*Gt4LlmCore' }
LePlainTextSnippet >> gtLlmSnippetContent [
	"Return a copy of my text, diffed by words"

	^ GtLLepiterSnippetStringContent string: self contentAsString diffKind: #text
]
