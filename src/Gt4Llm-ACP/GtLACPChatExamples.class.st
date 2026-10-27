"
Executable ACP chat examples, including BlScripter tests for typing, sending, cancellation, keyboard shortcuts, automatic streamed text updates, permission choices and draft preservation on failure.
"
Class {
	#name : #GtLACPChatExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-Examples'
}

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
 scripter assertStep: [ :step | step id: #'acp-final-preview'; exists ].
 scripter click id: #'acp-work-toggle'; play.
 scripter assertStep: [ :step | step id: #'acp-work-content'; exists ].
 scripter assertStep: [ :step | step id: #'acp-final-section'; satisfies: #isCollapsed ].
 scripter click id: #'acp-final-toggle'; play.
 scripter assertStep: [ :step | step id: #'acp-final-content'; exists ].
 scripter assertStep: [ :step | step id: #'acp-final-preview'; notExists ].
 scripter click id: #'acp-work-toggle'; play.
 scripter assertStep: [ :step | step id: #'acp-work-content'; notExists ].
 scripter assertStep: [ :step | step id: #'acp-final-content'; exists ].
 scripter click id: #'acp-final-toggle'; play.
 scripter assertStep: [ :step | step id: #'acp-final-preview'; exists ].
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
 self assert: (element isKindOf: GtLACPChatElement).
 self assert: element viewModel session == session.
 self assert: (GtPhlowViewTester new testView: (session gtChatFor: GtPhlowView empty)) isOk.
 ^ tool
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
 scripter click id: #'acp-final-toggle'; play.
 scripter assertStep: [ :step |
  step id: #'acp-work-content'; satisfies: [ :pane |
   | children tools commentary |
   children := pane children asArray.
   tools := children select: [ :child | child isKindOf: BrExpander ].
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
GtLACPChatExamples >> permissionButtons [
 <gtExample>
 | element scripter permission |
 element := self chatWithToolCalls.
 permission := element viewModel session currentTurn permissionRequests first.
 scripter := BlScripter new model: element viewModel session; element: element; yourself.
 scripter click id: #'acp-work-toggle'; play.
 scripter click id: #'acp-tool-toggle-tool-1'; play.
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
 scripter click id: #'acp-final-toggle'; play.
 scripter assertStep: [ :step |
  step id: #'acp-work-content'; satisfies: [ :pane |
   | children tools firstThought secondThought |
   children := pane children asArray.
   tools := children select: [ :child | child isKindOf: BrExpander ].
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
GtLACPChatExamples >> sendAndStop [
 <gtExample>
 | scripter session |
 scripter := self typedMessage.
 session := scripter model.
 scripter click id: #'acp-send'; play.
 self assert: session turns size equals: 1.
 scripter assertStep: [ :step |
  step id: #'acp-input'; value: [ :editor | editor text asString ] equals: [ '' ] ].
 scripter assertStep: [ :step |
  step id: #'acp-send'; satisfies: [ :button | button isEnabled not ] ].
 scripter assertStep: [ :step |
  step id: #'acp-stop'; satisfies: [ :button | button isEnabled ] ].
 scripter click id: #'acp-stop'; play.
 self assert: session currentTurn state equals: #cancelling.
 scripter assertStep: [ :step |
  step id: #'acp-stop'; satisfies: [ :button | button isEnabled not ] ].
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
 scripter click id: #'acp-send'; play.
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
  step id: #'acp-stop'; satisfies: [ :button | button isEnabled not ] ].
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> toolCallsCollapsedByDefault [
 <gtExample>
 | element scripter |
 element := self chatWithToolCalls.
 scripter := BlScripter new model: element viewModel session; element: element; yourself.
 scripter click id: #'acp-work-toggle'; play.
 scripter assertStep: [ :step |
  step id: #'acp-tool-tool-1'; satisfies: [ :tool | tool isCollapsed and: [ tool height < 50 ] ] ].
 scripter assertStep: [ :step | step id: #'acp-permission-allow'; notExists ].
 scripter assertStep: [ :step |
  step id: #'acp-message-2'; satisfies: [ :row |
   row children noneSatisfy: [ :child | (child isKindOf: BrLabel) and: [ child text asString = 'Activity' ] ] ] ].
 ^ scripter
]

{ #category : #examples }
GtLACPChatExamples >> toolExpansionSurvivesStreaming [
 <gtExample>
 | scripter session |
 scripter := self toolCallsCollapsedByDefault.
 session := scripter model.
 scripter click id: #'acp-tool-toggle-tool-1'; play.
 scripter assertStep: [ :step | step id: #'acp-tool-tool-1'; satisfies: [ :tool | tool isExpanded ] ].
 scripter assertStep: [ :step | step id: #'acp-permission-allow'; exists ].
 scripter doStep: [ :step | step block: [ :chat |
  GtLACPExamples new sendUpdate: { 'sessionUpdate' -> 'agent_message_chunk'.
   'content' -> { 'type' -> 'text'. 'text' -> ' Additional progress.' } asDictionary } asDictionary to: session ] ].
 scripter assertStep: [ :step | step id: #'acp-tool-tool-1'; satisfies: [ :tool | tool isExpanded ] ].
 scripter click id: #'acp-tool-toggle-tool-1'; play.
 scripter assertStep: [ :step | step id: #'acp-tool-tool-1'; satisfies: [ :tool | tool isCollapsed ] ].
 scripter assertStep: [ :step | step id: #'acp-permission-allow'; notExists ].
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
  step id: #'acp-send'; satisfies: [ :button | button isEnabled ] ].
 ^ scripter
]
