"
I exercise the distinction between streamed assistant commentary, final answers, reasoning and child coordination using deterministic Claude- and Codex-shaped protocol updates.
"
Class {
	#name : #GtLACPMessagePresentationExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #examples }
GtLACPMessagePresentationExamples >> cancelledAndFailedOutputStaysInWork [
 <gtExample>
 | cancelled failed |
 cancelled := GtLACPExamples new session.
 cancelled prompt: 'A cancellable task'.
 self text: 'Partial progress.' id: 'cancelled-progress' in: cancelled.
 cancelled cancelTurn.
 cancelled connection transport receive: { 'jsonrpc' -> '2.0'. 'id' -> cancelled currentTurn request id.
  'result' -> { 'stopReason' -> 'cancelled' } asDictionary } asDictionary.
 failed := GtLACPExamples new session.
 failed prompt: 'A failing task'.
 self text: 'More partial progress.' id: 'failed-progress' in: failed.
 failed connection transport receive: { 'jsonrpc' -> '2.0'. 'id' -> failed currentTurn request id.
  'error' -> { 'code' -> -32603. 'message' -> 'Fixture failure' } asDictionary } asDictionary.
 { cancelled. failed } do: [ :session |
  self assert: session currentTurn assistantMessage finalMessages isEmpty.
  self assert: session currentTurn assistantMessage localActivityItems size equals: 1 ].
 ^ { cancelled. failed }
]

{ #category : #examples }
GtLACPMessagePresentationExamples >> childLaunchAcknowledgementIsCoordination [
 <gtExample>
 | root child examples |
 root := GtLACPExamples new session.
 root prompt: 'Delegate'.
 examples := GtLACPSubagentExamples new.
 child := examples announce: 'launched-worker' title: 'Worker' in: root.
 examples update: { 'sessionUpdate' -> 'session_message'.
  'messageId' -> 'launch:reply'. 'senderSessionId' -> child remoteSessionId.
  'recipientSessionId' -> root remoteSessionId.
  'content' -> { { 'type' -> 'text'. 'text' -> 'Async agent launched successfully.' } asDictionary }
 } asDictionary for: root.
 self assert: root currentTurn inputMessages size equals: 1.
 self assert: root asChatViewModel messageViewModels size equals: 2.
 self assert: root interSessionMessages size equals: 1.
 ^ root
]

{ #category : #examples }
GtLACPMessagePresentationExamples >> claudeCompletedConversation [
 <gtExample>
 | root child |
 root := self claudeWorkInProgress.
 self finishClaudeWork: root.
 child := root childSessions first.
 self assert: root currentTurn assistantMessage text equals: 'The system is ready.'.
 self assert: root currentTurn finalMessage messageId equals: 'parent-answer'.
 self assert: root currentTurn assistantMessage localActivityItems size equals: 3.
 self assert: child currentTurn assistantMessage text equals: 'The implementation is complete.'.
 self assert: child currentTurn assistantMessage localActivityItems first text equals: 'I am checking the implementation.'.
 self assert: root currentTurn inputMessages size equals: 1.
 self assert: root asChatViewModel messageViewModels size equals: 2.
 ^ root
]

{ #category : #examples }
GtLACPMessagePresentationExamples >> claudeWorkDisplayed [
 <gtExample>
 | root scripter |
 root := self claudeWorkInProgress.
 scripter := BlScripter new extent: 1100 @ 900; model: root; element: root asElement; yourself.
 scripter assertStep: [ :step | step id: #'acp-final-section'; notExists ].
 scripter assertStep: [ :step | step id: #'acp-message-3'; notExists ].
 scripter click id: #'acp-work-toggle'; play.
 scripter assertStep: [ :step | step id: #'acp-work-content';
  satisfies: [ :pane | | texts |
   texts := (GtLACPSessionExamples new editorsIn: pane) collect: [ :editor | editor text asString ].
   (texts includes: 'I will launch a worker.') and: [
    (texts includes: 'The worker is running.') and: [
     (texts includes: 'Async agent launched successfully.') not ] ] ] ].
 scripter doStep: [ :step | step block: [ self finishClaudeWork: root ] ].
 scripter pulseUntilReady.
 scripter assertStep: [ :step | step id: #'acp-final-content';
  satisfies: [ :pane | (GtLACPSessionExamples new editorsIn: pane)
   anySatisfy: [ :editor | editor text asString = 'The system is ready.' ] ] ].
 scripter assertStep: [ :step | step id: #'acp-work-content';
  satisfies: [ :pane | (GtLACPSessionExamples new editorsIn: pane)
   anySatisfy: [ :editor | editor text asString = 'The worker has finished.' ] ] ].
 GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPMessagePresentationExamples >> claudeWorkInProgress [
 <gtExample>
 | root child examples |
 root := GtLACPExamples new session.
 root prompt: 'Implement with a worker'.
 examples := GtLACPSubagentExamples new.
 self text: 'I will launch a worker.' id: 'progress-1' in: root.
 child := examples announce: 'claude-worker' title: 'Implementation worker' in: root.
 examples task: 'Implement the class.' from: root to: child id: 'launch-call'.
 examples update: { 'sessionUpdate' -> 'session_message'.
  'messageId' -> 'launch-call:reply'.
  'senderSessionId' -> child remoteSessionId.
  'recipientSessionId' -> root remoteSessionId.
  'content' -> { { 'type' -> 'text'. 'text' -> 'Async agent launched successfully.' } asDictionary }
 } asDictionary for: root.
 self text: 'The worker is running.' id: 'progress-2' in: root.
 self assert: root currentTurn assistantMessage finalMessages isEmpty.
 self assert: root currentTurn inputMessages size equals: 1.
 self assert: root currentTurn assistantMessage localActivityItems size equals: 2.
 self assert: root interSessionMessages size equals: 2.
 self assert: child currentTurn inputMessages first text equals: 'Implement the class.'.
 self assert: (root currentTurn messages select: [ :each | each role = #agent ]) size equals: 2.
 ^ root
]

{ #category : #examples }
GtLACPMessagePresentationExamples >> codexCommentaryAndReasoning [
 <gtExample>
 | root |
 root := GtLACPExamples new session.
 root prompt: 'Review the changes'.
 self text: 'I will check the classes.' id: 'codex-commentary-1' in: root.
 GtLACPSubagentExamples new update: { 'sessionUpdate' -> 'agent_thought_chunk'.
  'messageId' -> 'codex-thought'.
  'content' -> { 'type' -> 'text'. 'text' -> 'Checking the shared contract.' } asDictionary
 } asDictionary for: root.
 self text: 'The checks are running.' id: 'codex-commentary-2' in: root.
 self text: 'All checks passed.' id: 'codex-answer' in: root.
 self assert: root currentTurn assistantMessage finalMessages isEmpty.
 root connection transport receive: { 'jsonrpc' -> '2.0'. 'id' -> root currentTurn request id.
  'result' -> { 'stopReason' -> 'end_turn' } asDictionary } asDictionary.
 self assert: root currentTurn assistantMessage text equals: 'All checks passed.'.
 self assert: root currentTurn assistantMessage localActivityItems size equals: 3.
 self assert: root currentTurn assistantMessage localActivityItems second role equals: #thought.
 self assert: root currentTurn assistantMessage localActivityItems third role equals: #agent.
 ^ root
]

{ #category : #examples }
GtLACPMessagePresentationExamples >> explicitAssistantElementIds [
	<gtExample>
	| model |
	model := self specializedMessageViewModels messageViewModels last.
	self assert: model workSectionId equals: #'acp-work-section'.
	self assert: model workToggleId equals: #'acp-work-toggle'.
	self assert: model finalSectionId equals: #'acp-final-section'.
	self assert: model finalToggleId equals: #'acp-final-toggle'.
	self assert: model workContentId equals: #'acp-work-content'.
	self assert: model workSummaryId equals: #'acp-work-summary'.
	self assert: model workSummaryTextId equals: #'acp-work-summary-text'.
	self
		assert: (model workSummaryCountIdAt: 1)
		equals: #'acp-work-summary-count-1'.
	self
		assert: (model workSummaryCountIdAt: 2)
		equals: #'acp-work-summary-count-2'.
	self assert: model finalTabsId equals: #'acp-final-tabs'.
	self assert: model finalContentId equals: #'acp-final-content'.
	self assert: (model elementIdAt: 2) equals: #'acp-message-2'.
	^ model
]

{ #category : #examples }
GtLACPMessagePresentationExamples >> finishClaudeWork: root [
 | child examples |
 examples := GtLACPSubagentExamples new.
 child := root childSessions first.
 self text: 'I am checking the implementation.' id: 'child-progress' in: child.
 examples update: { 'sessionUpdate' -> 'tool_call'. 'toolCallId' -> 'child-tool'.
  'title' -> 'Inspect implementation'. 'status' -> 'completed' } asDictionary for: child.
 self text: 'The implementation ' id: 'child-answer' in: child.
 self text: 'is complete.' id: 'child-answer' in: child.
 self assert: child currentTurn assistantMessage finalMessages isEmpty.
 examples idle: child.
 self text: 'The worker has finished.' id: 'progress-3' in: root.
 self text: 'The system ' id: 'parent-answer' in: root.
 self text: 'is ready.' id: 'parent-answer' in: root.
 self assert: root currentTurn assistantMessage finalMessages isEmpty.
 root connection transport receive: { 'jsonrpc' -> '2.0'. 'id' -> root currentTurn request id.
  'result' -> { 'stopReason' -> 'end_turn' } asDictionary } asDictionary
]

{ #category : #examples }
GtLACPMessagePresentationExamples >> interSessionInputViewModel [
	<gtExample>
	| child chat model |
	child := GtLACPSubagentExamples new nestedConversations childSessions first.
	chat := child asChatViewModel.
	model := chat messageViewModels first.
	self assert: model class equals: GtLACPInterSessionMessageViewModel.
	self assert: model message == child currentTurn inputMessages first.
	self assert: model asElement class equals: GtLACPInterSessionMessageElement.
	self assert: chat messageViewModels first == model.
	^ model
]

{ #category : #examples }
GtLACPMessagePresentationExamples >> interSessionWorkElements [
	<gtExample>
	| model assistant work elements comment |
	model := self interSessionInputViewModel.
	assistant := GtLACPAssistantMessageElement new.
	assistant viewModel: model.
	work := GtLACPAssistantWorkElement new
			commentElementProvider: [ :message | assistant commentElementFor: message ];
			yourself.
	elements := OrderedCollection new.
	model message addWorkElementsTo: elements in: work.
	comment := elements last.
	self assert: elements size equals: 2.
	self assert: elements first text asString equals: model message chatLabel.
	self assert: elements last == comment.
	self assert: comment class equals: GtLACPAssistantCommentElement.
	self assert: comment message == model message.
	self assert: comment editor text asString equals: model message text.
	self assert: (assistant commentElementFor: model message) == comment.
	^ comment
]

{ #category : #examples }
GtLACPMessagePresentationExamples >> interleavedMessageIdentity [
	<gtExample>
	| root turn message |
	root := GtLACPExamples new session.
	turn := root prompt: 'Keep message identity across tools'.
	self
		text: 'Progress'
		id: 'progress'
		in: root.
	self
		text: 'Answer'
		id: 'answer'
		in: root.
	message := turn messages last.
	GtLACPSubagentExamples new
		update: {'sessionUpdate' -> 'tool_call'.
				'toolCallId' -> 'interleaved-tool'.
				'title' -> 'Check result'.
				'status' -> 'completed'} asDictionary
		for: root.
	self
		text: ' after the tool'
		id: 'answer'
		in: root.
	self assert: turn finalMessage isNil.
	self assert: turn messages last == message.
	root connection transport
		receive: {'jsonrpc' -> '2.0'.
				'id' -> turn request id.
				'result' -> {'stopReason' -> 'end_turn'} asDictionary} asDictionary.
	self assert: turn finalMessage == message.
	self assert: message text equals: 'Answer after the tool'.
	self
		assert: (turn messages select: [ :each | each role = #agent ]) size
		equals: 2.
	^ root
]

{ #category : #examples }
GtLACPMessagePresentationExamples >> messageTextElementRoles [
	<gtExample>
	| chat prompt assistant comment interSession |
	chat := self specializedMessageViewModels.
	prompt := chat messageViewModels first asElement promptContent.
	self assert: prompt class equals: GtLACPMessageTextElement.
	self assert: prompt message == chat messageViewModels first message.
	self assert: prompt children first == prompt editor.
	assistant := chat messageViewModels last asElement.
	comment := assistant commentElementFor: assistant viewModel messages first.
	self assert: comment class equals: GtLACPAssistantCommentElement.
	self assert: comment children first == comment editor.
	self assert: (assistant commentElementFor: comment message) == comment.
	interSession := self interSessionInputViewModel asElement.
	self assert: interSession children last class equals: GtLACPMessageTextElement.
	self
		assert: interSession children last message == interSession viewModel message.
	^ assistant
]

{ #category : #examples }
GtLACPMessagePresentationExamples >> replayedProgressAndAnswers [
 <gtExample>
 | root |
 root := GtLACPExamples new session.
 root connection transport responder: [ :request :transport |
  (request at: 'method' ifAbsent: [ '' ]) = 'session/load' ifTrue: [
   #('one' 'two') do: [ :name |
    root receiveUpdate: { 'sessionUpdate' -> 'user_message_chunk'.
     'messageId' -> ('user-', name).
     'content' -> { 'type' -> 'text'. 'text' -> ('Question ', name) } asDictionary } asDictionary.
    self text: 'Progress ', name id: 'progress-', name in: root.
    self text: 'Answer ', name id: 'answer-', name in: root ].
   transport replyTo: request result: Dictionary new ] ].
 root load: 'replayed-claude-conversation'.
 self assert: root turns size equals: 2.
 root turns with: #('one' 'two') do: [ :turn :name |
  self assert: turn assistantMessage text equals: 'Answer ', name.
  self assert: turn assistantMessage localActivityItems first text equals: 'Progress ', name ].
 ^ root
]

{ #category : #examples }
GtLACPMessagePresentationExamples >> specializedMessageViewModels [
	<gtExample>
	| root chat models assistant interSession |
	root := self claudeWorkInProgress.
	chat := root asChatViewModel.
	models := chat messageViewModels.
	self assert: models first class equals: GtLACPUserMessageViewModel.
	self assert: models last class equals: GtLACPAssistantMessageViewModel.
	self assert: models first asElement class equals: GtLACPUserMessageElement.
	self assert: models last asElement class equals: GtLACPAssistantMessageElement.
	self
		assert: root currentTurn inputMessages first asElement viewModel class
		equals: GtLACPUserMessageViewModel.
	self
		assert: root currentTurn assistantMessage asElement viewModel class
		equals: GtLACPAssistantMessageViewModel.
	interSession := root interSessionMessages first asElement.
	self assert: interSession class equals: GtLACPInterSessionMessageElement.
	self
		assert: interSession viewModel class
		equals: GtLACPInterSessionMessageViewModel.
	assistant := models last.
	assistant workExpanded: true.
	assistant selectedFinalViewTitle: 'Text'.
	self assert: chat messageViewModels first == models first.
	self assert: chat messageViewModels last == assistant.
	self
		text: 'Another progress update.'
		id: 'progress-3'
		in: root.
	self assert: chat messageViewModels last == assistant.
	self assert: assistant isWorkExpanded.
	self assert: assistant selectedFinalViewTitle equals: 'Text'.
	self assert: assistant asElement viewModel == assistant.
	^ chat
]

{ #category : #examples }
GtLACPMessagePresentationExamples >> text: aString id: anId in: aSession [
 GtLACPSubagentExamples new update: {
  'sessionUpdate' -> 'agent_message_chunk'. 'messageId' -> anId.
  'content' -> { 'type' -> 'text'. 'text' -> aString } asDictionary
 } asDictionary for: aSession
]
