Extension { #name : #GtBPEEncoder }

{ #category : #'*Gt4Llm-GToolkit' }
GtBPEEncoder >> getStatsFor: aListOfTokens [
	| stats |
	stats := GtCounter new.
	1
		to: aListOfTokens size - 1
		do: [ :anIndex | 
			stats
				increment: {aListOfTokens at: anIndex.
						aListOfTokens at: anIndex + 1} ].
	^ stats
]
