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
	| tally view report |
	tally := MessageTally gtExampleSimplePrintString.
	report := tally gtTextReport.
	view := tally llmTextReportFor: GtLDataView empty.
	self assert: report notEmpty.
	self assert: (view llmJsonData at: 'report') equals: report.
	^ tally
]
