"
I represent one conversation associated with an absolute directory. I own turns and session updates, and reference my client and connection. Prompts return immediately with an inspectable turn. Closing the last local session stops the connection; v1 has no baseline remote close request. I announce state changes and open an ACP chat tool by default; my regular inspector remains available in the composite tool.
"
Class {
	#name : #GtLACPSession,
	#superclass : #GtLACPObject,
	#instVars : [
		'client',
		'connection',
		'directory',
		'remoteSessionId',
		'state',
		'turns',
		'updates',
		'modes',
		'configOptions',
		'promptText',
		'announcer',
		'summarizersRegistry',
		'subagents',
		'parentSubagent',
		'interSessionMessages',
		'conversationTitle'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #updating }
GtLACPSession class >> conversationTreeFor: aView roots: roots [
	| tree |
	tree := aView columnedTree
			title: 'Conversation tree';
			priority: 4;
			items: [ roots ];
			children: #childSessions;
			column: 'Conversation' text: #conversationTitle;
			column: 'State'
				text: #conversationState
				width: 110;
			column: 'Messages'
				text: [ :session | session turns sum: [ :turn | turn messages size ] ]
				width: 90;
			column: 'Directory'
				text: [ :session | session directory ifNil: [ '' ] ifNotNil: #fullName ];
			send: #yourself;
			expandAll;
			actionUpdateButtonTooltip: 'Refresh conversation tree'.
	roots
		ifNotEmpty: [ tree
				updateWhen: GtLACPConversationTreeChanged
				in: [ roots first connection announcer ] ].
	^ tree
]

{ #category : #accessing }
GtLACPSession >> allToolCalls [
 ^ (turns copy flatCollect: [ :turn | turn toolCalls copy ]),
  (self childSessions flatCollect: #allToolCalls)
]

{ #category : #announcing }
GtLACPSession >> announceChanged [
 self announceMessageChanged: (self currentTurn ifNotNil: #assistantMessage)
]

{ #category : #announcing }
GtLACPSession >> announceConversationTreeChanged [
 connection ifNotNil: #announceConversationTreeChanged
]

{ #category : #announcing }
GtLACPSession >> announceMessageChanged: aMessage [
 self announcer announce: (GtLACPSessionChanged new
  session: self; message: aMessage; yourself).
 self currentTurn ifNotNil: [ :turn |
  turn parentTurn ifNotNil: [ :parent |
   parent session announceMessageChanged: parent assistantMessage ] ]
]

{ #category : #announcing }
GtLACPSession >> announcePermissionChanged: aPermission [
 | turn |
 turn := turns detect: [ :each | each permissionRequests includes: aPermission ]
  ifNone: [ nil ].
 self announceMessageChanged: (turn ifNotNil: #assistantMessage)
]

{ #category : #accessing }
GtLACPSession >> announcer [
 ^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #updating }
GtLACPSession >> applySubagentWorkState: aSnapshot [
 | work turn reason |
 aSnapshot ifNil: [
  state := #observing.
  self currentTurn ifNotNil: [ :current | current isActive ifTrue: [ current state: #observed ] ].
  ^ self announceChanged ].
 work := aSnapshot at: 'state' ifAbsent: [ 'unknown' ].
 turn := self currentTurn.
 (#('running' 'requires_action') includes: work) ifTrue: [
  state := #prompting.
  (turn isNil or: [ turn isActive not and: [ turn state ~= #observed ] ]) ifTrue: [ turn := self newObservedTurn ].
  turn state: #running ].
 work = 'unknown' ifTrue: [
  state := #observing.
  turn ifNotNil: [ turn isActive ifTrue: [ turn state: #observed ] ] ].
 work = 'idle' ifTrue: [
  state := #ready.
  (turn notNil and: [ turn isActive or: [ turn state = #observed ] ]) ifTrue: [
   reason := aSnapshot at: 'stopReason' ifAbsent: [ nil ].
   reason
    ifNil: [ turn state: #idle; finishedAt: DateAndTime now. turn permissionRequests do: #cancel ]
    ifNotNil: [ reason = 'error' ifTrue: [ turn fail: 'Subagent reported an error' ] ifFalse: [ turn complete: reason ] ] ].
  self updateToolSummarizers ].
 self announceChanged
]

{ #category : #ui }
GtLACPSession >> asChatViewModel [
 ^ GtLACPChatViewModel new session: self; yourself
]

{ #category : #ui }
GtLACPSession >> asElement [
 ^ GtLACPChatElement new viewModel: self asChatViewModel; yourself
]

{ #category : #testing }
GtLACPSession >> canCancel [
 ^ self isSubagent
  ifTrue: [ parentSubagent canCancel and: [ self currentTurn isNil or: [ self currentTurn state ~= #cancelling ] ] ]
  ifFalse: [ state = #prompting and: [ self currentTurn notNil and: [ self currentTurn state = #running ] ] ]
]

{ #category : #testing }
GtLACPSession >> canPrompt [
 ^ self isSubagent not and: [ state = #ready ]
]

{ #category : #updating }
GtLACPSession >> cancelTurn [
 | turn |
 [
 self canCancel ifFalse: [ ^ self ].
 turn := self currentTurn.
 turn ifNotNil: [
  turn state: #cancelling.
  turn permissionRequests do: #cancel ].
 connection notify: 'session/cancel' parameters: { 'sessionId' -> remoteSessionId } asDictionary
 ] ensure: [ self announceChanged ]
]

{ #category : #updating }
GtLACPSession >> childSessions [
 ^ self subagents copy collect: #session
]

{ #category : #accessing }
GtLACPSession >> client [
 ^ client
]

{ #category : #accessing }
GtLACPSession >> client: anObject [
 client := anObject
]

{ #category : #updating }
GtLACPSession >> close [
 self requireRootSession.
 self closeLocally.
 connection sessions isEmpty ifTrue: [ connection stop ]
]

{ #category : #updating }
GtLACPSession >> closeLocally [
 self currentTurn ifNotNil: [ :turn |
  turn permissionRequests do: #cancel.
  turn isActive ifTrue: [ turn state: #closed; finishedAt: DateAndTime now ] ].
 self childSessions do: #closeLocally.
 connection sessions removeKey: remoteSessionId ifAbsent: [ ].
 state := #closed.
 self announceChanged.
 self announceConversationTreeChanged
]

{ #category : #accessing }
GtLACPSession >> configOptions [
 ^ configOptions
]

{ #category : #accessing }
GtLACPSession >> configOptions: anObject [
 configOptions := anObject
]

{ #category : #accessing }
GtLACPSession >> connection [
 ^ connection
]

{ #category : #accessing }
GtLACPSession >> connection: anObject [
 connection := anObject
]

{ #category : #updating }
GtLACPSession >> connectionClosed: aReason [
 [
 self isSubagent ifTrue: [
  parentSubagent invalidateLiveState.
  self currentTurn ifNotNil: [ :turn |
   turn isActive ifTrue: [ turn state: #disconnected; finishedAt: DateAndTime now ].
   turn permissionRequests do: #abandon ].
  state := #disconnected ]
 ifFalse: [
  self currentTurn ifNotNil: [ :turn | turn isActive ifTrue: [ turn fail: aReason ]. turn permissionRequests do: #abandon ].
  state = #closed ifFalse: [ state := #failed ] ]
 ] ensure: [ self updateToolSummarizers. self announceChanged. self announceConversationTreeChanged ]
]

{ #category : #accessing }
GtLACPSession >> conversationState [
 ^ self isSubagent ifTrue: [ parentSubagent workState ] ifFalse: [ state ]
]

{ #category : #accessing }
GtLACPSession >> conversationTitle [
 self isSubagent ifTrue: [ ^ parentSubagent title ].
 ^ conversationTitle ifNil: [ client ifNil: [ 'ACP chat' ] ifNotNil: [ client displayName ] ]
]

{ #category : #updating }
GtLACPSession >> create [
 | result |
 self requireRootSession.
 [
 state := #starting.
 [ result := connection request: 'session/new' parameters: self creationParameters.
 remoteSessionId := result at: 'sessionId'.
 connection sessions at: remoteSessionId put: self.
 self updateSettingsFrom: result.
 state := #ready ]
 on: Error do: [ :ex | state := #failed. ex pass ]
 ] ensure: [ self announceChanged ]
]

{ #category : #accessing }
GtLACPSession >> creationParameters [
 ^ { 'cwd' -> directory fullName. 'mcpServers' -> client configuration mcpServers } asDictionary
]

{ #category : #accessing }
GtLACPSession >> currentTurn [
 ^ turns ifEmpty: [ nil ] ifNotEmpty: [ turns last ]
]

{ #category : #accessing }
GtLACPSession >> directory [
 ^ self isSubagent ifTrue: [ parentSubagent directory ] ifFalse: [ directory ]
]

{ #category : #accessing }
GtLACPSession >> directory: anObject [
 directory := anObject
]

{ #category : #updating }
GtLACPSession >> gtCancelFor: anAction [
 <gtAction>
 self canCancel ifFalse: [ ^ anAction noAction ].
 ^ anAction button label: 'Cancel turn'; priority: 10; action: [ self cancelTurn ]
]

{ #category : #views }
GtLACPSession >> gtChatFor: aView [
 <gtView>
 <gtLlmView>
 ^ aView explicit title: 'Chat'; priority: 0; stencil: [ self asElement ]
]

{ #category : #updating }
GtLACPSession >> gtCloseFor: anAction [
 <gtAction>
 (self isSubagent or: [ state = #closed ]) ifTrue: [ ^ anAction noAction ].
 ^ anAction button label: 'Close session'; priority: 50; action: [ self close ]
]

{ #category : #updating }
GtLACPSession >> gtComposeFor: aView [
 <gtView>
 self isSubagent ifTrue: [ ^ aView empty ].
 ^ aView explicit title: 'Compose'; priority: 6;
  stencil: [
   | pane editor send |
   editor := BrEditor new
    aptitude: BrGlamorousEditorAptitude;
    text: promptText;
    hMatchParent; vMatchParent; yourself.
   send := BrButton new
    aptitude: BrGlamorousButtonWithLabelAptitude;
    label: 'Send';
    action: [
     promptText := editor text asString.
     self prompt: promptText ];
    yourself.
   pane := BrVerticalPane new hMatchParent; vMatchParent; yourself.
   pane addChild: editor; addChild: send.
   pane ]
]

{ #category : #views }
GtLACPSession >> gtConfigurationOptionsFor: aView [
 <gtView>
 <gtLlmView>
 ^ aView columnedList title: 'Configuration options'; priority: 25;
  items: [ configOptions ];
  column: 'Option' text: [ :each | each at: 'name' ifAbsent: [ each at: 'id' ] ];
  column: 'Current value' text: [ :each | (each at: 'currentValue' ifAbsent: [ nil ]) printString ];
  column: 'Choices' text: [ :each | (each at: 'options' ifAbsent: [ #() ]) printString ]
]

{ #category : #views }
GtLACPSession >> gtConversationFor: aView [
 <gtView>
 <gtLlmView>
 ^ aView list title: 'Conversation'; priority: 5; items: [ turns flatCollect: [ :each | each messages copy ] ]; itemText: #printString; actionUpdateButtonTooltip: 'Refresh conversation'
]

{ #category : #views }
GtLACPSession >> gtConversationTreeFor: aView [
 <gtView>
 <gtLlmView>
 ^ self class conversationTreeFor: aView roots: { self rootSession }
]

{ #category : #ui }
GtLACPSession >> gtDefaultInspectorTool [
 ^ GtPhlowCompositeTool new
  addTool: (GtLACPChatTool forChat: self);
  addTool: super gtDefaultInspectorTool;
  name: 'ACP: ', client displayName
]

{ #category : #views }
GtLACPSession >> gtInspectorTargetModels [
 ^ self summarizersRegistry relevantCurrentSummarizers
]

{ #category : #views }
GtLACPSession >> gtInterSessionMessagesFor: aView [
 <gtView>
 <gtLlmView>
 self interSessionMessages ifEmpty: [ ^ aView empty ].
 ^ aView columnedList title: 'Session messages'; priority: 7;
  items: [ self interSessionMessages copy ];
  column: 'Direction' text: #chatLabel;
  column: 'Message' text: #text;
  send: #yourself;
  actionUpdateButtonTooltip: 'Refresh session messages'
]

{ #category : #views }
GtLACPSession >> gtPermissionsFor: aView [
 <gtView>
 <gtLlmView>
 ^ aView list title: 'Permissions'; priority: 20; items: [ turns flatCollect: [ :each | each permissionRequests copy ] ]; itemText: #yourself; actionUpdateButtonTooltip: 'Refresh permissions'
]

{ #category : #actions }
GtLACPSession >> gtRefreshSummarizersFor: anAction [
 <gtAction>
 ^ anAction button
  icon: BrGlamorousVectorIcons refresh;
  tooltip: 'Refresh tool call summaries';
  action: [ self updateToolSummarizers ]
]

{ #category : #views }
GtLACPSession >> gtSessionFor: aView [
 <gtView>
 <gtLlmView>
 ^ aView columnedList title: 'Session'; priority: 10;
  items: [ { 'Project directory' -> directory. 'Remote session ID' -> remoteSessionId.
   'Status' -> state. 'Client' -> client. 'Connection' -> connection } ];
  column: 'Session' text: #key;
  column: 'Value' text: [ :entry | entry value printString ];
  send: #value;
  actionUpdateButtonTooltip: 'Refresh session'
]

{ #category : #views }
GtLACPSession >> gtSummarizersRegistryFor: aView [
 <gtView>
 <gtLlmView>
 ^ aView forward
  title: 'Summarizers';
  priority: 42;
  object: [ self summarizersRegistry ];
  view: #gtCurrentSummarizersFor:
]

{ #category : #views }
GtLACPSession >> gtTurnsFor: aView [
 <gtView>
 <gtLlmView>
 ^ aView list title: 'Turns'; priority: 20; items: [ turns copy ]; itemText: #yourself; actionUpdateButtonTooltip: 'Refresh turns'
]

{ #category : #views }
GtLACPSession >> gtUpdatesFor: aView [
 <gtView>
 <gtLlmView>
 ^ aView list title: 'Updates'; priority: 20; items: [ updates copy ]; itemText: #kind; actionUpdateButtonTooltip: 'Refresh updates'
]

{ #category : #views }
GtLACPSession >> gtViewsInContext: aContext [
 | views |
 aContext objectRegistry: self objectStorage.
 views := (super gtViewsInContext: aContext),
  (self summarizerViewsFor: self gtInspectorTargetModels inContext: aContext).
 GtPhlowUtility sortByPriority: views.
 ^ views
]

{ #category : #accessing }
GtLACPSession >> initialize [
 super initialize.
 state := #new.
 turns := OrderedCollection new.
 updates := OrderedCollection new.
 modes := Dictionary new.
 configOptions := #().
 promptText := ''
]

{ #category : #accessing }
GtLACPSession >> interSessionMessages [
 ^ interSessionMessages ifNil: [ interSessionMessages := OrderedCollection new ]
]

{ #category : #updating }
GtLACPSession >> invalidateSubagentLiveState [
 parentSubagent ifNotNil: #invalidateLiveState.
 state := #observing.
 self currentTurn ifNotNil: [ :turn | turn isActive ifTrue: [ turn state: #observed ] ].
 self childSessions do: #invalidateSubagentLiveState
]

{ #category : #testing }
GtLACPSession >> isReplaying [
 ^ self rootSession state = #loading
]

{ #category : #testing }
GtLACPSession >> isSubagent [
 ^ parentSubagent notNil
]

{ #category : #updating }
GtLACPSession >> load: anId [
 | params result |
 self requireRootSession.
 [
 connection capabilities supportsLoad ifFalse: [ self error: 'Agent does not support loading sessions' ].
 state := #loading.
 self childSessions do: #invalidateSubagentLiveState.
 remoteSessionId := anId.
 connection sessions at: anId put: self.
 params := self creationParameters at: 'sessionId' put: anId; yourself.
 [ result := connection request: 'session/load' parameters: params.
 self updateSettingsFrom: result.
 state := #ready ] on: Error do: [ :ex | state := #failed. ex pass ]
 ] ensure: [ self updateConversationSummarizers. self announceChanged ]
]

{ #category : #accessing }
GtLACPSession >> mcpToolMessages [
 ^ self mcpToolMessagesFor: self allToolCalls
]

{ #category : #summaries }
GtLACPSession >> mcpToolMessagesFor: toolCalls [
 ^ self isSubagent
  ifTrue: [ parentSubagent parentSession mcpToolMessagesFor: toolCalls ]
  ifFalse: [ self mcpToolMessagesFor: toolCalls in: GtLMcpServer current ]
]

{ #category : #summaries }
GtLACPSession >> mcpToolMessagesFor: toolCalls in: aServer [
 | messages seen |
 messages := GtLMessagesGroup new.
 seen := IdentitySet new.
 toolCalls do: [ :call |
  (call mcpToolMessageIn: aServer) ifNotNil: [ :message |
   (seen includes: message) ifFalse: [
    seen add: message.
    messages add: message ] ] ].
 ^ messages
]

{ #category : #accessing }
GtLACPSession >> mcpToolMessagesIn: aServer [
 ^ self mcpToolMessagesFor: self allToolCalls in: aServer
]

{ #category : #accessing }
GtLACPSession >> modes [
 ^ modes
]

{ #category : #accessing }
GtLACPSession >> modes: anObject [
 modes := anObject
]

{ #category : #updating }
GtLACPSession >> newObservedTurn [
 | turn |
 turn := GtLACPPromptTurn new session: self;
  state: (self isReplaying ifTrue: [ #replayed ] ifFalse: [ #observed ]); yourself.
 self isSubagent ifTrue: [ turn parentTurn: parentSubagent parentSession currentTurn ].
 turns add: turn.
 ^ turn
]

{ #category : #accessing }
GtLACPSession >> objectStorage [
 ^ self isSubagent
  ifTrue: [ parentSubagent parentSession objectStorage ]
  ifFalse: [ GtLMcpServer current ifNotNil: #objectStorage ]
]

{ #category : #accessing }
GtLACPSession >> parentSubagent [
 ^ parentSubagent
]

{ #category : #accessing }
GtLACPSession >> parentSubagent: anAssociation [
 parentSubagent := anAssociation
]

{ #category : #views }
GtLACPSession >> phlowContext [
 ^ GtPhlowContext new objectRegistry: self objectStorage; yourself
]

{ #category : #printing }
GtLACPSession >> printOn: aStream [
 aStream nextPutAll: 'ACP session ('; nextPutAll: state asString; nextPutAll: ')'.
 directory ifNotNil: [ aStream space; nextPutAll: directory fullName ]
]

{ #category : #prompting }
GtLACPSession >> prompt: aString [
 ^ self promptContent: { GtLACPContentBlock text: aString }
]

{ #category : #prompting }
GtLACPSession >> promptContent: blocks [
 | turn rpc |
 self requireRootSession.
 [
 state = #ready ifFalse: [ self error: 'Session must be ready before prompting' ].
 blocks do: [ :each |
  (connection capabilities supportsPromptType: each type) ifFalse: [ self error: 'Agent does not support this content type' ] ].
 turn := GtLACPPromptTurn new session: self; yourself.
 turn addMessageWithRole: #user content: blocks.
 turns add: turn.
 state := #prompting.
 rpc := connection newRequest: 'session/prompt' parameters: {
  'sessionId' -> remoteSessionId. 'prompt' -> (blocks collect: #asDictionary) asArray } asDictionary.
 turn request: rpc.
 rpc onSuccess: [ :result | turn complete: (result at: 'stopReason'). state := #ready. self updateToolSummarizers. self announceMessageChanged: turn assistantMessage. self announceConversationTreeChanged ];
  onFailure: [ :reason | turn fail: reason. state = #closed ifFalse: [ state := (connection state = #ready ifTrue: [ #ready ] ifFalse: [ #failed ]) ]. self updateToolSummarizers. self announceMessageChanged: turn assistantMessage. self announceConversationTreeChanged ].
 connection sendRequest: rpc.
 ^ turn
 ] ensure: [ self announceMessageChanged: (turn ifNotNil: #assistantMessage). self announceConversationTreeChanged ]
]

{ #category : #accessing }
GtLACPSession >> promptText [
 ^ promptText
]

{ #category : #accessing }
GtLACPSession >> promptText: anObject [
 promptText := anObject
]

{ #category : #updating }
GtLACPSession >> receiveInterSessionMessage: aDictionary [
 | message turn |
 message := self interSessionMessages
  detect: [ :each | each messageId = (aDictionary at: 'messageId') ] ifNone: [ nil ].
 message ifNil: [
  turn := self currentTurn.
  (turn isNil or: [ turn isActive not and: [ turn activity notEmpty ] ])
   ifTrue: [ turn := self newObservedTurn ].
  message := GtLACPInterSessionMessage new
   session: self; turn: turn; messageId: (aDictionary at: 'messageId'); yourself.
  self interSessionMessages add: message.
  turn messages add: message ].
 message updateFrom: aDictionary.
 message isOutgoing
  ifTrue: [ (message turn activity includes: message) ifFalse: [ message turn activity add: message ] ]
  ifFalse: [ message turn activity remove: message ifAbsent: [ ] ].
 self announceMessageChanged: (message isOutgoing ifTrue: [ message turn assistantMessage ] ifFalse: [ message ]).
 ^ message
]

{ #category : #updating }
GtLACPSession >> receiveLegacySubagentUpdate: anUpdate [
 | normalized snapshot status |
 normalized := anUpdate copy.
 normalized at: 'sessionId' put: (anUpdate at: 'subagentSessionId').
 normalized at: 'sessionUpdate' put: 'subagent_update'.
 (anUpdate includesKey: 'name') ifTrue: [ normalized at: 'title' put: (anUpdate at: 'name') ].
 (anUpdate includesKey: 'task') ifTrue: [ normalized at: 'description' put: (anUpdate at: 'task') ].
 (anUpdate at: 'state' ifAbsent: [ nil ]) ifNotNil: [ :value |
  value isString ifTrue: [
   status := value.
   snapshot := { 'state' -> ((#('running' 'requires_action' 'unknown') includes: status)
    ifTrue: [ status ] ifFalse: [ status = 'disconnected' ifTrue: [ 'unknown' ] ifFalse: [ 'idle' ] ]) } asDictionary.
   (#('completed' 'failed' 'cancelled') includes: status) ifTrue: [
    snapshot at: 'stopReason' put: ({ 'completed' -> 'end_turn'. 'failed' -> 'error'. 'cancelled' -> 'cancelled' } asDictionary at: status) ].
   normalized at: 'state' put: snapshot ] ].
 ^ self receiveSubagentUpdate: normalized
]

{ #category : #updating }
GtLACPSession >> receivePermission: params requestId: anId [
 | turn permission call |
 [
 turn := self currentTurn.
 (self isSubagent and: [ self isReplaying not ]) ifTrue: [
  (turn isNil or: [ turn isActive not and: [ turn state ~= #observed ] ]) ifTrue: [ turn := self newObservedTurn ].
  turn state: #running. state := #prompting ].
 (turn isNil or: [ turn isActive not ]) ifTrue: [
  ^ connection replyTo: anId result: { 'outcome' -> { 'outcome' -> 'cancelled' } asDictionary } asDictionary ].
 call := turn updateToolCall: (params at: 'toolCall').
 permission := GtLACPPermissionRequest new
  connection: connection; session: self; requestId: anId; toolCall: call; yourself.
 permission options: ((params at: 'options') collect: [ :each |
  GtLACPPermissionOption new request: permission; data: each; yourself ]).
 call permissionRequests add: permission.
 turn permissionRequests add: permission
 ] ensure: [ self announceChanged ]
]

{ #category : #updating }
GtLACPSession >> receiveSubagentUpdate: aDictionary [
 | childId child association |
 childId := aDictionary at: 'sessionId'.
 (childId isString and: [ childId notEmpty ]) ifFalse: [ self error: 'Invalid child session ID' ].
 childId = remoteSessionId ifTrue: [ self error: 'A session cannot own itself' ].
 child := connection sessions at: childId ifAbsent: [ nil ].
 child ifNotNil: [
  (child isSubagent and: [ child parentSubagent parentSession == self ])
   ifFalse: [ self error: 'A child session cannot change parent or form a cycle' ].
  association := child parentSubagent ] ifNil: [
  child := client newSessionIn: self directory connection: connection.
  association := GtLACPSubagent new parentSession: self; session: child; yourself.
  child parentSubagent: association; remoteSessionId: childId; state: #observing.
  self subagents add: association.
  connection sessions at: childId put: child ].
 association updateFrom: aDictionary.
 child announceChanged.
 self announceConversationTreeChanged.
 ^ association
]

{ #category : #updating }
GtLACPSession >> receiveUpdate: aDictionary [
 | kind turn changedMessage |
 [
 updates add: (GtLACPSessionUpdate new data: aDictionary; timestamp: DateAndTime now; yourself).
 kind := aDictionary at: 'sessionUpdate'.
 kind = 'subagent_update' ifTrue: [
  ^ (aDictionary includesKey: 'sessionId')
   ifTrue: [ self receiveSubagentUpdate: aDictionary ]
   ifFalse: [ self receiveLegacySubagentUpdate: aDictionary ] ].
 (#('subagent_spawned' 'subagent_state_update') includes: kind)
  ifTrue: [ ^ self receiveLegacySubagentUpdate: aDictionary ].
 (#('session_message' 'session_message_chunk') includes: kind)
  ifTrue: [ ^ self receiveInterSessionMessage: aDictionary ].
 kind = 'session_info_update' ifTrue: [
  (aDictionary includesKey: 'title') ifTrue: [ conversationTitle := aDictionary at: 'title'. self announceConversationTreeChanged ] ].
 kind = 'config_option_update' ifTrue: [ configOptions := aDictionary at: 'configOptions' ].
 kind = 'current_mode_update' ifTrue: [ modes at: 'currentModeId' put: (aDictionary at: 'currentModeId') ].
 (#('agent_message_chunk' 'agent_thought_chunk' 'user_message_chunk' 'tool_call' 'tool_call_update') includes: kind)
  ifFalse: [ ^ self ].
 turn := self currentTurn.
 (turn isNil or: [
  (self isReplaying and: [ turn state ~= #replayed or: [
   kind = 'user_message_chunk' and: [ turn activity notEmpty ] ] ]) or: [
   self isSubagent and: [ self isReplaying not and: [ turn isActive not and: [ turn state ~= #observed ] ] ] ] ])
  ifTrue: [ turn := self newObservedTurn.
   self isSubagent ifFalse: [ turn state: #replayed ] ].
 (self isSubagent and: [ self isReplaying not ])
  ifTrue: [ turn state: #running. state := #prompting ].
 turn receiveUpdate: aDictionary.
 changedMessage := kind = 'user_message_chunk'
  ifTrue: [ turn userMessages ifEmpty: [ nil ] ifNotEmpty: #last ]
  ifFalse: [ turn assistantMessage ]
 ] ensure: [ self announceMessageChanged: changedMessage ]
]

{ #category : #accessing }
GtLACPSession >> remoteSessionId [
 ^ remoteSessionId
]

{ #category : #accessing }
GtLACPSession >> remoteSessionId: anObject [
 remoteSessionId := anObject
]

{ #category : #private }
GtLACPSession >> requireRootSession [
 self isSubagent ifTrue: [ self error: 'This conversation is owned by its parent agent' ]
]

{ #category : #accessing }
GtLACPSession >> rootSession [
 ^ self isSubagent ifTrue: [ parentSubagent parentSession rootSession ] ifFalse: [ self ]
]

{ #category : #updating }
GtLACPSession >> setConfigOption: anId value: aValue [
 | option |
 self requireRootSession.
 option := configOptions detect: [ :each | (each at: 'id') = anId ] ifNone: [ self error: 'Unknown session configuration option' ].
 self updateSettingsFrom: (connection request: 'session/set_config_option' parameters: {
  'sessionId' -> remoteSessionId. 'configId' -> (option at: 'id'). 'value' -> aValue } asDictionary)
]

{ #category : #updating }
GtLACPSession >> setMode: anId [
 | available |
 self requireRootSession.
 available := modes at: 'availableModes' ifAbsent: [ #() ].
 (available anySatisfy: [ :each | (each at: 'id') = anId ]) ifFalse: [ self error: 'Mode is not advertised by the agent' ].
 connection request: 'session/set_mode' parameters: { 'sessionId' -> remoteSessionId. 'modeId' -> anId } asDictionary.
 modes at: 'currentModeId' put: anId
]

{ #category : #updating }
GtLACPSession >> setModel: anId [
 | option |
 self requireRootSession.
 option := configOptions detect: [ :each | (each at: 'category' ifAbsent: [ '' ]) = 'model' ]
  ifNone: [ self error: 'Agent does not advertise a model configuration option' ].
 self setConfigOption: (option at: 'id') value: anId
]

{ #category : #accessing }
GtLACPSession >> state [
 ^ state
]

{ #category : #accessing }
GtLACPSession >> state: anObject [
 state := anObject
]

{ #category : #accessing }
GtLACPSession >> subagents [
 ^ subagents ifNil: [ subagents := OrderedCollection new ]
]

{ #category : #views }
GtLACPSession >> summarizerViewsFor: summarizers inContext: aContext [
 | views |
 views := Array streamContents: [ :stream |
  summarizers do: [ :model |
   stream nextPutAll: ((GtPhlowViewsCollector new
    fromObject: model;
    context: aContext;
    collect) select: [ :view |
     view definingMethod methodClass inheritsFrom: GtLToolCallsSummarizer ]) ] ].
 GtPhlowUtility sortByPriority: views.
 ^ views
]

{ #category : #summaries }
GtLACPSession >> summarizersRegistry [
 ^ summarizersRegistry ifNil: [
  summarizersRegistry := GtLToolCallSummarizersRegistry new
   addDefaultSpecifications;
   yourself ]
]

{ #category : #summaries }
GtLACPSession >> summarizersRegistry: aRegistry [
 summarizersRegistry := aRegistry
]

{ #category : #accessing }
GtLACPSession >> turns [
 ^ turns
]

{ #category : #accessing }
GtLACPSession >> turns: anObject [
 turns := anObject
]

{ #category : #updating }
GtLACPSession >> updateConversationSummarizers [
 self updateToolSummarizers.
 self childSessions do: #updateConversationSummarizers
]

{ #category : #accessing }
GtLACPSession >> updateSettingsFrom: aDictionary [
 modes := aDictionary at: 'modes' ifAbsent: [ modes ].
 configOptions := aDictionary at: 'configOptions' ifAbsent: [ configOptions ]
]

{ #category : #summarizers }
GtLACPSession >> updateToolSummarizers [
 self summarizersRegistry updateSummarizersForMessages: self mcpToolMessages.
 parentSubagent ifNotNil: [ parentSubagent parentSession updateToolSummarizers ]
]

{ #category : #accessing }
GtLACPSession >> updates [
 ^ updates
]

{ #category : #accessing }
GtLACPSession >> updates: anObject [
 updates := anObject
]
