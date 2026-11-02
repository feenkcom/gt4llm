"
I am a transcript-local message sent between agent sessions. Metadata patches and content chunks retain my identity. I distinguish agent communication from human input and expose sender, recipient and counterpart messages.
"
Class {
	#name : #GtLACPInterSessionMessage,
	#superclass : #GtLACPConversationMessage,
	#instVars : [
		'session',
		'turn',
		'data'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #converting }
GtLACPInterSessionMessage >> asElement [
 ^ (GtLACPChatMessageViewModel new turn: turn; message: self; yourself) asElement
]

{ #category : #converting }
GtLACPInterSessionMessage >> chatElementClass [
 ^ GtLACPInterSessionMessageElement
]

{ #category : #accessing }
GtLACPInterSessionMessage >> chatLabel [
 | other |
 other := self counterpart.
 other ifNil: [ ^ 'Agent message' ].
 ^ (self isOutgoing ifTrue: [ 'To ' ] ifFalse: [ 'From ' ]), other conversationTitle
]

{ #category : #accessing }
GtLACPInterSessionMessage >> counterpart [
 | id |
 id := self isOutgoing ifTrue: [ self recipientSessionId ] ifFalse: [ self senderSessionId ].
 ^ session connection sessions at: id ifAbsent: [ nil ]
]

{ #category : #accessing }
GtLACPInterSessionMessage >> counterpartMessage [
 | other id |
 other := self counterpart.
 other ifNil: [ ^ nil ].
 id := data at: (self isOutgoing ifTrue: [ 'recipientMessageId' ] ifFalse: [ 'senderMessageId' ]) ifAbsent: [ ^ nil ].
 ^ other interSessionMessages detect: [ :message | message messageId = id ] ifNone: [ nil ]
]

{ #category : #accessing }
GtLACPInterSessionMessage >> data [
 ^ data
]

{ #category : #views }
GtLACPInterSessionMessage >> gtRoutingFor: aView [
 <gtView>
 ^ aView columnedList title: 'Routing'; priority: 0;
  items: [ { 'Transcript' -> session. 'Sender ID' -> self senderSessionId.
   'Recipient ID' -> self recipientSessionId. 'Other conversation' -> self counterpart.
   'Counterpart message' -> self counterpartMessage. 'Metadata' -> data } ];
  column: 'Field' text: #key; column: 'Value' text: [ :entry | entry value printString ]; send: #value
]

{ #category : #testing }
GtLACPInterSessionMessage >> hasCompletedReply [
 ^ false
]

{ #category : #initialization }
GtLACPInterSessionMessage >> initialize [
 super initialize.
 role := #session.
 data := Dictionary new
]

{ #category : #testing }
GtLACPInterSessionMessage >> isChildCoordination [
 | otherId |
 otherId := self isOutgoing ifTrue: [ self recipientSessionId ] ifFalse: [ self senderSessionId ].
 ^ session childSessions anySatisfy: [ :child | child remoteSessionId = otherId ]
]

{ #category : #testing }
GtLACPInterSessionMessage >> isInterSessionMessage [
 ^ true
]

{ #category : #testing }
GtLACPInterSessionMessage >> isOutgoing [
 ^ self senderSessionId = session remoteSessionId and: [ self recipientSessionId ~= session remoteSessionId ]
]

{ #category : #accessing }
GtLACPInterSessionMessage >> recipientSessionId [
 ^ data at: 'recipientSessionId' ifAbsent: [ nil ]
]

{ #category : #accessing }
GtLACPInterSessionMessage >> senderSessionId [
 ^ data at: 'senderSessionId' ifAbsent: [ nil ]
]

{ #category : #accessing }
GtLACPInterSessionMessage >> session [
 ^ session
]

{ #category : #accessing }
GtLACPInterSessionMessage >> session: aSession [
 session := aSession
]

{ #category : #accessing }
GtLACPInterSessionMessage >> turn [
 ^ turn
]

{ #category : #accessing }
GtLACPInterSessionMessage >> turn: aTurn [
 turn := aTurn
]

{ #category : #updating }
GtLACPInterSessionMessage >> updateFrom: anUpdate [
 (anUpdate at: 'sessionUpdate') = 'session_message_chunk'
  ifTrue: [ content add: (GtLACPContentBlock new data: (anUpdate at: 'content') deepCopy; yourself) ]
  ifFalse: [
   anUpdate keysAndValuesDo: [ :key :value |
    (#('content' 'sessionUpdate') includes: key) ifFalse: [
     value ifNil: [ data removeKey: key ifAbsent: [ ] ]
      ifNotNil: [ data at: key put: value deepCopy ] ] ].
   (anUpdate includesKey: 'content') ifTrue: [
    content := ((anUpdate at: 'content') ifNil: [ #() ])
     collect: [ :block | GtLACPContentBlock new data: block deepCopy; yourself ] as: OrderedCollection ] ]
]
