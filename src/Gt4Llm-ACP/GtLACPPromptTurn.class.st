"
I own one prompt's execution and protocol timeline. User prompts are GtLACPUserMessage objects; my GtLACPAssistantMessage exposes the assistant's tools and reasoning separately from its final reply.
"
Class {
	#name : #GtLACPPromptTurn,
	#superclass : #GtLACPObject,
	#instVars : [
		'session',
		'state',
		'stopReason',
		'messages',
		'toolCalls',
		'permissionRequests',
		'request',
		'error',
		'startedAt',
		'finishedAt',
		'activity',
		'activityVersion',
		'assistantMessage'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #accessing }
GtLACPPromptTurn >> activity [
 (activity isNil or: [ activityVersion ~= 2 ]) ifTrue: [
  activity := self restoredActivity.
  activityVersion := 2 ].
 ^ activity
]

{ #category : #accessing }
GtLACPPromptTurn >> activity: aCollection [
 activity := aCollection.
 activityVersion := aCollection ifNil: [ nil ] ifNotNil: [ 2 ]
]

{ #category : #accessing }
GtLACPPromptTurn >> addMessageWithRole: aRole content: blocks [
 | message |
 message := (aRole = #user ifTrue: [ GtLACPUserMessage ] ifFalse: [ GtLACPConversationMessage ]) new
  role: aRole; content: blocks asOrderedCollection; yourself.
 (#(thought agent) includes: aRole) ifTrue: [ self activity add: message ].
 messages add: message.
 ^ message
]

{ #category : #accessing }
GtLACPPromptTurn >> assistantMessage [
 ^ assistantMessage ifNil: [
  assistantMessage := GtLACPAssistantMessage new turn: self; yourself ]
]

{ #category : #lifecycle }
GtLACPPromptTurn >> complete: aReason [
 stopReason := aReason.
 state := aReason = 'cancelled' ifTrue: [ #cancelled ] ifFalse: [ #completed ].
 finishedAt := DateAndTime now.
 permissionRequests do: #cancel
]

{ #category : #accessing }
GtLACPPromptTurn >> error [
 ^ error
]

{ #category : #lifecycle }
GtLACPPromptTurn >> fail: aReason [
 error := aReason.
 state := #failed.
 finishedAt := DateAndTime now.
 permissionRequests do: #abandon
]

{ #category : #accessing }
GtLACPPromptTurn >> finishedAt [
 ^ finishedAt
]

{ #category : #accessing }
GtLACPPromptTurn >> finishedAt: anObject [
 finishedAt := anObject
]

{ #category : #views }
GtLACPPromptTurn >> gtActivityFor: aView [
 <gtView>
 ^ aView list title: 'Activity'; priority: 6; items: [ self activity copy ];
  itemText: [ :each | (each isKindOf: GtLACPToolCall)
   ifTrue: [ each title, ' · ', each status ]
   ifFalse: [ (each role = #thought ifTrue: [ 'Thinking: ' ] ifFalse: [ 'Assistant: ' ]), each text ] ];
  actionUpdateButtonTooltip: 'Refresh activity'
]

{ #category : #views }
GtLACPPromptTurn >> gtMessagesFor: aView [
 <gtView>
 ^ aView list title: 'Messages'; priority: 5; items: [ messages copy ]; itemText: #printString; actionUpdateButtonTooltip: 'Refresh messages'
]

{ #category : #views }
GtLACPPromptTurn >> gtOutcomeFor: aView [
 <gtView>
 ^ aView columnedList title: 'Outcome'; priority: 0;
  items: [ { 'Status' -> state. 'Stop reason' -> stopReason.
   'Failure' -> error. 'Started' -> startedAt. 'Finished' -> finishedAt } ];
  column: 'Turn outcome' text: #key;
  column: 'Value' text: [ :entry | entry value printString ];
  send: #value;
  actionUpdateButtonTooltip: 'Refresh turn outcome'
]

{ #category : #views }
GtLACPPromptTurn >> gtPermissionsFor: aView [
 <gtView>
 ^ aView list title: 'Permissions'; priority: 20; items: [ permissionRequests copy ]; itemText: #yourself; actionUpdateButtonTooltip: 'Refresh permissions'
]

{ #category : #views }
GtLACPPromptTurn >> gtToolsFor: aView [
 <gtView>
 ^ aView list title: 'Tool calls'; priority: 20; items: [ toolCalls copy ]; itemText: #title; actionUpdateButtonTooltip: 'Refresh tool calls'
]

{ #category : #updates }
GtLACPPromptTurn >> initialize [
 super initialize.
 state := #running.
 messages := OrderedCollection new.
 toolCalls := OrderedCollection new.
 permissionRequests := OrderedCollection new.
 startedAt := DateAndTime now.
 activity := OrderedCollection new.
 activityVersion := 2
]

{ #category : #accessing }
GtLACPPromptTurn >> isActive [
 ^ #(running cancelling) includes: state
]

{ #category : #accessing }
GtLACPPromptTurn >> messages [
 ^ messages
]

{ #category : #accessing }
GtLACPPromptTurn >> messages: anObject [
 messages := anObject
]

{ #category : #accessing }
GtLACPPromptTurn >> permissionRequests [
 ^ permissionRequests
]

{ #category : #accessing }
GtLACPPromptTurn >> permissionRequests: anObject [
 permissionRequests := anObject
]

{ #category : #printing }
GtLACPPromptTurn >> printOn: aStream [
 aStream nextPutAll: 'Turn ('; nextPutAll: state asString; nextPutAll: ')'.
 stopReason ifNotNil: [ aStream space; nextPutAll: stopReason ]
]

{ #category : #updates }
GtLACPPromptTurn >> receiveUpdate: aDictionary [
 | kind aRole anId message |
 kind := aDictionary at: 'sessionUpdate'.
 (#('tool_call' 'tool_call_update') includes: kind) ifTrue: [ ^ self updateToolCall: aDictionary ].
 aRole := { 'agent_message_chunk' -> #agent. 'agent_thought_chunk' -> #thought. 'user_message_chunk' -> #user } asDictionary at: kind.
 anId := aDictionary at: 'messageId' ifAbsent: [ nil ].
 message := aRole = #user
  ifTrue: [ messages ifEmpty: [ nil ] ifNotEmpty: [ messages last ] ]
  ifFalse: [ self activity ifEmpty: [ nil ] ifNotEmpty: [ self activity last ] ].
 (message isNil or: [ (message isKindOf: GtLACPConversationMessage) not or: [
  message role ~= aRole or: [ message messageId ~= anId ] ] ]) ifTrue: [
   message := self addMessageWithRole: aRole content: #().
   message messageId: anId ].
 message content add: (GtLACPContentBlock new data: (aDictionary at: 'content'); yourself)
]

{ #category : #accessing }
GtLACPPromptTurn >> request [
 ^ request
]

{ #category : #accessing }
GtLACPPromptTurn >> request: anObject [
 request := anObject
]

{ #category : #migration }
GtLACPPromptTurn >> restoredActivity [
 "Recover both thought chunks and ordinary assistant commentary in wire order."
 | result seen lastMessage |
 result := OrderedCollection new.
 seen := IdentitySet new.
 session ifNotNil: [
  session updates copy do: [ :event |
   ((event timestamp >= startedAt) and: [
    finishedAt isNil or: [ event timestamp <= finishedAt ] ]) ifTrue: [
    | data kind |
    data := event data.
    kind := data at: 'sessionUpdate'.
    (#('tool_call' 'tool_call_update') includes: kind) ifTrue: [
     toolCalls detect: [ :call | call id = (data at: 'toolCallId') ] ifFound: [ :call |
      (seen includes: call) ifFalse: [
       seen add: call.
       result add: call.
       lastMessage := nil ] ] ].
    (#('agent_thought_chunk' 'agent_message_chunk') includes: kind) ifTrue: [
     | identifier messageRole |
     identifier := data at: 'messageId' ifAbsent: [ nil ].
     messageRole := kind = 'agent_thought_chunk' ifTrue: [ #thought ] ifFalse: [ #agent ].
     (lastMessage isNil or: [ lastMessage messageId ~= identifier or: [ lastMessage role ~= messageRole ] ]) ifTrue: [
      lastMessage := GtLACPConversationMessage new role: messageRole; messageId: identifier; yourself.
      result add: lastMessage ].
     lastMessage content add: (GtLACPContentBlock new data: (data at: 'content'); yourself) ] ] ] ].
 result isEmpty
  ifTrue: [
   result addAll: (messages select: [ :each | each role = #thought ]).
   result addAll: toolCalls.
   result addAll: (messages select: [ :each | each role = #agent ]) ]
  ifFalse: [
   messages := ((messages select: [ :each | each role = #user ]),
    (result select: [ :each | each isKindOf: GtLACPConversationMessage ])) asOrderedCollection ].
 ^ result
]

{ #category : #accessing }
GtLACPPromptTurn >> session [
 ^ session
]

{ #category : #accessing }
GtLACPPromptTurn >> session: anObject [
 session := anObject
]

{ #category : #accessing }
GtLACPPromptTurn >> startedAt [
 ^ startedAt
]

{ #category : #accessing }
GtLACPPromptTurn >> startedAt: anObject [
 startedAt := anObject
]

{ #category : #accessing }
GtLACPPromptTurn >> state [
 ^ state
]

{ #category : #accessing }
GtLACPPromptTurn >> state: anObject [
 state := anObject
]

{ #category : #accessing }
GtLACPPromptTurn >> stopReason [
 ^ stopReason
]

{ #category : #accessing }
GtLACPPromptTurn >> stopReason: anObject [
 stopReason := anObject
]

{ #category : #accessing }
GtLACPPromptTurn >> toolCalls [
 ^ toolCalls
]

{ #category : #accessing }
GtLACPPromptTurn >> toolCalls: anObject [
 toolCalls := anObject
]

{ #category : #updates }
GtLACPPromptTurn >> updateToolCall: aDictionary [
 | call |
 call := toolCalls detect: [ :each | each id = (aDictionary at: 'toolCallId') ]
  ifNone: [ | created | created := GtLACPToolCall new. self activity add: created. toolCalls add: created. created ].
 call updateFrom: aDictionary.
 ^ call
]

{ #category : #accessing }
GtLACPPromptTurn >> userMessages [
 messages withIndexDo: [ :each :index |
  (each role = #user and: [ (each isKindOf: GtLACPUserMessage) not ]) ifTrue: [
   messages at: index put: (GtLACPUserMessage new
    messageId: each messageId; content: each content; yourself) ] ].
 ^ messages select: [ :each | each isKindOf: GtLACPUserMessage ]
]

{ #category : #waiting }
GtLACPPromptTurn >> waitForSeconds: seconds [
 request waitForSeconds: seconds.
 ^ self
]
