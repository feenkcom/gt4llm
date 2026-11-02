"
Agent Client Protocol v1 integration for Glamorous Toolkit. See GtLACPExamples for executable usage.
"
Class {
	#name : #GtLACPPermissionRequest,
	#superclass : #GtLACPObject,
	#instVars : [
		'connection',
		'requestId',
		'session',
		'toolCall',
		'options',
		'decision',
		'state'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #actions }
GtLACPPermissionRequest >> abandon [
 [
 state = #pending ifTrue: [ state := #cancelled ]
 ] ensure: [ session ifNotNil: [ session announcePermissionChanged: self ] ]
]

{ #category : #actions }
GtLACPPermissionRequest >> cancel [
 [
 state = #pending ifFalse: [ ^ self ].
 state := #cancelled.
 connection replyTo: requestId result: { 'outcome' -> { 'outcome' -> 'cancelled' } asDictionary } asDictionary
 ] ensure: [ session ifNotNil: [ session announcePermissionChanged: self ] ]
]

{ #category : #accessing }
GtLACPPermissionRequest >> connection [
 ^ connection
]

{ #category : #accessing }
GtLACPPermissionRequest >> connection: anObject [
 connection := anObject
]

{ #category : #accessing }
GtLACPPermissionRequest >> decision [
 ^ decision
]

{ #category : #accessing }
GtLACPPermissionRequest >> decision: anObject [
 decision := anObject
]

{ #category : #actions }
GtLACPPermissionRequest >> gtCancelFor: anAction [
 <gtAction>
 state = #pending ifFalse: [ ^ anAction noAction ].
 ^ anAction button label: 'Cancel request'; priority: 50; action: [ self cancel ]
]

{ #category : #views }
GtLACPPermissionRequest >> gtDecisionFor: aView [
 <gtView>
 ^ aView columnedList title: 'Decision'; priority: 10;
  items: [ { 'Status' -> state. 'Selected option' -> decision. 'Request ID' -> requestId } ];
  column: 'Permission decision' text: #key;
  column: 'Value' text: [ :entry | entry value printString ];
  send: #value;
  actionUpdateButtonTooltip: 'Refresh permission decision'
]

{ #category : #views }
GtLACPPermissionRequest >> gtOperationFor: aView [
 <gtView>
 toolCall ifNil: [ ^ aView empty ].
 ^ aView forward title: 'Requested operation'; priority: 0;
  object: [ toolCall ]; view: #gtDataFor:
]

{ #category : #views }
GtLACPPermissionRequest >> gtOptionsFor: aView [
 <gtView>
 ^ aView list title: 'Choices'; priority: 5; items: [ options ]; itemText: #name; actionUpdateButtonTooltip: 'Refresh choices'
]

{ #category : #accessing }
GtLACPPermissionRequest >> initialize [
 super initialize.
 options := #().
 state := #pending
]

{ #category : #accessing }
GtLACPPermissionRequest >> options [
 ^ options
]

{ #category : #accessing }
GtLACPPermissionRequest >> options: anObject [
 options := anObject
]

{ #category : #printing }
GtLACPPermissionRequest >> printOn: aStream [
 aStream nextPutAll: 'Permission ('; nextPutAll: state asString; nextPutAll: ')'.
 toolCall ifNotNil: [ aStream space; nextPutAll: toolCall title ]
]

{ #category : #accessing }
GtLACPPermissionRequest >> requestId [
 ^ requestId
]

{ #category : #accessing }
GtLACPPermissionRequest >> requestId: anObject [
 requestId := anObject
]

{ #category : #actions }
GtLACPPermissionRequest >> resolve: anOptionId [
 | choice |
 [
 state = #pending ifFalse: [ self error: 'Permission request has already been resolved' ].
 choice := options detect: [ :each | each id = anOptionId ]
  ifNone: [ self error: 'Unknown permission option' ].
 decision := choice.
 state := #selected.
 connection replyTo: requestId result: { 'outcome' -> {
  'outcome' -> 'selected'. 'optionId' -> choice id } asDictionary } asDictionary
 ] ensure: [ session ifNotNil: [ session announcePermissionChanged: self ] ]
]

{ #category : #accessing }
GtLACPPermissionRequest >> session [
 ^ session
]

{ #category : #accessing }
GtLACPPermissionRequest >> session: anObject [
 session := anObject
]

{ #category : #accessing }
GtLACPPermissionRequest >> state [
 ^ state
]

{ #category : #accessing }
GtLACPPermissionRequest >> state: anObject [
 state := anObject
]

{ #category : #accessing }
GtLACPPermissionRequest >> toolCall [
 ^ toolCall
]

{ #category : #accessing }
GtLACPPermissionRequest >> toolCall: anObject [
 toolCall := anObject
]
