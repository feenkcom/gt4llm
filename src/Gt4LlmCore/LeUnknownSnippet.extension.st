Extension { #name : #LeUnknownSnippet }

{ #category : #'*Gt4LlmCore' }
LeUnknownSnippet >> gtLlmSnippetContent [
	"My class could not be loaded and I have no contentAsString: keep my JSON, diffed by lines"

	^ GtLLepiterSnippetStringContent string: self jsonString diffKind: #lines
]
