"
I exercise session-scoped MCP tool summaries and their chat tool views with isolated in-image fixtures.
"
Class {
	#name : #GtLACPSummarizerExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #fixtures }
GtLACPSummarizerExamples >> addCallWithId: anId to: aSession [
 aSession receiveUpdate: {
  'sessionUpdate' -> 'tool_call'.
  'toolCallId' -> anId.
  'title' -> 'Look up Object'.
  'status' -> 'completed' } asDictionary
]

{ #category : #examples }
GtLACPSummarizerExamples >> customRegistry [
 <gtExample>
 | session registry |
 session := self sessionWithSummaries.
 registry := GtLToolCallSummarizersRegistry new.
 registry addSpecification: GtLToolCallsByTypeSummarizer asSpecification.
 session summarizersRegistry: registry; updateToolSummarizers.
 self assert: session summarizersRegistry == registry.
 self assert: session gtInspectorTargetModels size equals: 1.
 ^ session
]

{ #category : #examples }
GtLACPSummarizerExamples >> failedAndCancelledSummaries [
 <gtExample>
 | failed cancelled turn |
 failed := self session.
 turn := failed prompt: 'Fail after a tool'.
 failed mcpServer privateAddToolMessage: (self messageWithId: 'before-failure').
 self addCallWithId: 'before-failure' to: failed.
 failed connection transport receive: {
  'jsonrpc' -> '2.0'. 'id' -> turn request id.
  'error' -> { 'code' -> -32000. 'message' -> 'Fixture failure' } asDictionary } asDictionary.
 self assert: turn state equals: #failed.
 self assert: failed gtInspectorTargetModels notEmpty.
 cancelled := self session.
 turn := cancelled prompt: 'Cancel after a tool'.
 cancelled mcpServer privateAddToolMessage: (self messageWithId: 'before-cancellation').
 self addCallWithId: 'before-cancellation' to: cancelled.
 cancelled cancelTurn.
 cancelled connection transport receive: {
  'jsonrpc' -> '2.0'. 'id' -> turn request id.
  'result' -> { 'stopReason' -> 'cancelled' } asDictionary } asDictionary.
 self assert: turn state equals: #cancelled.
 self assert: cancelled gtInspectorTargetModels notEmpty.
 ^ { failed. cancelled }
]

{ #category : #fixtures }
GtLACPSummarizerExamples >> finish: aTurn in: aSession [
 aSession connection transport receive: {
  'jsonrpc' -> '2.0'. 'id' -> aTurn request id.
  'result' -> { 'stopReason' -> 'end_turn' } asDictionary } asDictionary
]

{ #category : #examples }
GtLACPSummarizerExamples >> lateMessageRefresh [
 <gtExample>
 | session turn message |
 session := self session.
 turn := session prompt: 'Inspect Object'.
 self addCallWithId: 'late' to: session.
 self finish: turn in: session.
 self assert: session gtInspectorTargetModels isEmpty.
 message := self messageWithId: 'late'.
 session mcpServer privateAddToolMessage: message.
 session updateToolSummarizers.
 self assert: session mcpToolMessages first == message.
 self assert: session gtInspectorTargetModels notEmpty.
 ^ session
]

{ #category : #fixtures }
GtLACPSummarizerExamples >> messageWithId: anId [
 | call |
 call := GtLFunctionToolCall new
  id: anId;
  name: 'lookupClass';
  arguments: { 'className' -> 'Object' } asDictionary;
  performedByTool: GtLMagritteToolForClassLookup new;
  yourself.
 call updateExecutionDetailsAtStart.
 call updateExecutionDetailsAtTermination.
 ^ GtLToolMessage new toolCall: call; beFinishedExecutionState; yourself
]

{ #category : #examples }
GtLACPSummarizerExamples >> refreshPreservesChat [
 <gtExample>
 | session element scripter chat input turn |
 session := self sessionWithSummaries.
 element := (GtLACPChatTool forChat: session) asElementDo: [ :widget | widget ].
 scripter := BlScripter new extent: 1100 @ 800; model: session; element: element; yourself.
 chat := scripter element query // GtLACPChatElement; anyOne.
 input := scripter element query // #'acp-input'; anyOne.
 input text: 'Keep this draft'.
 turn := session prompt: 'Again'.
 session mcpServer privateAddToolMessage: (self messageWithId: 'next').
 self addCallWithId: 'next' to: session.
 self finish: turn in: session.
 scripter assertStep: [ :step | step id: #'acp-input'; value: [ :editor | editor text asString ] equals: [ 'Keep this draft' ] ].
 self assert: (scripter element query // GtLACPChatElement; anyOne) == chat.
 scripter clickStep: [ :step |
  step // BrTabGroup; // #tabbar;
   onChildFromBlock: [ :bar | bar children detect: [ :tab | tab label asString = 'Grouped tools' ] ] ].
 scripter assertStep: [ :step | step onPhlowCellWithString: 'lookupClass'; exists ].
 session updateToolSummarizers.
 scripter assertStep: [ :step | step onPhlowCellWithString: 'lookupClass'; exists ].
 GtLACPChatExamples new assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPSummarizerExamples >> replayedSummaries [
 <gtExample>
 | session |
 session := self session.
 session mcpServer privateAddToolMessage: (self messageWithId: 'replay-1');
  privateAddToolMessage: (self messageWithId: 'replay-2').
 session connection transport responder: [ :request :transport |
  (request at: 'method' ifAbsent: [ '' ]) = 'session/load' ifTrue: [
   #('replay-1' 'replay-2') do: [ :callId |
    session receiveUpdate: { 'sessionUpdate' -> 'user_message_chunk'.
     'content' -> { 'type' -> 'text'. 'text' -> callId } asDictionary } asDictionary.
    self addCallWithId: callId to: session ].
   transport replyTo: request result: Dictionary new ] ].
 session load: 'replayed-summary-session'.
 self assert: session turns size equals: 2.
 self assert: session mcpToolMessages size equals: 2.
 self assert: session gtInspectorTargetModels first relevantToolCalls size equals: 2.
 ^ session
]

{ #category : #examples }
GtLACPSummarizerExamples >> scopedAndUniqueMessages [
 <gtExample>
 | session first second other turn |
 session := self session.
 first := self messageWithId: 'first'.
 second := self messageWithId: 'second'.
 other := self messageWithId: 'another-session'.
 session mcpServer privateAddToolMessage: second; privateAddToolMessage: other; privateAddToolMessage: first.
 turn := session prompt: 'First'.
 self addCallWithId: 'first' to: session.
 self addCallWithId: 'unmatched' to: session.
 self finish: turn in: session.
 turn := session prompt: 'Second'.
 self addCallWithId: 'first' to: session.
 self addCallWithId: 'second' to: session.
 self finish: turn in: session.
 self assert: session mcpToolMessages asArray equals: { first. second }.
 self assert: (self session mcpToolMessagesIn: session mcpServer) isEmpty.
 ^ session
]

{ #category : #fixtures }
GtLACPSummarizerExamples >> session [
	<gtExample>
 | original session |
 original := GtLACPExamples new session.
 session := GtLACPFixtureSession new
  client: original client;
  connection: original connection;
  directory: original directory;
  remoteSessionId: original remoteSessionId;
  state: #ready;
  mcpServer: GtLMcpServer new;
  yourself.
 session connection sessions at: session remoteSessionId put: session.
 ^ session
]

{ #category : #examples }
GtLACPSummarizerExamples >> sessionWithSummaries [
 <gtExample>
 | session turn message |
 session := self session.
 turn := session prompt: 'Inspect Object'.
 message := self messageWithId: 'summary-call'.
 session mcpServer privateAddToolMessage: message.
 self addCallWithId: message toolCall id to: session.
 self assert: session summarizersRegistry relevantCurrentSummarizers isEmpty.
 self finish: turn in: session.
 self assert: session mcpToolMessages size equals: 1.
 self assert: session mcpToolMessages first == message.
 self assert: (session summarizersRegistry relevantCurrentSummarizers
  anySatisfy: [ :each | each class = GtLToolCallsByTypeSummarizer ]).
 ^ session
]

{ #category : #examples }
GtLACPSummarizerExamples >> summariesDisplayed [
 <gtExample>
 | session element scripter |
 session := self sessionWithSummaries.
 element := (GtLACPChatTool forChat: session) asElementDo: [ :widget | widget ].
 scripter := BlScripter new extent: 1100 @ 800; model: session; element: element; yourself.
 scripter assertStep: [ :step | step id: #'acp-input'; exists ].
 scripter clickStep: [ :step |
  step // BrTabGroup; // #tabbar;
   onChildFromBlock: [ :bar | bar children detect: [ :tab | tab label asString = 'Grouped tools' ] ] ].
 scripter assertStep: [ :step | step onPhlowCellWithString: 'lookupClass'; exists ].
 GtLACPChatExamples new assertNoRenderingErrorsIn: scripter.
 ^ scripter
]
