Extension { #name : #GtSamplingProfiler }

{ #category : #'*Gt4LlmCore' }
GtSamplingProfiler >> llmTextReportFor: aDataView [
	"What does the sampling profile report about the call tree, memory and garbage collection?"

	<gtLlmDataView>
	^ aDataView
		title: 'Text report';
		jsonData: [ {'report' -> self textReport} asDictionary ]
]
