Class {
	#name : #GtLProviderIdleState,
	#superclass : #GtLProviderState,
	#category : #'Gt4LlmCore-Provider - Support'
}

{ #category : #'api - changes' }
GtLProviderIdleState >> scheduled [
	"Set to scheduled state, which means that it is not running a code yet,
	but is about to schedule/start one."

	^ GtLProviderState scheduled
]
