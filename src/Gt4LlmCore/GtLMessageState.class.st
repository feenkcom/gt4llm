Class {
	#name : #GtLMessageState,
	#superclass : #Object,
	#classVars : [
		'Created',
		'Finished',
		'Running'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #factory }
GtLMessageState class >> created [
	^ Created ifNil: [ Created := GtLMessageCreatedState new ]
]

{ #category : #factory }
GtLMessageState class >> finished [
	^ Finished ifNil: [ Finished := GtLMessageFinishedState new ]
]

{ #category : #factory }
GtLMessageState class >> running [
	^ Running ifNil: [ Running := GtLMessageRunningState new ]
]

{ #category : #'api - accessing' }
GtLMessageState >> messageExecutionStateLabel [
	^ ((self className copyWithout: 'GtLMessage') copyWithout: 'State') asLowercase
]
