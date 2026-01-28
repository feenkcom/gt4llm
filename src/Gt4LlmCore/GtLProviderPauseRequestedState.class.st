Class {
	#name : #GtLProviderPauseRequestedState,
	#superclass : #GtLProviderState,
	#category : #'Gt4LlmCore-Core'
}

{ #category : #'api - changes' }
GtLProviderPauseRequestedState >> finished [
	"Set to finished state"

	^ GtLProviderState idle
]
