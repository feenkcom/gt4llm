Class {
	#name : #GtLProviderScheduledState,
	#superclass : #GtLProviderState,
	#category : #'Gt4LlmCore-Provider - Support'
}

{ #category : #'api - testing' }
GtLProviderScheduledState >> ifCanStop: aCanBlock ifStopping: aStoppingBlock ifIdle: anIdleBlock [
	"Evaluate aCanBlock if provider can be stopped.
	Evaluate aStoppingBlock if provider is already stopping existing execution.
	Evaluate anIdleBlock otherwise."

	^ aCanBlock value
]

{ #category : #'api - changes' }
GtLProviderScheduledState >> running [
	"Set to running state, which means that a message is processed."

	^ GtLProviderState running
]

{ #category : #'api - changes' }
GtLProviderScheduledState >> stop [
	"Interrupt ongoing provider execution."

	^ GtLProviderState stopping
]
