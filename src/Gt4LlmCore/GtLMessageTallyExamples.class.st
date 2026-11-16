"
I validate the textual report exposed to LLMs by MessageTally.
"
Class {
	#name : #GtLMessageTallyExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLMessageTallyExamples >> textReportLlmView [
	<gtExample>
	| tally view |
	tally := MessageTally gtExampleSimplePrintString.
	view := tally llmTextReportFor: GtLDataView empty.
	self assert: (view llmJsonData at: 'report') equals: tally textReport.
	self assert: tally textReport notEmpty.
	self assert: (tally llmDataViewsInContext: GtLDataViewContext new) notEmpty.
	^ tally
]
