"
Agent Client Protocol v1 integration for Glamorous Toolkit. See GtLACPExamples for executable usage.
"
Class {
	#name : #GtLACPExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #examples }
GtLACPExamples >> allInspectorViews [
 <gtExample>
 | objects |
 objects := self inspectorObjects.
 objects do: [ :each |
  each class allMethods do: [ :method |
   ((method pragmaAt: #gtView) notNil and: [ method methodClass package name = 'Gt4Llm-ACP' ])
    ifTrue: [ | result |
     result := GtPhlowViewTester new testView: (each perform: method selector with: GtPhlowView empty).
     self assert: (result isOk or: [ result isEmpty ]) description: each class name, '>>', method selector, ': ', result printString ] ] ].
 ^ objects
]

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
 self assert: turn state equals: #cancelling.
 session connection transport receive: { 'jsonrpc' -> '2.0'. 'id' -> turn request id.
  'result' -> { 'stopReason' -> 'cancelled' } asDictionary } asDictionary.
 self assert: turn state equals: #cancelled.
 self assert: session state equals: #ready.
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
 self assert: session state equals: #closed.
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
GtLACPExamples >> disconnectedTurn [
 <gtExample>
 | session turn |
 session := self session.
 turn := session prompt: 'Hello'.
 session connection failed: 'Agent exited unexpectedly'.
 self assert: turn state equals: #failed.
 self assert: session state equals: #failed.
 self assert: session connection pendingRequests isEmpty.
 ^ turn
]

{ #category : #examples }
GtLACPExamples >> distinctDirectories [
 <gtExample>
 | client first second |
 client := GtLACPCodexClient new transportFactory: [ :config :directory | self transport ]; yourself.
 first := client startSessionIn: FileLocator temp.
 second := client startSessionIn: FileLocator home.
 self assert: first directory ~= second directory.
 self assert: first connection ~~ second connection.
 self assert: client sessions size equals: 2.
 first close.
 self assert: second state equals: #ready.
 second close.
 ^ client
]

{ #category : #fixtures }
GtLACPExamples >> fixtureSource [
 ^ 'import sys,json,os
pending={}
def send(x):
 print(json.dumps(dict(jsonrpc="2.0",**x),ensure_ascii=False),flush=True)
def update(s,u):
 send(dict(method="session/update",params=dict(sessionId=s,update=u)))
for line in sys.stdin:
 m=json.loads(line); method=m.get("method",""); p=m.get("params",{}); i=m.get("id")
 if method=="initialize":
  send(dict(id=i,result=dict(protocolVersion=1,agentCapabilities=dict(loadSession=True),authMethods=[])))
 elif method=="session/new":
  assert p["cwd"]==os.getcwd()
  send(dict(id=i,result=dict(sessionId="fixture-session")))
 elif method=="session/load":
  update(p["sessionId"],dict(sessionUpdate="agent_message_chunk",content=dict(type="text",text="Replayed")))
  send(dict(id=i,result={}))
 elif method=="session/prompt":
  s=p["sessionId"]
  update(s,dict(sessionUpdate="agent_message_chunk",content=dict(type="text",text="Grüezi 🌍")))
  if p["prompt"][0]["text"]=="permission":
   pending["permission"]=(i,s)
   send(dict(id="permission",method="session/request_permission",params=dict(sessionId=s,toolCall=dict(toolCallId="read",title="Read fixture",status="pending"),options=[dict(optionId="allow",name="Allow once",kind="allow_once")])))
  elif p["prompt"][0]["text"]=="wait":
   pending["turn"]=(i,s)
  else:
   send(dict(id=i,result=dict(stopReason="end_turn")))
 elif method=="session/cancel":
  for k,(pi,s) in list(pending.items()):
   send(dict(id=pi,result=dict(stopReason="cancelled"))); del pending[k]
 elif "result" in m and i=="permission":
  pi,s=pending.pop(i)
  update(s,dict(sessionUpdate="tool_call_update",toolCallId="read",status="completed"))
  send(dict(id=pi,result=dict(stopReason="end_turn")))
 else:
  send(dict(id=i,error=dict(code=-32601,message="Unsupported fixture method")))
'
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
GtLACPExamples >> inspectorObjects [
 <gtExample>
 | turn permission objects |
 turn := self streamedTurn.
 permission := self pendingPermission.
 objects := { turn userMessages first. turn assistantMessage. turn session client. self claudeClient. turn session client configuration.
  self claudeClient configuration. turn session. turn. turn messages last.
  turn messages last content first. permission. permission options first.
  permission toolCall. permission connection. permission connection capabilities.
  turn session connection transcript. turn session connection transcript messages first.
  turn request. turn session updates first.
  GtLACPProcess new. GtLACPStdioTransport new. self transport }.
 ^ objects
]

{ #category : #examples }
GtLACPExamples >> loadedSession [
 <gtExample>
 | client session |
 client := GtLACPCodexClient new transportFactory: [ :config :directory | self transport ]; yourself.
 session := client loadSession: 'existing-session' in: FileLocator temp.
 self assert: session state equals: #ready.
 self assert: session remoteSessionId equals: 'existing-session'.
 ^ session
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
 session connection transport receive: { 'jsonrpc' -> '2.0'. 'id' -> turn request id.
  'error' -> { 'code' -> -32603. 'message' -> 'Example failure' } asDictionary } asDictionary.
 self assert: turn state equals: #failed.
 self assert: session state equals: #ready.
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
 | client session |
 client := GtLACPCodexClient new transportFactory: [ :config :directory | self transport ]; yourself.
 session := client startSessionIn: FileLocator temp.
 self assert: session state equals: #ready.
 self assert: session directory equals: FileLocator temp asFileReference asAbsolute.
 self assert: session connection state equals: #ready.
 ^ session
]

{ #category : #examples }
GtLACPExamples >> streamedTurn [
 <gtExample>
 | session turn |
 session := self session.
 turn := session prompt: 'Hello'.
 self sendUpdate: { 'sessionUpdate' -> 'agent_message_chunk'.
  'content' -> { 'type' -> 'text'. 'text' -> 'Hello ' } asDictionary } asDictionary to: session.
 self sendUpdate: { 'sessionUpdate' -> 'agent_message_chunk'.
  'content' -> { 'type' -> 'text'. 'text' -> 'world' } asDictionary } asDictionary to: session.
 session connection transport receive: { 'jsonrpc' -> '2.0'. 'id' -> turn request id.
  'result' -> { 'stopReason' -> 'end_turn' } asDictionary } asDictionary.
 self assert: turn messages last text equals: 'Hello world'.
 self assert: turn state equals: #completed.
 self assert: session state equals: #ready.
 self assert: session connection pendingRequests isEmpty.
 ^ turn
]

{ #category : #examples }
GtLACPExamples >> subprocessCancellation [
 <gtExample>
 | session turn |
 session := self subprocessClient startSessionIn: FileLocator temp.
 [ turn := session prompt: 'wait'.
 session cancelTurn.
 turn waitForSeconds: 5.
 self assert: turn state equals: #cancelled ]
 ensure: [ session close ].
 ^ turn
]

{ #category : #fixtures }
GtLACPExamples >> subprocessClient [
 ^ GtLACPCodexClient new
  configuration: (GtLACPCodexClientConfiguration new
   executable: '/usr/bin/python3';
   arguments: { '-u'. '-c'. self fixtureSource };
   requestTimeout: 5; yourself);
  yourself
]

{ #category : #examples }
GtLACPExamples >> subprocessConversation [
 <gtExample>
 | session turn |
 session := self subprocessClient startSessionIn: FileLocator temp.
 [ turn := session prompt: 'hello'.
 turn waitForSeconds: 5.
 self assert: turn messages last text equals: 'Grüezi 🌍'.
 self assert: turn state equals: #completed.
 self assert: session connection transport agentProcess directory equals: session directory ]
 ensure: [ session close ].
 self assert: session connection transport agentProcess isRunning not.
 ^ session
]

{ #category : #examples }
GtLACPExamples >> subprocessPermission [
 <gtExample>
 | session turn deadline |
 session := self subprocessClient startSessionIn: FileLocator temp.
 [ turn := session prompt: 'permission'.
 deadline := Time millisecondClockValue + 5000.
 [ turn permissionRequests isEmpty and: [ Time millisecondClockValue < deadline ] ] whileTrue: [ (Delay forMilliseconds: 10) wait ].
 self assert: turn permissionRequests size equals: 1.
 turn permissionRequests first options first select.
 turn waitForSeconds: 5.
 self assert: turn toolCalls first status equals: 'completed'.
 self assert: turn state equals: #completed ]
 ensure: [ session close ].
 ^ turn
]

{ #category : #examples }
GtLACPExamples >> subprocessReplay [
 <gtExample>
 | session |
 session := self subprocessClient loadSession: 'saved-session' in: FileLocator temp.
 [ self assert: session turns first messages first text equals: 'Replayed'.
 self assert: session turns first state equals: #replayed ]
 ensure: [ session close ].
 ^ session
]

{ #category : #examples }
GtLACPExamples >> toolCallDataView [
 <gtExample>
 | call element scripter |
 call := self updatedToolCall.
 element := (call gtDataFor: GtPhlowView empty) asElementDo: [ :widget |
  widget background: Color white.
  widget ].
 scripter := BlScripter new model: call; element: element; yourself.
 scripter assertStep: [ :step | step onPhlowCellWithString: 'rawOutput'; exists ].
 scripter assertStep: [ :step | step onPhlowCellWithString: 'status'; exists ].
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
 self assert: turn state equals: #running.
 self assert: session state equals: #prompting.
 self assert: session connection pendingRequests size equals: 1.
 session cancelTurn.
 self assert: turn state equals: #cancelling.
 session close.
 ^ turn
]
