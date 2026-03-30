Class {
	#name : #GtLSettings,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Support'
}

{ #category : #settings }
GtLSettings class >> defaultToolbarCellSpacing [
	^ 5
]

{ #category : #settings }
GtLSettings class >> futureExecutionConfiguration [
	"Future that calls LLM servers, tools, etc."

	^ AsyncFutureExecutionConfiguration new
		customGroup: #AI;
		lowPriority
]

{ #category : #settings }
GtLSettings class >> futureUIExecutionConfiguration [
	"Future that computes UI elements"

	^ AsyncFutureExecutionConfiguration new
		customGroup: #AI;
		highPriority
]

{ #category : #settings }
GtLSettings class >> messageViewPragmaNames [
	^ #(gtLlmMessageView gtLlmView)
]
