Class {
	#name : #GtLProviderState,
	#superclass : #Object,
	#classVars : [
		'Idle',
		'Running',
		'Scheduled',
		'Stopping'
	],
	#category : #'Gt4LlmCore-Provider - Support'
}

{ #category : #factory }
GtLProviderState class >> idle [
	^ self
		gtDo: [ Idle ifNil: [ Idle := GtLProviderIdleState new ] ]
		gemstoneDo: [ SessionTemps current
				at: #GtLProviderState_Idle
				ifAbsentPut: [ GtLProviderIdleState new ] ]
]

{ #category : #factory }
GtLProviderState class >> running [
	^ self
		gtDo: [ Running ifNil: [ Running := GtLProviderRunningState new ] ]
		gemstoneDo: [ SessionTemps current
				at: #GtLProviderState_Running
				ifAbsentPut: [ GtLProviderRunningState new ] ]
]

{ #category : #factory }
GtLProviderState class >> scheduled [
	^ self
		gtDo: [ Scheduled ifNil: [ Scheduled := GtLProviderScheduledState new ] ]
		gemstoneDo: [ SessionTemps current
				at: #GtLProviderState_Scheduled
				ifAbsentPut: [ GtLProviderScheduledState new ] ]
]

{ #category : #factory }
GtLProviderState class >> stopping [
	^ self
		gtDo: [ Stopping ifNil: [ Stopping := GtLProviderStoppingState new ] ]
		gemstoneDo: [ SessionTemps current
				at: #GtLProviderState_Stopping
				ifAbsentPut: [ GtLProviderStoppingState new ] ]
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
