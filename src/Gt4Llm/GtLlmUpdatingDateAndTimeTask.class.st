Class {
	#name : #GtLlmUpdatingDateAndTimeTask,
	#superclass : #BlRepeatedTask,
	#instVars : [
		'dateAndTime',
		'converter'
	],
	#category : #'Gt4Llm-Widgets'
}

{ #category : #accessing }
GtLlmUpdatingDateAndTimeTask >> converter [
	^ converter
]

{ #category : #accessing }
GtLlmUpdatingDateAndTimeTask >> converter: anObject [
	converter := anObject
]

{ #category : #accessing }
GtLlmUpdatingDateAndTimeTask >> dateAndTime [
	^ dateAndTime
]

{ #category : #accessing }
GtLlmUpdatingDateAndTimeTask >> dateAndTime: anObject [
	dateAndTime := anObject
]

{ #category : #'private - event handling' }
GtLlmUpdatingDateAndTimeTask >> elementRemovedFromSceneGraphEvent: anEvent [
	delay := 0 milliSeconds.
	super elementRemovedFromSceneGraphEvent: anEvent
]

{ #category : #initialization }
GtLlmUpdatingDateAndTimeTask >> initialize [
	super initialize.
	delay := 0 milliSeconds.
	converter := [ :aDuration | aDuration gtHumanReadableString ]
]

{ #category : #hooks }
GtLlmUpdatingDateAndTimeTask >> onEnqueuedInElement: anElement [
	super onEnqueuedInElement: anElement.

	element == anElement ifTrue: [ ^ self ].

	delay := 0 milliSeconds
]

{ #category : #'api - running' }
GtLlmUpdatingDateAndTimeTask >> onRun [
	| aDuration aText |
	dateAndTime ifNil: [ ^ self ].

	aDuration := DateAndTime now - dateAndTime.
	aText := converter value: aDuration.
	element text: aText.
	
	aDuration < 1 minute ifTrue: [ delay := 1 seconds. ^ self ].
	aDuration < 1 hour ifTrue: [ delay := 1 minute. ^ self ].
	delay := 1 hour.
]

{ #category : #'api - running' }
GtLlmUpdatingDateAndTimeTask >> stop [ 
	super stop.
	delay := 0 milliSeconds
]
