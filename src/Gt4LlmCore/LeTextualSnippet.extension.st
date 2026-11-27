Extension { #name : #LeTextualSnippet }

{ #category : #'*Gt4LlmCore' }
LeTextualSnippet >> gtLlmSnippetContent [
	"Return a copy of my text, diffed by lines"

	^ GtLLepiterSnippetStringContent string: self contentAsString diffKind: #lines
]
