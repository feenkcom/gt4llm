Extension { #name : #GtLModelUserMessage }

{ #category : #'*Gt4Llm-VectorDb' }
GtLModelUserMessage >> addContextFromRag: aGtRag [
	| ragContext ragPages |

	ragContext := aGtRag asRagQueryContext
		queryString: self contentText.
	ragPages := aGtRag asRag query: ragContext.
	ragPages do: [ :ragPage |
		self pageObjectExplanation: ragPage page ].
]
