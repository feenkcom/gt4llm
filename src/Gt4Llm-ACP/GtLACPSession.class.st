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
		'summarizersRegistry'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #announcing }
GtLACPSession >> announceChanged [
 self announceMessageChanged: (self currentTurn ifNotNil: #assistantMessage)
]

{ #category : #announcing }
GtLACPSession >> announceMessageChanged: aMessage [
 self announcer announce: (GtLACPSessionChanged new
  session: self; message: aMessage; yourself)
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

{ #category : #ui }
GtLACPSession >> asChatViewModel [
 ^ GtLACPChatViewModel new session: self; yourself
]

{ #category : #ui }
GtLACPSession >> asElement [
 ^ GtLACPChatElement new viewModel: self asChatViewModel; yourself
]

{ #category : #announcing }
GtLACPSession >> cancelTurn [
 | turn |
 [
 turn := self currentTurn.
 (turn isNil or: [ turn isActive not ]) ifTrue: [ ^ self ].
 turn state: #cancelling.
 turn permissionRequests do: [ :each | each cancel ].
 connection notify: 'session/cancel' parameters: { 'sessionId' -> remoteSessionId } asDictionary
 ] ensure: [ self announceChanged ]
]

{ #category : #accessing }
GtLACPSession >> client [
 ^ client
]

{ #category : #accessing }
GtLACPSession >> client: anObject [
 client := anObject
]

{ #category : #announcing }
GtLACPSession >> close [
 [
 self currentTurn ifNotNil: [ :turn | turn permissionRequests do: #cancel ].
 connection sessions removeKey: remoteSessionId ifAbsent: [ ].
 state := #closed.
 connection sessions isEmpty ifTrue: [ connection stop ]
 ] ensure: [ self announceChanged ]
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
 self currentTurn ifNotNil: [ :turn | turn isActive ifTrue: [ turn fail: aReason ].
  turn permissionRequests do: #abandon ].
 state = #closed ifFalse: [ state := #failed ]
 ] ensure: [ self updateToolSummarizers. self announceChanged ]
]

{ #category : #announcing }
GtLACPSession >> create [
 | result |
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
 ^ directory
]

{ #category : #accessing }
GtLACPSession >> directory: anObject [
 directory := anObject
]

{ #category : #actions }
GtLACPSession >> gtCancelFor: anAction [
 <gtAction>
 state = #prompting ifFalse: [ ^ anAction noAction ].
 ^ anAction button label: 'Cancel turn'; priority: 10; action: [ self cancelTurn ]
]

{ #category : #views }
GtLACPSession >> gtChatFor: aView [
 <gtView>
 <gtLlmView>
 ^ aView explicit title: 'Chat'; priority: 0; stencil: [ self asElement ]
]

{ #category : #actions }
GtLACPSession >> gtCloseFor: anAction [
 <gtAction>
 state = #closed ifTrue: [ ^ anAction noAction ].
 ^ anAction button label: 'Close session'; priority: 50; action: [ self close ]
]

{ #category : #views }
GtLACPSession >> gtComposeFor: aView [
 <gtView>
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

{ #category : #updating }
GtLACPSession >> load: anId [
 | params result |
 [
 connection capabilities supportsLoad ifFalse: [ self error: 'Agent does not support loading sessions' ].
 state := #loading.
 remoteSessionId := anId.
 connection sessions at: anId put: self.
 params := self creationParameters at: 'sessionId' put: anId; yourself.
 [ result := connection request: 'session/load' parameters: params.
 self updateSettingsFrom: result.
 state := #ready ] on: Error do: [ :ex | state := #failed. ex pass ]
 ] ensure: [ self updateToolSummarizers. self announceChanged ]
]

{ #category : #summaries }
GtLACPSession >> mcpToolMessages [
 ^ self mcpToolMessagesIn: GtLMcpServer current
]

{ #category : #summaries }
GtLACPSession >> mcpToolMessagesIn: aServer [
 | messages seen |
 messages := GtLMessagesGroup new.
 seen := IdentitySet new.
 turns copy do: [ :turn |
  turn toolCalls copy do: [ :call |
   (call mcpToolMessageIn: aServer) ifNotNil: [ :message |
    (seen includes: message) ifFalse: [
     seen add: message.
     messages add: message ] ] ] ].
 ^ messages
]

{ #category : #accessing }
GtLACPSession >> modes [
 ^ modes
]

{ #category : #accessing }
GtLACPSession >> modes: anObject [
 modes := anObject
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

{ #category : #updating }
GtLACPSession >> promptContent: blocks [
 | turn rpc |
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
 rpc onSuccess: [ :result | turn complete: (result at: 'stopReason'). state := #ready. self updateToolSummarizers. self announceMessageChanged: turn assistantMessage ];
  onFailure: [ :reason | turn fail: reason. state = #closed ifFalse: [ state := (connection state = #ready ifTrue: [ #ready ] ifFalse: [ #failed ]) ]. self updateToolSummarizers. self announceMessageChanged: turn assistantMessage ].
 connection sendRequest: rpc.
 ^ turn
 ] ensure: [ self announceMessageChanged: (turn ifNotNil: #assistantMessage) ]
]

{ #category : #accessing }
GtLACPSession >> promptText [
 ^ promptText
]

{ #category : #accessing }
GtLACPSession >> promptText: anObject [
 promptText := anObject
]

{ #category : #announcing }
GtLACPSession >> receivePermission: params requestId: anId [
 | turn permission call |
 [
 turn := self currentTurn.
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

{ #category : #receiving }
GtLACPSession >> receiveUpdate: aDictionary [
	| kind turn changedMessage |
	[ 
	turn := self currentTurn.
 turn ifNotNil: [ turn activity ].
	updates
		add: (GtLACPSessionUpdate new
				data: aDictionary;
				timestamp: DateAndTime now;
				yourself).
	kind := aDictionary at: 'sessionUpdate'.
	kind = 'config_option_update'
		ifTrue: [ configOptions := aDictionary at: 'configOptions' ].
	kind = 'current_mode_update'
		ifTrue: [ modes at: 'currentModeId' put: (aDictionary at: 'currentModeId') ].
	(#('agent_message_chunk' 'agent_thought_chunk' 'user_message_chunk' 'tool_call' 'tool_call_update')
		includes: kind) ifFalse: [ ^ self ].
	turn := self currentTurn.
	(turn isNil or: [ state = #loading and: [
  turn state ~= #replayed or: [
   kind = 'user_message_chunk' and: [ turn activity notEmpty ] ] ] ])
		ifTrue: [ turn := GtLACPPromptTurn new
					session: self;
					state: #replayed;
					yourself.
			turns add: turn ].
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

{ #category : #configuration }
GtLACPSession >> setConfigOption: anId value: aValue [
 | option |
 option := configOptions detect: [ :each | (each at: 'id') = anId ] ifNone: [ self error: 'Unknown session configuration option' ].
 self updateSettingsFrom: (connection request: 'session/set_config_option' parameters: {
  'sessionId' -> remoteSessionId. 'configId' -> (option at: 'id'). 'value' -> aValue } asDictionary)
]

{ #category : #configuration }
GtLACPSession >> setMode: anId [
 | available |
 available := modes at: 'availableModes' ifAbsent: [ #() ].
 (available anySatisfy: [ :each | (each at: 'id') = anId ]) ifFalse: [ self error: 'Mode is not advertised by the agent' ].
 connection request: 'session/set_mode' parameters: { 'sessionId' -> remoteSessionId. 'modeId' -> anId } asDictionary.
 modes at: 'currentModeId' put: anId
]

{ #category : #configuration }
GtLACPSession >> setModel: anId [
 | option |
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

{ #category : #accessing }
GtLACPSession >> updateSettingsFrom: aDictionary [
 modes := aDictionary at: 'modes' ifAbsent: [ modes ].
 configOptions := aDictionary at: 'configOptions' ifAbsent: [ configOptions ]
]

{ #category : #summaries }
GtLACPSession >> updateToolSummarizers [
 self summarizersRegistry updateSummarizersForMessages: self mcpToolMessages
]

{ #category : #accessing }
GtLACPSession >> updates [
 ^ updates
]

{ #category : #accessing }
GtLACPSession >> updates: anObject [
 updates := anObject
]
