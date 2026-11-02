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
		'finalReplyAutoExpanded',
		'selectedFinalViewTitle',
		'delegatedMessageViewModels',
		'elementIdPrefix'
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

{ #category : #updating }
GtLACPChatMessageViewModel >> delegatedViewModelFor: anAssistantMessage [
 delegatedMessageViewModels ifNil: [ delegatedMessageViewModels := IdentityDictionary new ].
 ^ delegatedMessageViewModels at: anAssistantMessage ifAbsentPut: [
  self class new turn: anAssistantMessage turn; message: anAssistantMessage;
   elementIdPrefix: 'acp-agent-', anAssistantMessage turn identityHash asString;
   subscribeToSession; yourself ]
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> elementIdAt: anIndex [
 ^ ('acp-message-', anIndex asString) asSymbol
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> elementIdFor: aSuffix [
 ^ (self elementIdPrefix, '-', aSuffix asString) asSymbol
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> elementIdPrefix [
 ^ elementIdPrefix ifNil: [ 'acp' ]
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> elementIdPrefix: aString [
 elementIdPrefix := aString
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

{ #category : #accessing }
GtLACPChatMessageViewModel >> section: aName expanded: aBoolean [
 sectionExpansion at: aName put: aBoolean
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> selectedFinalViewTitle [
 ^ selectedFinalViewTitle ifNil: [ 'Markdown' ]
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> selectedFinalViewTitle: aString [
 selectedFinalViewTitle := aString
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
