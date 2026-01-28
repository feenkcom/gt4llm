Class {
	#name : #GtLProviderRunningState,
	#superclass : #GtLProviderState,
	#category : #'Gt4LlmCore-Provider - Support'
}

{ #category : #'api - changes' }
GtLProviderRunningState >> finished [
	"Set to finished state"

	^ GtLProviderState idle
]

{ #category : #'api - testing' }
GtLProviderRunningState >> ifCanContinue: aCanBlock ifDisabled: aDisabledBlock [
	"Evaluate aCanBlock if provider can proceed in executing other messages.
	Evaluate aDisabledBlock otherwise."

	^ aCanBlock value
]

{ #category : #'api - testing' }
GtLProviderRunningState >> ifCanStop: aCanBlock ifIdle: anIdleBlock [
	"Evaluate aCanBlock if provider can be stopped.
	Evaluate anIdleBlock otherwise."

	^ aCanBlock value
]

{ #category : #'api - changes' }
GtLProviderRunningState >> stop [
	"Interrupt ongoing provider execution."

	^ GtLProviderState idle
]
