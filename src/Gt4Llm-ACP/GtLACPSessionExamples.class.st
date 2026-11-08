"
Executable ACP chat examples, including BlScripter tests for typing, sending, cancellation, keyboard shortcuts, automatic streamed text updates, permission choices and draft preservation on failure.
"
Class {
	#name : #GtLACPSessionExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #assertions }
GtLACPSessionExamples >> assertCloseActionUnavailableIn: aScripter [
	"The session menu remains available even when this session cannot be closed."

	aScripter
		assertStep: [ :step | 
			step
				id: #'acp-session-actions';
				exists ].
	aScripter menuStep
		openDropdownWithId: #'acp-session-actions';
		assertMenuContainerExist;
		play.
	aScripter
		assertStep: [ :step | 
			step
				onSpaceRoot;
				// #'acp-close-session';
				notExists ]
]

{ #category : #assertions }
GtLACPSessionExamples >> assertNoRenderingErrorsIn: aScripter [
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
GtLACPSessionExamples >> assistantHeaderIndicatorDuringStreamingAndCancellation [
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
GtLACPSessionExamples >> assistantHeaderIndicatorStopsOnCompletion [
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
GtLACPSessionExamples >> assistantMessageElement [
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
GtLACPSessionExamples >> assistantSectionChoicesSurviveMessageUpdates [
	<gtExample>
	| element session scripter |
	element := self completedChat.
	session := element viewModel session.
	scripter := BlScripter new
			model: session;
			element: element;
			yourself.
	scripter click
		id: #'acp-final-toggle';
		play.
	scripter
		doStep: [ :step | 
			step
				block: [ :chat | 
					GtLACPExamples new
						sendUpdate: {'sessionUpdate' -> 'agent_thought_chunk'.
								'content'
									-> {'type' -> 'text'.
											'text' -> 'Reasoning continues.'} asDictionary} asDictionary
						to: session.
					GtLACPExamples new
						sendUpdate: {'sessionUpdate' -> 'agent_message_chunk'.
								'content'
									-> {'type' -> 'text'.
											'text' -> 'A new final reply.'} asDictionary} asDictionary
						to: session ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-section';
				satisfies: #isCollapsed ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-final-section';
				satisfies: #isCollapsed ].
	scripter click
		id: #'acp-final-toggle';
		play.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-final-content';
				satisfies: [ :pane | 
					(self editorsIn: pane)
						anySatisfy: [ :child | (child isKindOf: BrEditor) and: [ child text asString = 'A new final reply.' ] ] ] ].
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> assistantSectionsCollapseIndependently [
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
GtLACPSessionExamples >> chatWithToolCalls [
	<gtExample>
	| permission session turn element |
	permission := GtLACPExamples new pendingPermission.
	session := permission session.
	turn := session currentTurn.
	GtLACPExamples new
		sendUpdate: {'sessionUpdate' -> 'agent_message_chunk'.
				'content'
					-> {'type' -> 'text'.
							'text' -> 'I will **inspect the directory** using the following tool.'}
							asDictionary} asDictionary
		to: session.
	turn toolCalls first
		updateFrom: {'rawInput' -> {'path' -> session directory fullName} asDictionary} asDictionary.
	element := session asElement.
	element viewModel messageViewModels last workExpanded: false.
	self assert: element viewModel messageViewModels size equals: 2.
	self
		assert: element viewModel messageViewModels last toolCalls first == permission toolCall.
	^ element
]

{ #category : #examples }
GtLACPSessionExamples >> chatWithToolCallsDisplayed [
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
 scripter assertStep: [ :step | step id: #'acp-work-content'; satisfies: [ :pane |
  (self editorsIn: pane) anySatisfy: [ :child | (child isKindOf: BrEditor) and: [
   child text asString = 'I will **inspect the directory** using the following tool.' ] ] ] ].
 self assertNoRenderingErrorsIn: scripter.
 element updateMessages.
 scripter assertStep: [ :step | step id: #'acp-work-section'; satisfies: [ :section | section isExpanded ] ].
 scripter assertStep: [ :step | step id: #'acp-final-section'; notExists ].
 self assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> chatWithToolCallsStyledLayout [
 <gtExample>
 | element scripter |
 element := self chatWithToolCalls.
 scripter := BlScripter new model: element viewModel session; element: element; yourself.
 scripter click id: #'acp-work-toggle'; play.
 #(800 400 1000 300 800) do: [ :width |
  scripter extent: width @ 600.
  self assertNoRenderingErrorsIn: scripter.
  scripter assertStep: [ :step | step id: #'acp-work-content'; exists ].
  scripter assertStep: [ :step | step id: #'acp-messages'; satisfies: [ :list |
   (list childNamed: #scrollable) state isStartStep ] ] ].
 ^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> closeSessionFromMenuIn: aScripter [
	self openCloseConfirmationIn: aScripter.
	aScripter click
		onSpaceRoot;
		// #'acp-close-session-confirm';
		play
]

{ #category : #examples }
GtLACPSessionExamples >> commentaryBetweenToolCalls [
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
  'sessionUpdate' -> 'agent_message_chunk'. 'messageId' -> 'runtime-answer'.
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
GtLACPSessionExamples >> commentaryRenderedBetweenTools [
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
  (self editorsIn: pane) anySatisfy: [ :child |
   (child isKindOf: BrEditor) and: [ child text asString = 'The runtime is compatible.' ] ] ] ].
 ^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> commentarySelectionSurvivesStreaming [
	<gtExample>
	| scripter session row editor selection |
	scripter := self streamedCommentaryEditor.
	session := scripter model.
	row := (scripter element query // #'acp-message-2') anyOne.
	editor := (self editorsIn: row)
			detect: [ :each | each text asString = 'Hello' ].
	scripter
		doStep: [ :step | 
			step
				block: [ editor selecter
						from: 0 to: 5;
						select ] ].
	selection := editor selection copy.
	scripter
		doStep: [ :step | 
			step
				block: [ GtLACPExamples new
						sendUpdate: {'sessionUpdate' -> 'agent_message_chunk'.
								'messageId' -> 'streamed-commentary'.
								'content'
									-> {'type' -> 'text'.
											'text' -> ' world'} asDictionary} asDictionary
						to: session ] ].
	scripter pulseUntilReady.
	self assert: (scripter element query // #'acp-message-2') anyOne == row.
	self assert: ((self editorsIn: row) identityIncludes: editor).
	self assert: editor text asString equals: 'Hello world'.
	self assert: editor selection equals: selection.
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> compactAssistantHeaders [
	<gtExample>
	| element scripter |
	element := self reasoningBetweenToolCalls.
	element viewModel messageViewModels last finalReplyExpanded: false.
	scripter := BlScripter new
			model: element viewModel session;
			element: element;
			yourself.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-summary';
				value: [ :line | line children collect: [ :label | label text asString ] as: Array ]
					equals: [ #('2 tools' 'Inspect files') ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-final-preview';
				value: [ :editor | editor text asString ]
					equals: [ 'Finished. The project configuration is consistent.' ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-section';
				satisfies: #isCollapsed ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-final-section';
				satisfies: #isCollapsed ].
	scripter click
		id: #'acp-work-summary';
		play.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-content';
				exists ].
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> compactFinalPreview [
	<gtExample>
	| session turn text element scripter |
	session := GtLACPExamples new session.
	text := String
			streamContents: [ :stream | 
				1
					to: 50
					do: [ :index | 
						stream
							nextPutAll: 'Reply line ';
							print: index;
							lf ] ].
	turn := session prompt: 'Give me a long reply'.
	GtLACPExamples new
		sendUpdate: {'sessionUpdate' -> 'agent_message_chunk'.
				'content'
					-> {'type' -> 'text'.
							'text' -> text} asDictionary} asDictionary
		to: session.
	session connection transport
		receive: {'jsonrpc' -> '2.0'.
				'id' -> turn request id.
				'result' -> {'stopReason' -> 'end_turn'} asDictionary} asDictionary.
	element := session asElement.
	element viewModel messageViewModels last finalReplyExpanded: false.
	scripter := BlScripter new
			model: session;
			element: element;
			yourself.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-final-preview';
				satisfies: [ :editor | 
					editor text asString size <= 181
						and: [ editor text asString beginsWith: 'Reply line 1 ' ] ] ].
	scripter click
		id: #'acp-final-toggle';
		play.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-final-content';
				satisfies: [ :pane | 
					(self editorsIn: pane)
						anySatisfy: [ :child | (child isKindOf: BrEditor) and: [ child text asString = text ] ] ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-final-preview';
				notExists ].
	scripter click
		id: #'acp-final-toggle';
		play.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-final-preview';
				exists ].
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> completedChat [
 <gtExample>
 | turn |
 turn := GtLACPExamples new streamedTurn.
 ^ turn session asElement
]

{ #category : #examples }
GtLACPSessionExamples >> completedReplyAppendsToExistingEditor [
	<gtExample>
	| scripter session row editor |
	scripter := self finalReplyRetainsStreamedEditor.
	session := scripter model.
	row := (scripter element query // #'acp-message-2') anyOne.
	editor := (row query // #'acp-final-text') anyOne.
	scripter
		doStep: [ :step | 
			step
				block: [ GtLACPExamples new
						sendUpdate: {'sessionUpdate' -> 'agent_message_chunk'.
								'messageId' -> 'streamed-commentary'.
								'content'
									-> {'type' -> 'text'.
											'text' -> ' again'} asDictionary} asDictionary
						to: session ] ].
	scripter pulseUntilReady.
	self assert: (scripter element query // #'acp-message-2') anyOne == row.
	self assert: (row query // #'acp-final-text') anyOne == editor.
	self assert: editor text asString equals: 'Hello world again'.
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> completedReplyStartsExpanded [
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
GtLACPSessionExamples >> composerAppearance [
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
GtLACPSessionExamples >> composerReturnsToSend [
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
GtLACPSessionExamples >> copySessionIdActionAvailability [
	<gtExample>
	| session selectorsFor |
	session := GtLACPSession new.
	selectorsFor := [ (GtLACPSessionActionTarget actionsForObject: session)
			collect: [ :each | each definingMethod selector ] ].
	self assert: (selectorsFor value includes: #gtCopySessionIdFor:) not.
	session remoteSessionId: ''.
	self assert: (selectorsFor value includes: #gtCopySessionIdFor:) not.
	session := GtLACPExamples new session.
	self assert: (selectorsFor value includes: #gtCopySessionIdFor:).
	session close.
	self assert: (selectorsFor value includes: #gtCopySessionIdFor:).
	^ session
]

{ #category : #examples }
GtLACPSessionExamples >> disclosuresAlignWithText [
	<gtExample>
	| element scripter |
	element := self reasoningBetweenToolCalls.
	element viewModel messageViewModels last finalReplyExpanded: false.
	scripter := BlScripter new
			model: element viewModel session;
			element: element;
			yourself.
	{#prompt -> #'acp-user-preview'.
		#work -> #'acp-work-summary'.
		#final -> #'acp-final-preview'}
		do: [ :pair | 
			scripter
				assertStep: [ :step | 
					step
						id: ('acp-' , pair key asString , '-section') asSymbol;
						satisfies: [ :section | 
							| toggle preview |
							toggle := (section childNamed: #sidebar)
									childNamed: ('acp-' , pair key asString , '-toggle') asSymbol.
							section
								withAllChildrenBreadthFirstDo: [ :child | child id asSymbol = pair value ifTrue: [ preview := child ] ].
							(toggle bounds inSpace center y - preview bounds inSpace center y) abs
								<= 2 ] ] ].
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> draftSurvivesFailure [
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

{ #category : #asserting }
GtLACPSessionExamples >> editorsIn: anElement [
 | editors |
 editors := OrderedCollection new.
 anElement withAllChildrenBreadthFirstDo: [ :each |
  (each isKindOf: BrEditor) ifTrue: [ editors add: each ] ].
 ^ editors
]

{ #category : #examples }
GtLACPSessionExamples >> emptyChat [
 <gtExample>
 | session element |
 session := GtLACPExamples new session.
 element := session asElement.
 self assert: element viewModel session == session.
 self assert: element viewModel messageViewModels isEmpty.
 ^ element
]

{ #category : #examples }
GtLACPSessionExamples >> explicitMessageObjects [
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
GtLACPSessionExamples >> finalReplyExpandsOnCompletion [
 <gtExample>
 | chat session turn scripter |
 chat := self chatWithToolCalls.
 session := chat viewModel session.
 turn := session currentTurn.
 scripter := BlScripter new model: session; element: chat; yourself.
 scripter assertStep: [ :step | step id: #'acp-final-section'; notExists ].
 scripter doStep: [ :step | step block: [ :element |
  GtLACPExamples new sendUpdate: { 'sessionUpdate' -> 'agent_message_chunk'.
   'messageId' -> 'final-reply'.
   'content' -> { 'type' -> 'text'. 'text' -> 'Directory inspection is complete.' } asDictionary } asDictionary to: session.
  session connection transport receive: { 'jsonrpc' -> '2.0'. 'id' -> turn request id.
   'result' -> { 'stopReason' -> 'end_turn' } asDictionary } asDictionary ] ].
 scripter assertStep: [ :step | step id: #'acp-final-section'; satisfies: #isExpanded ].
 scripter assertStep: [ :step | step id: #'acp-final-preview'; notExists ].
 scripter assertStep: [ :step | step id: #'acp-final-content'; satisfies: [ :pane |
  (self editorsIn: pane) anySatisfy: [ :child | (child isKindOf: BrEditor) and: [
   child text asString = turn assistantMessage text ] ] ] ].
 scripter assertStep: [ :step | step id: #'acp-work-section'; satisfies: #isCollapsed ].
 self assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> finalReplyManualCollapsePersists [
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
GtLACPSessionExamples >> finalReplyRetainsStreamedEditor [
	<gtExample>
	| scripter session turn row editor |
	scripter := self streamAppendsToExistingCommentaryEditor.
	session := scripter model.
	turn := session currentTurn.
	row := (scripter element query // #'acp-message-2') anyOne.
	editor := (self editorsIn: row)
			detect: [ :each | each text asString = 'Hello world' ].
	scripter
		doStep: [ :step | 
			step
				block: [ session connection transport
						receive: {'jsonrpc' -> '2.0'.
								'id' -> turn request id.
								'result' -> {'stopReason' -> 'end_turn'} asDictionary} asDictionary ] ].
	scripter pulseUntilReady.
	self assert: session isReady.
	self assert: (scripter element query // #'acp-message-2') anyOne == row.
	self assert: (row query // #'acp-final-text') anyOne == editor.
	self assert: editor text asString equals: 'Hello world'.
	self assert: (row query // #'acp-final-section') anyOne isExpanded.
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> keyboardSend [
 <gtExample>
 | scripter |
 scripter := self typedMessage.
 scripter shortcut id: #'acp-input'; combination: BlKeyCombination primaryReturn; play.
 self assert: scripter model turns size equals: 1.
 self assert: scripter model currentTurn messages first text equals: 'Hello ACP'.
 ^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> lastMessageLayoutKeepsStreamEnd [
 <gtExample>
 | scripter |
 scripter := self longStreamingChat.
 scripter doStep: [ :step |
  step label: 'Grow the last row after the initial scroll has completed';
   block: [ :chat | | last |
    last := chat messageViewport layout childAtPosition: chat viewModel messageViewModels size.
    self assert: last notNil.
    last vExact: last height + 200 ] ].
 scripter assertStep: [ :step |
  step label: 'Follow the end after a later layout without another message update';
   satisfies: [ :chat | chat isAtStreamEnd ] ].
 self assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> logicalScrollReachesEndOfTallReply [
 <gtExample>
 | session turn text chat scripter |
 session := GtLACPExamples new session.
 text := String streamContents: [ :stream |
  1 to: 60 do: [ :index | stream nextPutAll: 'Reply line '; print: index; lf ] ].
 turn := session prompt: 'Give me a tall reply'.
 GtLACPExamples new sendUpdate: { 'sessionUpdate' -> 'agent_message_chunk'.
  'content' -> { 'type' -> 'text'. 'text' -> text } asDictionary } asDictionary to: session.
 session connection transport receive: { 'jsonrpc' -> '2.0'. 'id' -> turn request id.
  'result' -> { 'stopReason' -> 'end_turn' } asDictionary } asDictionary.
 chat := session asElement.
 scripter := BlScripter new extent: 1000 @ 700; model: session; element: chat; yourself.
 scripter assertStep: [ :step | step satisfies: [ :element | element isAtStreamEnd ] ].
 scripter assertStep: [ :step | step id: #'acp-stream-end';
  satisfies: [ :marker |
   chat messageViewport bounds inSpace asRectangle containsPoint: marker bounds inSpace center ] ].
 self assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> logicalScrollTargetSurvivesNewTurns [
 <gtExample>
 | chat session scripter marker items row |
 chat := self completedChat.
 session := chat viewModel session.
 scripter := BlScripter new extent: 1000 @ 800; model: session; element: chat; yourself.
 marker := chat endMarker.
 items := chat listElement items.
 self assert: items size equals: chat viewModel messageViewModels size + 1.
 self assert: items last == marker.
 self assert: (chat viewModel messageViewModels includes: marker) not.
 scripter assertStep: [ :step | step id: #'acp-stream-end'; exists ].
 scripter assertStep: [ :step | step id: #'acp-message-2';
  satisfies: [ :element | row := element. true ] ].
 scripter doStep: [ :step | step block: [
  session prompt: 'Another question'.
  chat updateMessages ] ].
 scripter assertStep: [ :step | step id: #'acp-message-2';
  satisfies: [ :element | element == row ] ].
 self assert: chat listElement items == items.
 self assert: items size equals: chat viewModel messageViewModels size + 1.
 self assert: items last == marker.
 self assert: (items count: [ :each | each == marker ]) equals: 1.
 scripter assertStep: [ :step | step id: #'acp-stream-end'; exists ].
 self assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> longStreamingChat [
	<gtExample>
	| session turn examples text element scripter |
	examples := GtLACPExamples new.
	session := examples session.
	text := String
			streamContents: [ :stream | 
				1
					to: 12
					do: [ :index | 
						stream
							nextPutAll: 'Line ';
							print: index;
							nextPutAll: ' of the assistant response.';
							lf ] ].
	1
		to: 8
		do: [ :index | 
			turn := session prompt: 'Question ' , index asString.
			examples
				sendUpdate: {'sessionUpdate' -> 'agent_message_chunk'.
						'content'
							-> {'type' -> 'text'.
									'text' -> text} asDictionary} asDictionary
				to: session.
			session connection transport
				receive: {'jsonrpc' -> '2.0'.
						'id' -> turn request id.
						'result' -> {'stopReason' -> 'end_turn'} asDictionary} asDictionary ].
	session prompt: 'Keep streaming'.
	examples
		sendUpdate: {'sessionUpdate' -> 'agent_message_chunk'.
				'content'
					-> {'type' -> 'text'.
							'text' -> text} asDictionary} asDictionary
		to: session.
	element := session asElement.
	scripter := BlScripter new
			model: session;
			element: element;
			yourself.
	scripter assertStep: [ :step | step satisfies: [ :chat | chat isAtStreamEnd ] ].
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> messageAssignmentIsIdempotent [
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
GtLACPSessionExamples >> messageAtRest [
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
GtLACPSessionExamples >> messageHoverLeaves [
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
GtLACPSessionExamples >> messageHovered [
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
GtLACPSessionExamples >> messageSpecificRows [
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

{ #category : #'examples - streaming' }
GtLACPSessionExamples >> newCommentaryKeepsEarlierEditor [
	<gtExample>
	| scripter session row first parent |
	scripter := self streamAppendsToExistingCommentaryEditor.
	session := scripter model.
	row := (scripter element query // #'acp-message-2') anyOne.
	first := (self editorsIn: row)
			detect: [ :each | each text asString = 'Hello world' ].
	parent := first parent.
	scripter
		doStep: [ :step | 
			step
				block: [ GtLACPExamples new
						sendUpdate: {'sessionUpdate' -> 'agent_message_chunk'.
								'messageId' -> 'second-commentary'.
								'content'
									-> {'type' -> 'text'.
											'text' -> 'A separate message.'} asDictionary} asDictionary
						to: session ] ].
	self assert: (scripter element query // #'acp-message-2') anyOne == row.
	self assert: ((self editorsIn: row) identityIncludes: first).
	self assert: first parent == parent.
	self assert: first text asString equals: 'Hello world'.
	self
		assert: ((self editorsIn: row)
				anySatisfy: [ :editor | editor ~~ first and: [ editor text asString = 'A separate message.' ] ]).
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> newTurnFollowsBottom [
 <gtExample>
 | scripter session |
 scripter := self longStreamingChat.
 session := scripter model.
 scripter doStep: [ :step | step block: [ :chat |
  session connection transport receive: { 'jsonrpc' -> '2.0'. 'id' -> session currentTurn request id.
   'result' -> { 'stopReason' -> 'end_turn' } asDictionary } asDictionary.
  session prompt: 'A new question at the end' ] ].
 scripter assertStep: [ :step | step satisfies: [ :chat |
  chat isAtStreamEnd and: [ chat viewModel messageViewModels size = 20 ] ] ].
 ^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> newTurnPreservesReadingPosition [
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

{ #category : #updating }
GtLACPSessionExamples >> olderMessageChangeRefreshesOnlyItsRow [
	<gtExample>
	| scripter session firstRow secondRow lastRow |
	scripter := self unchangedRowsSurviveStreamingAndNewTurn.
	session := scripter model.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-message-1';
				satisfies: [ :row | 
					firstRow := row.
					true ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-message-2';
				satisfies: [ :row | 
					secondRow := row.
					true ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-message-4';
				satisfies: [ :row | 
					lastRow := row.
					true ] ].
	scripter
		doStep: [ :step | 
			step
				block: [ :element | 
					session announceMessageChanged: session turns first assistantMessage.
					element updateMessages ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-message-1';
				satisfies: [ :row | row == firstRow ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-message-2';
				satisfies: [ :row | row == secondRow and: [ row viewModel == secondRow viewModel ] ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-message-4';
				satisfies: [ :row | row == lastRow ] ].
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> openCloseConfirmationIn: aScripter [
	aScripter menuStep
		openDropdownWithId: #'acp-session-actions';
		assertMenuContainerExist;
		play.
	aScripter menuStep
		hoverMenuItemWithId: #'acp-close-session';
		onPopover;
		play
]

{ #category : #examples }
GtLACPSessionExamples >> openRenameFormIn: aScripter [
	aScripter menuStep
		openDropdownWithId: #'acp-session-actions';
		assertMenuContainerExist;
		play.
	aScripter menuStep
		hoverMenuItemWithId: #'acp-rename-session';
		onPopover;
		play
]

{ #category : #examples }
GtLACPSessionExamples >> permissionButtons [
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
GtLACPSessionExamples >> preStyledMessageText [
	<gtExample>
	| messageElement editor |
	messageElement := self chatWithToolCalls viewModel session currentTurn
			assistantMessage asElement.
	editor := messageElement textElementFor: '**Already styled**'.
	self assert: (editor styler isKindOf: BlTextNullStyler).
	self
		assert: ((editor text attributesAt: 3)
				anySatisfy: [ :attribute | attribute isKindOf: BlFontWeightAttribute ]).
	^ editor
]

{ #category : #examples }
GtLACPSessionExamples >> reasoningBetweenToolCalls [
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
  'sessionUpdate' -> 'agent_thought_chunk'. 'messageId' -> 'reasoning-after-configuration'.
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
GtLACPSessionExamples >> reasoningRenderedBetweenTools [
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
  (self editorsIn: pane) anySatisfy: [ :child |
   (child isKindOf: BrEditor) and: [ child text asString beginsWith: 'Finished.' ] ] ] ].
 ^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> recoveredCommentaryOrder [
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
GtLACPSessionExamples >> recoveredReasoningOrder [
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
GtLACPSessionExamples >> replayedConversationDisplayed [
 <gtExample>
 | session chat scripter |
 session := GtLACPExamples new fixtureReplayConversation.
 chat := session asElement.
 scripter := BlScripter new extent: 1000 @ 1000; model: session; element: chat; yourself.
 1 to: 4 do: [ :index |
  scripter assertStep: [ :step | step id: ('acp-message-', index asString) asSymbol; exists ] ].
 scripter assertStep: [ :step |
  step id: #'acp-message-2'; id: #'acp-final-content';
   satisfies: [ :pane | (self editorsIn: pane) anySatisfy: [ :child |
    (child isKindOf: BrEditor) and: [ child text asString = 'First answer' ] ] ] ].
 scripter assertStep: [ :step |
  step id: #'acp-message-4'; id: #'acp-final-content';
   satisfies: [ :pane | (self editorsIn: pane) anySatisfy: [ :child |
    (child isKindOf: BrEditor) and: [ child text asString = 'Second answer' ] ] ] ].
 self assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> scrollingUpCancelsPendingFollow [
 <gtExample>
 | scripter |
 scripter := self longStreamingChat.
 scripter doStep: [ :step | step block: [ :chat |
  chat updateMessages.
  chat messageViewport scrollBy: 0 @ -200 ] ].
 scripter assertStep: [ :step | step satisfies: [ :chat | chat isAtStreamEnd not ] ].
 ^ scripter
]

{ #category : #'examples - streaming' }
GtLACPSessionExamples >> secondCommentaryGroupsExistingEditor [
	<gtExample>
	| scripter editor content |
	scripter := self singleCommentaryAppendsWithoutReparenting.
	editor := (scripter element query // #'acp-work-content') anyOne.
	scripter
		doStep: [ :step | 
			step
				block: [ GtLACPExamples new
						sendUpdate: {'sessionUpdate' -> 'agent_message_chunk'.
								'messageId' -> 'second-commentary'.
								'content'
									-> {'type' -> 'text'.
											'text' -> 'Another message'} asDictionary} asDictionary
						to: scripter model ] ].
	content := (scripter element query // #'acp-work-content') anyOne.
	self assert: content children size equals: 2.
	self assert: content children first == editor.
	self assert: editor text asString equals: 'Hello world'.
	self assert: content children second text asString equals: 'Another message'.
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> selectionSurvivesUnrelatedUpdates [
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
GtLACPSessionExamples >> sendAndStop [
	<gtExample>
	| scripter session button |
	scripter := self typedMessage.
	session := scripter model.
	button := scripter element actionButton.
	scripter click
		id: #'acp-action';
		play.
	self assert: session turns size equals: 1.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-input';
				value: [ :editor | editor text asString ] equals: [ '' ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-action';
				satisfies: [ :action | 
					action == button
						and: [ action isEnabled and: [ action label asString = 'Stop' ] ] ] ].
	scripter click
		id: #'acp-action';
		play.
	self assert: session currentTurn isCancelling.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-action';
				satisfies: [ :action | 
					action == button
						and: [ action isEnabled not and: [ action label asString = 'Stopping…' ] ] ] ].
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> sessionActionsMenuCollectsTargetedActions [
	<gtExample>
	| session selectorsFor |
	session := GtLACPExamples new session.
	selectorsFor := [ :aTarget | 
		(aTarget actionsForObject: session)
			collect: [ :each | each definingMethod selector ] ].
	self
		assert: ((selectorsFor value: GtLACPSessionActionTarget) includes: #gtCloseFor:).
	self
		assert: ((selectorsFor value: GtLACPSessionActionTarget) includes: #gtRenameFor:).
	self
		assert: ((selectorsFor value: GtPhlowObjectActionTarget) includes: #gtCloseFor:).
	^ session
]

{ #category : #examples }
GtLACPSessionExamples >> sessionInspectorTool [
	<gtExample>
	| session tool element |
	session := GtLACPExamples new session.
	tool := GtLACPSessionTool forSession: session.
	self assert: tool name equals: 'ACP Session'.
	self assert: tool object == session.
	element := tool asElementDo: [ :widget | widget ].
	self assert: (element isKindOf: GtLACPSessionToolElement).
	self assert: element chat == session.
	self
		assert: ((element childNamed: #header) childNamed: #toolLabel) text asString
		equals: 'ACP Session'.
	self
		assert: (element collectToolViews anySatisfy: [ :view | view title = 'Chat' ]).
	self
		assert: (element collectToolViews
				anySatisfy: [ :view | view title = 'Conversation tree' ]).
	self assertObjectPhlowViewsFor: session.
	^ tool
]

{ #category : #examples }
GtLACPSessionExamples >> sessionMenuCopiesSessionId [
	<gtExample>
	| session element scripter previousClipboard |
	session := GtLACPExamples new session.
	element := (GtLACPSessionTool forSession: session)
			asElementDo: [ :widget | widget ].
	scripter := BlScripter new
			extent: 1100 @ 700;
			model: session;
			element: element;
			yourself.
	previousClipboard := Clipboard clipboardText.
	[ scripter menuStep
		openDropdownWithId: #'acp-session-actions';
		assertMenuContainerExist;
		play.
	scripter click
		onSpaceRoot;
		// #'acp-copy-session-id';
		play.
	self assert: Clipboard clipboardText asString equals: session remoteSessionId ]
		ensure: [ Clipboard clipboardText: previousClipboard ].
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> sessionToolChildCannotCloseSession [
	<gtExample>
	| root child element scripter |
	root := GtLACPSubagentExamples new nestedConversations.
	child := root childSessions first.
	element := (GtLACPSessionTool forSession: child)
			asElementDo: [ :widget | widget ].
	scripter := BlScripter new
			extent: 1100 @ 800;
			model: child;
			element: element;
			yourself.
	self assert: child canClose not.
	self assertCloseActionUnavailableIn: scripter.
	self assert: root isReady.
	self assert: root connection state equals: #ready.
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> sessionToolCloseAsksForConfirmation [
	<gtExample>
	| session element scripter |
	session := GtLACPExamples new session.
	element := (GtLACPSessionTool forSession: session)
			asElementDo: [ :widget | widget ].
	scripter := BlScripter new
			extent: 1100 @ 800;
			model: session;
			element: element;
			yourself.
	self openCloseConfirmationIn: scripter.
	scripter assert
		exists;
		onSpaceRoot;
		// #'acp-close-session-confirmation';
		play.
	scripter assert
		exists;
		onSpaceRoot;
		// #'acp-close-session-confirm';
		play.
	self assert: session isReady.
	self assert: session connection state equals: #ready.
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> sessionToolClosePreservesOtherSessions [
	<gtExample>
	| session other element scripter |
	session := GtLACPExamples new session.
	other := session client
			newSessionIn: session directory
			connection: session connection.
	other create.
	element := (GtLACPSessionTool forSession: session)
			asElementDo: [ :widget | widget ].
	scripter := BlScripter new
			extent: 1100 @ 800;
			model: session;
			element: element;
			yourself.
	self closeSessionFromMenuIn: scripter.
	self assert: session isClosed.
	self assert: other isReady.
	self assert: other canPrompt.
	self assert: session connection state equals: #ready.
	self assert: (session connection sessions at: other remoteSessionId) == other.
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> sessionToolClosesSession [
	<gtExample>
	| scripter session |
	scripter := self sessionToolWithViews.
	session := scripter model.
	self closeSessionFromMenuIn: scripter.
	self assert: session isClosed.
	self assert: session connection state equals: #stopped.
	self assert: session connection pendingRequests isEmpty.
	self
		assert: (session currentTurn permissionRequests
				allSatisfy: [ :each | each state = #cancelled ]).
	scripter pulseUntilReady.
	self assertCloseActionUnavailableIn: scripter.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-message-1';
				exists ].
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> sessionToolForClosedSessionHidesCloseAction [
	<gtExample>
	| session element scripter |
	session := GtLACPExamples new closedSession.
	element := (GtLACPSessionTool forSession: session)
			asElementDo: [ :widget | widget ].
	scripter := BlScripter new
			extent: 1100 @ 800;
			model: session;
			element: element;
			yourself.
	self assert: session canClose not.
	self assertCloseActionUnavailableIn: scripter.
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> sessionToolHeaderFollowsConversationTitle [
	<gtExample>
	| session element scripter |
	session := GtLACPExamples new session.
	element := (GtLACPSessionTool forSession: session)
			asElementDo: [ :widget | widget ].
	scripter := BlScripter new
			extent: 1100 @ 800;
			model: session;
			element: element;
			yourself.
	scripter
		doStep: [ :step | 
			step
				block: [ session
						receiveUpdate: (Dictionary new
								at: 'sessionUpdate' put: 'session_info_update';
								at: 'title' put: 'Renamed conversation';
								yourself) ] ].
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | 
			step
				id: #titleLabel;
				value: [ :label | label text asString ] equals: [ 'Renamed conversation' ] ].
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> sessionToolHeaderKeepsSessionActionsVisibleForLongTitle [
	<gtExample>
	| session element scripter |
	session := GtLACPExamples new session.
	session
		receiveUpdate: (Dictionary new
				at: 'sessionUpdate' put: 'session_info_update';
				at: 'title' put: (String new: 400 withAll: $x);
				yourself).
	element := (GtLACPSessionTool forSession: session)
			asElementDo: [ :widget | widget ].
	scripter := BlScripter new
			extent: 600 @ 400;
			model: session;
			element: element;
			yourself.
	scripter
		assertStep: [ :step | 
			step
				id: #toolbar;
				value: [ :toolbar | toolbar bounds inParent right <= toolbar parent width ]
					equals: [ true ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-session-actions';
				exists ].
	scripter
		assertStep: [ :step | 
			step
				id: #sessionState;
				value: [ :state | 
						state bounds inParent right
							<= (state parent childNamed: #toolbar) bounds inParent left ]
					equals: [ true ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #sessionState;
				value: [ :state | state width > 30 ] equals: [ true ] ].
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> sessionToolHeaderShowsConversationTitle [
	<gtExample>
	| session element scripter |
	session := GtLACPExamples new session.
	self assert: session header equals: session conversationTitle.
	element := (GtLACPSessionTool forSession: session)
			asElementDo: [ :widget | widget ].
	scripter := BlScripter new
			extent: 1100 @ 800;
			model: session;
			element: element;
			yourself.
	scripter
		assertStep: [ :step | 
			step
				id: #toolLabel;
				value: [ :label | label text asString ] equals: [ 'ACP Session' ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #titleLabel;
				value: [ :label | label text asString ]
					equals: [ session conversationTitle ] ].
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> sessionToolHeaderShowsSessionState [
	<gtExample>
	| session element scripter |
	session := GtLACPExamples new session.
	element := (GtLACPSessionTool forSession: session)
			asElementDo: [ :widget | widget ].
	scripter := BlScripter new
			extent: 1100 @ 800;
			model: session;
			element: element;
			yourself.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-session-state-label';
				value: [ :label | label text asString ] equals: [ 'ready' ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-session-state-label';
				value: [ :label | label parent id asSymbol ]
					equals: [ #'acp-session-state-marker' ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #sessionState;
				value: [ :state | 
						state bounds inParent left
							- (state parent childNamed: #titleLabel) bounds inParent right < 30 ]
					equals: [ true ] ].
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> sessionToolHeaderStateFollowsSession [
	<gtExample>
	| session element scripter |
	session := GtLACPExamples new session.
	element := (GtLACPSessionTool forSession: session)
			asElementDo: [ :widget | widget ].
	scripter := BlScripter new
			extent: 1100 @ 800;
			model: session;
			element: element;
			yourself.
	scripter doStep: [ :step | step block: [ session close ] ].
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-session-state-label';
				value: [ :label | label text asString ] equals: [ 'closed' ] ].
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> sessionToolReflectsExternalClose [
	<gtExample>
	| session element scripter |
	session := GtLACPExamples new session.
	element := (GtLACPSessionTool forSession: session)
			asElementDo: [ :widget | widget ].
	scripter := BlScripter new
			extent: 1100 @ 800;
			model: session;
			element: element;
			yourself.
	scripter menuStep
		openDropdownWithId: #'acp-session-actions';
		assertMenuContainerExist;
		play.
	scripter
		assertStep: [ :step | 
			step
				onSpaceRoot;
				// #'acp-close-session';
				exists ].
	(scripter keyPress: BlKeyboardKey escape) play.
	scripter doStep: [ :step | step block: [ session close ] ].
	scripter pulseUntilReady.
	self assertCloseActionUnavailableIn: scripter.
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> sessionToolRenameFormAsksForTitle [
	<gtExample>
	| session element scripter form |
	session := GtLACPExamples new session.
	element := (GtLACPSessionTool forSession: session)
			asElementDo: [ :widget | widget ].
	scripter := BlScripter new
			extent: 1100 @ 800;
			model: session;
			element: element;
			yourself.
	self openRenameFormIn: scripter.
	form := GtLACPRenameSessionForm new
			session: session;
			yourself.
	scripter assert
		exists;
		onSpaceRoot;
		// #'acp-rename-session-form';
		play.
	scripter
		assertStep: [ :step | 
			step
				label: 'Accept stays disabled until the title changes';
				onSpaceRoot;
				// (GtMagritteActionElementId new description: form magritteAcceptAction);
				value: [ :button | button isEnabled ] equals: [ false ] ].
	scripter
		assertStep: [ :step | 
			step
				label: 'The form has no cancel button';
				onSpaceRoot;
				value: [ :root | 
						(root query
							// (GtMagritteActionElementId new description: Object new magritteCancelAction))
							result size ]
					equals: [ 0 ] ].
	self assert: session conversationTitle equals: 'Codex'.
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> sessionToolRenamesSession [
	<gtExample>
	| scripter session form field |
	scripter := self sessionToolRenameFormAsksForTitle.
	session := scripter model.
	form := GtLACPRenameSessionForm new
			session: session;
			yourself.
	field := GtMagritteFieldElementId new description: form titleDescription.
	scripter requestFocus
		onSpaceRoot;
		// field;
		play.
	scripter
		typeStep: [ :step | 
			step
				text: ' renamed';
				onSpaceRoot;
				// field ].
	scripter click
		onSpaceRoot;
		// (GtMagritteActionElementId new description: form magritteAcceptAction);
		play.
	scripter pulseUntilReady.
	scripter menuStep
		assertClosedMenuContainer;
		play.
	self assert: (session conversationTitle includesSubstring: 'renamed').
	scripter
		assertStep: [ :step | 
			step
				id: #titleLabel;
				value: [ :label | label text asString ]
					equals: [ session conversationTitle ] ].
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> sessionToolViewSwitching [
	<gtExample>
	| scripter |
	scripter := self sessionToolWithViews.
	scripter
		clickStep: [ :step | 
			step
				// BrTabGroup;
				// #tabbar;
				onChildFromBlock: [ :bar | bar children detect: [ :tab | tab label asString = 'Conversation tree' ] ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-input';
				notExists ].
	scripter
		assertStep: [ :step | 
			step
				onPhlowCellWithString: scripter model currentTurn userMessages first text;
				exists ].
	scripter
		clickStep: [ :step | 
			step
				// BrTabGroup;
				// #tabbar;
				onChildFromBlock: [ :bar | bar children detect: [ :tab | tab label asString = 'Session' ] ] ].
	scripter
		assertStep: [ :step | 
			step
				onPhlowCellWithString: 'Project directory';
				exists ].
	scripter
		clickStep: [ :step | 
			step
				// BrTabGroup;
				// #tabbar;
				onChildFromBlock: [ :bar | bar children detect: [ :tab | tab label asString = 'Chat' ] ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-input';
				exists ].
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> sessionToolWithViews [
	<gtExample>
	| session element scripter |
	session := self chatWithToolCalls viewModel session.
	element := (GtLACPSessionTool forSession: session)
			asElementDo: [ :widget | widget ].
	scripter := BlScripter new
			extent: 1100 @ 800;
			model: session;
			element: element;
			yourself.
	scripter
		assertStep: [ :step | 
			step
				id: #toolLabel;
				value: [ :label | label text asString ] equals: [ 'ACP Session' ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-input';
				exists ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-message-1';
				exists ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-message-2';
				exists ].
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> sessionWithoutClientHasFallbackTitle [
	<gtExample>
	| session |
	session := GtLACPSession new.
	self assert: session conversationTitle equals: 'ACP session'.
	^ session
]

{ #category : #examples }
GtLACPSessionExamples >> shortToolCallLabels [
	<gtExample>
	| permission session tool title input scripter |
	permission := GtLACPExamples new pendingPermission.
	session := permission session.
	tool := permission toolCall.
	title := 'Read ' , (String new: 120 withAll: $x).
	input := {'path' -> (String new: 200 withAll: $y)} asDictionary.
	tool
		updateFrom: {'title' -> title.
				'rawInput' -> input} asDictionary.
	GtLACPExamples new
		sendUpdate: {'sessionUpdate' -> 'tool_call'.
				'toolCallId' -> 'tool-2'.
				'title' -> 'Another tool'.
				'status' -> 'completed'} asDictionary
		to: session.
	GtLACPExamples new
		sendUpdate: {'sessionUpdate' -> 'tool_call_update'.
				'toolCallId' -> tool id.
				'rawInput' -> input} asDictionary
		to: session.
	self assert: tool shortDescription size equals: 80.
	self assert: (tool shortDescription endsWith: '…').
	self assert: tool title equals: title.
	self assert: (tool data at: 'rawInput') equals: input.
	scripter := BlScripter new
			model: session;
			element: session asElement;
			yourself.
	scripter click
		id: #'acp-work-toggle';
		play.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-summary-text';
				value: [ :label | label text asString ] equals: [ tool shortDescription ] ].
	scripter click
		id: #'acp-work-summary';
		play.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-tool-summary-tool-1';
				value: [ :button | button label asString ] equals: [ tool summary ] ].
	self assert: tool summary equals: tool shortDescription.
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #'examples - streaming' }
GtLACPSessionExamples >> singleCommentaryAppendsWithoutReparenting [
	<gtExample>
	| scripter editor parent |
	scripter := self singleCommentaryUsesEditorAsContent.
	editor := (scripter element query // #'acp-work-content') anyOne.
	parent := editor parent.
	scripter
		doStep: [ :step | 
			step
				block: [ GtLACPExamples new
						sendUpdate: {'sessionUpdate' -> 'agent_message_chunk'.
								'messageId' -> 'only-commentary'.
								'content'
									-> {'type' -> 'text'.
											'text' -> ' world'} asDictionary} asDictionary
						to: scripter model ] ].

	self assert: (scripter element query // #'acp-work-content') anyOne == editor.
	self assert: editor parent == parent.
	self assert: editor text asString equals: 'Hello world'.
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #'examples - streaming' }
GtLACPSessionExamples >> singleCommentaryUsesEditorAsContent [
	<gtExample>
	| session chat scripter |
	session := GtLACPExamples new session.
	session prompt: 'Explain the project'.
	GtLACPExamples new
		sendUpdate: {'sessionUpdate' -> 'agent_message_chunk'.
				'messageId' -> 'only-commentary'.
				'content'
					-> {'type' -> 'text'.
							'text' -> 'Hello'} asDictionary} asDictionary
		to: session.
	chat := session asElement.
	chat viewModel messageViewModels last workExpanded: true.
	scripter := BlScripter new
			extent: 1000 @ 900;
			model: session;
			element: chat;
			yourself.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-content';
				satisfies: [ :content | (content isKindOf: BrEditor) and: [ content text asString = 'Hello' ] ] ].
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> stableAssistantGroup [
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

{ #category : #'examples - streaming' }
GtLACPSessionExamples >> streamAppendsToExistingCommentaryEditor [
	<gtExample>
	| scripter session row editor |
	scripter := self streamedCommentaryEditor.
	session := scripter model.
	row := (scripter element query // #'acp-message-2') anyOne.
	editor := (self editorsIn: row)
			detect: [ :each | each text asString = 'Hello' ].
	scripter
		doStep: [ :step | 
			step
				block: [ GtLACPExamples new
						sendUpdate: {'sessionUpdate' -> 'agent_message_chunk'.
								'messageId' -> 'streamed-commentary'.
								'content'
									-> {'type' -> 'text'.
											'text' -> ' world'} asDictionary} asDictionary
						to: session ] ].
	scripter pulseUntilReady.
	self
		assert: (scripter element query // #'acp-message-2') anyOne == row
		description: 'Streaming must retain the assistant row'.
	self assert: ((self editorsIn: row) identityIncludes: editor).
	self assert: editor text asString equals: 'Hello world'.
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> streamFollowsBottom [
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

{ #category : #updating }
GtLACPSessionExamples >> streamPreservesMessageElement [
	<gtExample>
	| chat session scripter originalRow originalModel |
	chat := self chatWithToolCalls.
	session := chat viewModel session.
	scripter := BlScripter new
			extent: 1000 @ 1000;
			model: session;
			element: chat;
			yourself.
	scripter click
		id: #'acp-work-toggle';
		play.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-message-2';
				satisfies: [ :row | 
					originalRow := row.
					originalModel := row viewModel.
					true ] ].
	scripter
		doStep: [ :step | 
			step
				block: [ :element | 
					GtLACPExamples new
						sendUpdate: {'sessionUpdate' -> 'agent_message_chunk'.
								'content'
									-> {'type' -> 'text'.
											'text' -> ' More progress.'} asDictionary} asDictionary
						to: session.
					element updateMessages ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-message-2';
				satisfies: [ :row | row == originalRow and: [ row viewModel == originalModel ] ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-section';
				satisfies: #isExpanded ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-tool-tool-1';
				exists ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-final-section';
				notExists ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-content';
				satisfies: [ :pane | 
					(self editorsIn: pane)
						anySatisfy: [ :child | 
							(child isKindOf: BrEditor)
								and: [ child text asString endsWith: ' More progress.' ] ] ] ].
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> streamPreservesReadingPosition [
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
GtLACPSessionExamples >> streamResumesFollowingAtBottom [
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
GtLACPSessionExamples >> streamedCommentaryEditor [
	<gtExample>
	| chat session scripter |
	chat := self chatWithToolCalls.
	session := chat viewModel session.
	scripter := BlScripter new
			extent: 1000 @ 1000;
			model: session;
			element: chat;
			yourself.
	scripter click
		id: #'acp-work-toggle';
		play.
	scripter
		doStep: [ :step | 
			step
				block: [ GtLACPExamples new
						sendUpdate: {'sessionUpdate' -> 'agent_message_chunk'.
								'messageId' -> 'streamed-commentary'.
								'content'
									-> {'type' -> 'text'.
											'text' -> 'Hello'} asDictionary} asDictionary
						to: session ] ].
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-content';
				satisfies: [ :pane | (self editorsIn: pane) anySatisfy: [ :editor | editor text asString = 'Hello' ] ] ].
	^ scripter
]

{ #category : #'examples - streaming' }
GtLACPSessionExamples >> streamedMarkdownKeepsExistingEditor [
	<gtExample>
	| scripter session row editor |
	scripter := self streamedCommentaryEditor.
	session := scripter model.
	scripter
		doStep: [ :step | 
			step
				block: [ GtLACPExamples new
						sendUpdate: {'sessionUpdate' -> 'agent_message_chunk'.
								'messageId' -> 'markdown-commentary'.
								'content'
									-> {'type' -> 'text'.
											'text' -> '**bo'} asDictionary} asDictionary
						to: session ] ].
	scripter pulseUntilReady.
	row := (scripter element query // #'acp-message-2') anyOne.
	editor := (self editorsIn: row) detect: [ :each | each text asString = '**bo' ].
	self assert: (editor styler isKindOf: BlTextNullStyler).
	scripter
		doStep: [ :step | 
			step
				block: [ GtLACPExamples new
						sendUpdate: {'sessionUpdate' -> 'agent_message_chunk'.
								'messageId' -> 'markdown-commentary'.
								'content'
									-> {'type' -> 'text'.
											'text' -> 'ld**'} asDictionary} asDictionary
						to: session ] ].
	scripter pulseUntilReady.
	self assert: ((self editorsIn: row) identityIncludes: editor).
	self assert: editor text asString equals: '**bold**'.
	self assert: (editor styler isKindOf: BlTextNullStyler).
	self
		assert: ((editor text attributesAt: 3)
				anySatisfy: [ :attribute | attribute isKindOf: BlFontWeightAttribute ]).
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> streamingUpdatesVisibleText [
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
  step id: #'acp-work-summary-text'; satisfies: [ :row |
   row text asString = 'First ' ] ].
 scripter doStep: [ :step | step block: [ :element |
  GtLACPExamples new sendUpdate: { 'sessionUpdate' -> 'agent_message_chunk'.
   'content' -> { 'type' -> 'text'. 'text' -> 'second' } asDictionary } asDictionary to: session ] ].
 scripter assertStep: [ :step |
  step id: #'acp-work-summary-text'; satisfies: [ :row |
   row text asString = 'First second' ] ].
 scripter doStep: [ :step | step block: [ :element |
  session connection transport receive: { 'jsonrpc' -> '2.0'. 'id' -> turn request id.
   'result' -> { 'stopReason' -> 'end_turn' } asDictionary } asDictionary ] ].
 scripter assertStep: [ :step | step id: #'acp-final-text';
  value: [ :editor | editor text asString ] equals: [ 'First second' ] ].
 scripter assertStep: [ :step |
  step id: #'acp-action'; satisfies: [ :button | button isEnabled not ] ].
 ^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> toolCallLineSurvivesStreaming [
	<gtExample>
	| scripter session tool originalSummary |
	scripter := self toolCallsShownAsLines.
	session := scripter model.
	tool := session currentTurn toolCalls first.
	originalSummary := tool summary.
	scripter
		doStep: [ :step | 
			step
				block: [ :chat | 
					GtLACPExamples new
						sendUpdate: {'sessionUpdate' -> 'tool_call_update'.
								'toolCallId' -> tool id.
								'title' -> 'Read updated directory'.
								'status' -> 'completed'.
								'rawOutput' -> {'files' -> 3} asDictionary} asDictionary
						to: session.
					chat updateMessages ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-tool-summary-tool-1';
				satisfies: [ :label | 
					label label asString = tool summary
						and: [ label label asString ~= originalSummary ] ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-tool-tool-1';
				satisfies: [ :row | (row isKindOf: BrExpander) not ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-tool-inspector-tool-1';
				notExists ].
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> toolCallOpensOnRight [
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
GtLACPSessionExamples >> toolCallWorkingLabel [
	<gtExample>
	| scripter session tool |
	scripter := self workingAssistantHeader.
	session := scripter model.
	tool := session currentTurn toolCalls first.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-tool-summary-tool-1';
				value: [ :label | label label asString ] equals: [ tool shortDescription ] ].
	scripter click
		id: #'acp-permission-allow';
		play.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-tool-summary-tool-1';
				value: [ :label | label label asString ] equals: [ tool shortDescription ] ].
	#('in_progress' 'running')
		do: [ :status | 
			scripter
				doStep: [ :step | 
					step
						block: [ :element | 
							GtLACPExamples new
								sendUpdate: {'sessionUpdate' -> 'tool_call_update'.
										'toolCallId' -> tool id.
										'status' -> status} asDictionary
								to: session ] ].
			scripter
				assertStep: [ :step | 
					step
						id: #'acp-tool-summary-tool-1';
						value: [ :label | label label asString ]
							equals: [ tool shortDescription , ' · working' ] ] ].
	scripter
		doStep: [ :step | 
			step
				block: [ :element | 
					GtLACPExamples new
						sendUpdate: {'sessionUpdate' -> 'tool_call_update'.
								'toolCallId' -> tool id.
								'status' -> 'completed'} asDictionary
						to: session ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-tool-summary-tool-1';
				value: [ :label | label label asString ] equals: [ tool shortDescription ] ].
	self assert: tool status equals: 'completed'.
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> toolCallsShownAsLines [
	<gtExample>
	| element scripter tool |
	element := self chatWithToolCalls.
	tool := element viewModel session currentTurn toolCalls first.
	scripter := BlScripter new
			model: element viewModel session;
			element: element;
			yourself.
	scripter click
		id: #'acp-work-toggle';
		play.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-summary';
				notExists ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-tool-kind-tool-1';
				satisfies: [ :label | label text asString = 'tool' ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-tool-summary-tool-1';
				satisfies: [ :label | 
					label class = BrButton
						and: [ label label asString = tool summary and: [ label border width = 0 ] ] ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-tool-tool-1';
				satisfies: [ :row | (row isKindOf: BrExpander) not ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-tool-toggle-tool-1';
				notExists ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-tool-inspector-tool-1';
				notExists ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-permission-allow';
				exists ].
	self assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> typedMessage [
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
GtLACPSessionExamples >> unchangedRowsSurviveStreamingAndNewTurn [
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
GtLACPSessionExamples >> userMessageElement [
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
GtLACPSessionExamples >> viewModelCreatesMessageElement [
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
 scripter assertStep: [ :step | step id: #'acp-work-summary'; exists ].
 self assert: element children asArray equals: originalChildren.
 self assertNoRenderingErrorsIn: scripter.
 ^ scripter
]

{ #category : #examples }
GtLACPSessionExamples >> workingAssistantHeader [
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
