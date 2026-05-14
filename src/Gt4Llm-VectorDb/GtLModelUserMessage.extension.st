Extension { #name : #GtLModelUserMessage }

{ #category : #'*Gt4Llm-VectorDb' }
GtLModelUserMessage >> addGtBookContextPages [
	| contextPageNames |

	contextPageNames := GtLGtBookExperimentalRag uniqueInstance query: self contentText.
	contextPageNames do: [ :pageName |
		self pageExplanation: pageName ].
]
