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
		'conversationTitle',
		'availableCommands',
		'contextWindow'
	],
	#classVars : [
		'McpServer'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #accessing }
GtLACPSession class >> mcpServer [
	^ McpServer ifNil: [ GtLMcpServer current ]
]

{ #category : #accessing }
GtLACPSession class >> mcpServer: aServer [
	"Use this MCP server instance. Pass nil to use the current default server."

	McpServer := aServer
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

{ #category : #updating }
GtLACPSession >> announceChatMessageChanged: aMessage [
 self announceChatMessageChanged: aMessage from: self
]

{ #category : #updating }
GtLACPSession >> announceChatMessageChanged: aMessage from: anOriginSession [
	self announcer
		announce: (GtLACPSessionChanged new
				session: self;
				sourceSession: anOriginSession;
				message: aMessage;
				yourself).
	aMessage ifNil: [ ^ self ].
	self currentTurn
		ifNotNil: [ :turn | 
			turn parentTurn
				ifNotNil: [ :parent | 
					parent session
						announceChatMessageChanged: parent assistantMessage
						from: anOriginSession ] ]
]

{ #category : #announcing }
GtLACPSession >> announceConversationTreeChanged [
 connection ifNotNil: #announceConversationTreeChanged
]

{ #category : #announcing }
GtLACPSession >> announceMessageChanged: aMessage [
	self pendingInteractions do: #publishInputNeededNotification.
	self announceChatMessageChanged: aMessage.
	self announceConversationTreeChanged
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

{ #category : #converting }
GtLACPSession >> asConversationTreeNode [
 ^ GtLACPSessionTreeNode new object: self; yourself
]

{ #category : #ui }
GtLACPSession >> asElement [
 ^ GtLACPChatElement new viewModel: self asChatViewModel; yourself
]

{ #category : #converting }
GtLACPSession >> asWorkGraph [
	^ GtLACPWorkGraph new
		session: self;
		refresh;
		yourself
]

{ #category : #accessing }
GtLACPSession >> availableCommands [
	^ availableCommands
		ifNil: [ | advertisement |
			availableCommands := GtLACPCommandGroup new
					session: self;
					yourself.
			advertisement := updates reversed
					detect: [ :update | update kind = 'available_commands_update' ]
					ifNone: [ nil ].
			advertisement
				ifNotNil: [ availableCommands
						items: ((advertisement data at: 'availableCommands')
								collect: [ :each | client commandFrom: each for: self ]
								as: Array) ].
			availableCommands ]
]

{ #category : #testing }
GtLACPSession >> canCancel [
 ^ self isSubagent
  ifTrue: [ parentSubagent canCancel and: [ self currentTurn isNil or: [ self currentTurn state ~= #cancelling ] ] ]
  ifFalse: [ state = #prompting and: [ self currentTurn notNil and: [ self currentTurn state = #running ] ] ]
]

{ #category : #testing }
GtLACPSession >> canClose [
 ^ self isSubagent not and: [ state ~= #closed ]
]

{ #category : #testing }
GtLACPSession >> canPrompt [
 ^ self isSubagent not and: [ state = #ready ]
]

{ #category : #private }
GtLACPSession >> cancelTurn [
	| turn |
	[ self canCancel ifFalse: [ ^ self ].
	turn := self currentTurn.
	turn
		ifNotNil: [ turn state: #cancelling.
			turn permissionRequests do: #cancel.
			turn elicitationRequests do: #cancel ].
	connection
		notify: 'session/cancel'
		parameters: {'sessionId' -> remoteSessionId} asDictionary ]
		ensure: [ self announceChanged ]
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

{ #category : #private }
GtLACPSession >> closeLocally [
	self currentTurn
		ifNotNil: [ :turn | 
			turn permissionRequests do: #cancel.
			turn elicitationRequests do: #cancel.
			turn isActive
				ifTrue: [ turn
						state: #closed;
						finishedAt: DateAndTime now ] ].
	self childSessions do: #closeLocally.
	connection sessions removeKey: remoteSessionId ifAbsent: [  ].
	state := #closed.
	self announceChanged.
	self announceConversationTreeChanged
]

{ #category : #commands }
GtLACPSession >> commandNamed: aName [
	^ self availableCommands
		detect: [ :each | each name = aName or: [ each invocation = aName ] ]
		ifNone: [ self error: 'Unknown advertised command: ' , aName ]
]

{ #category : #accessing }
GtLACPSession >> commands [
	^ self availableCommands commands
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

{ #category : #private }
GtLACPSession >> connectionClosed: aReason [
	[ self isSubagent
		ifTrue: [ parentSubagent invalidateLiveState.
			self currentTurn
				ifNotNil: [ :turn | 
					turn isActive
						ifTrue: [ turn
								state: #disconnected;
								finishedAt: DateAndTime now ].
					turn permissionRequests do: #abandon.
					turn elicitationRequests do: #abandon ].
			state := #disconnected ]
		ifFalse: [ self currentTurn
				ifNotNil: [ :turn | 
					turn isActive ifTrue: [ turn fail: aReason ].
					turn permissionRequests do: #abandon.
					turn elicitationRequests do: #abandon ].
			state = #closed ifFalse: [ state := #failed ] ] ]
		ensure: [ self updateToolSummarizers.
			self announceChanged.
			self announceConversationTreeChanged ]
]

{ #category : #accessing }
GtLACPSession >> contextWindow [
	^ contextWindow
]

{ #category : #accessing }
GtLACPSession >> conversationState [
 ^ self isSubagent ifTrue: [ parentSubagent workState ] ifFalse: [ state ]
]

{ #category : #accessing }
GtLACPSession >> conversationTitle [
	self isSubagent ifTrue: [ ^ parentSubagent title ].
	^ conversationTitle
		ifNil: [ client ifNil: [ 'ACP session' ] ifNotNil: [ client displayName ] ]
]

{ #category : #accessing }
GtLACPSession >> conversationTitle: aString [
	self requireRootSession.
	conversationTitle := aString.
	self announceMessageChanged: nil
]

{ #category : #lifecycle }
GtLACPSession >> create [
	| result |
	self requireRootSession.
	[ state := #starting.
	[ result := connection
			request: 'session/new'
			parameters: self creationParameters.
	remoteSessionId := result at: 'sessionId'.
	connection registerSession: self.
	self updateSettingsFrom: result.
	state := #ready ]
		on: Error
		do: [ :ex | 
			state := #failed.
			ex pass ] ] ensure: [ self announceChanged ]
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
	^ aView explicit
		title: 'Chat';
		priority: 0;
		stencil: [ self asElement ]
]

{ #category : #actions }
GtLACPSession >> gtCloseFor: anAction [
	<gtAction>
	self canClose ifFalse: [ ^ anAction noAction ].
	^ anAction dropdown
		id: #'acp-close-session';
		label: 'Close session';
		priority: 50;
		target: GtPhlowObjectActionTarget;
		addTarget: GtLACPSessionActionTarget;
		menuItemGroup: BrMenuItemGroupConfiguration removal;
		content: [ :anActionElement :aTargetElement :anExplicitMenu | 
			GtLACPCloseSessionConfirmationStencil new
				session: self;
				menuModel: anExplicitMenu;
				asElement ]
]

{ #category : #views }
GtLACPSession >> gtCommandsFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Commands';
		priority: 26;
		object: [ self availableCommands ];
		view: #gtCommandsFor:
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
	^ aView list
		title: 'Conversation';
		priority: 5;
		items: [ turns flatCollect: [ :each | each messages copy ] ];
		itemText: #printString;
		actionUpdateButtonTooltip: 'Refresh conversation'
]

{ #category : #views }
GtLACPSession >> gtConversationTreeFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Conversation tree';
		priority: 4;
		object: [ GtLACPSessionGroup withAll: {self rootSession} ];
		view: #gtConversationTreeFor:
]

{ #category : #'gt - extensions' }
GtLACPSession >> gtDefaultInspectorTool [
	^ GtPhlowCompositeTool new
		addTool: (GtLACPSessionTool forSession: self);
		addTool: super gtDefaultInspectorTool;
		name: 'ACP: ' , client gtDisplayString
]

{ #category : #'gt - actions' }
GtLACPSession >> gtInspectDirectoryFor: anAction [
	<gtAction>
	| aDirectory |
	aDirectory := self directory.
	(aDirectory isNotNil and: [ aDirectory isDirectory ])
		ifFalse: [ ^ anAction noAction ].
	^ anAction button
		id: #'acp-inspect-directory';
		label: 'Inspect directory';
		priority: 30;
		target: GtLACPSessionActionTarget;
		menuItemGroup: BrMenuItemGroupConfiguration inspection;
		action: [ :anElement | anElement phlow spawnObject: aDirectory ]
]

{ #category : #views }
GtLACPSession >> gtInspectorTargetModels [
 ^ self summarizersRegistry relevantCurrentSummarizers
]

{ #category : #views }
GtLACPSession >> gtInterSessionMessagesFor: aView [
 <gtView>
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

{ #category : #actions }
GtLACPSession >> gtRenameFor: anAction [
	<gtAction>
	self canClose ifFalse: [ ^ anAction noAction ].
	^ anAction dropdown
		id: #'acp-rename-session';
		label: 'Rename session';
		priority: 40;
		target: GtLACPSessionActionTarget;
		menuItemGroup: BrMenuItemGroupConfiguration editing;
		content: [ :anActionElement :aTargetElement :anExplicitMenu | 
			GtLACPRenameSessionForm new
				session: self;
				menuModel: anExplicitMenu;
				asElement ]
]

{ #category : #actions }
GtLACPSession >> gtSessionActionsDropdownFor: anAction [
	<gtToolAction>
	(GtLACPSessionActionTarget actionsForObject: self)
		ifEmpty: [ ^ anAction noAction ].
	^ anAction dropdown
		tooltip: 'Session actions';
		icon: BrGlamorousVectorIcons hamburger;
		id: #'acp-session-actions';
		priority: 100;
		menuItemsForObject: self fromTarget: GtLACPSessionActionTarget
]

{ #category : #'gt-views' }
GtLACPSession >> gtSessionFor: aView [
	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'Session';
		priority: 10;
		items: [ {'Project directory' -> directory.
				'Remote session ID' -> remoteSessionId.
				'Status' -> state.
				'Context window' -> (self contextWindow ifNil: [ 'Not reported' ]).
				'Client' -> client.
				'Connection' -> connection} ];
		column: 'Session' text: #key;
		column: 'Value' text: [ :entry | entry value printString ];
		send: #value;
		updateWhen: GtLACPSessionChanged in: [ self announcer ];
		actionUpdateButtonTooltip: 'Refresh session'
]

{ #category : #views }
GtLACPSession >> gtSkillsFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Skills';
		priority: 27;
		object: [ self availableCommands ];
		view: #gtSkillsFor:
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
	^ aView list
		title: 'Turns';
		priority: 20;
		items: [ turns copy ];
		itemText: #yourself;
		actionUpdateButtonTooltip: 'Refresh turns'
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

{ #category : #views }
GtLACPSession >> gtWorkGraphFor: aView [
	<gtView>
	<gtLlmView>
	^ aView explicit
		title: 'Work graph';
		priority: 5;
		stencil: [ self asWorkGraph asElement ];
		actionUpdateButtonTooltip: 'Refresh agent work graph'
]

{ #category : #accessing }
GtLACPSession >> header [
	^ self conversationTitle
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

{ #category : #commands }
GtLACPSession >> invokeCommand: aCommand arguments: arguments [
	(self availableCommands identityIncludes: aCommand)
		ifFalse: [ self error: 'The command is no longer available in this session' ].
	^ self prompt: (aCommand promptWith: arguments)
]

{ #category : #commands }
GtLACPSession >> invokeCommandNamed: aName arguments: arguments [
	^ self invokeCommand: (self commandNamed: aName) arguments: arguments
]

{ #category : #testing }
GtLACPSession >> isReplaying [
 ^ self rootSession state = #loading
]

{ #category : #testing }
GtLACPSession >> isSubagent [
 ^ parentSubagent notNil
]

{ #category : #lifecycle }
GtLACPSession >> load: anId [
	| params result |
	self requireRootSession.
	[ connection capabilities supportsLoad
		ifFalse: [ self error: 'Agent does not support loading sessions' ].
	state := #loading.
	self childSessions do: #invalidateSubagentLiveState.
	remoteSessionId := anId.
	connection registerSession: self.
	params := self creationParameters
			at: 'sessionId' put: anId;
			yourself.
	[ result := connection request: 'session/load' parameters: params.
	self updateSettingsFrom: result.
	state := #ready ]
		on: Error
		do: [ :ex | 
			state := #failed.
			ex pass ] ]
		ensure: [ self updateConversationSummarizers.
			self announceChanged ]
]

{ #category : #accessing }
GtLACPSession >> mcpToolMessages [
 ^ self mcpToolMessagesFor: self allToolCalls
]

{ #category : #accessing }
GtLACPSession >> mcpToolMessagesFor: toolCalls [
	^ self isSubagent
		ifTrue: [ parentSubagent parentSession mcpToolMessagesFor: toolCalls ]
		ifFalse: [ self mcpToolMessagesFor: toolCalls in: self class mcpServer ]
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
 turn parentTurn ifNotNil: [ :parent |
  parent session announceMessageChanged: parent assistantMessage ].
 ^ turn
]

{ #category : #accessing }
GtLACPSession >> objectStorage [
	^ self isSubagent
		ifTrue: [ parentSubagent parentSession objectStorage ]
		ifFalse: [ self class mcpServer ifNotNil: #objectStorage ]
]

{ #category : #accessing }
GtLACPSession >> parentSubagent [
 ^ parentSubagent
]

{ #category : #accessing }
GtLACPSession >> parentSubagent: anAssociation [
 parentSubagent := anAssociation
]

{ #category : #accessing }
GtLACPSession >> pendingInteractions [
	^ self currentTurn ifNil: [ #() ] ifNotNil: #pendingInteractions
]

{ #category : #views }
GtLACPSession >> phlowContext [
 ^ GtPhlowContext new objectRegistry: self objectStorage; yourself
]

{ #category : #accessing }
GtLACPSession >> presentationState [
	self pendingInteractions ifNotEmpty: [ ^ #inputNeeded ].
	^ state
]

{ #category : #printing }
GtLACPSession >> printOn: aStream [
	aStream
		nextPutAll: 'ACP session - ';
		nextPutAll: state asString;
		nextPutAll: ' - ';
		nextPutAll: turns size asString;
		nextPutAll: ' turns'.

	directory
		ifNotNil: [ aStream
				nextPutAll: ' - ';
				nextPutAll: directory fullName ]
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

{ #category : #private }
GtLACPSession >> receiveElicitation: params requestId: anId [
	| turn elicitation toolId |
	[ turn := self currentTurn.
	(self isSubagent and: [ self isReplaying not ])
		ifTrue: [ (turn isNil or: [ turn isActive not and: [ turn state ~= #observed ] ])
				ifTrue: [ turn := self newObservedTurn ].
			turn state: #running.
			state := #prompting ].
	(turn isNil or: [ turn isActive not ])
		ifTrue: [ ^ connection replyTo: anId result: {'action' -> 'cancel'} asDictionary ].
	(turn elicitationRequests anySatisfy: [ :each | each requestId = anId ])
		ifTrue: [ ^ self ].
	elicitation := GtLACPElicitationRequest new
			session: self;
			turn: turn;
			requestId: anId;
			data: params;
			yourself.
	elicitation isSupported
		ifFalse: [ ^ connection
				replyErrorTo: anId
				code: -32602
				message: 'Unsupported elicitation form' ].
	toolId := params at: 'toolCallId' ifAbsent: [ nil ].
	toolId
		ifNotNil: [ elicitation
				toolCall: (turn toolCalls
						detect: [ :call | call id = toolId ]
						ifNone: [ turn
								updateToolCall: {'toolCallId' -> toolId.
										'title' -> 'User question'.
										'status' -> 'pending'} asDictionary ]) ].
	elicitation toolCall
		ifNotNil: [ :call | call elicitationRequests add: elicitation ].
	turn elicitationRequests add: elicitation ] ensure: [ self announceChanged ]
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

{ #category : #protocol }
GtLACPSession >> receivePermission: params requestId: anId [
	| turn permission call |
	[ turn := self currentTurn.
	(self isSubagent and: [ self isReplaying not ])
		ifTrue: [ (turn isNil or: [ turn isActive not and: [ turn state ~= #observed ] ])
				ifTrue: [ turn := self newObservedTurn ].
			turn state: #running.
			state := #prompting ].
	(turn isNil or: [ turn isActive not ])
		ifTrue: [ ^ connection
				replyTo: anId
				result: {'outcome' -> {'outcome' -> 'cancelled'} asDictionary} asDictionary ].
	(turn permissionRequests anySatisfy: [ :each | each requestId = anId ])
		ifTrue: [ ^ self ].
	call := turn updateToolCall: (params at: 'toolCall').
	permission := GtLACPPermissionRequest new
			connection: connection;
			session: self;
			requestId: anId;
			toolCall: call;
			yourself.
	permission
		options: ((params at: 'options')
				collect: [ :each | 
					GtLACPPermissionOption new
						request: permission;
						data: each;
						yourself ]).
	call permissionRequests add: permission.
	turn permissionRequests add: permission ] ensure: [ self announceChanged ]
]

{ #category : #lifecycle }
GtLACPSession >> receiveSubagentUpdate: aDictionary [
	| childId child association owner |
	childId := aDictionary at: 'sessionId'.
	(childId isString and: [ childId notEmpty ])
		ifFalse: [ self error: 'Invalid child session ID' ].
	childId = remoteSessionId ifTrue: [ self error: 'A session cannot own itself' ].
	child := connection sessions at: childId ifAbsent: [ nil ].
	child
		ifNotNil: [ (child isSubagent and: [ child parentSubagent parentSession == self ])
				ifFalse: [ self error: 'A child session cannot change parent or form a cycle' ].
			association := child parentSubagent ]
		ifNil: [ child := client newSessionIn: self directory connection: connection.
			association := GtLACPSubagent new
					parentSession: self;
					session: child;
					yourself.
			child
				parentSubagent: association;
				remoteSessionId: childId;
				state: #observing.
			self subagents add: association.
			connection registerSession: child ].
	association updateFrom: aDictionary.
	owner := child currentTurn
			ifNil: [ self currentTurn ]
			ifNotNil: [ :turn | turn parentTurn ].
	owner ifNotNil: [ owner registerDelegatedSession: child ].
	child announceChanged.
	self announceConversationTreeChanged.
	^ association
]

{ #category : #receiving }
GtLACPSession >> receiveUpdate: aDictionary [
	| kind turn changedMessage |
	[ updates
		add: (GtLACPSessionUpdate new
				data: aDictionary;
				timestamp: DateAndTime now;
				yourself).
	kind := aDictionary at: 'sessionUpdate'.
	kind = 'usage_update' ifTrue: [ ^ self updateContextWindow: aDictionary ].
	kind = 'available_commands_update'
		ifTrue: [ ^ self updateAvailableCommands: (aDictionary at: 'availableCommands') ].
	kind = 'subagent_update'
		ifTrue: [ ^ (aDictionary includesKey: 'sessionId')
				ifTrue: [ self receiveSubagentUpdate: aDictionary ]
				ifFalse: [ self receiveLegacySubagentUpdate: aDictionary ] ].
	(#('subagent_spawned' 'subagent_state_update') includes: kind)
		ifTrue: [ ^ self receiveLegacySubagentUpdate: aDictionary ].
	(#('session_message' 'session_message_chunk') includes: kind)
		ifTrue: [ ^ self receiveInterSessionMessage: aDictionary ].
	kind = 'session_info_update'
		ifTrue: [ (aDictionary includesKey: 'title')
				ifTrue: [ conversationTitle := aDictionary at: 'title'.
					self announceConversationTreeChanged ] ].
	kind = 'config_option_update'
		ifTrue: [ configOptions := aDictionary at: 'configOptions' ].
	kind = 'current_mode_update'
		ifTrue: [ modes at: 'currentModeId' put: (aDictionary at: 'currentModeId') ].
	(#('agent_message_chunk' 'agent_thought_chunk' 'user_message_chunk' 'tool_call' 'tool_call_update')
		includes: kind) ifFalse: [ ^ self ].
	turn := self currentTurn.
	(turn isNil
		or: [ (self isReplaying
				and: [ turn state ~= #replayed
						or: [ kind = 'user_message_chunk' and: [ turn activity notEmpty ] ] ])
				or: [ self isSubagent
						and: [ self isReplaying not
								and: [ turn isActive not and: [ turn state ~= #observed ] ] ] ] ])
		ifTrue: [ turn := self newObservedTurn.
			self isSubagent ifFalse: [ turn state: #replayed ] ].
	(self isSubagent and: [ self isReplaying not ])
		ifTrue: [ turn state: #running.
			state := #prompting ].
	turn receiveUpdate: aDictionary.
	changedMessage := kind = 'user_message_chunk'
			ifTrue: [ turn userMessages ifEmpty: [ nil ] ifNotEmpty: #last ]
			ifFalse: [ turn assistantMessage ] ]
		ensure: [ self announceMessageChanged: changedMessage ]
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
GtLACPSession >> skills [
	^ self availableCommands skills
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

{ #category : #commands }
GtLACPSession >> updateAvailableCommands: aCollection [
	| previous |
	availableCommands
		ifNil: [ availableCommands := GtLACPCommandGroup new
					session: self;
					yourself ].
	previous := Dictionary new.
	availableCommands
		do: [ :command | 
			previous
				at: {command name.
						command class}
				put: command ].
	availableCommands
		items: (aCollection
				collect: [ :data | 
					previous
						at: {data at: 'name'.
								client commandClassFor: data}
						ifPresent: [ :command | 
							command
								data: data;
								yourself ]
						ifAbsent: [ client commandFrom: data for: self ] ]
				as: Array).
	self announcer
		announce: (GtLACPCommandsChanged new
				session: self;
				yourself)
]

{ #category : #updating }
GtLACPSession >> updateContextWindow: aDictionary [
	contextWindow := GtLACPContextWindow new initializeFrom: aDictionary
]

{ #category : #updating }
GtLACPSession >> updateConversationSummarizers [
 self updateToolSummarizers.
 self childSessions do: #updateConversationSummarizers
]

{ #category : #updating }
GtLACPSession >> updateSettingsFrom: aDictionary [
	modes := aDictionary at: 'modes' ifAbsent: [ modes ].
	configOptions := aDictionary at: 'configOptions' ifAbsent: [ configOptions ].
	(aDictionary includesKey: 'availableCommands')
		ifTrue: [ self updateAvailableCommands: (aDictionary at: 'availableCommands') ]
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

{ #category : #accessing }
GtLACPSession >> workSummaryText [
 ^ self conversationTitle
]
