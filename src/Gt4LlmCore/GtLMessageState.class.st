Class {
	#name : #GtLMessageState,
	#superclass : #Object,
	#classVars : [
		'Created',
		'Finished',
		'Running',
		'Skipped'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #factory }
GtLMessageState class >> created [
	^ self
		gtDo: [ Created ifNil: [ Created := GtLMessageCreatedState new ] ]
		gemstoneDo: [ SessionTemps current
				at: #GtLMessageState_Created
				ifAbsentPut: [ GtLMessageCreatedState new ] ]
]

{ #category : #factory }
GtLMessageState class >> finished [
	^ self
		gtDo: [ Finished ifNil: [ Finished := GtLMessageFinishedState new ] ]
		gemstoneDo: [ SessionTemps current
				at: #GtLMessageState_Finished
				ifAbsentPut: [ GtLMessageFinishedState new ] ]
]

{ #category : #factory }
GtLMessageState class >> running [
	^ self
		gtDo: [ Running ifNil: [ Running := GtLMessageRunningState new ] ]
		gemstoneDo: [ SessionTemps current
				at: #GtLMessageState_Running
				ifAbsentPut: [ GtLMessageRunningState new ] ]
]

{ #category : #factory }
GtLMessageState class >> skipped [
	^ self
		gtDo: [ Skipped ifNil: [ Skipped := GtLMessageSkippedState new ] ]
		gemstoneDo: [ SessionTemps current
				at: #GtLMessageState_Skipped
				ifAbsentPut: [ GtLMessageSkippedState new ] ]
]

{ #category : #testing }
GtLMessageState >> isFinished [
	^ false
]

{ #category : #'api - accessing' }
GtLMessageState >> messageExecutionStateLabel [
	^ ((self className copyWithout: 'GtLMessage') copyWithout: 'State') asLowercase
]
