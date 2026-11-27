Extension { #name : #LeCodeSnippet }

{ #category : #'*Gt4LlmCore' }
LeCodeSnippet >> gtLlmSnippetContent [
	"Return a copy of my code, diffed by lines: code other than Pharo (Python, shell, JavaScript, ...) would be split wrongly by the Pharo diff splitter"

	^ GtLLepiterSnippetStringContent string: self contentAsString diffKind: #lines
]
