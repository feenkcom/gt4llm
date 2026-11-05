"
I display an amber ACP input-needed notification. Inspect opens the root session tool at the exact pending request without dismissing the notification.
"
Class {
	#name : #GtLACPInputNeededNotificationElement,
	#superclass : #GtObjectNotificationMessageElement,
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #initialization }
GtLACPInputNeededNotificationElement >> initialize [
	super initialize.
	self inspectButton id: #'acp-input-notification-inspect'.
	self borderElement
		borderDo: [ :border | 
			border border: (BlBorder paint: GtLACPInputNeededElement amberColor width: 1).
			border background: GtLACPInputNeededElement paleAmberColor ]
]

{ #category : #actions }
GtLACPInputNeededNotificationElement >> inspectObject [
	self
		notificationDo: [ :notification | self phlow spawnTool: notification navigationTool ]
]
