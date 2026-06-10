Extension { #name : #GtExampleExceptionWithDebuggingView }

{ #category : #'*Gt4LlmCore' }
GtExampleExceptionWithDebuggingView >> llmDiffJsonViewFor: aDataView [
	<gtLlmDataView>
	^ aDataView jsonData
		dataKey: 'stringDiffFromExpectedToActual';
		data: [ self computeDiff asJsonData ]
]
