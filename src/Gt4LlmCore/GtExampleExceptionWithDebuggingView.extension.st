Extension { #name : #GtExampleExceptionWithDebuggingView }

{ #category : #'*Gt4LlmCore' }
GtExampleExceptionWithDebuggingView >> llmDiffJsonViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView jsonData: [ self computeDiff asJsonData ]
]

{ #category : #'*Gt4LlmCore' }
GtExampleExceptionWithDebuggingView >> llmExpectedAndActualStringViewFor: aDataView [
	<gtLlmDataView>
	
	^aDataView jsonObject: [ :data |
			data at: 'expectedString' put: expectedString.
			data at: 'actualString' put: actualString. ]
]
