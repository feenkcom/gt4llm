Class {
	#name : #GtLProviderStoppingState,
	#superclass : #GtLProviderState,
	#category : #'Gt4LlmCore-Provider - Support'
}

{ #category : #'api - changes' }
GtLProviderStoppingState >> finished [
	"Set to finished state"

	^ GtLProviderState idle
]

{ #category : #'api - testing' }
GtLProviderStoppingState >> ifCanStop: aCanBlock ifStopping: aStoppingBlock ifIdle: anIdleBlock [
	"Evaluate aCanBlock if provider can be stopped.
	Evaluate aStoppingBlock if provider is already stopping existing execution.
	Evaluate anIdleBlock otherwise."
	
	^ aStoppingBlock value
]
