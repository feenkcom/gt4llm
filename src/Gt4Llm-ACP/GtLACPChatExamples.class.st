"
Executable ACP chat examples, including BlScripter tests for typing, sending, cancellation, keyboard shortcuts, automatic streamed text updates, permission choices and draft preservation on failure.
"
Class {
	#name : #GtLACPChatExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #assertions }
GtLACPChatExamples >> assertNoRenderingErrorsIn: aScripter [
 aScripter assertStep: [ :step |
  step label: 'No rendering errors in the inspector or its children';
   value: [ :root |
    | errors |
    errors := OrderedCollection new.
    root withAllChildrenBreadthFirstDo: [ :each |
     each errorHandler hasError ifTrue: [ errors addAll: each errorHandler errors ] ].
    errors asArray ]
   equals: [ #() ] ]
]

{ #category : #examples }
GtLACPChatExamples >> assistantHeaderIndicatorDuringStreamingAndCancellation [
 <gtExample>
 | scripter session |
 scripter := self workingAssistantHeader.
 session := scripter model.
 scripter doStep: [ :step | step block: [ :element |
  GtLACPExamples new sendUpdate: { 'sessionUpdate' -> 'agent_message_chunk'.
   'content' -> { 'type' -> 'text'. 'text' -> 'Inspecting the directory.' } asDictionary } asDictionary to: session ] ].
 scripter assertStep: [ :step | step id: #'acp-work-indicator'; satisfies: [ :indicator |
  indicator text asString = 'Working…' and: [
   indicator parent id asSymbol = #'acp-message-header' ] ] ].
 scripter doStep: [ :step | step block: [ :element | session cancelTurn ] ].
 scripter assertStep: [ :step | step id: #'acp-work-indicator'; satisfies: [ :indicator |
  indicator text asString = 'Stopping…' ] ].
 scripter doStep: [ :step | step block: [ :element |
  session connection transport receive: { 'jsonrpc' -> '2.0'. 'id' -> session currentTurn request id.
   'result' -> { 'stopReason' -> 'cancelled' } asDictionary } asDictionary ] ].
 scripter assertStep: [ :step | step id: #'acp-work-indicator'; notExists ].
 self assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> assistantHeaderIndicatorStopsOnCompletion [
 <gtExample>
 | scripter session |
 scripter := self workingAssistantHeader.
 session := scripter model.
 scripter doStep: [ :step | step block: [ :element |
  GtLACPExamples new sendUpdate: { 'sessionUpdate' -> 'agent_message_chunk'.
   'content' -> { 'type' -> 'text'. 'text' -> 'The directory contains the project.' } asDictionary } asDictionary to: session.
  session connection transport receive: { 'jsonrpc' -> '2.0'. 'id' -> session currentTurn request id.
   'result' -> { 'stopReason' -> 'end_turn' } asDictionary } asDictionary ] ].
 scripter assertStep: [ :step | step id: #'acp-work-indicator'; notExists ].
 scripter assertStep: [ :step | step id: #'acp-final-section'; satisfies: #isExpanded ].
 self assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> assistantMessageElement [
 <gtExample>
 | turn message element |
 turn := GtLACPExamples new streamedTurn.
 message := turn assistantMessage.
 element := message asElement.
 self assert: element class equals: GtLACPAssistantMessageElement.
 self assert: element viewModel message == message.
 self assert: element viewModel turn == turn.
 self assert: element replyPreviewText equals: message text.
 ^ element
]

{ #category : #examples }
GtLACPChatExamples >> assistantSectionChoicesSurviveStreaming [
 <gtExample>
 | element session scripter |
 element := self chatWithToolCalls.
 session := element viewModel session.
 scripter := BlScripter new model: session; element: element; yourself.
 scripter doStep: [ :step | step block: [ :chat |
  GtLACPExamples new sendUpdate: { 'sessionUpdate' -> 'agent_thought_chunk'.
   'content' -> { 'type' -> 'text'. 'text' -> 'Reasoning continues.' } asDictionary } asDictionary to: session.
  GtLACPExamples new sendUpdate: { 'sessionUpdate' -> 'agent_message_chunk'.
   'content' -> { 'type' -> 'text'. 'text' -> 'A new final reply.' } asDictionary } asDictionary to: session ] ].
 scripter assertStep: [ :step | step id: #'acp-work-section'; satisfies: #isCollapsed ].
 scripter assertStep: [ :step | step id: #'acp-final-section'; satisfies: #isCollapsed ].
 scripter click id: #'acp-final-toggle'; play.
 scripter assertStep: [ :step | step id: #'acp-final-content'; satisfies: [ :pane |
  pane children anySatisfy: [ :child | (child isKindOf: BrEditor) and: [
   child text asString = 'A new final reply.' ] ] ] ].
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> assistantSectionsCollapseIndependently [
 <gtExample>
 | element scripter |
 element := self reasoningBetweenToolCalls.
 scripter := BlScripter new model: element viewModel session; element: element; yourself.
 scripter assertStep: [ :step | step id: #'acp-work-section'; satisfies: #isCollapsed ].
 scripter assertStep: [ :step | step id: #'acp-final-content'; exists ].
 scripter click id: #'acp-work-toggle'; play.
 scripter assertStep: [ :step | step id: #'acp-work-content'; exists ].
 scripter assertStep: [ :step | step id: #'acp-final-section'; satisfies: #isExpanded ].
 scripter click id: #'acp-final-toggle'; play.
 scripter assertStep: [ :step | step id: #'acp-final-preview'; exists ].
 scripter assertStep: [ :step | step id: #'acp-work-content'; exists ].
 scripter click id: #'acp-work-toggle'; play.
 scripter assertStep: [ :step | step id: #'acp-work-content'; notExists ].
 scripter assertStep: [ :step | step id: #'acp-final-preview'; exists ].
 scripter click id: #'acp-final-toggle'; play.
 scripter assertStep: [ :step | step id: #'acp-final-content'; exists ].
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> chatInspectorTool [
 <gtExample>
 | session tool element |
 session := GtLACPExamples new session.
 tool := GtLACPChatTool forChat: session.
 self assert: (tool isKindOf: GtPhlowChatTool).
 self assert: tool object == session.
 element := tool asElementDo: [ :widget | widget ].
 self assert: (element isKindOf: GtLACPChatToolElement).
 self assert: element chat == session.
 self assert: ((element childNamed: #header) childNamed: #toolLabel) text asString equals: 'ACP Chat'.
 self assert: (element collectToolViews anySatisfy: [ :view | view title = 'Live chat' ]).
 self assert: (element collectToolViews anySatisfy: [ :view | view title = 'Conversation' ]).
 self assert: (GtPhlowViewTester new testView: (session gtChatFor: GtPhlowView empty)) isOk.
 ^ tool
]

{ #category : #examples }
GtLACPChatExamples >> chatToolViewSwitching [
 <gtExample>
 | scripter |
 scripter := self chatToolWithViews.
 scripter clickStep: [ :step |
  step // BrTabGroup; // #tabbar;
   onChildFromBlock: [ :bar | bar children detect: [ :tab | tab label asString = 'Conversation' ] ] ].
 scripter assertStep: [ :step | step id: #'acp-input'; notExists ].
 scripter assertStep: [ :step |
  step onPhlowCellWithString: scripter model currentTurn userMessages first printString; exists ].
 scripter clickStep: [ :step |
  step // BrTabGroup; // #tabbar;
   onChildFromBlock: [ :bar | bar children detect: [ :tab | tab label asString = 'Session' ] ] ].
 scripter assertStep: [ :step | step onPhlowCellWithString: 'Project directory'; exists ].
 scripter clickStep: [ :step |
  step // BrTabGroup; // #tabbar;
   onChildFromBlock: [ :bar | bar children detect: [ :tab | tab label asString = 'Live chat' ] ] ].
 scripter assertStep: [ :step | step id: #'acp-input'; exists ].
 self assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> chatToolWithViews [
 <gtExample>
 | session element scripter |
 session := self chatWithToolCalls viewModel session.
 element := (GtLACPChatTool forChat: session) asElementDo: [ :widget | widget ].
 scripter := BlScripter new extent: 1100 @ 800; model: session; element: element; yourself.
 scripter assertStep: [ :step | step id: #toolLabel;
  value: [ :label | label text asString ] equals: [ 'ACP Chat' ] ].
 scripter assertStep: [ :step | step id: #'acp-input'; exists ].
 scripter assertStep: [ :step | step id: #'acp-message-1'; exists ].
 scripter assertStep: [ :step | step id: #'acp-message-2'; exists ].
 self assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> chatWithToolCalls [
 <gtExample>
 | permission session turn element |
 permission := GtLACPExamples new pendingPermission.
 session := permission session.
 turn := session currentTurn.
 GtLACPExamples new sendUpdate: {
  'sessionUpdate' -> 'agent_message_chunk'.
  'content' -> { 'type' -> 'text'. 'text' -> 'I will **inspect the directory** using the following tool.' } asDictionary } asDictionary to: session.
 turn toolCalls first updateFrom: { 'rawInput' -> { 'path' -> session directory fullName } asDictionary } asDictionary.
 element := session asElement.
 self assert: element viewModel messageViewModels size equals: 2.
 self assert: element viewModel messageViewModels last toolCalls first == permission toolCall.
 ^ element
]

{ #category : #examples }
GtLACPChatExamples >> chatWithToolCallsDisplayed [
 <gtExample>
 | element scripter |
 element := self chatWithToolCalls.
 scripter := BlScripter new
  extent: 1000 @ 1000;
  model: element viewModel session;
  element: (GtInspector forObject: element);
  yourself.
 self assertNoRenderingErrorsIn: scripter.
 scripter assertStep: [ :step | step id: #'acp-message-1'; exists ].
 scripter assertStep: [ :step | step id: #'acp-message-2'; exists ].
 scripter click id: #'acp-work-toggle'; play.
 self assertNoRenderingErrorsIn: scripter.
 scripter assertStep: [ :step | step id: #'acp-permission-allow'; exists ].
 self assertNoRenderingErrorsIn: scripter.
 scripter click id: #'acp-final-toggle'; play.
 scripter assertStep: [ :step | step id: #'acp-final-content'; satisfies: [ :pane |
  pane children anySatisfy: [ :child | (child isKindOf: BrEditor) and: [
   child text asString = 'I will **inspect the directory** using the following tool.' ] ] ] ].
 self assertNoRenderingErrorsIn: scripter.
 element updateMessages.
 scripter assertStep: [ :step | step id: #'acp-work-section'; satisfies: [ :section | section isExpanded ] ].
 scripter assertStep: [ :step | step id: #'acp-final-section'; satisfies: [ :section | section isExpanded ] ].
 self assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> chatWithToolCallsStyledLayout [
 <gtExample>
 | element scripter |
 element := self chatWithToolCalls.
 scripter := BlScripter new model: element viewModel session; element: element; yourself.
 #(800 400 1000 300 800) do: [ :width |
  scripter extent: width @ 600.
  self assertNoRenderingErrorsIn: scripter.
  scripter assertStep: [ :step | step id: #'acp-final-preview'; exists ].
  scripter assertStep: [ :step | step id: #'acp-messages'; satisfies: [ :list |
   (list childNamed: #scrollable) state isStartStep ] ] ].
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> commentaryBetweenToolCalls [
 <gtExample>
 | session turn examples element assistant |
 examples := GtLACPExamples new.
 session := examples session.
 turn := session prompt: 'Inspect the runtime'.
 examples sendUpdate: {
  'sessionUpdate' -> 'tool_call'. 'toolCallId' -> 'first'.
  'title' -> 'Inspect runtime'. 'status' -> 'completed' } asDictionary to: session.
 examples sendUpdate: {
  'sessionUpdate' -> 'agent_message_chunk'. 'messageId' -> 'same-message'.
  'content' -> { 'type' -> 'text'. 'text' -> 'The first result suggests ' } asDictionary } asDictionary to: session.
 examples sendUpdate: {
  'sessionUpdate' -> 'agent_message_chunk'. 'messageId' -> 'same-message'.
  'content' -> { 'type' -> 'text'. 'text' -> 'checking the runtime version.' } asDictionary } asDictionary to: session.
 examples sendUpdate: {
  'sessionUpdate' -> 'tool_call'. 'toolCallId' -> 'second'.
  'title' -> 'Check version'. 'status' -> 'completed' } asDictionary to: session.
 examples sendUpdate: {
  'sessionUpdate' -> 'tool_call_update'. 'toolCallId' -> 'first'.
  'rawOutput' -> 'Runtime found' } asDictionary to: session.
 examples sendUpdate: {
  'sessionUpdate' -> 'agent_message_chunk'. 'messageId' -> 'same-message'.
  'content' -> { 'type' -> 'text'. 'text' -> 'The runtime is compatible.' } asDictionary } asDictionary to: session.
 session connection transport receive: { 'jsonrpc' -> '2.0'. 'id' -> turn request id.
  'result' -> { 'stopReason' -> 'end_turn' } asDictionary } asDictionary.
 element := session asElement.
 assistant := element viewModel messageViewModels last.
 self assert: assistant activityItems size equals: 3.
 self assert: assistant activityItems first == turn toolCalls first.
 self assert: assistant activityItems second role equals: #agent.
 self assert: assistant activityItems second text equals: 'The first result suggests checking the runtime version.'.
 self assert: assistant activityItems third == turn toolCalls second.
 self assert: assistant replyMessages size equals: 1.
 self assert: assistant replyMessages first text equals: 'The runtime is compatible.'.
 ^ element
]

{ #category : #examples }
GtLACPChatExamples >> commentaryRenderedBetweenTools [
 <gtExample>
 | element scripter |
 element := self commentaryBetweenToolCalls.
 scripter := BlScripter new model: element viewModel session; element: element; yourself.
 scripter click id: #'acp-work-toggle'; play.
 scripter assertStep: [ :step |
  step id: #'acp-work-content'; satisfies: [ :pane |
   | children tools commentary |
   children := pane children asArray.
   tools := children select: [ :child | child id asSymbol asString beginsWith: 'acp-tool-' ].
   commentary := children detect: [ :child | (child isKindOf: BrEditor) and: [
    child text asString = 'The first result suggests checking the runtime version.' ] ].
   tools size = 2 and: [
    (children indexOf: tools first) < (children indexOf: commentary) and: [
     (children indexOf: commentary) < (children indexOf: tools second) ] ] ] ].
 scripter assertStep: [ :step | step id: #'acp-final-content'; satisfies: [ :pane |
  pane children anySatisfy: [ :child |
   (child isKindOf: BrEditor) and: [ child text asString = 'The runtime is compatible.' ] ] ] ].
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> compactAssistantHeaders [
 <gtExample>
 | element scripter |
 element := self reasoningBetweenToolCalls.
 element viewModel messageViewModels last section: #final expanded: false.
 scripter := BlScripter new model: element viewModel session; element: element; yourself.
 scripter assertStep: [ :step | step id: #'acp-work-summary';
  value: [ :label | label text asString ] equals: [ 'Read configuration + 1 other tool' ] ].
 scripter assertStep: [ :step | step id: #'acp-final-preview';
  value: [ :editor | editor text asString ] equals: [ 'Finished. The project configuration is consistent.' ] ].
 scripter assertStep: [ :step | step id: #'acp-work-section'; satisfies: #isCollapsed ].
 scripter assertStep: [ :step | step id: #'acp-final-section'; satisfies: #isCollapsed ].
 scripter click id: #'acp-work-summary'; play.
 scripter assertStep: [ :step | step id: #'acp-work-content'; exists ].
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> compactFinalPreview [
 <gtExample>
 | session turn text element scripter |
 session := GtLACPExamples new session.
 text := String streamContents: [ :stream | 1 to: 50 do: [ :index | stream nextPutAll: 'Reply line '; print: index; lf ] ].
 turn := session prompt: 'Give me a long reply'.
 GtLACPExamples new sendUpdate: { 'sessionUpdate' -> 'agent_message_chunk'.
  'content' -> { 'type' -> 'text'. 'text' -> text } asDictionary } asDictionary to: session.
 session connection transport receive: { 'jsonrpc' -> '2.0'. 'id' -> turn request id.
  'result' -> { 'stopReason' -> 'end_turn' } asDictionary } asDictionary.
 element := session asElement.
 element viewModel messageViewModels last section: #final expanded: false.
 scripter := BlScripter new model: session; element: element; yourself.
 scripter assertStep: [ :step | step id: #'acp-final-preview'; satisfies: [ :editor |
  editor text asString size <= 181 and: [ editor text asString beginsWith: 'Reply line 1 ' ] ] ].
 scripter click id: #'acp-final-toggle'; play.
 scripter assertStep: [ :step | step id: #'acp-final-content'; satisfies: [ :pane |
  pane children anySatisfy: [ :child | (child isKindOf: BrEditor) and: [ child text asString = text ] ] ] ].
 scripter assertStep: [ :step | step id: #'acp-final-preview'; notExists ].
 scripter click id: #'acp-final-toggle'; play.
 scripter assertStep: [ :step | step id: #'acp-final-preview'; exists ].
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> completedChat [
 <gtExample>
 | turn |
 turn := GtLACPExamples new streamedTurn.
 ^ turn session asElement
]

{ #category : #examples }
GtLACPChatExamples >> completedReplyStartsExpanded [
 <gtExample>
 | chat scripter |
 chat := self completedChat.
 scripter := BlScripter new model: chat viewModel session; element: chat; yourself.
 scripter assertStep: [ :step | step id: #'acp-final-section'; satisfies: #isExpanded ].
 scripter assertStep: [ :step | step id: #'acp-final-preview'; notExists ].
 scripter assertStep: [ :step | step id: #'acp-final-content'; exists ].
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> composerAppearance [
 <gtExample>
 | scripter |
 scripter := self typedMessage.
 scripter assertStep: [ :step | step id: #'acp-input'; satisfies: [ :editor | editor border width isZero ] ].
 scripter assertStep: [ :step | step id: #'acp-composer'; satisfies: [ :composer |
  | buttons |
  buttons := OrderedCollection new.
  composer withAllChildrenBreadthFirstDo: [ :each |
   (each isKindOf: BrButton) ifTrue: [ buttons add: each ] ].
  buttons size = 1 and: [ (composer effect isKindOf: BlNullEffect) not ] ] ].
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> composerReturnsToSend [
 <gtExample>
 | scripter session turn button |
 scripter := self typedMessage.
 session := scripter model.
 button := scripter element actionButton.
 scripter click id: #'acp-action'; play.
 turn := session currentTurn.
 scripter assertStep: [ :step | step id: #'acp-action'; satisfies: [ :action |
  action == button and: [ action label asString = 'Stop' ] ] ].
 scripter doStep: [ :step | step block: [ :chat |
  session connection transport receive: { 'jsonrpc' -> '2.0'. 'id' -> turn request id.
   'result' -> { 'stopReason' -> 'end_turn' } asDictionary } asDictionary ] ].
 scripter assertStep: [ :step | step id: #'acp-action'; satisfies: [ :action |
  action == button and: [ action label asString = 'Send' and: [ action isEnabled not ] ] ] ].
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> disclosuresAlignWithText [
 <gtExample>
 | element scripter |
 element := self chatWithToolCalls.
 scripter := BlScripter new model: element viewModel session; element: element; yourself.
 { #prompt -> #'acp-user-preview'. #work -> #'acp-work-summary'. #final -> #'acp-final-preview' } do: [ :pair |
  scripter assertStep: [ :step |
   step id: ('acp-', pair key asString, '-section') asSymbol;
    satisfies: [ :section |
     | toggle preview |
     toggle := (section childNamed: #sidebar) childNamed: ('acp-', pair key asString, '-toggle') asSymbol.
     section withAllChildrenBreadthFirstDo: [ :child | child id asSymbol = pair value ifTrue: [ preview := child ] ].
     (toggle bounds inSpace center y - preview bounds inSpace center y) abs <= 2 ] ] ].
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> draftSurvivesFailure [
 <gtExample>
 | element session transport |
 element := self emptyChat.
 session := element viewModel session.
 transport := session connection transport.
 transport responder: [ :message :sender | self error: 'Example send failure' ].
 element inputElement text: 'Keep this draft'.
 element sendDraft.
 self assert: element inputElement text asString equals: 'Keep this draft'.
 self assert: element viewModel lastError equals: 'Example send failure'.
 ^ element
]

{ #category : #examples }
GtLACPChatExamples >> emptyChat [
 <gtExample>
 | session element |
 session := GtLACPExamples new session.
 element := session asElement.
 self assert: element viewModel session == session.
 self assert: element viewModel messageViewModels isEmpty.
 ^ element
]

{ #category : #examples }
GtLACPChatExamples >> explicitMessageObjects [
 <gtExample>
 | element turn rows |
 element := self reasoningBetweenToolCalls.
 turn := element viewModel session currentTurn.
 rows := element viewModel messageViewModels.
 self assert: turn userMessages first class equals: GtLACPUserMessage.
 self assert: turn assistantMessage class equals: GtLACPAssistantMessage.
 self assert: rows first inspectionTarget == turn userMessages first.
 self assert: rows last inspectionTarget == turn assistantMessage.
 self assert: turn assistantMessage == turn assistantMessage.
 self assert: turn assistantMessage activityItems size equals: 4.
 self assert: turn assistantMessage finalMessages size equals: 1.
 self assert: turn assistantMessage text equals: 'Finished. The project configuration is consistent.'.
 ^ turn assistantMessage
]

{ #category : #examples }
GtLACPChatExamples >> finalReplyExpandsOnCompletion [
 <gtExample>
 | chat session turn scripter |
 chat := self chatWithToolCalls.
 session := chat viewModel session.
 turn := session currentTurn.
 scripter := BlScripter new model: session; element: chat; yourself.
 scripter assertStep: [ :step | step id: #'acp-final-section'; satisfies: #isCollapsed ].
 scripter click id: #'acp-final-toggle'; play.
 scripter click id: #'acp-final-toggle'; play.
 scripter doStep: [ :step | step block: [ :element |
  session connection transport receive: { 'jsonrpc' -> '2.0'. 'id' -> turn request id.
   'result' -> { 'stopReason' -> 'end_turn' } asDictionary } asDictionary ] ].
 scripter assertStep: [ :step | step id: #'acp-final-section'; satisfies: #isExpanded ].
 scripter assertStep: [ :step | step id: #'acp-final-preview'; notExists ].
 scripter assertStep: [ :step | step id: #'acp-final-content'; satisfies: [ :pane |
  pane children anySatisfy: [ :child | (child isKindOf: BrEditor) and: [
   child text asString = turn assistantMessage text ] ] ] ].
 scripter assertStep: [ :step | step id: #'acp-work-section'; satisfies: #isCollapsed ].
 self assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> finalReplyManualCollapsePersists [
 <gtExample>
 | scripter |
 scripter := self finalReplyExpandsOnCompletion.
 scripter click id: #'acp-final-toggle'; play.
 scripter doStep: [ :step | step block: [ :chat | chat updateMessages. chat updateMessages ] ].
 scripter assertStep: [ :step | step id: #'acp-final-section'; satisfies: #isCollapsed ].
 scripter assertStep: [ :step | step id: #'acp-final-preview'; exists ].
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> keyboardSend [
 <gtExample>
 | scripter |
 scripter := self typedMessage.
 scripter shortcut id: #'acp-input'; combination: BlKeyCombination primaryReturn; play.
 self assert: scripter model turns size equals: 1.
 self assert: scripter model currentTurn messages first text equals: 'Hello ACP'.
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> longStreamingChat [
 <gtExample>
 | session turn examples text element scripter |
 examples := GtLACPExamples new.
 session := examples session.
 text := String streamContents: [ :stream |
  1 to: 12 do: [ :index | stream nextPutAll: 'Line '; print: index; nextPutAll: ' of the assistant response.'; lf ] ].
 1 to: 8 do: [ :index |
  turn := session prompt: 'Question ', index asString.
  examples sendUpdate: { 'sessionUpdate' -> 'agent_message_chunk'.
   'content' -> { 'type' -> 'text'. 'text' -> text } asDictionary } asDictionary to: session.
  session connection transport receive: { 'jsonrpc' -> '2.0'. 'id' -> turn request id.
   'result' -> { 'stopReason' -> 'end_turn' } asDictionary } asDictionary ].
 session prompt: 'Keep streaming'.
 examples sendUpdate: { 'sessionUpdate' -> 'agent_message_chunk'.
  'content' -> { 'type' -> 'text'. 'text' -> text } asDictionary } asDictionary to: session.
 element := session asElement.
 scripter := BlScripter new model: session; element: element; yourself.
 scripter assertStep: [ :step | step satisfies: [ :chat | chat isAtStreamEnd ] ].
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> messageAssignmentIsIdempotent [
 <gtExample>
 | chat models versions |
 chat := self chatWithToolCalls.
 models := chat viewModel messageViewModels.
 versions := models collect: #renderingVersion.
 self assert: (chat viewModel messageViewModels collect: #renderingVersion) equals: versions.
 models do: [ :model | model message: model message ].
 self assert: (models collect: #renderingVersion) equals: versions.
 models last changed.
 self assert: models first renderingVersion equals: versions first.
 self assert: models last renderingVersion equals: versions last + 1.
 ^ chat viewModel
]

{ #category : #examples }
GtLACPChatExamples >> messageAtRest [
 <gtExample>
 | element scripter |
 element := self completedChat.
 scripter := BlScripter new model: element viewModel session; element: element; yourself.
 scripter mouseMoveOverStep: [ :step | step id: #'acp-input' ].
 scripter assertStep: [ :step | step id: #'acp-message-2'; satisfies: [ :row |
  | header |
  header := row childNamed: #'acp-message-header'.
  (header childNamed: #'acp-inspect') visibility = BlVisibility hidden and: [
   (header childNamed: #'acp-timestamp') visibility = BlVisibility hidden and: [
    row effect isKindOf: BlNullEffect ] ] ] ].
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> messageHoverLeaves [
 <gtExample>
 | scripter |
 scripter := self messageHovered.
 scripter mouseMoveOverStep: [ :step | step id: #'acp-input' ].
 scripter assertStep: [ :step | step id: #'acp-message-2'; satisfies: [ :row |
  | header |
  header := row childNamed: #'acp-message-header'.
  (header childNamed: #'acp-inspect') visibility = BlVisibility hidden and: [
   (header childNamed: #'acp-timestamp') visibility = BlVisibility hidden and: [
    row effect isKindOf: BlNullEffect ] ] ] ].
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> messageHovered [
 <gtExample>
 | scripter |
 scripter := self messageAtRest.
 scripter mouseMoveOverStep: [ :step | step id: #'acp-message-2' ].
 scripter assertStep: [ :step | step id: #'acp-message-2'; satisfies: [ :row |
  | header |
  header := row childNamed: #'acp-message-header'.
  (header childNamed: #'acp-inspect') visibility = BlVisibility visible and: [
   (header childNamed: #'acp-timestamp') visibility = BlVisibility visible and: [
    (header childNamed: #'acp-timestamp') text asString notEmpty and: [
     (row effect isKindOf: BlNullEffect) not ] ] ] ] ].
 self assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> messageSpecificRows [
 <gtExample>
 | element scripter models |
 element := self chatWithToolCalls.
 models := element viewModel messageViewModels.
 scripter := BlScripter new model: element viewModel session; element: element; yourself.
 scripter assertStep: [ :step | step id: #'acp-message-1'; satisfies: [ :row |
  row class = GtLACPUserMessageElement and: [ row viewModel == models first ] ] ].
 scripter assertStep: [ :step | step id: #'acp-message-2'; satisfies: [ :row |
  row class = GtLACPAssistantMessageElement and: [ row viewModel == models last ] ] ].
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> newTurnFollowsBottom [
 <gtExample>
 | scripter session |
 scripter := self longStreamingChat.
 session := scripter model.
 scripter doStep: [ :step | step block: [ :chat |
  session connection transport receive: { 'jsonrpc' -> '2.0'. 'id' -> session currentTurn request id.
   'result' -> { 'stopReason' -> 'end_turn' } asDictionary } asDictionary.
  session prompt: 'A new question at the end' ] ].
 scripter assertStep: [ :step | step satisfies: [ :chat |
  chat isAtStreamEnd and: [ chat listElement items size = 20 ] ] ].
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> newTurnPreservesReadingPosition [
 <gtExample>
 | scripter session anchor |
 scripter := self streamPreservesReadingPosition.
 session := scripter model.
 scripter doStep: [ :step | step block: [ :chat |
  | viewport first |
  viewport := chat messageViewport.
  first := viewport children first.
  anchor := { viewport layout childPositionOf: first. first bounds inParent top }.
  session connection transport receive: { 'jsonrpc' -> '2.0'. 'id' -> session currentTurn request id.
   'result' -> { 'stopReason' -> 'end_turn' } asDictionary } asDictionary.
  session prompt: 'A new question while reading history' ] ].
 scripter assertStep: [ :step | step satisfies: [ :chat |
  | viewport first |
  viewport := chat messageViewport.
  first := viewport children first.
  chat isAtStreamEnd not and: [
   { viewport layout childPositionOf: first. first bounds inParent top } = anchor ] ] ].
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> olderMessageChangeRefreshesOnlyItsRow [
 <gtExample>
 | scripter session firstRow secondRow lastRow |
 scripter := self unchangedRowsSurviveStreamingAndNewTurn.
 session := scripter model.
 scripter assertStep: [ :step | step id: #'acp-message-1'; satisfies: [ :row | firstRow := row. true ] ].
 scripter assertStep: [ :step | step id: #'acp-message-2'; satisfies: [ :row | secondRow := row. true ] ].
 scripter assertStep: [ :step | step id: #'acp-message-4'; satisfies: [ :row | lastRow := row. true ] ].
 scripter doStep: [ :step | step block: [ :element |
  session announceMessageChanged: session turns first assistantMessage.
  element updateMessages ] ].
 scripter assertStep: [ :step | step id: #'acp-message-1'; satisfies: [ :row | row == firstRow ] ].
 scripter assertStep: [ :step | step id: #'acp-message-2'; satisfies: [ :row |
  row ~~ secondRow and: [ row viewModel == secondRow viewModel ] ] ].
 scripter assertStep: [ :step | step id: #'acp-message-4'; satisfies: [ :row | row == lastRow ] ].
 self assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> permissionButtons [
 <gtExample>
 | element scripter permission |
 element := self chatWithToolCalls.
 permission := element viewModel session currentTurn permissionRequests first.
 scripter := BlScripter new model: element viewModel session; element: element; yourself.
 scripter click id: #'acp-work-toggle'; play.
 scripter click id: #'acp-permission-allow'; play.
 self assert: permission state equals: #selected.
 scripter assertStep: [ :step | step id: #'acp-permission-allow'; notExists ].
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> reasoningBetweenToolCalls [
 <gtExample>
 | session turn examples element items |
 examples := GtLACPExamples new.
 session := examples session.
 turn := session prompt: 'Inspect and explain'.
 examples sendUpdate: {
  'sessionUpdate' -> 'tool_call'. 'toolCallId' -> 'one'.
  'title' -> 'Inspect files'. 'status' -> 'completed' } asDictionary to: session.
 examples sendUpdate: {
  'sessionUpdate' -> 'agent_thought_chunk'. 'messageId' -> 'reasoning'.
  'content' -> { 'type' -> 'text'. 'text' -> 'The files suggest ' } asDictionary } asDictionary to: session.
 examples sendUpdate: {
  'sessionUpdate' -> 'agent_thought_chunk'. 'messageId' -> 'reasoning'.
  'content' -> { 'type' -> 'text'. 'text' -> 'checking the configuration.' } asDictionary } asDictionary to: session.
 examples sendUpdate: {
  'sessionUpdate' -> 'tool_call'. 'toolCallId' -> 'two'.
  'title' -> 'Read configuration'. 'status' -> 'completed' } asDictionary to: session.
 examples sendUpdate: {
  'sessionUpdate' -> 'agent_thought_chunk'. 'messageId' -> 'reasoning'.
  'content' -> { 'type' -> 'text'. 'text' -> 'Now I can explain the result.' } asDictionary } asDictionary to: session.
 examples sendUpdate: {
  'sessionUpdate' -> 'tool_call_update'. 'toolCallId' -> 'one'.
  'rawOutput' -> 'Found project files' } asDictionary to: session.
 examples sendUpdate: {
  'sessionUpdate' -> 'agent_message_chunk'.
  'content' -> { 'type' -> 'text'. 'text' -> 'Finished. The project configuration is consistent.' } asDictionary } asDictionary to: session.
 session connection transport receive: { 'jsonrpc' -> '2.0'. 'id' -> turn request id.
  'result' -> { 'stopReason' -> 'end_turn' } asDictionary } asDictionary.
 element := session asElement.
 items := element viewModel messageViewModels last activityItems.
 self assert: items size equals: 4.
 self assert: items first == turn toolCalls first.
 self assert: items second text equals: 'The files suggest checking the configuration.'.
 self assert: items third == turn toolCalls second.
 self assert: items fourth text equals: 'Now I can explain the result.'.
 self assert: element viewModel messageViewModels last replyMessages size equals: 1.
 ^ element
]

{ #category : #examples }
GtLACPChatExamples >> reasoningRenderedBetweenTools [
 <gtExample>
 | element scripter |
 element := self reasoningBetweenToolCalls.
 scripter := BlScripter new model: element viewModel session; element: element; yourself.
 scripter click id: #'acp-work-toggle'; play.
 scripter assertStep: [ :step |
  step id: #'acp-work-content'; satisfies: [ :pane |
   | children tools firstThought secondThought |
   children := pane children asArray.
   tools := children select: [ :child | child id asSymbol asString beginsWith: 'acp-tool-' ].
   firstThought := children detect: [ :child |
    (child isKindOf: BrEditor) and: [ child text asString = 'The files suggest checking the configuration.' ] ].
   secondThought := children detect: [ :child |
    (child isKindOf: BrEditor) and: [ child text asString = 'Now I can explain the result.' ] ].
   tools size = 2 and: [
    (children indexOf: tools first) < (children indexOf: firstThought) and: [
     (children indexOf: firstThought) < (children indexOf: tools second) and: [
      (children indexOf: tools second) < (children indexOf: secondThought) ] ] ] ] ].
 scripter assertStep: [ :step | step id: #'acp-final-content'; satisfies: [ :pane |
  pane children anySatisfy: [ :child |
   (child isKindOf: BrEditor) and: [ child text asString beginsWith: 'Finished.' ] ] ] ].
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> recoveredCommentaryOrder [
 <gtExample>
 | element turn assistant |
 element := self commentaryBetweenToolCalls.
 turn := element viewModel session currentTurn.
 turn activity: nil.
 assistant := element viewModel messageViewModels last.
 self assert: assistant activityItems size equals: 3.
 self assert: assistant activityItems second text equals: 'The first result suggests checking the runtime version.'.
 self assert: assistant replyMessages first text equals: 'The runtime is compatible.'.
 self assert: turn messages last text equals: 'The runtime is compatible.'.
 ^ element
]

{ #category : #examples }
GtLACPChatExamples >> recoveredReasoningOrder [
 <gtExample>
 | element turn items |
 element := self reasoningBetweenToolCalls.
 turn := element viewModel session currentTurn.
 turn activity: nil.
 items := element viewModel messageViewModels last activityItems.
 self assert: items size equals: 4.
 self assert: items first == turn toolCalls first.
 self assert: items second text equals: 'The files suggest checking the configuration.'.
 self assert: items third == turn toolCalls second.
 self assert: items fourth text equals: 'Now I can explain the result.'.
 ^ element
]

{ #category : #examples }
GtLACPChatExamples >> scrollingUpCancelsPendingFollow [
 <gtExample>
 | scripter |
 scripter := self longStreamingChat.
 scripter doStep: [ :step | step block: [ :chat |
  chat updateMessages.
  chat messageViewport scrollBy: 0 @ -200 ] ].
 scripter assertStep: [ :step | step satisfies: [ :chat | chat isAtStreamEnd not ] ].
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> selectionSurvivesUnrelatedUpdates [
 <gtExample>
 | chat session scripter editor |
 chat := self completedChat.
 session := chat viewModel session.
 scripter := BlScripter new extent: 1000 @ 1000; model: session; element: chat; yourself.
 scripter doStep: [ :step | step id: #'acp-user-preview'; block: [ :element |
  editor := element.
  editor selecter from: 0 to: 5; select ] ].
 scripter assertStep: [ :step | step id: #'acp-user-preview'; satisfies: [ :element |
  element selection isEmpty not ] ].
 scripter doStep: [ :step | step block: [ :element |
  session prompt: 'Continue'.
  GtLACPExamples new sendUpdate: { 'sessionUpdate' -> 'agent_message_chunk'.
   'content' -> { 'type' -> 'text'. 'text' -> 'Another answer.' } asDictionary } asDictionary to: session.
  element updateMessages ] ].
 scripter assertStep: [ :step | step id: #'acp-message-1'; satisfies: [ :row |
  | found |
  found := false.
  row withAllChildrenBreadthFirstDo: [ :each |
   each == editor ifTrue: [ found := each selection isEmpty not ] ].
  found ] ].
 self assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> sendAndStop [
 <gtExample>
 | scripter session button |
 scripter := self typedMessage.
 session := scripter model.
 button := scripter element actionButton.
 scripter click id: #'acp-action'; play.
 self assert: session turns size equals: 1.
 scripter assertStep: [ :step |
  step id: #'acp-input'; value: [ :editor | editor text asString ] equals: [ '' ] ].
 scripter assertStep: [ :step | step id: #'acp-action'; satisfies: [ :action |
  action == button and: [ action isEnabled and: [ action label asString = 'Stop' ] ] ] ].
 scripter click id: #'acp-action'; play.
 self assert: session currentTurn state equals: #cancelling.
 scripter assertStep: [ :step | step id: #'acp-action'; satisfies: [ :action |
  action == button and: [ action isEnabled not and: [ action label asString = 'Stopping…' ] ] ] ].
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> shortToolCallLabels [
 <gtExample>
 | permission session tool title input scripter |
 permission := GtLACPExamples new pendingPermission.
 session := permission session.
 tool := permission toolCall.
 title := 'Read ', (String new: 120 withAll: $x).
 input := { 'path' -> (String new: 200 withAll: $y) } asDictionary.
 tool updateFrom: { 'title' -> title. 'rawInput' -> input } asDictionary.
 GtLACPExamples new sendUpdate: { 'sessionUpdate' -> 'tool_call'.
  'toolCallId' -> 'tool-2'. 'title' -> 'Another tool'. 'status' -> 'completed' } asDictionary to: session.
 self assert: tool shortDescription size equals: 80.
 self assert: (tool shortDescription endsWith: '…').
 self assert: tool title equals: title.
 self assert: (tool data at: 'rawInput') equals: input.
 scripter := BlScripter new model: session; element: session asElement; yourself.
 scripter assertStep: [ :step | step id: #'acp-work-summary';
  value: [ :label | label text asString ]
  equals: [ tool shortDescription, ' + 1 other tool · permission required' ] ].
 scripter click id: #'acp-work-summary'; play.
 scripter assertStep: [ :step | step id: #'acp-tool-summary-tool-1';
  value: [ :label | label text asString ]
  equals: [ tool summary ] ].
 self assert: (tool summary beginsWith: tool shortDescription, ' · ').
 self assert: (tool summary endsWith: 'permission required').
 self assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> stableAssistantGroup [
 <gtExample>
 | element model first second session |
 element := self chatWithToolCalls.
 model := element viewModel.
 session := model session.
 first := model messageViewModels last.
 GtLACPExamples new sendUpdate: {
  'sessionUpdate' -> 'agent_message_chunk'.
  'content' -> { 'type' -> 'text'. 'text' -> ' More streamed text.' } asDictionary } asDictionary to: session.
 second := model messageViewModels last.
 self assert: first == second.
 self assert: second toolCalls size equals: 1.
 self assert: (second messages last text endsWith: ' More streamed text.').
 ^ model
]

{ #category : #examples }
GtLACPChatExamples >> streamFollowsBottom [
 <gtExample>
 | scripter session |
 scripter := self longStreamingChat.
 session := scripter model.
 scripter doStep: [ :step | step block: [ :chat |
  GtLACPExamples new sendUpdate: { 'sessionUpdate' -> 'agent_message_chunk'.
   'content' -> { 'type' -> 'text'. 'text' -> (String streamContents: [ :stream |
    1 to: 24 do: [ :index | stream nextPutAll: 'Additional streamed line '; print: index; lf ] ]) } asDictionary } asDictionary to: session ] ].
 scripter assertStep: [ :step | step satisfies: [ :chat |
  chat isAtStreamEnd and: [ session currentTurn messages last text includesSubstring: 'Additional streamed line 24' ] ] ].
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> streamPreservesReadingPosition [
 <gtExample>
 | scripter session anchor |
 scripter := self longStreamingChat.
 session := scripter model.
 scripter doStep: [ :step | step block: [ :chat | chat messageViewport scrollBy: 0 @ -250 ] ].
 scripter assertStep: [ :step | step satisfies: [ :chat | chat isAtStreamEnd not ] ].
 scripter doStep: [ :step | step block: [ :chat |
  | viewport first |
  viewport := chat messageViewport.
  first := viewport children first.
  anchor := { viewport layout childPositionOf: first. first bounds inParent top }.
  GtLACPExamples new sendUpdate: { 'sessionUpdate' -> 'agent_message_chunk'.
   'content' -> { 'type' -> 'text'. 'text' -> 'New content while reading earlier messages.' } asDictionary } asDictionary to: session ] ].
 scripter assertStep: [ :step | step satisfies: [ :chat |
  | viewport first |
  viewport := chat messageViewport.
  first := viewport children first.
  chat isAtStreamEnd not and: [
   { viewport layout childPositionOf: first. first bounds inParent top } = anchor ] ] ].
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> streamRecreatesMessageElement [
 <gtExample>
 | chat session scripter originalRow originalModel |
 chat := self chatWithToolCalls.
 session := chat viewModel session.
 scripter := BlScripter new extent: 1000 @ 1000; model: session; element: chat; yourself.
 scripter click id: #'acp-work-toggle'; play.
 scripter click id: #'acp-final-toggle'; play.
 scripter assertStep: [ :step | step id: #'acp-message-2'; satisfies: [ :row |
  originalRow := row.
  originalModel := row viewModel.
  true ] ].
 scripter doStep: [ :step | step block: [ :element |
  GtLACPExamples new sendUpdate: { 'sessionUpdate' -> 'agent_message_chunk'.
   'content' -> { 'type' -> 'text'. 'text' -> ' More progress.' } asDictionary } asDictionary to: session.
  element updateMessages ] ].
 scripter assertStep: [ :step | step id: #'acp-message-2'; satisfies: [ :row |
  row ~~ originalRow and: [ row viewModel == originalModel ] ] ].
 scripter assertStep: [ :step | step id: #'acp-work-section'; satisfies: #isExpanded ].
 scripter assertStep: [ :step | step id: #'acp-tool-tool-1'; exists ].
 scripter assertStep: [ :step | step id: #'acp-final-section'; satisfies: #isExpanded ].
 scripter assertStep: [ :step | step id: #'acp-final-content'; satisfies: [ :pane |
  pane children anySatisfy: [ :child | (child isKindOf: BrEditor) and: [
   child text asString endsWith: ' More progress.' ] ] ] ].
 self assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> streamResumesFollowingAtBottom [
 <gtExample>
 | scripter session |
 scripter := self streamPreservesReadingPosition.
 session := scripter model.
 scripter doStep: [ :step | step block: [ :chat | chat messageViewport scrollBy: 0 @ 100000 ] ].
 scripter assertStep: [ :step | step satisfies: [ :chat | chat isAtStreamEnd ] ].
 scripter doStep: [ :step | step block: [ :chat |
  GtLACPExamples new sendUpdate: { 'sessionUpdate' -> 'agent_message_chunk'.
   'content' -> { 'type' -> 'text'. 'text' -> (String streamContents: [ :stream |
    1 to: 12 do: [ :index | stream nextPutAll: 'Following resumed'; lf ] ]) } asDictionary } asDictionary to: session ] ].
 scripter assertStep: [ :step | step satisfies: [ :chat | chat isAtStreamEnd ] ].
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> streamingUpdatesVisibleText [
 <gtExample>
 | scripter session turn |
 scripter := self typedMessage.
 session := scripter model.
 scripter click id: #'acp-action'; play.
 turn := session currentTurn.
 scripter doStep: [ :step | step block: [ :element |
  GtLACPExamples new sendUpdate: { 'sessionUpdate' -> 'agent_message_chunk'.
   'content' -> { 'type' -> 'text'. 'text' -> 'First ' } asDictionary } asDictionary to: session ] ].
 scripter assertStep: [ :step |
  step id: #'acp-final-preview'; satisfies: [ :row |
   row text asString = 'First ' ] ].
 scripter doStep: [ :step | step block: [ :element |
  GtLACPExamples new sendUpdate: { 'sessionUpdate' -> 'agent_message_chunk'.
   'content' -> { 'type' -> 'text'. 'text' -> 'second' } asDictionary } asDictionary to: session ] ].
 scripter assertStep: [ :step |
  step id: #'acp-final-preview'; satisfies: [ :row |
   row text asString = 'First second' ] ].
 scripter doStep: [ :step | step block: [ :element |
  session connection transport receive: { 'jsonrpc' -> '2.0'. 'id' -> turn request id.
   'result' -> { 'stopReason' -> 'end_turn' } asDictionary } asDictionary ] ].
 scripter assertStep: [ :step |
  step id: #'acp-action'; satisfies: [ :button | button isEnabled not ] ].
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> toolCallLineSurvivesStreaming [
 <gtExample>
 | scripter session tool originalSummary |
 scripter := self toolCallsShownAsLines.
 session := scripter model.
 tool := session currentTurn toolCalls first.
 originalSummary := tool summary.
 scripter doStep: [ :step | step block: [ :chat |
  GtLACPExamples new sendUpdate: { 'sessionUpdate' -> 'tool_call_update'.
   'toolCallId' -> tool id. 'title' -> 'Read updated directory'. 'status' -> 'completed'.
   'rawOutput' -> { 'files' -> 3 } asDictionary } asDictionary to: session.
  chat updateMessages ] ].
 scripter assertStep: [ :step | step id: #'acp-tool-summary-tool-1'; satisfies: [ :label |
  label text asString = tool summary and: [ label text asString ~= originalSummary ] ] ].
 scripter assertStep: [ :step | step id: #'acp-tool-tool-1'; satisfies: [ :row |
  (row isKindOf: BrExpander) not ] ].
 scripter assertStep: [ :step | step id: #'acp-tool-inspector-tool-1'; notExists ].
 self assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> toolCallOpensOnRight [
 <gtExample>
 | chat session tool scripter |
 chat := self chatWithToolCalls.
 session := chat viewModel session.
 tool := session currentTurn toolCalls first.
 scripter := BlScripter new extent: 1400 @ 900; model: session;
  element: (GtPagerSettings usedPager createWrappedOn: (GtInspector forObject: chat)); yourself.
 scripter click id: #'acp-work-toggle'; play.
 scripter click id: #'acp-tool-summary-tool-1'; play.
 scripter assertStep: [ :step |
  step onPagerPaneWithIndex: 2; // GtInspector;
   satisfies: [ :inspector | inspector object == tool ] ].
 self assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> toolCallWorkingLabel [
 <gtExample>
 | scripter session tool |
 scripter := self workingAssistantHeader.
 session := scripter model.
 tool := session currentTurn toolCalls first.
 scripter click id: #'acp-work-summary'; play.
 scripter assertStep: [ :step | step id: #'acp-tool-summary-tool-1';
  value: [ :label | label text asString ]
  equals: [ tool shortDescription, ' · permission required' ] ].
 scripter click id: #'acp-permission-allow'; play.
 scripter assertStep: [ :step | step id: #'acp-tool-summary-tool-1';
  value: [ :label | label text asString ] equals: [ tool shortDescription ] ].
 #('in_progress' 'running') do: [ :status |
  scripter doStep: [ :step | step block: [ :element |
   GtLACPExamples new sendUpdate: { 'sessionUpdate' -> 'tool_call_update'.
    'toolCallId' -> tool id. 'status' -> status } asDictionary to: session ] ].
  scripter assertStep: [ :step | step id: #'acp-tool-summary-tool-1';
   value: [ :label | label text asString ]
   equals: [ tool shortDescription, ' · working' ] ] ].
 scripter doStep: [ :step | step block: [ :element |
  GtLACPExamples new sendUpdate: { 'sessionUpdate' -> 'tool_call_update'.
   'toolCallId' -> tool id. 'status' -> 'completed' } asDictionary to: session ] ].
 scripter assertStep: [ :step | step id: #'acp-tool-summary-tool-1';
  value: [ :label | label text asString ] equals: [ tool shortDescription ] ].
 self assert: tool status equals: 'completed'.
 self assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> toolCallsShownAsLines [
 <gtExample>
 | element scripter tool |
 element := self chatWithToolCalls.
 tool := element viewModel session currentTurn toolCalls first.
 scripter := BlScripter new model: element viewModel session; element: element; yourself.
 scripter click id: #'acp-work-toggle'; play.
 scripter assertStep: [ :step | step id: #'acp-work-summary'; notExists ].
 scripter assertStep: [ :step | step id: #'acp-tool-kind-tool-1'; satisfies: [ :label |
  label text asString = 'tool' ] ].
 scripter assertStep: [ :step | step id: #'acp-tool-summary-tool-1'; satisfies: [ :label |
  label class = BrLabel and: [ label text asString = tool summary ] ] ].
 scripter assertStep: [ :step | step id: #'acp-tool-tool-1'; satisfies: [ :row |
  (row isKindOf: BrExpander) not ] ].
 scripter assertStep: [ :step | step id: #'acp-tool-toggle-tool-1'; notExists ].
 scripter assertStep: [ :step | step id: #'acp-tool-inspector-tool-1'; notExists ].
 scripter assertStep: [ :step | step id: #'acp-permission-allow'; exists ].
 self assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> typedMessage [
 <gtExample>
 | element scripter |
 element := self emptyChat.
 scripter := BlScripter new model: element viewModel session; element: element; yourself.
 scripter requestFocus id: #'acp-input'; play.
 scripter typeStep: [ :step | step text: 'Hello ACP' ].
 scripter assertStep: [ :step |
  step id: #'acp-input'; value: [ :editor | editor text asString ] equals: [ 'Hello ACP' ] ].
 scripter assertStep: [ :step |
  step id: #'acp-action'; satisfies: [ :button | button isEnabled ] ].
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> unchangedRowsSurviveStreamingAndNewTurn [
 <gtExample>
 | chat session scripter userRow assistantRow userChildren assistantChildren |
 chat := self completedChat.
 session := chat viewModel session.
 scripter := BlScripter new extent: 1000 @ 1000; model: session; element: chat; yourself.
 scripter assertStep: [ :step | step id: #'acp-message-1'; satisfies: [ :row |
  userRow := row. userChildren := row children asArray. true ] ].
 scripter assertStep: [ :step | step id: #'acp-message-2'; satisfies: [ :row |
  assistantRow := row. assistantChildren := row children asArray. true ] ].
 scripter mouseMoveOverStep: [ :step | step id: #'acp-message-2' ].
 scripter doStep: [ :step | step block: [ :element |
  session prompt: 'Another question'.
  element updateMessages ] ].
 scripter assertStep: [ :step | step id: #'acp-message-1'; satisfies: [ :row |
  row == userRow and: [ row children asArray = userChildren ] ] ].
 scripter assertStep: [ :step | step id: #'acp-message-2'; satisfies: [ :row |
  row == assistantRow and: [ row children asArray = assistantChildren ] ] ].
 scripter doStep: [ :step | step block: [ :element |
  GtLACPExamples new sendUpdate: { 'sessionUpdate' -> 'agent_message_chunk'.
   'content' -> { 'type' -> 'text'. 'text' -> 'Streaming into the new reply.' } asDictionary } asDictionary to: session.
  element updateMessages ] ].
 scripter assertStep: [ :step | step id: #'acp-message-1'; satisfies: [ :row | row == userRow ] ].
 scripter assertStep: [ :step | step id: #'acp-message-2'; satisfies: [ :row |
  row == assistantRow and: [
   ((row childNamed: #'acp-message-header') childNamed: #'acp-timestamp') visibility = BlVisibility visible ] ] ].
 scripter assertStep: [ :step | step id: #'acp-message-4'; exists ].
 self assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> userMessageElement [
 <gtExample>
 | turn message element scripter |
 turn := GtLACPExamples new streamedTurn.
 message := turn userMessages first.
 element := message asElement.
 self assert: element class equals: GtLACPUserMessageElement.
 self assert: element viewModel message == message.
 self assert: element viewModel label equals: 'You'.
 scripter := BlScripter new model: turn session; element: element; yourself.
 scripter assertStep: [ :step | step id: #'acp-user-preview'; satisfies: [ :editor |
  editor text asString = message text ] ].
 ^ element
]

{ #category : #examples }
GtLACPChatExamples >> viewModelCreatesMessageElement [
 <gtExample>
 | chat model element originalChildren scripter |
 chat := self chatWithToolCalls.
 model := chat viewModel messageViewModels last.
 element := model asElement.
 self assert: element class equals: GtLACPAssistantMessageElement.
 self assert: element viewModel == model.
 self assert: element children isNotEmpty.
 originalChildren := element children asArray.
 element viewModel: model.
 self assert: element children asArray equals: originalChildren.
 scripter := BlScripter new model: model; element: element; yourself.
 scripter assertStep: [ :step | step id: #'acp-final-preview'; exists ].
 self assert: element children asArray equals: originalChildren.
 self assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> workingAssistantHeader [
 <gtExample>
 | permission session scripter |
 permission := GtLACPExamples new pendingPermission.
 session := permission session.
 scripter := BlScripter new model: session; element: session asElement; yourself.
 scripter assertStep: [ :step | step id: #'acp-message-1'; satisfies: [ :row |
  (row childNamed: #'acp-message-header') children noneSatisfy: [ :each |
   each id asSymbol = #'acp-work-indicator' ] ] ].
 scripter assertStep: [ :step | step id: #'acp-message-2'; satisfies: [ :row |
  | header |
  header := row childNamed: #'acp-message-header'.
  (header childNamed: #'acp-work-indicator') text asString = 'Working…'
   and: [ row children size = 2 ] ] ].
 self assertNoRenderingErrorsIn: scripter.
 ^ scripter
]
