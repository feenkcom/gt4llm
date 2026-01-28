Class {
	#name : #GtLProviderState,
	#superclass : #Object,
	#classVars : [
		'Idle',
		'Running',
		'Scheduled'
	],
	#category : #'Gt4LlmCore-Core'
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

{ #category : #'api - changes' }
GtLProviderState >> finished [
	"Set to finished state"

	^ self
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
