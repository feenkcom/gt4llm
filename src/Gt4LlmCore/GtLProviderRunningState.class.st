Class {
	#name : #GtLProviderRunningState,
	#superclass : #GtLProviderState,
	#category : #'Gt4LlmCore-Core'
}

{ #category : #'api - changes' }
GtLProviderRunningState >> finished [
	"Set to finished state"

	^ GtLProviderState idle
]
