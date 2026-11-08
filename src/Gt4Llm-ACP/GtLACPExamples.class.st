"
Deterministic executable examples for ACP state, transport, streaming, permissions, failures and inspection. An in-image Smalltalk fixture server exercises the real stdio framing and asynchronous reader without agent installations or external language runtimes. Separate sort command examples exercise native process pipes and shutdown.
"
Class {
	#name : #GtLACPExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #asserting }
GtLACPExamples >> assertRaisesError: aBlock raise: aClass [
 | raised |
 raised := false.
 aBlock on: aClass do: [ :ex | raised := true ].
 self assert: raised
]

{ #category : #examples }
GtLACPExamples >> cancelledTurn [
	<gtExample>
	| permission session turn |
	permission := self pendingPermission.
	session := permission session.
	turn := session currentTurn.
	session cancelTurn.
	self assert: permission state equals: #cancelled.
	self assert: turn isCancelling.
	session connection transport
		receive: {'jsonrpc' -> '2.0'.
				'id' -> turn request id.
				'result' -> {'stopReason' -> 'cancelled'} asDictionary} asDictionary.
	self assert: turn isCancelled.
	self assert: session isReady.
	^ turn
]

{ #category : #examples }
GtLACPExamples >> claudeClient [
 <gtExample>
 | client |
 client := GtLACPClaudeCodeClient new.
 self assert: client configuration class equals: GtLACPClaudeCodeClientConfiguration.
 ^ client
]

{ #category : #examples }
GtLACPExamples >> closedSession [
	<gtExample>
	| permission session |
	permission := self pendingPermission.
	session := permission session.
	session close.
	self assert: session isClosed.
	self assert: session connection state equals: #stopped.
	self assert: session connection pendingRequests isEmpty.
	self assert: permission state equals: #cancelled.
	^ session
]

{ #category : #examples }
GtLACPExamples >> codexClient [
 <gtExample>
 | client |
 client := GtLACPCodexClient new.
 self assert: client configuration class equals: GtLACPCodexClientConfiguration.
 ^ client
]

{ #category : #examples }
GtLACPExamples >> configurableMcpServer [
	<gtExample>
	| previousServer server session call message |
	previousServer := GtLACPSession mcpServer.
	server := GtLMcpServer new.
	session := GtLACPSession new.
	call := GtLACPToolCall new
			data: {'toolCallId' -> 'acp-configured-server-example'} asDictionary;
			yourself.
	message := GtLToolMessage new
			toolCall: (GtLFunctionToolCall new
					id: call id;
					name: 'example';
					yourself);
			yourself.
	server privateAddToolMessage: message.
	[ GtLACPSession mcpServer: nil.
	self assert: GtLACPSession mcpServer == GtLMcpServer current.
	GtLACPSession mcpServer: server.
	self assert: GtLACPSession mcpServer == server.
	self assert: session objectStorage == server objectStorage.
	self assert: (session mcpToolMessagesFor: {call}) size equals: 1.
	self assert: (session mcpToolMessagesFor: {call}) first == message.
	self
		assert: (call withMcpToolCallIfPresent: [ :each | each ] ifAbsent: [ nil ]) == message.
	GtLACPSession mcpServer: GtLMcpServer new.
	self assert: (session mcpToolMessagesFor: {call}) isEmpty.
	self
		assert: (call withMcpToolCallIfPresent: [ :each | each ] ifAbsent: [ #absent ])
		equals: #absent.
	GtLACPSession mcpServer: nil.
	self assert: GtLACPSession mcpServer == GtLMcpServer current ]
		ensure: [ GtLACPSession mcpServer: previousServer ].
	^ session
]

{ #category : #examples }
GtLACPExamples >> connectionHistory [
 <gtExample>
 | permission session connection entries |
 permission := self selectedPermission.
 session := permission session.
 connection := session connection.
 self sendUpdate: {
  'sessionUpdate' -> 'agent_message_chunk'.
  'content' -> { 'type' -> 'text'. 'text' -> 'Done' } asDictionary } asDictionary to: session.
 connection transport receive: {
  'jsonrpc' -> '2.0'. 'id' -> session currentTurn request id.
  'result' -> { 'stopReason' -> 'end_turn' } asDictionary } asDictionary.
 connection notify: 'fixture/notification' parameters: Dictionary new.
 connection transport receive: {
  'jsonrpc' -> '2.0'. 'id' -> 'unsupported-1'.
  'method' -> 'fixture/unsupported'. 'params' -> Dictionary new } asDictionary.
 connection transport receive: {
  'jsonrpc' -> '2.0'. 'id' -> 'orphan-response'.
  'result' -> Dictionary new } asDictionary.
 connection transport receive: {
  'jsonrpc' -> '2.0'. 'method' -> 'session/update'.
  'params' -> { 'sessionId' -> 'unannounced-child'.
   'update' -> { 'sessionUpdate' -> 'agent_message_chunk'.
    'content' -> { 'type' -> 'text'. 'text' -> 'Child output' } asDictionary } asDictionary } asDictionary } asDictionary.
 entries := connection transcript messages.
 self assert: entries size equals: 14.
 self assert: (entries count: [ :each | each direction = #outgoing ]) equals: 6.
 self assert: (entries count: [ :each | each kind = #request ]) equals: 5.
 self assert: (entries count: [ :each | each kind = #response ]) equals: 5.
 self assert: (entries count: [ :each | each kind = #error ]) equals: 1.
 self assert: (entries count: [ :each | each kind = #notification ]) equals: 3.
 self assert: entries last sessionId equals: 'unannounced-child'.
 self assert: entries last operation equals: 'session/update · agent_message_chunk'.
 self assert: (entries anySatisfy: [ :each | each id = 'orphan-response' ]).
 ^ connection
]

{ #category : #examples }
GtLACPExamples >> connectionHistorySnapshotsPayloads [
 <gtExample>
 | connection params message entry |
 connection := self session connection.
 params := { 'nested' -> { 'value' -> 'original' } asDictionary } asDictionary.
 connection notify: 'fixture/snapshot' parameters: params.
 entry := connection transcript messages last.
 (params at: 'nested') at: 'value' put: 'changed'.
 self assert: (((entry data at: 'params') at: 'nested') at: 'value') equals: 'original'.
 message := { 'jsonrpc' -> '2.0'. 'id' -> 'snapshot-response'.
  'result' -> { 'value' -> 'received' } asDictionary } asDictionary.
 connection transport receive: message.
 entry := connection transcript messages last.
 (message at: 'result') at: 'value' put: 'changed'.
 self assert: ((entry data at: 'result') at: 'value') equals: 'received'.
 ^ connection
]

{ #category : #examples }
GtLACPExamples >> disconnectedTurn [
	<gtExample>
	| session turn |
	session := self session.
	turn := session prompt: 'Hello'.
	session connection failed: 'Agent exited unexpectedly'.
	self assert: turn isFailed.
	self assert: session isFailed.
	self assert: session connection pendingRequests isEmpty.
	^ turn
]

{ #category : #examples }
GtLACPExamples >> distinctDirectories [
	<gtExample>
	| client first second |
	client := GtLACPCodexClient new
			transportFactory: [ :config :directory | self transport ];
			yourself.
	first := client startSessionIn: FileLocator temp.
	second := client startSessionIn: FileLocator home.
	self assert: first directory ~= second directory.
	self assert: first connection ~~ second connection.
	self assert: client sessions size equals: 2.
	first close.
	self assert: second isReady.
	second close.
	^ client
]

{ #category : #examples }
GtLACPExamples >> fixtureCancellation [
	<gtExample>
	| session turn |
	session := self fixtureClient startSessionIn: FileLocator temp.
	[ turn := session prompt: 'wait'.
	session cancelTurn.
	turn waitForSeconds: 1.
	self assert: turn isCancelled.
	self assert: session connection transport agentProcess pendingRequests isEmpty ]
		ensure: [ session close ].
	^ turn
]

{ #category : #fixtures }
GtLACPExamples >> fixtureClient [
	^ GtLACPCodexClient new
		configuration: (GtLACPCodexClientConfiguration new
				executable: 'in-image ACP fixture';
				arguments: #();
				requestTimeout: 5;
				yourself);
		transportFactory: [ :configuration :directory | 
			GtLACPStdioTransport new
				agentProcess: GtLACPFixtureServer new;
				yourself ];
		yourself
]

{ #category : #examples }
GtLACPExamples >> fixtureConversation [
	<gtExample>
	| session turn server reader newSessionRequest |
	session := self fixtureClient startSessionIn: FileLocator temp.
	server := session connection transport agentProcess.
	reader := session connection transport reader.
	[ self assert: server isRunning.
	self assert: server worker ~~ Processor activeProcess.
	turn := session prompt: 'hello'.
	turn waitForSeconds: 5.
	self assert: turn messages last text equals: 'Grüezi 🌍'.
	self assert: turn isCompleted.
	newSessionRequest := session connection transcript messages
			detect: [ :each | 
				each direction = #outgoing
					and: [ (each data at: 'method' ifAbsent: [ '' ]) = 'session/new' ] ].
	self
		assert: ((newSessionRequest data at: 'params') at: 'cwd')
		equals: session directory fullName ] ensure: [ session close ].
	self assert: server isRunning not.
	self assert: server worker isTerminated.
	self assert: reader isTerminated.
	self assert: server failure isNil.
	^ session
]

{ #category : #examples }
GtLACPExamples >> fixturePermission [
	<gtExample>
	| session turn deadline notifications |
	session := self fixtureClient startSessionIn: FileLocator temp.
	notifications := GtNotifications new.
	session connection
		notificationPublisher: [ :notification | notifications addNotification: notification ].
	[ turn := session prompt: 'permission'.
	deadline := Time millisecondClockValue + 5000.
	[ turn permissionRequests isEmpty
		and: [ Time millisecondClockValue < deadline ] ]
		whileTrue: [ (Delay forMilliseconds: 10) wait ].
	self assert: turn permissionRequests size equals: 1.
	self
		assert: (GtPhlowViewTester new
				testView: (session connection transport agentProcess
						gtPendingRequestsFor: GtPhlowView empty)) isOk.
	turn permissionRequests first options first select.
	turn waitForSeconds: 5.
	self assert: turn toolCalls first status equals: 'completed'.
	self assert: turn isCompleted.
	self assert: session connection transport agentProcess pendingRequests isEmpty ]
		ensure: [ session close ].
	^ turn
]

{ #category : #examples }
GtLACPExamples >> fixtureReplay [
	<gtExample>
	| session |
	session := self fixtureClient loadSession: 'saved-session' in: FileLocator temp.
	[ self assert: session turns first messages first text equals: 'Replayed'.
	self assert: session turns first isReplayed ] ensure: [ session close ].
	^ session
]

{ #category : #examples }
GtLACPExamples >> fixtureReplayConversation [
	<gtExample>
	| session first second models |
	session := self fixtureClient
			loadSession: 'saved-conversation'
			in: FileLocator temp.
	[ self assert: session turns size equals: 2.
	first := session turns first.
	second := session turns second.
	self assert: first userMessages size equals: 1.
	self assert: first userMessages first text equals: 'First question'.
	self
		assert: first assistantMessage finalMessages first text
		equals: 'First answer'.
	self assert: second userMessages first text equals: 'Second question'.
	self
		assert: second assistantMessage finalMessages first text
		equals: 'Second answer'.
	self assert: first toolCalls isEmpty.
	self assert: second toolCalls size equals: 1.
	self
		assert: second assistantMessage activityItems first text
		equals: 'Let me check'.
	self assert: (session turns allSatisfy: [ :turn | turn isReplayed ]).
	models := (GtLACPChatViewModel new
			session: session;
			yourself) messageViewModels.
	self assert: models size equals: 4.
	self
		assert: (models collect: [ :model | model message ])
		equals: {first userMessages first.
				first assistantMessage.
				second userMessages first.
				second assistantMessage} ] ensure: [ session close ].
	^ session
]

{ #category : #examples }
GtLACPExamples >> fixtureServer [
 <gtExample>
 ^ self fixtureConversation connection transport agentProcess
]

{ #category : #examples }
GtLACPExamples >> fixtureUnsupportedRequest [
	<gtExample>
	| session |
	session := self fixtureClient startSessionIn: FileLocator temp.
	[ self
		assertRaisesError: [ session connection request: 'fixture/unsupported' parameters: Dictionary new ]
		raise: Error.
	self assert: session connection transport agentProcess isRunning.
	self assert: session connection pendingRequests isEmpty ]
		ensure: [ session close ].
	^ session
]

{ #category : #examples }
GtLACPExamples >> fragmentedFrames [
 <gtExample>
 | connection transport rpc line |
 connection := GtLACPConnection new transport: self transport; yourself.
 connection start.
 rpc := connection newRequest: 'fragmented' parameters: Dictionary new.
 transport := GtLACPStdioTransport new connection: connection; yourself.
 line := STONJSON toString: { 'jsonrpc' -> '2.0'. 'id' -> rpc id. 'result' -> { 'text' -> 'Grüezi 🌍' } asDictionary } asDictionary.
 transport acceptChunk: (line first: 12).
 self assert: rpc state equals: #pending.
 transport acceptChunk: (line allButFirst: 12), String lf.
 self assert: (rpc result at: 'text') equals: 'Grüezi 🌍'.
 self assert: transport buffer isEmpty.
 ^ connection transcript
]

{ #category : #examples }
GtLACPExamples >> loadedSession [
	<gtExample>
	| client session |
	client := GtLACPCodexClient new
			transportFactory: [ :config :directory | self transport ];
			yourself.
	session := client loadSession: 'existing-session' in: FileLocator temp.
	self assert: session isReady.
	self assert: session remoteSessionId equals: 'existing-session'.
	^ session
]

{ #category : #examples }
GtLACPExamples >> mcpToolMessageLookup [
 <gtExample>
 | server call message unrelated |
 server := GtLMcpServer new.
 call := GtLACPToolCall new data: { 'toolCallId' -> 'acp-mcp-example' } asDictionary; yourself.
 unrelated := GtLToolMessage new
  toolCall: (GtLFunctionToolCall new id: 'another-call'; name: 'other'; yourself);
  yourself.
 message := GtLToolMessage new
  toolCall: (GtLFunctionToolCall new id: call id; name: 'example'; yourself);
  yourself.
 self assert: (call mcpToolMessageIn: server) isNil.
 server privateAddToolMessage: unrelated.
 self assert: (call mcpToolMessageIn: server) isNil.
 server privateAddToolMessage: message.
 self assert: (call mcpToolMessageIn: server) == message.
 ^ call
]

{ #category : #examples }
GtLACPExamples >> modeSelection [
 <gtExample>
 | session |
 session := self session.
 session setMode: 'code'.
 self assert: (session modes at: 'currentModeId') equals: 'code'.
 self assertRaisesError: [ session setMode: 'unknown' ] raise: Error.
 ^ session
]

{ #category : #examples }
GtLACPExamples >> nativeProcessPipes [
 <gtExample>
 | process output deadline configuration |
 configuration := GtLACPCodexClientConfiguration new
  executable: 'sort'; arguments: #(); yourself.
 process := GtLACPProcess new configuration: configuration;
  directory: FileLocator temp asFileReference asAbsolute; yourself.
 output := ''.
 [ process start.
 process write: 'beta', String lf, 'alpha', String lf.
 process nativeProcess stdin close.
 deadline := Time millisecondClockValue + 5000.
 [ process isRunning and: [ Time millisecondClockValue < deadline ] ] whileTrue: [
  output := output, process pollStdout.
  (Delay forMilliseconds: 10) wait ].
 self assert: process isRunning not.
 output := output, process pollStdout.
 self assert: output lines asArray equals: #('alpha' 'beta') ]
 ensure: [ process stop ].
 self assert: process exitStatus isSuccess.
 ^ process
]

{ #category : #examples }
GtLACPExamples >> nativeProcessShutdown [
 <gtExample>
 | process |
 process := GtLACPProcess new
  configuration: (GtLACPCodexClientConfiguration new executable: 'sort'; arguments: #(); yourself);
  directory: FileLocator temp asFileReference asAbsolute; yourself.
 [ process start.
 self assert: process isRunning ]
 ensure: [ process stop ].
 self assert: process isRunning not.
 self assert: process exitStatus isSuccess.
 ^ process
]

{ #category : #examples }
GtLACPExamples >> pendingPermission [
 <gtExample>
 | session turn |
 session := self session.
 turn := session prompt: 'Inspect the directory'.
 session connection transport receive: { 'jsonrpc' -> '2.0'. 'id' -> 'permission-1'.
  'method' -> 'session/request_permission'.
  'params' -> { 'sessionId' -> session remoteSessionId.
   'toolCall' -> { 'toolCallId' -> 'tool-1'. 'title' -> 'Read directory'. 'status' -> 'pending' } asDictionary.
   'options' -> {
    { 'optionId' -> 'allow'. 'name' -> 'Allow once'. 'kind' -> 'allow_once' } asDictionary.
    { 'optionId' -> 'deny'. 'name' -> 'Reject once'. 'kind' -> 'reject_once' } asDictionary } } asDictionary } asDictionary.
 self assert: turn permissionRequests size equals: 1.
 self assert: turn toolCalls first permissionRequests first == turn permissionRequests first.
 ^ turn permissionRequests first
]

{ #category : #examples }
GtLACPExamples >> protocolError [
	<gtExample>
	| session turn |
	session := self session.
	turn := session prompt: 'Hello'.
	session connection transport
		receive: {'jsonrpc' -> '2.0'.
				'id' -> turn request id.
				'error'
					-> {'code' -> -32603.
							'message' -> 'Example failure'} asDictionary} asDictionary.
	self assert: turn isFailed.
	self assert: session isReady.
	^ turn
]

{ #category : #examples }
GtLACPExamples >> requestTimeout [
 <gtExample>
 | connection |
 connection := GtLACPConnection new transport: self transport; requestTimeout: 0.01; yourself.
 connection start.
 self assertRaisesError: [ connection request: 'unanswered' parameters: Dictionary new ] raise: Error.
 self assert: connection pendingRequests isEmpty.
 ^ connection
]

{ #category : #examples }
GtLACPExamples >> selectedPermission [
 <gtExample>
 | permission reply |
 permission := self pendingPermission.
 permission options first select.
 reply := permission connection transport sentMessages last.
 self assert: permission state equals: #selected.
 self assert: (((reply at: 'result') at: 'outcome') at: 'optionId') equals: 'allow'.
 self assertRaisesError: [ permission resolve: 'deny' ] raise: Error.
 ^ permission
]

{ #category : #fixtures }
GtLACPExamples >> sendUpdate: update to: session [
 session connection transport receive: { 'jsonrpc' -> '2.0'. 'method' -> 'session/update'.
 'params' -> { 'sessionId' -> session remoteSessionId. 'update' -> update } asDictionary } asDictionary
]

{ #category : #examples }
GtLACPExamples >> session [
	<gtExample>
	| client session notifications |
	client := GtLACPCodexClient new
			transportFactory: [ :config :directory | self transport ];
			yourself.
	session := client startSessionIn: FileLocator temp.
	notifications := GtNotifications new.
	session connection
		notificationPublisher: [ :notification | notifications addNotification: notification ].
	self assert: session isReady.
	self
		assert: session directory
		equals: FileLocator temp asFileReference asAbsolute.
	self assert: session connection state equals: #ready.
	^ session
]

{ #category : #examples }
GtLACPExamples >> streamedTurn [
	<gtExample>
	| session turn |
	session := self session.
	turn := session prompt: 'Hello'.
	self
		sendUpdate: {'sessionUpdate' -> 'agent_message_chunk'.
				'content'
					-> {'type' -> 'text'.
							'text' -> 'Hello '} asDictionary} asDictionary
		to: session.
	self
		sendUpdate: {'sessionUpdate' -> 'agent_message_chunk'.
				'content'
					-> {'type' -> 'text'.
							'text' -> 'world'} asDictionary} asDictionary
		to: session.
	session connection transport
		receive: {'jsonrpc' -> '2.0'.
				'id' -> turn request id.
				'result' -> {'stopReason' -> 'end_turn'} asDictionary} asDictionary.
	self assert: turn messages last text equals: 'Hello world'.
	self assert: turn isCompleted.
	self assert: session isReady.
	self assert: session connection pendingRequests isEmpty.
	^ turn
]

{ #category : #examples }
GtLACPExamples >> toolCallDataView [
	<gtExample>
	| call view element scripter |
	call := self updatedToolCall.
	view := call gtDataFor: GtPhlowView empty.
	self assert: view class equals: (call data gtItemsFor: GtPhlowView empty) class.
	element := view
			asElementDo: [ :widget | 
				widget background: Color white.
				widget ].
	scripter := BlScripter new
			model: call;
			element: element;
			yourself.
	scripter
		assertStep: [ :step | 
			step
				onPhlowCellWithString: 'rawOutput';
				exists ].
	scripter
		assertStep: [ :step | 
			step
				onPhlowCellWithString: 'status';
				exists ].
	^ scripter
]

{ #category : #fixtures }
GtLACPExamples >> transport [
 ^ GtLACPMemoryTransport new responder: [ :message :transport |
  | method |
  method := message at: 'method' ifAbsent: [ '' ].
  method = 'initialize' ifTrue: [
   transport replyTo: message result: { 'protocolVersion' -> 1.
    'agentCapabilities' -> { 'loadSession' -> true } asDictionary.
    'authMethods' -> #() } asDictionary ].
  method = 'session/new' ifTrue: [
   transport replyTo: message result: {
    'sessionId' -> ('session-', (message at: 'id') asString).
    'modes' -> { 'currentModeId' -> 'ask'. 'availableModes' -> {
     { 'id' -> 'ask'. 'name' -> 'Ask' } asDictionary.
     { 'id' -> 'code'. 'name' -> 'Code' } asDictionary } } asDictionary } asDictionary ].
  method = 'session/set_mode' ifTrue: [ transport replyTo: message result: Dictionary new ].
  method = 'session/load' ifTrue: [ transport replyTo: message result: Dictionary new ] ]; yourself
]

{ #category : #examples }
GtLACPExamples >> unknownInboundRequest [
 <gtExample>
 | session reply |
 session := self session.
 session connection transport receive: { 'jsonrpc' -> '2.0'. 'id' -> 'unknown'.
  'method' -> 'terminal/create'. 'params' -> Dictionary new } asDictionary.
 reply := session connection transport sentMessages last.
 self assert: ((reply at: 'error') at: 'code') equals: -32601.
 ^ session connection transcript
]

{ #category : #examples }
GtLACPExamples >> unmatchedMcpToolMessage [
 <gtExample>
 | call server |
 call := GtLACPToolCall new.
 server := GtLMcpServer new.
 server privateAddToolMessage: (GtLToolMessage new
  toolCall: (GtLFunctionToolCall new name: 'without-id'; yourself);
  yourself).
 self assert: (call mcpToolMessageIn: server) isNil.
 self assert: (call mcpToolMessageIn: nil) isNil.
 self assert: call hasCorrespondingMcpToolCall not.
 self assert: (call
  withMcpToolCallIfPresent: [ :message | self error: 'Unexpected matching message' ]
  ifAbsent: [ #absent ]) equals: #absent.
 self assert: ((call gtMcpToolMessageFor: GtPhlowView empty) isKindOf: GtPhlowEmptyView).
 ^ call
]

{ #category : #examples }
GtLACPExamples >> unsupportedContent [
 <gtExample>
 | session |
 session := self session.
 self assertRaisesError: [ session promptContent: { GtLACPContentBlock new data: { 'type' -> 'image' } asDictionary; yourself } ] raise: Error.
 self assert: session turns isEmpty.
 ^ session
]

{ #category : #examples }
GtLACPExamples >> updatedToolCall [
 <gtExample>
 | permission session |
 permission := self pendingPermission.
 session := permission session.
 self sendUpdate: { 'sessionUpdate' -> 'tool_call_update'.
  'toolCallId' -> 'tool-1'. 'status' -> 'completed'. 'rawOutput' -> 'directory contents' } asDictionary to: session.
 self assert: session currentTurn toolCalls size equals: 1.
 self assert: permission toolCall title equals: 'Read directory'.
 self assert: permission toolCall status equals: 'completed'.
 ^ permission toolCall
]

{ #category : #examples }
GtLACPExamples >> waitingTimeoutPreservesTurn [
	<gtExample>
	| session turn |
	session := self session.
	turn := session prompt: 'Hello'.
	self assertRaisesError: [ turn waitForSeconds: 0.01 ] raise: Error.
	self assert: turn isRunning.
	self assert: session isPrompting.
	self assert: session connection pendingRequests size equals: 1.
	session cancelTurn.
	self assert: turn isCancelling.
	session close.
	^ turn
]
