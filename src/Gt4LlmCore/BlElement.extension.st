Extension { #name : #BlElement }

{ #category : #'*Gt4LlmCore' }
BlElement >> llmImageViewFor: aDataView [
	<gtLlmDataView>
	
	^aDataView imageData
			title: 'Image' ;
			element: [ self ]
]
