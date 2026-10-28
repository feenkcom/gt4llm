"
I announce that an ACP session's visible state changed. Streaming, permissions, prompt completion, cancellation and connection state changes emit me. UI subscribers must dispatch updates onto their UI thread.
"
Class {
	#name : #GtLACPSessionChanged,
	#superclass : #Announcement,
	#instVars : [
		'session'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #accessing }
GtLACPSessionChanged >> session [
 ^ session
]

{ #category : #accessing }
GtLACPSessionChanged >> session: anObject [
 session := anObject
]
