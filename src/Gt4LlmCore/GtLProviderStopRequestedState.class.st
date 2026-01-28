Class {
	#name : #GtLProviderStopRequestedState,
	#superclass : #GtLProviderState,
	#category : #'Gt4LlmCore-Core'
}

{ #category : #'as yet unclassified' }
GtLProviderStopRequestedState >> finished [
	"Set to finished state"

	^ GtLProviderState idle
]
