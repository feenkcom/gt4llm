Extension { #name : #BlElement }

{ #category : #'*Gt4LlmCore' }
BlElement >> llmImageViewFor: aDataView [
	<gtLlmDataView>
	
	^aDataView imageData
			title: 'Visual Diff' ;
			element: [ self ]
]
