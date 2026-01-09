Class {
	#name : #GtLSettings,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Support'
}

{ #category : #settings }
GtLSettings class >> futureExecutionConfiguration [
	^ AsyncFutureExecutionConfiguration new
		customGroup: #AI;
		lowPriority
]
