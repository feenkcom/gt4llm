Class {
	#name : #GtLChatStopButtonHandler,
	#superclass : #Object,
	#instVars : [
		'button',
		'chat'
	],
	#category : 'Gt4LlmCore-UI - Support'
}

{ #category : #accessing }
GtLChatStopButtonHandler >> button [
	^ button
]

{ #category : #accessing }
GtLChatStopButtonHandler >> button: anObject [
	button := anObject
]

{ #category : #accessing }
GtLChatStopButtonHandler >> chat [
	^ chat
]

{ #category : #accessing }
GtLChatStopButtonHandler >> chat: anObject [
	chat := anObject
]

{ #category : #'private - event handling' }
GtLChatStopButtonHandler >> onChatExecutionStateChanged: anAnnouncement [
	anAnnouncement state
		ifCanStop: [ self button
				enable;
				visibility: BlVisibility visible ]
		ifStopping: [ self button
				disable;
				visibility: BlVisibility visible ]
		ifIdle: [ self button
				disable;
				visibility: BlVisibility hidden ]
]

{ #category : #building }
GtLChatStopButtonHandler >> subscribe [
	self button userData at: self class put: self.

	self chat announcer weak
		when: GtLChatExecutionStateChanged
		send: #onChatExecutionStateChanged:
		to: self
]
