Extension { #name : #GtLModelUserMessage }

{ #category : #'*Gt4Llm-VectorDb' }
GtLModelUserMessage >> addContextFromRag: aGtRag [
	| contextPageNames |

	contextPageNames := aGtRag query: self contentText.
	contextPageNames do: [ :pageName |
		self pageObjectExplanation: (aGtRag pageNamed: pageName) ].
]
