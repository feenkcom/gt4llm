"
I adapt an explicit GtLACPUserMessage or GtLACPAssistantMessage for the chat. I preserve independent expansion choices for the assistant work, final reply and individual tools.
"
Class {
	#name : #GtLACPChatMessageViewModel,
	#superclass : #GtLACPObject,
	#instVars : [
		'turn',
		'message',
		'role',
		'expandedTools',
		'sectionExpansion'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #accessing }
GtLACPChatMessageViewModel >> activityItems [
 ^ message activityItems
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

{ #category : #accessing }
GtLACPChatMessageViewModel >> inspectionTarget [
 ^ message
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> isSectionExpanded: aName [
 ^ sectionExpansion ifNil: [ false ] ifNotNil: [
  sectionExpansion at: aName ifAbsent: [ false ] ]
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> isToolExpanded: aTool [
 ^ expandedTools notNil and: [ expandedTools includes: aTool ]
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> label [
 ^ role = #user ifTrue: [ 'You' ] ifFalse: [ turn session client displayName, ' · ', turn state asString ]
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> message [
 ^ message
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> message: anObject [
 message := anObject
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> messages [
 ^ message messages
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> replyMessages [
 ^ message finalMessages
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> role [
 ^ role
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> role: anObject [
 role := anObject
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> section: aName expanded: aBoolean [
 sectionExpansion ifNil: [ sectionExpansion := Dictionary new ].
 sectionExpansion at: aName put: aBoolean
]

{ #category : #accessing }
GtLACPChatMessageViewModel >> tool: aTool expanded: aBoolean [
 expandedTools ifNil: [ expandedTools := IdentitySet new ].
 aBoolean
  ifTrue: [ expandedTools add: aTool ]
  ifFalse: [ expandedTools remove: aTool ifAbsent: [ ] ]
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
