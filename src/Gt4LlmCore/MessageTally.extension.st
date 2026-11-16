Extension { #name : #MessageTally }

{ #category : #'*Gt4LlmCore' }
MessageTally >> llmTextReportFor: aDataView [
	"What does the message tally report about the call tree, memory and garbage collection?"

	<gtLlmDataView>
	^ aDataView
		title: 'Text report';
		jsonData: [ {'report' -> self textReport} asDictionary ]
]
