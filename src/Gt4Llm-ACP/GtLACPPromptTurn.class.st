"
I own one prompt's execution and protocol timeline. My state is a GtLACPPromptTurnState object, which holds a back-reference to me. I delegate activity, cancellation, completion, failure, observation, connection loss, closing and final-reply selection to its hierarchy. stateName supplies the presentation label. User prompts are GtLACPUserMessage objects, and my GtLACPAssistantMessage exposes the assistant's work separately from its final reply.
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
		'assistantMessage',
		'parentTurn',
		'workUpdates',
		'delegatedSessions',
		'elicitationRequests'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #'private - lifecycle' }
GtLACPPromptTurn >> abandonPendingInteractions [
	permissionRequests do: #abandon.
	self elicitationRequests do: #abandon
]

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
GtLACPPromptTurn >> allDelegatedSessions [
 | sessions |
 sessions := self delegatedSessions copy.
 self delegatedTurns do: [ :each |
  sessions add: each session.
  sessions addAll: each allDelegatedSessions ].
 ^ sessions
]

{ #category : #accessing }
GtLACPPromptTurn >> allToolCalls [
 ^ toolCalls copy , (self delegatedTurns flatCollect: #allToolCalls)
]

{ #category : #accessing }
GtLACPPromptTurn >> assistantMessage [
 ^ assistantMessage ifNil: [
  assistantMessage := GtLACPAssistantMessage new turn: self; yourself ]
]

{ #category : #testing }
GtLACPPromptTurn >> canCancel [
	^ self state canCancel
]

{ #category : #testing }
GtLACPPromptTurn >> cancel [
	^ self state cancel
]

{ #category : #'private - lifecycle' }
GtLACPPromptTurn >> cancelPendingInteractions [
	permissionRequests do: #cancel.
	self elicitationRequests do: #cancel
]

{ #category : #accessing }
GtLACPPromptTurn >> childCoordinationMessages [
 ^ messages select: [ :message |
  message isInterSessionMessage and: [ message isChildCoordination ] ]
]

{ #category : #lifecycle }
GtLACPPromptTurn >> close [
	^ self state close
]

{ #category : #lifecycle }
GtLACPPromptTurn >> complete: aReason [
	^ self state complete: aReason
]

{ #category : #lifecycle }
GtLACPPromptTurn >> connectionClosed: aReason [
	^ self state connectionClosed: aReason
]

{ #category : #accessing }
GtLACPPromptTurn >> conversationTreeItems [
 | inputs activityItems |
 inputs := self inputMessages.
 activityItems := self activity copy.
 ^ inputs, activityItems, (messages reject: [ :message |
  (inputs includes: message) or: [ activityItems includes: message ] ])
]

{ #category : #accessing }
GtLACPPromptTurn >> delegatedSessions [
 ^ delegatedSessions ifNil: [ delegatedSessions := IdentitySet new ]
]

{ #category : #accessing }
GtLACPPromptTurn >> delegatedTurns [
 ^ session childSessions flatCollect: [ :child |
  child turns copy select: [ :each | each parentTurn == self ] ]
]

{ #category : #lifecycle }
GtLACPPromptTurn >> disconnect [
	^ self state disconnect
]

{ #category : #accessing }
GtLACPPromptTurn >> elicitationRequests [
	^ elicitationRequests ifNil: [ elicitationRequests := OrderedCollection new ]
]

{ #category : #accessing }
GtLACPPromptTurn >> error [
 ^ error
]

{ #category : #lifecycle }
GtLACPPromptTurn >> fail: aReason [
	^ self state fail: aReason
]

{ #category : #lifecycle }
GtLACPPromptTurn >> finalMessage [
	^ self state finalMessage
]

{ #category : #lifecycle }
GtLACPPromptTurn >> finishIdle [
	^ self state finishIdle
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
GtLACPPromptTurn >> gtDelegatedTurnsFor: aView [
 <gtView>
 self delegatedTurns ifEmpty: [ ^ aView empty ].
 ^ aView columnedList title: 'Delegated turns'; priority: 21;
  items: [ self delegatedTurns ];
  column: 'Worker' text: [ :each | each session conversationTitle ];
  column: 'State' text: #state;
  column: 'Tools' text: [ :each | each allToolCalls size ];
  actionUpdateButtonTooltip: 'Refresh delegated turns'
]

{ #category : #views }
GtLACPPromptTurn >> gtMessagePresentationFor: aView [
 <gtView>
 ^ aView columnedList title: 'Message presentation'; priority: 8;
  items: [ messages copy ];
  column: 'Presentation' text: [ :message | self presentationOf: message ];
  column: 'Role' text: #role;
  column: 'Message ID' text: [ :message | message messageId ifNil: [ '' ] ];
  column: 'Text' text: [ :message | message text first: (message text size min: 140) ];
  send: #yourself;
  actionUpdateButtonTooltip: 'Refresh message classification'
]

{ #category : #views }
GtLACPPromptTurn >> gtMessagesFor: aView [
 <gtView>
 ^ aView list title: 'Messages'; priority: 5; items: [ messages copy ]; itemText: #printString; actionUpdateButtonTooltip: 'Refresh messages'
]

{ #category : #views }
GtLACPPromptTurn >> gtOutcomeFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Outcome';
		priority: 0;
		items: [ {'Status' -> self state.
				'Stop reason' -> stopReason.
				'Failure' -> error.
				'Started' -> startedAt.
				'Finished' -> finishedAt} ];
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

{ #category : #testing }
GtLACPPromptTurn >> hasPendingInteraction [
	^ self pendingInteractions notEmpty
]

{ #category : #testing }
GtLACPPromptTurn >> includesInteraction: aRequest [
	^ (permissionRequests includes: aRequest)
		or: [ (self elicitationRequests includes: aRequest)
				or: [ self delegatedTurns
						anySatisfy: [ :child | child includesInteraction: aRequest ] ] ]
]

{ #category : #initialization }
GtLACPPromptTurn >> initialize [
	super initialize.
	self state: GtLACPPromptTurnRunningState new.
	messages := OrderedCollection new.
	toolCalls := OrderedCollection new.
	permissionRequests := OrderedCollection new.
	startedAt := DateAndTime now.
	activity := OrderedCollection new.
	activityVersion := 2
]

{ #category : #accessing }
GtLACPPromptTurn >> inputMessages [
 ^ messages select: [ :message |
  message role = #user or: [ message isInterSessionMessage and: [
   message isOutgoing not and: [ message isChildCoordination not ] ] ] ]
]

{ #category : #testing }
GtLACPPromptTurn >> isActive [
	^ self state isActive
]

{ #category : #testing }
GtLACPPromptTurn >> isCancelled [
	^ self state isCancelled
]

{ #category : #testing }
GtLACPPromptTurn >> isCancelling [
	^ self state isCancelling
]

{ #category : #testing }
GtLACPPromptTurn >> isClosed [
	^ self state isClosed
]

{ #category : #testing }
GtLACPPromptTurn >> isCompleted [
	^ self state isCompleted
]

{ #category : #testing }
GtLACPPromptTurn >> isDisconnected [
	^ self state isDisconnected
]

{ #category : #testing }
GtLACPPromptTurn >> isFailed [
	^ self state isFailed
]

{ #category : #testing }
GtLACPPromptTurn >> isFinished [
	^ self state isFinished
]

{ #category : #testing }
GtLACPPromptTurn >> isIdle [
	^ self state isIdle
]

{ #category : #testing }
GtLACPPromptTurn >> isObserved [
	^ self state isObserved
]

{ #category : #testing }
GtLACPPromptTurn >> isReplayed [
	^ self state isReplayed
]

{ #category : #testing }
GtLACPPromptTurn >> isRunning [
	^ self state isRunning
]

{ #category : #'private - accessing' }
GtLACPPromptTurn >> lastAgentMessage [
	^ messages reversed
		detect: [ :message | message role = #agent ]
		ifNone: [ nil ]
]

{ #category : #accessing }
GtLACPPromptTurn >> messages [
 ^ messages
]

{ #category : #accessing }
GtLACPPromptTurn >> messages: anObject [
 messages := anObject
]

{ #category : #lifecycle }
GtLACPPromptTurn >> observe [
	^ self state observe
]

{ #category : #accessing }
GtLACPPromptTurn >> parentTurn [
 parentTurn ifNotNil: [ ^ parentTurn ].
 session isSubagent ifFalse: [ ^ nil ].
 parentTurn := session parentSubagent parentSession turns reversed
  detect: [ :each | each startedAt <= startedAt ] ifNone: [ nil ].
 ^ parentTurn
]

{ #category : #accessing }
GtLACPPromptTurn >> parentTurn: aTurn [
 parentTurn := aTurn
]

{ #category : #accessing }
GtLACPPromptTurn >> pendingDelegatedElicitations [
	^ self delegatedTurns
		flatCollect: [ :child | 
			(child elicitationRequests select: [ :each | each state = #pending ])
				, child pendingDelegatedElicitations ]
]

{ #category : #accessing }
GtLACPPromptTurn >> pendingInteractions [
	| requests seen |
	requests := OrderedCollection new.
	seen := IdentitySet new.
	permissionRequests , self elicitationRequests
		, (self delegatedTurns flatCollect: #pendingInteractions)
		do: [ :each | 
			(each state = #pending and: [ (seen includes: each) not ])
				ifTrue: [ seen add: each.
					requests add: each ] ].
	^ requests asArray
]

{ #category : #'private - lifecycle' }
GtLACPPromptTurn >> performCancel [
	self state: GtLACPPromptTurnCancellingState new.
	self cancelPendingInteractions
]

{ #category : #'private - lifecycle' }
GtLACPPromptTurn >> performClose [
	self state: GtLACPPromptTurnClosedState new.
	finishedAt := DateAndTime now.
	self cancelPendingInteractions
]

{ #category : #'private - lifecycle' }
GtLACPPromptTurn >> performComplete: aReason [
	stopReason := aReason.
	self state: (GtLACPPromptTurnState forStopReason: aReason).
	finishedAt := DateAndTime now.
	self cancelPendingInteractions
]

{ #category : #'private - lifecycle' }
GtLACPPromptTurn >> performDisconnect [
	self state: GtLACPPromptTurnDisconnectedState new.
	finishedAt := DateAndTime now.
	self abandonPendingInteractions
]

{ #category : #'private - lifecycle' }
GtLACPPromptTurn >> performFail: aReason [
	error := aReason.
	self state: GtLACPPromptTurnFailedState new.
	finishedAt := DateAndTime now.
	self abandonPendingInteractions
]

{ #category : #'private - lifecycle' }
GtLACPPromptTurn >> performFinishIdle [
	self state: GtLACPPromptTurnIdleState new.
	finishedAt := DateAndTime now.
	self cancelPendingInteractions
]

{ #category : #accessing }
GtLACPPromptTurn >> permissionRequests [
 ^ permissionRequests
]

{ #category : #accessing }
GtLACPPromptTurn >> permissionRequests: anObject [
 permissionRequests := anObject
]

{ #category : #accessing }
GtLACPPromptTurn >> presentationOf: aMessage [
 aMessage == self finalMessage ifTrue: [ ^ #final ].
 (self childCoordinationMessages includes: aMessage) ifTrue: [ ^ #coordination ].
 (self inputMessages includes: aMessage) ifTrue: [ ^ #input ].
 ^ #work
]

{ #category : #printing }
GtLACPPromptTurn >> printOn: aStream [
	aStream
		nextPutAll: 'Turn (';
		nextPutAll: self state asString;
		nextPutAll: ')'.
	stopReason
		ifNotNil: [ aStream
				space;
				nextPutAll: stopReason ]
]

{ #category : #updating }
GtLACPPromptTurn >> receiveUpdate: aDictionary [
 | kind aRole anId message |
 kind := aDictionary at: 'sessionUpdate'.
 (#('tool_call' 'tool_call_update') includes: kind) ifTrue: [ ^ self updateToolCall: aDictionary ].
 aRole := { 'agent_message_chunk' -> #agent. 'agent_thought_chunk' -> #thought. 'user_message_chunk' -> #user } asDictionary at: kind.
 anId := aDictionary at: 'messageId' ifAbsent: [ nil ].
 anId
  ifNotNil: [
   message := messages detect: [ :each | each role = aRole and: [ each messageId = anId ] ] ifNone: [ nil ] ]
  ifNil: [
   message := aRole = #user
    ifTrue: [ messages ifEmpty: [ nil ] ifNotEmpty: [ messages last ] ]
    ifFalse: [ self activity ifEmpty: [ nil ] ifNotEmpty: [ self activity last ] ].
   (message notNil and: [ (message isKindOf: GtLACPConversationMessage) not or: [
    message role ~= aRole or: [ message messageId notNil ] ] ]) ifTrue: [ message := nil ] ].
 message ifNil: [
  message := self addMessageWithRole: aRole content: #().
  message messageId: anId ].
 (aDictionary at: '_meta' ifAbsent: [ nil ]) ifNotNil: [ :metadata |
  message protocolMetadata: metadata ].
 message content add: (GtLACPContentBlock new data: (aDictionary at: 'content'); yourself).
 aRole = #user ifFalse: [ self recordWorkItem: message ]
]

{ #category : #updating }
GtLACPPromptTurn >> recordWorkItem: anObject [
 | history |
 history := self workUpdates.
 (history isEmpty or: [ history last ~~ anObject ]) ifTrue: [ history add: anObject ].
 self parentTurn ifNotNil: [ :parent | parent recordWorkItem: anObject ]
]

{ #category : #updating }
GtLACPPromptTurn >> registerDelegatedSession: aSession [
 self delegatedSessions add: aSession.
 self recordWorkItem: aSession
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

{ #category : #lifecycle }
GtLACPPromptTurn >> start [
	^ self state start
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
GtLACPPromptTurn >> state: aState [
	state := aState.
	state turn: self
]

{ #category : #accessing }
GtLACPPromptTurn >> stateName [
	^ self state name
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

{ #category : #accessing }
GtLACPPromptTurn >> turnForWorkItem: anObject [
 ((messages includes: anObject) or: [ toolCalls includes: anObject ]) ifTrue: [ ^ self ].
 self delegatedTurns do: [ :delegated |
  (delegated turnForWorkItem: anObject) ifNotNil: [ :owner | ^ owner ] ].
 ^ nil
]

{ #category : #updating }
GtLACPPromptTurn >> updateToolCall: aDictionary [
 | call |
 call := toolCalls detect: [ :each | each id = (aDictionary at: 'toolCallId') ]
  ifNone: [ | created | created := GtLACPToolCall new. self activity add: created. toolCalls add: created. created ].
 call updateFrom: aDictionary.
 self recordWorkItem: call.
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

{ #category : #accessing }
GtLACPPromptTurn >> workActivity [
 | answer coordination |
 answer := self finalMessage.
 coordination := self childCoordinationMessages.
 ^ self activity copy reject: [ :item | item == answer or: [ coordination includes: item ] ]
]

{ #category : #accessing }
GtLACPPromptTurn >> workUpdates [
 ^ workUpdates ifNil: [ workUpdates := self activity copy ]
]
