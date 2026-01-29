Class {
	#name : #GtLProviderState,
	#superclass : #Object,
	#classVars : [
		'Idle',
		'Running',
		'Scheduled',
		'Stopping'
	],
	#category : 'Gt4LlmCore-Provider - Support'
}

{ #category : #factory }
GtLProviderState class >> idle [
	^ Idle ifNil: [ Idle := GtLProviderIdleState new ]
]

{ #category : #factory }
GtLProviderState class >> running [
	^ Running ifNil: [ Running := GtLProviderRunningState new ]
]

{ #category : #factory }
GtLProviderState class >> scheduled [
	^ Scheduled ifNil: [ Scheduled := GtLProviderScheduledState new ]
]

{ #category : #factory }
GtLProviderState class >> stopping [
	^ Stopping ifNil: [ Stopping := GtLProviderStoppingState new ]
]

{ #category : #'api - changes' }
GtLProviderState >> finished [
	"Set to finished state"

	^ self
]

{ #category : #'api - testing' }
GtLProviderState >> ifCanContinue: aCanBlock ifDisabled: aDisabledBlock [
	"Evaluate aCanBlock if provider can proceed in executing other messages.
	Evaluate aDisabledBlock otherwise."

	^ aDisabledBlock value
]

{ #category : #'api - testing' }
GtLProviderState >> ifCanStop: aCanBlock ifStopping: aStoppingBlock ifIdle: anIdleBlock [
	"Evaluate aCanBlock if provider can be stopped.
	Evaluate aStoppingBlock if provider is already stopping existing execution.
	Evaluate anIdleBlock otherwise."

	^ anIdleBlock value
]

{ #category : #'api - accessing' }
GtLProviderState >> label [
	"Return a simple short string identifying the state"

	<return: #String>
	^ self className
]

{ #category : #'api - changes' }
GtLProviderState >> running [
	"Set to running state, which means that a message is processed."

	^ self
]

{ #category : #'api - changes' }
GtLProviderState >> scheduled [
	"Set to scheduled state, which means that it is not running a code yet,
	but is about to schedule/start one."

	^ self
]

{ #category : #'api - changes' }
GtLProviderState >> stop [
	"Interrupt ongoing provider execution."

	^ self
]
