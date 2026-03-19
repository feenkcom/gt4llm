Extension { #name : #GtMondrian }

{ #category : #'*Gt4LlmCore' }
GtMondrian >> llmImageViewFor: aDataView [
	<gtLlmDataView>
	^ aDataView imageData
		title: 'Element';
		element: [ self asElement ]
]
