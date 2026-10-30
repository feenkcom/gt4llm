"
I am an ACP fixture server running in a Smalltalk process in this image. Queues carry newline-delimited JSON to and from the real stdio transport. I implement its process endpoint protocol without launching an OS process. My protocol, pending prompts and worker views explain the fixture's behavior.
"
Class {
	#name : #GtLACPFixtureServer,
	#superclass : #GtLACPObject,
	#instVars : [
		'incoming',
		'outgoing',
		'worker',
		'state',
		'buffer',
		'pendingRequests',
		'transcript',
		'failure'
	],
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #protocol }
GtLACPFixtureServer >> cancel: aMessage [
 | prompts |
 prompts := pendingRequests values copy.
 pendingRequests removeAll.
 prompts do: [ :prompt | self complete: prompt reason: 'cancelled' ]
]

{ #category : #protocol }
GtLACPFixtureServer >> complete: aMessage reason: aString [
 self replyTo: aMessage result: { 'stopReason' -> aString } asDictionary
]

{ #category : #protocol }
GtLACPFixtureServer >> createSession: aMessage [
 self replyTo: aMessage result: { 'sessionId' -> 'fixture-session' } asDictionary
]

{ #category : #accessing }
GtLACPFixtureServer >> failure [
 ^ failure
]

{ #category : #views }
GtLACPFixtureServer >> gtPendingRequestsFor: aView [
 <gtView>
 ^ aView columnedList title: 'Pending prompts'; priority: 5;
  items: [ pendingRequests associations ];
  column: 'Waiting for' text: #key;
  column: 'Prompt' text: [ :entry | (((entry value at: 'params') at: 'prompt') first at: 'text') ];
  send: #value;
  actionUpdateButtonTooltip: 'Refresh pending prompts'
]

{ #category : #views }
GtLACPFixtureServer >> gtProcessFor: aView [
 <gtView>
 ^ aView columnedList title: 'Fixture worker'; priority: 10;
  items: [ { 'Worker' -> worker.
   'Running' -> self isRunning. 'Failure' -> failure } ];
  column: 'Worker' text: #key;
  column: 'Value' text: [ :entry | entry value printString ];
  send: #value;
  actionUpdateButtonTooltip: 'Refresh worker diagnostics'
]

{ #category : #views }
GtLACPFixtureServer >> gtTranscriptFor: aView [
 <gtView>
 ^ aView forward title: 'Protocol'; priority: 0;
  object: [ transcript ]; view: #gtMessagesFor:
]

{ #category : #initialization }
GtLACPFixtureServer >> initialize [
 super initialize.
 incoming := SharedQueue new.
 outgoing := SharedQueue new.
 pendingRequests := Dictionary new.
 transcript := GtLACPProtocolTranscript new.
 buffer := ''.
 state := #stopped
]

{ #category : #protocol }
GtLACPFixtureServer >> initializeConnection: aMessage [
 self replyTo: aMessage result: { 'protocolVersion' -> 1.
  'agentCapabilities' -> { 'loadSession' -> true } asDictionary.
  'authMethods' -> #() } asDictionary
]

{ #category : #testing }
GtLACPFixtureServer >> isRunning [
 ^ state = #running and: [ worker isTerminated not ]
]

{ #category : #protocol }
GtLACPFixtureServer >> loadSession: aMessage [
 self updateSession: ((aMessage at: 'params') at: 'sessionId') with: {
  'sessionUpdate' -> 'agent_message_chunk'.
  'content' -> { 'type' -> 'text'. 'text' -> 'Replayed' } asDictionary } asDictionary.
 self replyTo: aMessage result: Dictionary new
]

{ #category : #accessing }
GtLACPFixtureServer >> pendingRequests [
 ^ pendingRequests
]

{ #category : #io }
GtLACPFixtureServer >> pollStderr [
 ^ ''
]

{ #category : #io }
GtLACPFixtureServer >> pollStdout [
 ^ outgoing nextOrNil ifNil: [ '' ]
]

{ #category : #protocol }
GtLACPFixtureServer >> prompt: aMessage [
 | parameters sessionId text |
 parameters := aMessage at: 'params'.
 sessionId := parameters at: 'sessionId'.
 text := (parameters at: 'prompt') first at: 'text'.
 self updateSession: sessionId with: {
  'sessionUpdate' -> 'agent_message_chunk'.
  'content' -> { 'type' -> 'text'. 'text' -> 'Grüezi 🌍' } asDictionary } asDictionary.
 text = 'permission' ifTrue: [ ^ self requestPermissionFor: aMessage ].
 text = 'wait' ifTrue: [
  pendingRequests at: 'turn' put: aMessage.
  ^ self ].
 self complete: aMessage reason: 'end_turn'
]

{ #category : #protocol }
GtLACPFixtureServer >> receiveChunk: aString [
 | index line |
 buffer := buffer, aString.
 [ (index := buffer indexOf: Character lf) > 0 ] whileTrue: [
  line := (buffer copyFrom: 1 to: index - 1) trimBoth.
  buffer := buffer copyFrom: index + 1 to: buffer size.
  line ifNotEmpty: [
   | message |
   message := STONJSON fromString: line.
   transcript record: message direction: #incoming.
   self receiveMessage: message ] ]
]

{ #category : #protocol }
GtLACPFixtureServer >> receiveMessage: aMessage [
 | method |
 method := aMessage at: 'method' ifAbsent: [ ^ self receivePermissionReply: aMessage ].
 method = 'initialize' ifTrue: [ ^ self initializeConnection: aMessage ].
 method = 'session/new' ifTrue: [ ^ self createSession: aMessage ].
 method = 'session/load' ifTrue: [ ^ self loadSession: aMessage ].
 method = 'session/prompt' ifTrue: [ ^ self prompt: aMessage ].
 method = 'session/cancel' ifTrue: [ ^ self cancel: aMessage ].
 (aMessage includesKey: 'id') ifTrue: [
  self send: { 'jsonrpc' -> '2.0'. 'id' -> (aMessage at: 'id').
   'error' -> { 'code' -> -32601. 'message' -> 'Unsupported fixture method' } asDictionary } asDictionary ]
]

{ #category : #protocol }
GtLACPFixtureServer >> receivePermissionReply: aMessage [
 | prompt outcome |
 (aMessage at: 'id' ifAbsent: [ nil ]) = 'permission' ifFalse: [ ^ self ].
 prompt := pendingRequests removeKey: 'permission' ifAbsent: [ ^ self ].
 outcome := ((aMessage at: 'result') at: 'outcome') at: 'outcome'.
 outcome = 'selected' ifTrue: [
  self updateSession: ((prompt at: 'params') at: 'sessionId') with: {
   'sessionUpdate' -> 'tool_call_update'. 'toolCallId' -> 'read'. 'status' -> 'completed' } asDictionary ].
 self complete: prompt reason: (outcome = 'selected' ifTrue: [ 'end_turn' ] ifFalse: [ 'cancelled' ])
]

{ #category : #protocol }
GtLACPFixtureServer >> replyTo: aMessage result: aDictionary [
 self send: { 'jsonrpc' -> '2.0'. 'id' -> (aMessage at: 'id').
  'result' -> aDictionary } asDictionary
]

{ #category : #protocol }
GtLACPFixtureServer >> requestPermissionFor: aMessage [
 pendingRequests at: 'permission' put: aMessage.
 self send: { 'jsonrpc' -> '2.0'. 'id' -> 'permission'. 'method' -> 'session/request_permission'.
  'params' -> { 'sessionId' -> ((aMessage at: 'params') at: 'sessionId').
   'toolCall' -> { 'toolCallId' -> 'read'. 'title' -> 'Read fixture'. 'status' -> 'pending' } asDictionary.
   'options' -> { { 'optionId' -> 'allow'. 'name' -> 'Allow once'. 'kind' -> 'allow_once' } asDictionary } } asDictionary } asDictionary
]

{ #category : #protocol }
GtLACPFixtureServer >> send: aDictionary [
 | line middle |
 transcript record: aDictionary direction: #outgoing.
 line := (STONJSON toString: aDictionary), String lf.
 "Deliberately fragment frames to exercise the client's real frame assembler."
 middle := line size // 2.
 outgoing nextPut: (line first: middle).
 outgoing nextPut: (line allButFirst: middle)
]

{ #category : #lifecycle }
GtLACPFixtureServer >> start [
 state := #running.
 worker := [
  [ [ state = #running ] whileTrue: [ self receiveChunk: incoming next ] ]
   on: Error do: [ :error | failure := error. state := #failed ]
 ] forkAt: Processor userBackgroundPriority.
 worker name: 'ACP fixture server'
]

{ #category : #lifecycle }
GtLACPFixtureServer >> stop [
 state := #stopped.
 worker ifNotNil: [
  worker == Processor activeProcess ifFalse: [ worker terminate ] ]
]

{ #category : #accessing }
GtLACPFixtureServer >> transcript [
 ^ transcript
]

{ #category : #protocol }
GtLACPFixtureServer >> updateSession: aSessionId with: anUpdate [
 self send: { 'jsonrpc' -> '2.0'. 'method' -> 'session/update'.
  'params' -> { 'sessionId' -> aSessionId. 'update' -> anUpdate } asDictionary } asDictionary
]

{ #category : #accessing }
GtLACPFixtureServer >> worker [
 ^ worker
]

{ #category : #io }
GtLACPFixtureServer >> write: aString [
 self isRunning ifFalse: [ self error: 'Fixture server is not running' ].
 incoming nextPut: aString
]
