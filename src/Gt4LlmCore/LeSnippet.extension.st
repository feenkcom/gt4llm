Extension { #name : #LeSnippet }

{ #category : #'*Gt4LlmCore' }
LeSnippet >> gtLlmSnippetContent [
	"Return a copy of my content for the snapshots of the Lepiter change results: my specific properties"

	^ GtLLepiterSnippetPropertiesContent fromSnippet: self
]
