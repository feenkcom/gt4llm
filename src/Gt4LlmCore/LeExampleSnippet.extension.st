Extension { #name : #LeExampleSnippet }

{ #category : #'*Gt4LlmCore' }
LeExampleSnippet >> gtLlmSnippetContent [
	"Return a copy of my annotation, {{gtExample:...}}: the text Lepiter shows for me and that my changes (LeExampleSnippetChange) write, so previews and applied results show the same text. It names every attribute that is not at its default, so nothing is lost. Diffed by words"

	^ GtLLepiterSnippetStringContent string: self contentAsString diffKind: #text
]
