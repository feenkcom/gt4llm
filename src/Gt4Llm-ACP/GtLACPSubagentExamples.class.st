"
I exercise negotiated subagent sessions, nested conversation trees, directed messages, restricted controls and replay using only in-image ACP fixtures.
"
Class {
	#name : #GtLACPSubagentExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #examples }
GtLACPSubagentExamples >> agentReplyTabSurvivesRefresh [
 <gtExample>
 | scripter root child grandchild childTabs nestedTabs |
 scripter := self delegatedToolCallsInMainChat.
 root := scripter model.
 child := root childSessions first.
 grandchild := child childSessions first.
 childTabs := ('acp-agent-', child currentTurn identityHash asString, '-final-tabs') asSymbol.
 nestedTabs := ('acp-agent-', grandchild currentTurn identityHash asString, '-final-tabs') asSymbol.
 scripter clickStep: [ :step |
  step id: childTabs; // #tabbar;
   onChildFromBlock: [ :bar | bar children detect: [ :tab | tab label asString = 'Grouped tools' ] ] ].
 scripter doStep: [ :step |
  step label: 'Refresh the parent while a worker summary is selected';
   block: [ self update: { 'sessionUpdate' -> 'tool_call_update'.
    'toolCallId' -> 'main-call'. 'status' -> 'completed' } asDictionary for: root ] ].
 scripter pulseUntilReady.
 scripter assertStep: [ :step | step id: childTabs;
  satisfies: [ :tabs | tabs viewModel selectedTab tabLabel text asString = 'Grouped tools' ] ].
 { nestedTabs. #'acp-final-tabs' } do: [ :anId |
  scripter assertStep: [ :step | step id: anId;
   satisfies: [ :tabs | tabs viewModel selectedTab tabLabel text asString = 'Markdown' ] ] ].
 GtLACPChatExamples new assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPSubagentExamples >> agentReplyWithoutTools [
 <gtExample>
 | root child prefix scripter |
 root := GtLACPExamples new session.
 root prompt: 'Ask a worker for a greeting'.
 child := self announce: 'greeting-worker' title: 'Greeting worker' in: root.
 self reply: 'Hello from the worker.' in: child.
 self idle: child.
 prefix := 'acp-agent-', child currentTurn identityHash asString.
 self assert: child currentTurn toolCalls isEmpty.
 self assert: child currentTurn assistantMessage activityItems isEmpty.
 scripter := BlScripter new extent: 1100 @ 800; model: root; element: root asElement; yourself.
 scripter click id: #'acp-work-toggle'; play.
 scripter click id: (prefix, '-toggle') asSymbol; play.
 scripter assertStep: [ :step | step id: (prefix, '-header') asSymbol; exists ].
 scripter assertStep: [ :step | step id: (prefix, '-final-content') asSymbol;
  satisfies: [ :pane | (GtLACPChatExamples new editorsIn: pane)
   anySatisfy: [ :editor | editor text asString = 'Hello from the worker.' ] ] ].
 GtLACPChatExamples new assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #fixtures }
GtLACPSubagentExamples >> announce: anId title: aTitle in: aParent [
 self update: { 'sessionUpdate' -> 'subagent_update'. 'sessionId' -> anId.
  'title' -> aTitle. 'description' -> ('Task for ', aTitle).
  'state' -> { 'state' -> 'running' } asDictionary } asDictionary for: aParent.
 ^ aParent connection sessions at: anId
]

{ #category : #examples }
GtLACPSubagentExamples >> cancelChild [
 <gtExample>
 | root child sibling request |
 root := GtLACPExamples new session.
 child := self announce: 'cancel-child' title: 'Worker' in: root.
 sibling := self announce: 'other-child' title: 'Other worker' in: root.
 self update: { 'sessionUpdate' -> 'subagent_update'. 'sessionId' -> child remoteSessionId.
  'capabilities' -> { 'cancel' -> Dictionary new } asDictionary } asDictionary for: root.
 root connection transport receive: {
  'jsonrpc' -> '2.0'. 'id' -> 'child-permission'. 'method' -> 'session/request_permission'.
  'params' -> { 'sessionId' -> child remoteSessionId.
   'toolCall' -> { 'toolCallId' -> 'child-tool'. 'title' -> 'Inspect'. 'status' -> 'pending' } asDictionary.
   'options' -> { { 'optionId' -> 'allow'. 'name' -> 'Allow'. 'kind' -> 'allow_once' } asDictionary } } asDictionary } asDictionary.
 request := child currentTurn permissionRequests first.
 self assert: request state equals: #pending.
 self assert: child canCancel.
 child cancelTurn.
 self assert: request state equals: #cancelled.
 self assert: ((root connection transport sentMessages last at: 'params') at: 'sessionId') equals: child remoteSessionId.
 self assert: sibling currentTurn state equals: #running.
 self update: { 'sessionUpdate' -> 'subagent_update'. 'sessionId' -> child remoteSessionId.
  'state' -> { 'state' -> 'idle'. 'stopReason' -> 'cancelled' } asDictionary } asDictionary for: root.
 self assert: child currentTurn state equals: #cancelled.
 self assert: child conversationState equals: #idle.
 ^ root
]

{ #category : #examples }
GtLACPSubagentExamples >> childCancelControlDisplayed [
 <gtExample>
 | root child scripter |
 root := GtLACPExamples new session.
 child := self announce: 'controllable-child' title: 'Worker' in: root.
 self update: { 'sessionUpdate' -> 'subagent_update'. 'sessionId' -> child remoteSessionId.
  'capabilities' -> { 'cancel' -> Dictionary new } asDictionary } asDictionary for: root.
 scripter := BlScripter new extent: 1000 @ 700; model: child; element: child asElement; yourself.
 scripter assertStep: [ :step | step id: #'acp-composer'; satisfies: [ :pane | pane visibility = BlVisibility visible ] ].
 scripter assertStep: [ :step | step id: #'acp-input'; satisfies: [ :editor | editor visibility = BlVisibility gone ] ].
 scripter assertStep: [ :step | step id: #'acp-action'; satisfies: [ :button | button label asString = 'Stop' ] ].
 GtLACPChatExamples new assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPSubagentExamples >> childChatDisplayed [
 <gtExample>
 | root child scripter |
 root := self nestedConversations.
 child := root childSessions first.
 scripter := BlScripter new extent: 1000 @ 700; model: child; element: child asElement; yourself.
 scripter assertStep: [ :step | step id: #'acp-final-content';
  satisfies: [ :pane | (GtLACPChatExamples new editorsIn: pane)
   anySatisfy: [ :editor | editor text asString = 'The changes look consistent.' ] ] ].
 self assert: child asChatViewModel messageViewModels first label equals: 'From Codex'.
 scripter assertStep: [ :step | step id: #'acp-action'; satisfies: [ :button | button visibility = BlVisibility gone ] ].
 GtLACPChatExamples new assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPSubagentExamples >> childToolCallsDisplayed [
 <gtExample>
 | root child turn scripter |
 root := GtLACPExamples new session.
 turn := root prompt: 'Delegate the lookup'.
 child := self announce: 'tool-worker' title: 'Lookup worker' in: root.
 self task: 'Find the class' from: root to: child id: 'lookup-task'.
 scripter := BlScripter new extent: 1000 @ 700; model: child; element: child asElement; yourself.
 self update: {
  'sessionUpdate' -> 'tool_call'. 'toolCallId' -> 'parent-call'.
  'title' -> 'Parent lookup'. 'status' -> 'completed'
 } asDictionary for: root.
 scripter doStep: [ :step |
  step label: 'Receive a tool call addressed to the child session';
   block: [ self update: {
    'sessionUpdate' -> 'tool_call'. 'toolCallId' -> 'child-call'.
    'title' -> 'Child lookup'. 'status' -> 'in_progress'
   } asDictionary for: child ] ].
 scripter pulseUntilReady.
 scripter click id: #'acp-work-toggle'; play.
 scripter assertStep: [ :step |
  step id: #'acp-tool-summary-child-call';
   satisfies: [ :label | label text asString includesSubstring: 'Child lookup' ] ].
 scripter doStep: [ :step |
  step label: 'Finish the child tool call and reply';
   block: [
    self update: {
     'sessionUpdate' -> 'tool_call_update'. 'toolCallId' -> 'child-call'. 'status' -> 'completed'
    } asDictionary for: child.
    self reply: 'The class was found.' in: child.
    self idle: child ] ].
 scripter pulseUntilReady.
 scripter assertStep: [ :step |
  step id: #'acp-tool-summary-child-call';
   satisfies: [ :label | label text asString includesSubstring: 'Child lookup' ] ].
 scripter assertStep: [ :step |
  step id: #'acp-final-text';
   value: [ :editor | editor text asString ] equals: [ 'The class was found.' ] ].
 self assert: child currentTurn toolCalls size equals: 1.
 self assert: turn toolCalls size equals: 1.
 self assert: turn toolCalls first id equals: 'parent-call'.
 self assert: (turn assistantMessage activityItems includes: turn toolCalls first).
 GtLACPChatExamples new assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPSubagentExamples >> childUsesScopedMcpSummaries [
 <gtExample>
 | examples root child message |
 examples := GtLACPSummarizerExamples new.
 root := examples session.
 child := self announce: 'summarized-child' title: 'Worker' in: root.
 message := examples messageWithId: 'child-mcp-call'.
 root mcpServer privateAddToolMessage: message.
 self update: { 'sessionUpdate' -> 'tool_call'. 'toolCallId' -> message toolCall id.
  'title' -> 'Lookup'. 'status' -> 'completed' } asDictionary for: child.
 self reply: 'The class was found.' in: child.
 self idle: child.
 self assert: child objectStorage == root mcpServer objectStorage.
 self assert: child mcpToolMessages first == message.
 self assert: child summarizersRegistry relevantCurrentSummarizers notEmpty.
 self assert: child currentTurn assistantMessage relevantToolCallsSummarizers first relevantToolCalls first == message toolCall.
 self assert: root mcpToolMessages first == message.
 self assert: root summarizersRegistry relevantCurrentSummarizers notEmpty.
 ^ child
]

{ #category : #examples }
GtLACPSubagentExamples >> clearingChildStateAndCapabilities [
 <gtExample>
 | root child |
 root := GtLACPExamples new session.
 child := self announce: 'cleared-child' title: 'Worker' in: root.
 self update: { 'sessionUpdate' -> 'subagent_update'. 'sessionId' -> child remoteSessionId.
  'capabilities' -> { 'cancel' -> Dictionary new } asDictionary } asDictionary for: root.
 self assert: child canCancel.
 self update: { 'sessionUpdate' -> 'subagent_update'. 'sessionId' -> child remoteSessionId.
  'state' -> nil. 'capabilities' -> nil } asDictionary for: root.
 self assert: child canCancel not.
 self assert: child conversationState equals: #unconfirmed.
 self assert: child currentTurn stopReason isNil.
 ^ child
]

{ #category : #examples }
GtLACPSubagentExamples >> closingRootDetachesChildren [
 <gtExample>
 | root child |
 root := self nestedConversations.
 child := root childSessions first.
 root close.
 self assert: root connection sessions isEmpty.
 self assert: root connection state equals: #stopped.
 self assert: child state equals: #closed.
 self assert: child childSessions first state equals: #closed.
 self assert: root childSessions size equals: 2.
 ^ root
]

{ #category : #examples }
GtLACPSubagentExamples >> conversationTreeAfterPromptResponse: response [
 | root turn element scripter |
 root := GtLACPExamples new session.
 element := (root gtConversationTreeFor: GtPhlowView empty)
  asElementDo: [ :widget | widget background: Color white; yourself ].
 scripter := BlScripter new extent: 1100 @ 700; model: root; element: element; yourself.
 scripter assertStep: [ :step |
  step label: 'The conversation initially displays ready';
   onPhlowCellWithString: 'ready'; exists ].
 scripter doStep: [ :step |
  step label: 'Start a prompt while the conversation tree is open';
   block: [ turn := root prompt: 'Hello' ] ].
 scripter pulseUntilReady.
 scripter assertStep: [ :step |
  step label: 'The conversation displays prompting';
   onPhlowCellWithString: 'prompting'; exists ].
 scripter doStep: [ :step |
  step label: 'Stream an assistant reply';
   block: [ self update: {
    'sessionUpdate' -> 'agent_message_chunk'.
    'content' -> { 'type' -> 'text'. 'text' -> 'Hello world' } asDictionary
   } asDictionary for: root ] ].
 self assert: turn messages last text equals: 'Hello world'.
 scripter doStep: [ :step |
  step label: 'Receive the final prompt response';
   block: [
    root connection transport receive: ({ 'jsonrpc' -> '2.0'. 'id' -> turn request id } asDictionary
     addAll: response; yourself) ] ].
 scripter pulseUntilReady.
 self assert: root state equals: #ready.
 scripter assertStep: [ :step |
  step label: 'The conversation returns to ready without a manual refresh';
   onPhlowCellWithString: 'ready'; exists ].
 GtLACPChatExamples new assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPSubagentExamples >> conversationTreeContentsDisplayed [
 <gtExample>
 | root element scripter |
 root := self conversationTreeWithMessagesAndTools.
 element := (root gtConversationTreeFor: GtPhlowView empty)
  asElementDo: [ :widget | widget background: Color white; yourself ].
 scripter := BlScripter new extent: 1400 @ 900; model: root; element: element; yourself.
 #('Tree worker' 'Inspect project' 'Inspect class' 'Checking the class protocol'
  'Class inspection complete' 'Project inspection complete' 'Agent' 'Tool' 'Reasoning') do: [ :text |
  scripter assertStep: [ :step | step onPhlowCellWithString: text; exists ] ].
 GtLACPChatExamples new assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPSubagentExamples >> conversationTreeDisplayed [
 <gtExample>
 | root element scripter |
 root := self nestedConversations.
 element := (root gtConversationTreeFor: GtPhlowView empty)
  asElementDo: [ :widget | widget background: Color white; yourself ].
 scripter := BlScripter new extent: 1100 @ 700; model: root; element: element; yourself.
 #('Codex' 'Code reviewer' 'Test investigator' 'API researcher') do: [ :title |
  scripter assertStep: [ :step | step onPhlowCellWithString: title; exists ] ].
 GtLACPChatExamples new assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPSubagentExamples >> conversationTreeUpdates [
 <gtExample>
 | root element scripter |
 root := GtLACPExamples new session.
 element := (root gtConversationTreeFor: GtPhlowView empty)
  asElementDo: [ :widget | widget background: Color white; yourself ].
 scripter := BlScripter new extent: 1100 @ 700; model: root; element: element; yourself.
 scripter doStep: [ :step | step block: [ self announce: 'live-child' title: 'New worker' in: root ] ].
 scripter pulseUntilReady.
 scripter assertStep: [ :step | step onPhlowCellWithString: 'New worker'; exists ].
 GtLACPChatExamples new assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPSubagentExamples >> conversationTreeUpdatesAfterFinalReply [
 <gtExample>
 ^ self conversationTreeAfterPromptResponse: {
  'result' -> { 'stopReason' -> 'end_turn' } asDictionary } asDictionary
]

{ #category : #examples }
GtLACPSubagentExamples >> conversationTreeUpdatesAfterPromptFailure [
 <gtExample>
 ^ self conversationTreeAfterPromptResponse: {
  'error' -> { 'code' -> -32603. 'message' -> 'Example failure' } asDictionary } asDictionary
]

{ #category : #examples }
GtLACPSubagentExamples >> conversationTreeUpdatesForMessagesAndTools [
 <gtExample>
 | root child element scripter |
 root := GtLACPExamples new session.
 child := self announce: 'live-tree-worker' title: 'Live tree worker' in: root.
 self assert: child currentTurn parentTurn isNil.
 element := (root gtConversationTreeFor: GtPhlowView empty)
  asElementDo: [ :widget | widget background: Color white; yourself ].
 scripter := BlScripter new extent: 1400 @ 900; model: root; element: element; yourself.
 scripter doStep: [ :step | step block: [
  self update: { 'sessionUpdate' -> 'tool_call'. 'toolCallId' -> 'live-tree-tool'.
   'title' -> 'Read live class'. 'status' -> 'in_progress' } asDictionary for: child.
  GtLACPMessagePresentationExamples new text: 'Inspecting' id: 'live-tree-progress' in: child ] ].
 scripter pulseUntilReady.
 #('Read live class' 'Inspecting' 'in_progress') do: [ :text |
  scripter assertStep: [ :step | step onPhlowCellWithString: text; exists ] ].
 scripter doStep: [ :step | step block: [
  self update: { 'sessionUpdate' -> 'tool_call_update'. 'toolCallId' -> 'live-tree-tool'.
   'status' -> 'completed' } asDictionary for: child.
  GtLACPMessagePresentationExamples new text: ' the protocol' id: 'live-tree-progress' in: child.
  GtLACPMessagePresentationExamples new text: 'Live class checked' id: 'live-tree-answer' in: child.
  self idle: child ] ].
 scripter pulseUntilReady.
 #('Inspecting the protocol' 'Live class checked' 'completed' 'final') do: [ :text |
  scripter assertStep: [ :step | step onPhlowCellWithString: text; exists ] ].
 GtLACPChatExamples new assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPSubagentExamples >> conversationTreeWithMessagesAndTools [
 <gtExample>
 | root child turn cache rootNode childNode objects |
 root := GtLACPExamples new session.
 turn := root prompt: 'Inspect the project'.
 child := self announce: 'tree-worker' title: 'Tree worker' in: root.
 self task: 'Inspect the class' from: root to: child id: 'tree-assignment'.
 self update: { 'sessionUpdate' -> 'tool_call'. 'toolCallId' -> 'tree-parent-tool'.
  'title' -> 'Inspect project'. 'status' -> 'completed' } asDictionary for: root.
 self update: { 'sessionUpdate' -> 'tool_call'. 'toolCallId' -> 'tree-child-tool'.
  'title' -> 'Inspect class'. 'status' -> 'completed' } asDictionary for: child.
 self update: { 'sessionUpdate' -> 'agent_thought_chunk'. 'messageId' -> 'tree-reasoning'.
  'content' -> { 'type' -> 'text'. 'text' -> 'Checking the class protocol' } asDictionary
 } asDictionary for: child.
 GtLACPMessagePresentationExamples new text: 'Class inspection complete' id: 'tree-child-answer' in: child.
 self idle: child.
 GtLACPMessagePresentationExamples new text: 'Project inspection complete' id: 'tree-parent-answer' in: root.
 root connection transport receive: { 'jsonrpc' -> '2.0'. 'id' -> turn request id.
  'result' -> { 'stopReason' -> 'end_turn' } asDictionary } asDictionary.
 cache := IdentityDictionary new.
 rootNode := root asConversationTreeNode.
 objects := (rootNode childrenIn: cache) collect: #object.
 self assert: objects size equals: root childSessions size + turn messages size + turn toolCalls size.
 self assert: (objects includes: turn messages first).
 self assert: (objects includes: turn toolCalls first).
 self assert: (objects includes: turn finalMessage).
 childNode := (rootNode childrenIn: cache) detect: [ :node | node object == child ].
 objects := (childNode childrenIn: cache) collect: #object.
 self assert: (objects includes: child currentTurn toolCalls first).
 self assert: (objects includes: child currentTurn finalMessage).
 self assert: ((childNode childrenIn: cache) detect: [ :node | node object == child currentTurn finalMessage ]) state equals: #final.
 self assert: (rootNode childrenIn: cache) first == childNode.
 ^ root
]

{ #category : #examples }
GtLACPSubagentExamples >> delegatedToolCallsAreScopedToTurns [
 <gtExample>
 | root first second child firstChildTurn |
 root := GtLACPSummarizerExamples new session.
 first := root prompt: 'First assignment'.
 child := self announce: 'reusable-worker' title: 'Worker' in: root.
 self mcpToolCallWithId: 'first-worker-call' in: child.
 firstChildTurn := child currentTurn.
 self idle: child.
 self reply: 'First result' in: root.
 root connection transport receive: { 'jsonrpc' -> '2.0'. 'id' -> first request id.
  'result' -> { 'stopReason' -> 'end_turn' } asDictionary } asDictionary.
 second := root prompt: 'Second assignment'.
 self update: { 'sessionUpdate' -> 'subagent_update'. 'sessionId' -> child remoteSessionId.
  'state' -> { 'state' -> 'running' } asDictionary } asDictionary for: root.
 self mcpToolCallWithId: 'second-worker-call' in: child.
 self idle: child.
 self assert: firstChildTurn parentTurn == first.
 self assert: child currentTurn parentTurn == second.
 self assert: first delegatedTurns asArray equals: { firstChildTurn }.
 self assert: first assistantMessage toolCalls size equals: 1.
 self assert: first assistantMessage toolCalls first id equals: 'first-worker-call'.
 self assert: second assistantMessage toolCalls size equals: 1.
 self assert: second assistantMessage toolCalls first id equals: 'second-worker-call'.
 self assert: first assistantMessage mcpToolMessages size equals: 1.
 self assert: second assistantMessage mcpToolMessages size equals: 1.
 self assert: root mcpToolMessages size equals: 2.
 self assert: first assistantMessage text equals: 'First result'.
 ^ root
]

{ #category : #examples }
GtLACPSubagentExamples >> delegatedToolCallsInMainChat [
 <gtExample>
 | root turn child grandchild scripter |
 root := GtLACPSummarizerExamples new session.
 turn := root prompt: 'Delegate the lookup'.
 scripter := BlScripter new extent: 1100 @ 900; model: root; element: root asElement; yourself.
 scripter doStep: [ :step |
  step label: 'Receive parent and nested worker tool calls';
   block: [
    self mcpToolCallWithId: 'main-call' in: root.
    child := self announce: 'main-worker' title: 'Lookup worker' in: root.
    self mcpToolCallWithId: 'worker-call' in: child.
    grandchild := self announce: 'nested-worker' title: 'Nested worker' in: child.
    self mcpToolCallWithId: 'nested-call' in: grandchild ] ].
 scripter pulseUntilReady.
 self assert: turn assistantMessage toolCalls size equals: 3.
 scripter assertStep: [ :step |
  step id: #'acp-work-summary';
   satisfies: [ :label | label text asString includesSubstring: '+ 2 other tools' ] ].
 scripter click id: #'acp-work-toggle'; play.
 scripter assertStep: [ :step | step id: #'acp-tool-summary-worker-call'; notExists ].
 scripter assertStep: [ :step |
  step id: ('acp-agent-', child currentTurn identityHash asString, '-kind') asSymbol;
   value: [ :label | label text asString ] equals: [ 'agent' ] ].
 scripter click id: ('acp-agent-', child currentTurn identityHash asString, '-header') asSymbol; play.
 scripter assertStep: [ :step | step id: #'acp-tool-summary-nested-call'; notExists ].
 scripter click id: ('acp-agent-', grandchild currentTurn identityHash asString, '-toggle') asSymbol; play.
 #('main-call' 'worker-call' 'nested-call') do: [ :anId |
  scripter assertStep: [ :step | step id: ('acp-tool-summary-', anId) asSymbol; exists ] ].
 scripter doStep: [ :step |
  step label: 'Complete the workers and parent reply';
   block: [
    self reply: 'Nested result' in: grandchild. self idle: grandchild.
    self reply: 'Worker result' in: child. self idle: child.
    self reply: 'Combined result' in: root.
    root connection transport receive: { 'jsonrpc' -> '2.0'. 'id' -> turn request id.
     'result' -> { 'stopReason' -> 'end_turn' } asDictionary } asDictionary ] ].
 scripter pulseUntilReady.
 #('main-call' 'worker-call' 'nested-call') do: [ :anId |
  scripter assertStep: [ :step | step id: ('acp-tool-summary-', anId) asSymbol; exists ] ].
 scripter assertStep: [ :step | step id: #'acp-final-content';
  satisfies: [ :pane | (GtLACPChatExamples new editorsIn: pane)
   anySatisfy: [ :editor | editor text asString = 'Combined result' ] ] ].
 { child -> 'Worker result'. grandchild -> 'Nested result' } do: [ :pair |
  scripter assertStep: [ :step |
   step id: ('acp-agent-', pair key currentTurn identityHash asString, '-final-content') asSymbol;
    satisfies: [ :pane | (GtLACPChatExamples new editorsIn: pane)
     anySatisfy: [ :editor | editor text asString = pair value ] ] ] ].
 self assert: root mcpToolMessages size equals: 3.
 self assert: turn assistantMessage mcpToolMessages size equals: 3.
 self assert: child currentTurn assistantMessage mcpToolMessages size equals: 2.
 self assert: grandchild currentTurn assistantMessage mcpToolMessages size equals: 1.
 self assert: (root summarizersRegistry relevantCurrentSummarizers first relevantToolCalls size) equals: 3.
 self assert: (turn assistantMessage relevantToolCallsSummarizers first relevantToolCalls size) equals: 3.
 GtLACPChatExamples new assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPSubagentExamples >> delegatedToolCallsPreserveExpansion [
 <gtExample>
 | scripter root child grandchild childPrefix nestedPrefix |
 scripter := self delegatedToolCallsInMainChat.
 root := scripter model.
 child := root childSessions first.
 grandchild := child childSessions first.
 childPrefix := 'acp-agent-', child currentTurn identityHash asString.
 nestedPrefix := 'acp-agent-', grandchild currentTurn identityHash asString.
 scripter click id: (childPrefix, '-header') asSymbol; play.
 scripter assertStep: [ :step | step id: #'acp-tool-summary-worker-call'; notExists ].
 scripter assertStep: [ :step | step id: #'acp-tool-summary-nested-call'; notExists ].
 scripter click id: (childPrefix, '-toggle') asSymbol; play.
 scripter assertStep: [ :step | step id: #'acp-tool-summary-worker-call'; exists ].
 scripter assertStep: [ :step | step id: #'acp-tool-summary-nested-call'; exists ].
 scripter click id: (nestedPrefix, '-header') asSymbol; play.
 scripter doStep: [ :step |
  step label: 'Refresh the parent message after a tool update';
   block: [ self update: { 'sessionUpdate' -> 'tool_call_update'.
    'toolCallId' -> 'main-call'. 'status' -> 'completed' } asDictionary for: root ] ].
 scripter pulseUntilReady.
 scripter assertStep: [ :step | step id: (childPrefix, '-section') asSymbol; satisfies: #isExpanded ].
 scripter assertStep: [ :step | step id: (nestedPrefix, '-section') asSymbol;
  satisfies: [ :section | section isExpanded not ] ].
 scripter assertStep: [ :step | step id: #'acp-tool-summary-worker-call'; exists ].
 scripter assertStep: [ :step | step id: #'acp-tool-summary-nested-call'; notExists ].
 GtLACPChatExamples new assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPSubagentExamples >> directedMessagePatches [
 <gtExample>
 | root child message |
 root := GtLACPExamples new session.
 child := self announce: 'message-child' title: 'Worker' in: root.
 #('Check ' 'tests') do: [ :text |
  self update: { 'sessionUpdate' -> 'session_message_chunk'. 'messageId' -> 'assignment'.
   'content' -> { 'type' -> 'text'. 'text' -> text } asDictionary } asDictionary for: child ].
 message := child interSessionMessages first.
 self assert: message text equals: 'Check tests'.
 self update: { 'sessionUpdate' -> 'session_message'. 'messageId' -> 'assignment'.
  'senderSessionId' -> root remoteSessionId. 'recipientSessionId' -> child remoteSessionId } asDictionary for: child.
 self assert: message chatLabel equals: 'From Codex'.
 self assert: message text equals: 'Check tests'.
 self update: { 'sessionUpdate' -> 'session_message'. 'messageId' -> 'assignment'.
  'content' -> { { 'type' -> 'text'. 'text' -> 'Replace the assignment' } asDictionary } } asDictionary for: child.
 self assert: message text equals: 'Replace the assignment'.
 self update: { 'sessionUpdate' -> 'session_message'. 'messageId' -> 'assignment'. 'content' -> nil } asDictionary for: child.
 self assert: message text isEmpty.
 self assert: child interSessionMessages size equals: 1.
 self assert: child currentTurn inputMessages first == message.
 ^ message
]

{ #category : #examples }
GtLACPSubagentExamples >> disconnectedChildren [
 <gtExample>
 | root child |
 root := GtLACPExamples new session.
 child := self announce: 'lost-child' title: 'Worker' in: root.
 self reply: 'Partial output' in: child.
 root connection failed: 'Fixture disconnect'.
 self assert: child conversationState equals: #disconnected.
 self assert: child currentTurn state equals: #disconnected.
 self assert: child currentTurn stopReason isNil.
 self assert: child currentTurn assistantMessage finalMessages isEmpty.
 self assert: child currentTurn assistantMessage activityItems last text equals: 'Partial output'.
 self assert: child canCancel not.
 ^ root
]

{ #category : #fixtures }
GtLACPSubagentExamples >> idle: aChild [
 self update: { 'sessionUpdate' -> 'subagent_update'. 'sessionId' -> aChild remoteSessionId.
  'state' -> { 'state' -> 'idle'. 'stopReason' -> 'end_turn' } asDictionary } asDictionary
  for: aChild parentSubagent parentSession
]

{ #category : #examples }
GtLACPSubagentExamples >> lateParentMessagePreservesReply [
 <gtExample>
 | root child first |
 root := self nestedConversations.
 child := root childSessions first.
 first := root turns first assistantMessage text.
 self update: { 'sessionUpdate' -> 'session_message'. 'messageId' -> 'late-child-report'.
  'senderSessionId' -> child remoteSessionId. 'recipientSessionId' -> root remoteSessionId.
  'content' -> { { 'type' -> 'text'. 'text' -> 'A late finding' } asDictionary } } asDictionary for: root.
 self assert: root turns size equals: 2.
 self assert: root turns first assistantMessage text equals: first.
 self assert: root currentTurn inputMessages isEmpty.
 self assert: root currentTurn childCoordinationMessages first text equals: 'A late finding'.
 self assert: root asChatViewModel messageViewModels size equals: 2.
 ^ root
]

{ #category : #examples }
GtLACPSubagentExamples >> legacySubagentUpdates [
 <gtExample>
 | root child |
 root := GtLACPExamples new session.
 self update: { 'sessionUpdate' -> 'subagent_spawned'. 'subagentSessionId' -> 'legacy-child'.
  'name' -> 'Legacy worker'. 'task' -> 'Recorded task' } asDictionary for: root.
 child := root childSessions first.
 self reply: 'Legacy output' in: child.
 self update: { 'sessionUpdate' -> 'subagent_state_update'. 'subagentSessionId' -> child remoteSessionId.
  'state' -> 'completed' } asDictionary for: root.
 self assert: child conversationState equals: #idle.
 self assert: child currentTurn state equals: #completed.
 self assert: child conversationTitle equals: 'Legacy worker'.
 ^ root
]

{ #category : #examples }
GtLACPSubagentExamples >> mcpToolCallWithId: anId in: aSession [
 | message |
 message := GtLACPSummarizerExamples new messageWithId: anId.
 aSession rootSession mcpServer privateAddToolMessage: message.
 self update: { 'sessionUpdate' -> 'tool_call'. 'toolCallId' -> anId.
  'title' -> 'Lookup'. 'status' -> 'completed' } asDictionary for: aSession.
 ^ message
]

{ #category : #examples }
GtLACPSubagentExamples >> metadataPatches [
 <gtExample>
 | root child association |
 root := GtLACPExamples new session.
 child := self announce: 'patch-child' title: 'Initial title' in: root.
 association := child parentSubagent.
 self update: { 'sessionUpdate' -> 'subagent_update'. 'sessionId' -> child remoteSessionId.
  'cwd' -> FileLocator home fullName. 'title' -> 'Renamed worker' } asDictionary for: root.
 self assert: child directory equals: FileLocator home asFileReference asAbsolute.
 self update: { 'sessionUpdate' -> 'subagent_update'. 'sessionId' -> child remoteSessionId.
  'description' -> nil. 'cwd' -> nil } asDictionary for: root.
 self assert: association title equals: 'Renamed worker'.
 self assert: association description isEmpty.
 self assert: child directory equals: root directory.
 self assert: root subagents size equals: 1.
 self assert: child parentSubagent == association.
 ^ child
]

{ #category : #examples }
GtLACPSubagentExamples >> negotiatedSubagents [
 <gtExample>
 | root initialize |
 root := GtLACPExamples new session.
 initialize := root connection transcript messages first data.
 self assert: (((initialize at: 'params') at: 'clientCapabilities') at: 'subagents') isEmpty.
 ^ root connection
]

{ #category : #examples }
GtLACPSubagentExamples >> nestedConversations [
 <gtExample>
 | root reviewer tester researcher turn |
 root := GtLACPExamples new session.
 turn := root prompt: 'Review the implementation and test it'.
 reviewer := self announce: 'reviewer' title: 'Code reviewer' in: root.
 tester := self announce: 'tester' title: 'Test investigator' in: root.
 researcher := self announce: 'researcher' title: 'API researcher' in: reviewer.
 self task: 'Review the changes' from: root to: reviewer id: 'review-task'.
 self task: 'Investigate the API' from: reviewer to: researcher id: 'research-task'.
 self task: 'Run the tests' from: root to: tester id: 'test-task'.
 self reply: 'The API is compatible.' in: researcher.
 self idle: researcher.
 self reply: 'The changes look consistent.' in: reviewer.
 self idle: reviewer.
 self reply: 'All tests pass.' in: tester.
 self idle: tester.
 self reply: 'Review and tests are complete.' in: root.
 root connection transport receive: { 'jsonrpc' -> '2.0'. 'id' -> turn request id.
  'result' -> { 'stopReason' -> 'end_turn' } asDictionary } asDictionary.
 self assert: root childSessions size equals: 2.
 self assert: reviewer childSessions first == researcher.
 self assert: researcher rootSession == root.
 self assert: root connection sessions size equals: 4.
 self assert: researcher connection == root connection.
 self assert: reviewer currentTurn assistantMessage text equals: 'The changes look consistent.'.
 self assert: researcher currentTurn assistantMessage text equals: 'The API is compatible.'.
 self assert: reviewer interSessionMessages first counterpartMessage == root interSessionMessages first.
 self assert: (root connection transcript messages count: [ :message | message operation = 'session/new' ]) equals: 1.
 ^ root
]

{ #category : #examples }
GtLACPSubagentExamples >> reasoningStatusInHeaders [
 <gtExample>
 | root child prefix scripter |
 root := GtLACPExamples new session.
 root prompt: 'Compare the results'.
 child := self announce: 'reasoning-worker' title: 'Reasoning worker' in: root.
 prefix := 'acp-agent-', child currentTurn identityHash asString.
 self update: { 'sessionUpdate' -> 'agent_thought_chunk'.
  'content' -> { 'type' -> 'text'. 'text' -> 'I will compare the results.' } asDictionary
 } asDictionary for: root.
 self update: { 'sessionUpdate' -> 'agent_thought_chunk'.
  'content' -> { 'type' -> 'text'. 'text' -> 'I will inspect the class.' } asDictionary
 } asDictionary for: child.
 scripter := BlScripter new extent: 1100 @ 700; model: root; element: root asElement; yourself.
 scripter assertStep: [ :step | step id: #'acp-work-indicator';
  value: [ :label | label text asString ] equals: [ 'Working…' ] ].
 scripter click id: #'acp-work-toggle'; play.
 scripter assertStep: [ :step | step id: (prefix, '-work-indicator') asSymbol;
  satisfies: [ :label | label text asString = 'Working…'
   and: [ label parent id asSymbol = (prefix, '-header') asSymbol ] ] ].
 scripter click id: (prefix, '-toggle') asSymbol; play.
 scripter assertStep: [ :step | step id: #'acp-work-content';
  satisfies: [ :pane | | labels editors |
   labels := OrderedCollection new.
   pane withAllChildrenBreadthFirstDo: [ :each |
    (each isKindOf: BrLabel) ifTrue: [ labels add: each text asString ] ].
   editors := GtLACPChatExamples new editorsIn: pane.
   (labels includes: 'Thinking') not and: [
    (editors anySatisfy: [ :each | each text asString = 'I will compare the results.' ]) and: [
     editors anySatisfy: [ :each | each text asString = 'I will inspect the class.' ] ] ] ] ].
 scripter doStep: [ :step | step block: [ self idle: child ] ].
 scripter pulseUntilReady.
 scripter assertStep: [ :step | step id: (prefix, '-work-indicator') asSymbol; notExists ].
 scripter assertStep: [ :step | step id: #'acp-work-indicator'; exists ].
 GtLACPChatExamples new assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPSubagentExamples >> rejectCyclesAndReparenting [
 <gtExample>
 | root child sibling before |
 root := GtLACPExamples new session.
 child := self announce: 'cycle-child' title: 'Child' in: root.
 sibling := self announce: 'cycle-sibling' title: 'Sibling' in: root.
 before := root connection sessions size.
 self assert: ([ self announce: root remoteSessionId title: 'Cycle' in: child. false ] on: Error do: [ :error | true ]).
 self assert: ([ self announce: child remoteSessionId title: 'Moved' in: sibling. false ] on: Error do: [ :error | true ]).
 self assert: ([ self announce: child remoteSessionId title: 'Self' in: child. false ] on: Error do: [ :error | true ]).
 self assert: root connection sessions size equals: before.
 self assert: child parentSubagent parentSession == root.
 ^ root
]

{ #category : #examples }
GtLACPSubagentExamples >> replayClearsLiveControls [
 <gtExample>
 | root child association |
 root := GtLACPExamples new session.
 child := self announce: 'freshness-child' title: 'Worker' in: root.
 self update: { 'sessionUpdate' -> 'subagent_update'. 'sessionId' -> child remoteSessionId.
  'capabilities' -> { 'cancel' -> Dictionary new } asDictionary } asDictionary for: root.
 association := child parentSubagent.
 self assert: child canCancel.
 root connection transport responder: [ :request :transport |
  (request at: 'method' ifAbsent: [ '' ]) = 'session/load' ifTrue: [
   self update: { 'sessionUpdate' -> 'subagent_update'. 'sessionId' -> child remoteSessionId.
    'state' -> { 'state' -> 'running' } asDictionary.
    'capabilities' -> { 'cancel' -> Dictionary new } asDictionary } asDictionary for: root.
   transport replyTo: request result: Dictionary new ] ].
 root load: root remoteSessionId.
 self assert: child parentSubagent == association.
 self assert: child canCancel not.
 self assert: child conversationState equals: #unconfirmed.
 ^ root
]

{ #category : #examples }
GtLACPSubagentExamples >> replayedChildren [
 <gtExample>
 | root child |
 root := GtLACPExamples new session.
 root connection transport responder: [ :request :transport |
  (request at: 'method' ifAbsent: [ '' ]) = 'session/load' ifTrue: [
   child := self announce: 'replayed-child' title: 'Historical worker' in: root.
   self update: { 'sessionUpdate' -> 'subagent_update'. 'sessionId' -> child remoteSessionId.
    'capabilities' -> { 'cancel' -> Dictionary new } asDictionary } asDictionary for: root.
   self task: 'A recorded assignment' from: root to: child id: 'recorded-message'.
   self reply: 'A recorded reply' in: child.
   transport replyTo: request result: Dictionary new ] ].
 root load: root remoteSessionId.
 self assert: child conversationState equals: #unconfirmed.
 self assert: child canCancel not.
 self assert: child currentTurn state equals: #replayed.
 self assert: child currentTurn assistantMessage text equals: 'A recorded reply'.
 self update: { 'sessionUpdate' -> 'subagent_update'. 'sessionId' -> child remoteSessionId.
  'state' -> { 'state' -> 'idle' } asDictionary } asDictionary for: root.
 self assert: child conversationState equals: #idle.
 ^ root
]

{ #category : #fixtures }
GtLACPSubagentExamples >> reply: aString in: aSession [
 self update: { 'sessionUpdate' -> 'agent_message_chunk'.
  'content' -> { 'type' -> 'text'. 'text' -> aString } asDictionary } asDictionary for: aSession
]

{ #category : #examples }
GtLACPSubagentExamples >> restrictedChildren [
 <gtExample>
 | root child before model |
 root := GtLACPExamples new session.
 child := self announce: 'restricted-child' title: 'Worker' in: root.
 before := root connection transport sentMessages size.
 { [ child prompt: 'Do this' ]. [ child load: child remoteSessionId ].
   [ child setMode: 'code' ]. [ child setConfigOption: 'model' value: 'another' ]. [ child close ] }
  do: [ :operation | self assert: ([ operation value. false ] on: Error do: [ :error | true ]) ].
 self assert: root connection transport sentMessages size equals: before.
 self assert: child canCancel not.
 model := child asChatViewModel.
 model draft: 'A human prompt'.
 self assert: model canSend not.
 ^ child
]

{ #category : #examples }
GtLACPSubagentExamples >> reusedChildConversation [
 <gtExample>
 | root child assignment |
 root := GtLACPExamples new session.
 child := self announce: 'reused-child' title: 'Worker' in: root.
 self task: 'First assignment' from: root to: child id: 'first-assignment'.
 self reply: 'First result' in: child.
 self idle: child.
 self task: 'Second assignment' from: root to: child id: 'second-assignment'.
 assignment := child currentTurn.
 self update: { 'sessionUpdate' -> 'subagent_update'. 'sessionId' -> child remoteSessionId.
  'state' -> { 'state' -> 'running' } asDictionary } asDictionary for: root.
 self assert: child currentTurn == assignment.
 self reply: 'Second result' in: child.
 self idle: child.
 self assert: root subagents size equals: 1.
 self assert: child turns size equals: 2.
 self assert: child turns first assistantMessage text equals: 'First result'.
 self assert: child turns second inputMessages first text equals: 'Second assignment'.
 self assert: child turns second assistantMessage text equals: 'Second result'.
 ^ child
]

{ #category : #fixtures }
GtLACPSubagentExamples >> task: text from: parent to: child id: anId [
 self update: { 'sessionUpdate' -> 'session_message'. 'messageId' -> anId.
  'senderSessionId' -> parent remoteSessionId. 'recipientSessionId' -> child remoteSessionId.
  'recipientMessageId' -> (anId, '-incoming').
  'content' -> { { 'type' -> 'text'. 'text' -> text } asDictionary } } asDictionary for: parent.
 self update: { 'sessionUpdate' -> 'session_message'. 'messageId' -> (anId, '-incoming').
  'senderSessionId' -> parent remoteSessionId. 'recipientSessionId' -> child remoteSessionId.
  'senderMessageId' -> anId.
  'content' -> { { 'type' -> 'text'. 'text' -> text } asDictionary } } asDictionary for: child
]

{ #category : #fixtures }
GtLACPSubagentExamples >> update: update for: aSession [
 aSession connection transport receive: {
  'jsonrpc' -> '2.0'. 'method' -> 'session/update'.
  'params' -> { 'sessionId' -> aSession remoteSessionId. 'update' -> update } asDictionary } asDictionary
]
