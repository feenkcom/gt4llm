Extension { #name : #GtLModelUserMessage }

{ #category : #'*Gt4Llm-VectorDb' }
GtLModelUserMessage >> addContextFromRag: aGtRag [
	| ragContext ragPages |

	ragContext := GtLLepiterRagQueryContext new
		queryString: self contentText.
	ragPages := aGtRag query: ragContext.
	ragPages do: [ :ragPage |
		self pageObjectExplanation: ragPage page ].
]
