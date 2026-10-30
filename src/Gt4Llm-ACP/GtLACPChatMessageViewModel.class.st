"
I create the element for an explicit user or assistant message. I retain work and reply expansion choices across element recreation, and expose a rendering key so the list can replace an outdated presentation.
"
Class {
	#name : #GtLACPChatMessageViewModel,
	#superclass : #GtLACPObject,
	#instVars : [
		'turn',
		'message',
		'sectionExpansion',
		'renderingVersion',
		'finalReplyAutoExpanded'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #accessing }
GtLACPChatMessageViewModel >> activityItems [
 ^ message activityItems
]

{ #category : #converting }
GtLACPChatMessageViewModel >> asElement [
 ^ message chatElementClass new
  viewModel: self;
  build;
  yourself
]

{ #category : #updating }
GtLACPChatMessageViewModel >> changed [
 "Invalidate only this row. Its view model retains presentation state."
 self expandCompletedFinalReply.
 renderingVersion := self renderingVersion + 1
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

{ #category : #private }
GtLACPChatMessageViewModel >> expandCompletedFinalReply [
 finalReplyAutoExpanded ifTrue: [ ^ self ].
 message hasCompletedReply ifFalse: [ ^ self ].
 finalReplyAutoExpanded := true.
 self section: #final expanded: true
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
 sectionExpansion := Dictionary new.
 renderingVersion := 0.
 finalReplyAutoExpanded := false
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> inspectionTarget [
 ^ message
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> isSectionExpanded: aName [
 ^ sectionExpansion at: aName ifAbsent: [ false ]
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
 finalReplyAutoExpanded := false.
 self changed
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> messages [
 ^ message messages
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

{ #category : #accessing }
GtLACPChatMessageViewModel >> section: aName expanded: aBoolean [
 sectionExpansion at: aName put: aBoolean
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
