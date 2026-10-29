"
I announce a session state change and optionally identify the affected explicit user or assistant message. Subscribers can invalidate that message alone, including older messages. UI subscribers dispatch element updates onto their UI thread.
"
Class {
	#name : #GtLACPSessionChanged,
	#superclass : #Announcement,
	#instVars : [
		'session',
		'message'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #accessing }
GtLACPSessionChanged >> message [
 ^ message
]

{ #category : #accessing }
GtLACPSessionChanged >> message: aMessage [
 message := aMessage
]

{ #category : #accessing }
GtLACPSessionChanged >> session [
 ^ session
]

{ #category : #accessing }
GtLACPSessionChanged >> session: anObject [
 session := anObject
]
