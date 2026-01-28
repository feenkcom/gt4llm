Class {
	#name : #GtLProviderScheduledState,
	#superclass : #GtLProviderState,
	#category : #'Gt4LlmCore-Core'
}

{ #category : #'api - changes' }
GtLProviderScheduledState >> running [
	"Set to running state, which means that a message is processed."

	^ GtLProviderState running
]
