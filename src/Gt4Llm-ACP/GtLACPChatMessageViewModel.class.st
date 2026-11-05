Class {
	#name : #GtLACPChatMessageViewModel,
	#superclass : #GtLACPObject,
	#instVars : [
		'turn',
		'message',
		'sectionExpansion',
		'renderingVersion',
		'finalReplyAutoExpanded',
		'selectedFinalViewTitle',
		'delegatedMessageViewModels'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #accessing }
GtLACPChatMessageViewModel >> activityItems [
 ^ message activityItems
]

{ #category : #converting }
GtLACPChatMessageViewModel >> asElement [
	^ self chatElementClass new
		viewModel: self;
		build;
		yourself
]

{ #category : #updating }
GtLACPChatMessageViewModel >> changed [
	"Invalidate only this row. Its view model retains presentation state."

	renderingVersion := self renderingVersion + 1
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> chatElementClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> dateString [
 | date |
 turn ifNil: [ ^ '' ].
 date := turn startedAt ifNil: [ ^ '' ].
 date := date asLocal.
 ^ String streamContents: [ :stream |
  date asDate printOn: stream format: #(2 1 3 $  3 1 1).
  stream space.
  date hour printOn: stream base: 10 length: 2 padded: true.
  stream nextPut: $:.
  date minute printOn: stream base: 10 length: 2 padded: true ]
]

{ #category : #'element ids' }
GtLACPChatMessageViewModel >> elementIdAt: anIndex [
	^ ('acp-message-' , anIndex asString) asSymbol
]

{ #category : #views }
GtLACPChatMessageViewModel >> gtActivityFor: aView [
 <gtView>
 ^ aView list title: 'Activity'; priority: 7; items: [ self activityItems ];
  itemText: [ :each | (each isKindOf: GtLACPToolCall) ifTrue: [ each title ] ifFalse: [ each text ] ]
]

{ #category : #views }
GtLACPChatMessageViewModel >> gtMessagesFor: aView [
 <gtView>
 ^ aView list title: 'Messages'; priority: 5; items: [ self messages ]; itemText: #printString
]

{ #category : #views }
GtLACPChatMessageViewModel >> gtToolCallsFor: aView [
 <gtView>
 ^ aView list title: 'Tool calls'; priority: 6; items: [ self toolCalls ]; itemText: #title
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> id [
 ^ message ifNil: [ turn ]
]

{ #category : #initialization }
GtLACPChatMessageViewModel >> initialize [
	super initialize.
	renderingVersion := 0
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> inspectionTarget [
 ^ message
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> label [
 ^ message chatLabel
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> message [
 ^ message
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> message: anObject [
	message == anObject ifTrue: [ ^ self ].
	message := anObject.
	self changed
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> messages [
 ^ message messages
]

{ #category : #updating }
GtLACPChatMessageViewModel >> onSessionChanged: anAnnouncement [
 (anAnnouncement sourceSession == turn session
  and: [ anAnnouncement message == message ]) ifTrue: [ self changed ]
]

{ #category : #views }
GtLACPChatMessageViewModel >> phlowContext [
 ^ turn
  ifNil: [ GtPhlowContext new ]
  ifNotNil: [ turn session phlowContext ]
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> renderingKey [
 ^ { self. self renderingVersion }
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> renderingVersion [
 ^ renderingVersion
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> replyMessages [
 ^ message finalMessages
]

{ #category : #updating }
GtLACPChatMessageViewModel >> subscribeToSession [
 turn session announcer weak
  when: GtLACPSessionChanged send: #onSessionChanged: to: self
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> toolCalls [
 ^ message toolCalls
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> turn [
 ^ turn
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> turn: anObject [
 turn := anObject
]
