"
I represent one pending ACP input request in GT notifications. Resolving the shared request removes me; inspecting or dismissing me does not resolve it.
"
Class {
	#name : #GtLACPInputNeededNotification,
	#superclass : #GtObjectNotificationMessage,
	#instVars : [
		'request'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #notifications }
GtLACPInputNeededNotification >> addedTo: aNotifications [
	super addedTo: aNotifications.
	self updateRequest
]

{ #category : #converting }
GtLACPInputNeededNotification >> elementClass [
	^ GtLACPInputNeededNotificationElement
]

{ #category : #accessing }
GtLACPInputNeededNotification >> inputMessage [
	| root owner |
	owner := request session.
	root := owner rootSession.
	^ String
		streamContents: [ :stream | 
			stream
				nextPutAll: 'Input needed';
				cr;
				nextPutAll: root conversationTitle.
			owner == root
				ifFalse: [ stream
						nextPutAll: ' / ';
						nextPutAll: owner conversationTitle ].
			stream
				cr;
				nextPutAll: request inputDescription ]
]

{ #category : #converting }
GtLACPInputNeededNotification >> navigationTool [
	^ request navigationTool
]

{ #category : #updating }
GtLACPInputNeededNotification >> onSessionChanged: anAnnouncement [
	self updateRequest
]

{ #category : #notifications }
GtLACPInputNeededNotification >> removedFrom: aNotifications [
	super removedFrom: aNotifications.
	request session announcer unsubscribe: self
]

{ #category : #accessing }
GtLACPInputNeededNotification >> request [
	^ request
]

{ #category : #accessing }
GtLACPInputNeededNotification >> request: aRequest [
	request := aRequest.
	self object: request session rootSession.
	self tooltip: 'Inspect ACP session'.
	self message: self inputMessage.
	request session announcer weak
		when: GtLACPSessionChanged
		send: #onSessionChanged:
		to: self
]

{ #category : #updating }
GtLACPInputNeededNotification >> updateRequest [
	| text |
	request state = #pending
		ifFalse: [ request session announcer unsubscribe: self.
			^ self requestRemoval ].
	text := self inputMessage.
	text = self message ifTrue: [ ^ self ].
	self message: text.
	self notifyNotificationDataChanged
]
