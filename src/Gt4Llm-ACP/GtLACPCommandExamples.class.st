"
I exercise command and skill advertisements, invocation syntax, replacement snapshots, inspector views and chat composition using in-image transports.
"
Class {
	#name : #GtLACPCommandExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #examples }
GtLACPCommandExamples >> advertise: commands in: aSession [
	GtLACPSubagentExamples new
		update: {'sessionUpdate' -> 'available_commands_update'.
				'availableCommands' -> commands} asDictionary
		for: aSession
]

{ #category : #'examples - arguments' }
GtLACPCommandExamples >> advertisedArgumentChoices [
	<gtExample>
	| session |
	session := self argumentSession.
	self
		assert: (session commandNamed: 'effort') argumentChoices
		equals: #('low' 'medium' 'high' 'xhigh' 'max' 'auto').
	self
		assert: (session commandNamed: 'fast') argumentChoices
		equals: #('on' 'off').
	self
		assert: (session commandNamed: 'design') argumentChoices
		equals: #('consent' 'revoke').
	self assert: (session commandNamed: 'model') argumentChoices isEmpty.
	self assert: (session commandNamed: 'review') argumentChoices isEmpty.
	^ session commandNamed: 'effort'
]

{ #category : #fixtures }
GtLACPCommandExamples >> advertisement [
	^ {{'name' -> 'review'.
			'description' -> 'Review the selected changes'.
			'input' -> {'hint' -> 'what to review'} asDictionary} asDictionary.
		{'name' -> 'skills'.
			'description' -> 'List available skills'.
			'input' -> nil} asDictionary.
		{'name' -> 'moldable-review'.
			'description' -> 'Review a moldable implementation'.
			'input' -> nil} asDictionary.
		{'name' -> '$explain-code'.
			'description' -> 'Explain a codebase'.
			'input' -> nil} asDictionary}
]

{ #category : #examples }
GtLACPCommandExamples >> advertisementBeforeSessionResponse [
	<gtExample>
	| transport original client session |
	transport := GtLACPExamples new transport.
	original := transport responder.
	transport
		responder: [ :message :wire | 
			(message at: 'method') = 'session/new'
				ifTrue: [ wire
						receive: {'jsonrpc' -> '2.0'.
								'method' -> 'session/update'.
								'params'
									-> {'sessionId' -> 'early-commands'.
											'update'
												-> {'sessionUpdate' -> 'available_commands_update'.
														'availableCommands' -> self advertisement} asDictionary}
											asDictionary} asDictionary.
					wire
						replyTo: message
						result: {'sessionId' -> 'early-commands'} asDictionary ]
				ifFalse: [ original value: message value: wire ] ].
	client := GtLACPCodexClient new
			transportFactory: [ :configuration :directory | transport ];
			yourself.
	session := client startSessionIn: FileLocator temp.
	self assert: session availableCommands size equals: 4.
	self assert: session skills size equals: 1.
	self assert: session connection pendingCommandAdvertisements isEmpty.
	self assert: session updates last kind equals: 'available_commands_update'.
	^ session
]

{ #category : #examples }
GtLACPCommandExamples >> advertisementsPreserveChatRows [
	<gtExample>
	| session turn chat scripter row version |
	session := GtLACPExamples new session.
	turn := session prompt: 'Hello'.
	chat := session asElement.
	scripter := BlScripter new
			extent: 1100 @ 700;
			model: session;
			element: chat;
			yourself.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-message-2';
				satisfies: [ :element | 
					row := element.
					version := element viewModel renderingVersion.
					true ] ].
	scripter
		doStep: [ :step | step block: [ self advertise: self advertisement in: session ] ].
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-message-2';
				satisfies: [ :element | element == row and: [ element viewModel renderingVersion = version ] ] ].
	self assert: session availableCommands size equals: 4.
	scripter doStep: [ :step | step block: [ self advertise: #() in: session ] ].
	scripter pulseUntilReady.
	self assert: session availableCommands isEmpty.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-message-2';
				satisfies: [ :element | element == row and: [ element viewModel renderingVersion = version ] ] ].
	self assert: session currentTurn == turn.
	GtLACPChatExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #'examples - arguments' }
GtLACPCommandExamples >> argumentCompletion [
	<gtExample>
	| session strategy actions |
	session := self argumentSession.
	strategy := GtLACPInputCompletionStrategy new session: session.
	actions := strategy argumentCompletionActionsFor: '/effort ' asRopedText at: 8.
	self
		assert: (actions collect: #text)
		equals: #('low' 'medium' 'high' 'xhigh' 'max' 'auto').
	self
		assert: ((strategy argumentCompletionActionsFor: '/effort xh suffix' asRopedText at: 10)
				collect: #text)
		equals: #('xhigh').
	self
		assert: (strategy argumentCompletionActionsFor: '/effort high suffix' asRopedText at: 19)
				isEmpty.
	self
		assert: (strategy argumentCompletionActionsFor: '/model ' asRopedText at: 7) isEmpty.
	self
		assert: (strategy argumentCompletionActionsFor: 'hello /effort ' asRopedText at: 14)
				isEmpty.
	self advertise: #() in: session.
	self
		assert: (strategy argumentCompletionActionsFor: '/effort ' asRopedText at: 8) isEmpty.
	^ strategy
]

{ #category : #'examples - arguments' }
GtLACPCommandExamples >> argumentCompletionPreservesSuffix [
	<gtExample>
	| scripter input controller |
	scripter := self chatWithArgumentCommands.
	input := scripter element childWithId: #'acp-input'.
	controller := input userData at: GtCompletionController.
	scripter requestFocus
		id: #'acp-input';
		play.
	scripter
		doStep: [ :step | 
			step
				block: [ input text: '/effort xh keep this'.
					input editor moveCursorTo: 10.
					controller startCompletion ] ].
	scripter pulseUntilReady.
	scripter keyPress
		key: BlKeyboardKey tab;
		play.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-input';
				satisfies: [ :editor | editor text asString = '/effort xhigh keep this' ] ].
	self assert: scripter model turns isEmpty.
	^ scripter
]

{ #category : #'examples - arguments' }
GtLACPCommandExamples >> argumentSession [
	<gtExample>
	| session |
	session := self session.
	self
		advertise: self advertisement
				, {{'name' -> 'effort'.
							'description' -> 'Set effort level'.
							'input' -> {'hint' -> '<low|medium|high|xhigh|max|auto>'} asDictionary}
							asDictionary.
						{'name' -> 'fast'.
							'description' -> 'Toggle fast mode'.
							'input' -> {'hint' -> '[on|off]'} asDictionary} asDictionary.
						{'name' -> 'model'.
							'description' -> 'Set model'.
							'input' -> {'hint' -> '<model>'} asDictionary} asDictionary.
						{'name' -> 'design'.
							'description' -> 'Manage access'.
							'input' -> {'hint' -> 'consent | revoke'} asDictionary} asDictionary}
		in: session.
	^ session
]

{ #category : #'examples - arguments' }
GtLACPCommandExamples >> chatWithArgumentCommands [
	<gtExample>
	| session scripter |
	session := self argumentSession.
	scripter := BlScripter new
			extent: 1100 @ 700;
			model: session;
			element: session asElement;
			yourself.
	^ scripter
]

{ #category : #examples }
GtLACPCommandExamples >> chatWithCommands [
	<gtExample>
	| session scripter |
	session := self session.
	scripter := BlScripter new
			extent: 1100 @ 700;
			model: session;
			element: session asElement;
			yourself.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-composer';
				satisfies: [ :composer | 
					| buttons |
					buttons := OrderedCollection new.
					composer
						withAllChildrenBreadthFirstDo: [ :each | (each isKindOf: BrButton) ifTrue: [ buttons add: each ] ].
					buttons size = 1 ] ].
	GtLACPChatExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPCommandExamples >> claudeCommands [
	<gtExample>
	| client session command |
	client := GtLACPClaudeCodeClient new
			transportFactory: [ :configuration :directory | GtLACPExamples new transport ];
			yourself.
	session := client startSessionIn: FileLocator temp.
	self advertise: {self advertisement third} in: session.
	command := session commandNamed: 'moldable-review'.
	self assert: command class equals: GtLACPCommand.
	self assert: command invocation equals: '/moldable-review'.
	self assert: session skills isEmpty.
	^ command
]

{ #category : #examples }
GtLACPCommandExamples >> codexSkill [
	<gtExample>
	| session skill |
	session := self session.
	skill := session commandNamed: '$explain-code'.
	self assert: skill class equals: GtLACPSkill.
	self assert: skill invocation equals: '$explain-code'.
	self
		assert: (skill promptWith: '  this package  ')
		equals: '$explain-code this package'.
	^ skill
]

{ #category : #examples }
GtLACPCommandExamples >> commandsInSetupResponse [
	<gtExample>
	| transport original client session |
	transport := GtLACPExamples new transport.
	original := transport responder.
	transport
		responder: [ :message :wire | 
			(message at: 'method') = 'session/new'
				ifTrue: [ wire
						replyTo: message
						result: {'sessionId' -> 'commands-in-response'.
								'availableCommands' -> self advertisement} asDictionary ]
				ifFalse: [ original value: message value: wire ] ].
	client := GtLACPCodexClient new
			transportFactory: [ :configuration :directory | transport ];
			yourself.
	session := client startSessionIn: FileLocator temp.
	self assert: session availableCommands size equals: 4.
	session updateSettingsFrom: Dictionary new.
	self assert: session availableCommands size equals: 4.
	session updateSettingsFrom: {'availableCommands' -> #()} asDictionary.
	self assert: session availableCommands isEmpty.
	^ session
]

{ #category : #'examples - arguments' }
GtLACPCommandExamples >> completingEffortInChat [
	<gtExample>
	| scripter input controller |
	scripter := self chatWithArgumentCommands.
	scripter requestFocus
		id: #'acp-input';
		play.
	scripter typeStep: [ :step | step text: '/eff' ].
	input := scripter element childWithId: #'acp-input'.
	controller := input userData at: GtCompletionController.
	scripter space time wait: GtCompletionController popupDelay.
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | step satisfies: [ :element | controller isShowingPopup ] ].
	scripter keyPress
		key: BlKeyboardKey tab;
		play.
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-input';
				satisfies: [ :editor | editor text asString = '/effort ' ] ].
	scripter
		assertStep: [ :step | step satisfies: [ :element | controller isShowingPopup ] ].
	scripter keyPress
		key: BlKeyboardKey tab;
		play.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-input';
				satisfies: [ :editor | editor text asString = '/effort low' ] ].
	self assert: scripter model turns isEmpty.
	self assert: scripter element viewModel draft equals: '/effort low'.
	GtLACPChatExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #'examples - arguments' }
GtLACPCommandExamples >> completingEffortPrefix [
	<gtExample>
	| scripter controller |
	scripter := self chatWithArgumentCommands.
	scripter requestFocus
		id: #'acp-input';
		play.
	scripter typeStep: [ :step | step text: '/effort xh' ].
	controller := (scripter element childWithId: #'acp-input') userData
			at: GtCompletionController.
	scripter space time wait: GtCompletionController popupDelay.
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | step satisfies: [ :element | controller isShowingPopup ] ].
	scripter keyPress
		key: BlKeyboardKey tab;
		play.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-input';
				satisfies: [ :editor | editor text asString = '/effort xhigh' ] ].
	self assert: scripter model turns isEmpty.
	GtLACPChatExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #'examples - completion' }
GtLACPCommandExamples >> completingSkillInChat [
	<gtExample>
	| scripter input controller |
	scripter := self chatWithCommands.
	scripter requestFocus
		id: #'acp-input';
		play.
	scripter typeStep: [ :step | step text: '/ex' ].
	input := scripter element childWithId: #'acp-input'.
	controller := input userData at: GtCompletionController.
	scripter space time wait: GtCompletionController popupDelay.
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | step satisfies: [ :element | controller isShowingPopup ] ].
	scripter
		doStep: [ :step | 
			step
				block: [ controller selectFirst.
					controller completeWithCursor: true ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-input';
				satisfies: [ :editor | editor text asString = '$explain-code' ] ].
	self assert: scripter model turns isEmpty.
	GtLACPChatExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #'examples - arguments' }
GtLACPCommandExamples >> effortArgumentCompletionPopup [
	<gtExample>
	| scripter |
	scripter := self chatWithArgumentCommands.
	scripter requestFocus
		id: #'acp-input';
		play.
	scripter typeStep: [ :step | step text: '/effort ' ].
	scripter space time wait: GtCompletionController popupDelay.
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | 
			step
				onSpaceRoot;
				id: #'completion-list';
				satisfies: [ :list | 
					(list items collect: #text) asArray
						= #('low' 'medium' 'high' 'xhigh' 'max' 'auto') ] ].
	GtLACPChatExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #'examples - completion' }
GtLACPCommandExamples >> inputCompletionStyling [
	<gtExample>
	| styler text |
	styler := GtLACPInputStyler new session: self session.
	text := styler style: '/review arguments' asRopedText.
	self
		assert: ((text attributesAt: 1)
				anySatisfy: [ :attribute | attribute isKindOf: GtCompletionStrategyAttribute ]).
	self
		assert: ((text attributesAt: 9)
				noneSatisfy: [ :attribute | attribute isKindOf: GtCompletionStrategyAttribute ]).
	^ text
]

{ #category : #examples }
GtLACPCommandExamples >> invokeCommand [
	<gtExample>
	| session turn prompt |
	session := self session.
	turn := session invokeCommandNamed: 'review' arguments: 'the ACP package'.
	prompt := session connection transport sentMessages last at: 'params'.
	self
		assert: ((prompt at: 'prompt') first at: 'text')
		equals: '/review the ACP package'.
	self assert: turn session == session.
	^ turn
]

{ #category : #examples }
GtLACPCommandExamples >> invokeSkill [
	<gtExample>
	| session turn prompt |
	session := self session.
	turn := (session commandNamed: '$explain-code') invokeWith: 'the ACP package'.
	prompt := session connection transport sentMessages last at: 'params'.
	self
		assert: ((prompt at: 'prompt') first at: 'text')
		equals: '$explain-code the ACP package'.
	^ turn
]

{ #category : #examples }
GtLACPCommandExamples >> newAdvertisementDuringRegistration [
	<gtExample>
	| root session connection token |
	root := GtLACPExamples new session.
	connection := root connection.
	session := root client newSessionIn: root directory connection: connection.
	session remoteSessionId: 'registering-commands'.
	self advertise: {self advertisement first} in: session.
	token := Object new.
	session announcer
		when: GtLACPCommandsChanged
		do: [ :event | 
			(session commands anySatisfy: [ :command | command name = 'review' ])
				ifTrue: [ self advertise: {self advertisement second} in: session ] ]
		for: token.
	[ connection registerSession: session ]
		ensure: [ session announcer unsubscribe: token ].
	self assert: session availableCommands size equals: 1.
	self assert: session availableCommands first name equals: 'skills'.
	self assert: connection pendingCommandAdvertisements isEmpty.
	self assert: (connection sessions at: session remoteSessionId) == session.
	^ session
]

{ #category : #examples }
GtLACPCommandExamples >> refreshPreservesCommands [
	<gtExample>
	| session command changed |
	session := self session.
	command := session commandNamed: 'review'.
	changed := self advertisement first copy
			at: 'description' put: 'Review the current changes';
			yourself.
	self advertise: {changed} in: session.
	self assert: (session commandNamed: 'review') == command.
	self assert: command description equals: 'Review the current changes'.
	^ command
]

{ #category : #examples }
GtLACPCommandExamples >> replacementAndClear [
	<gtExample>
	| session group old |
	session := self session.
	group := session availableCommands.
	old := session commandNamed: 'review'.
	self advertise: {self advertisement second} in: session.
	self assert: session availableCommands == group.
	self assert: session commands size equals: 1.
	self assert: session skills isEmpty.
	self
		assert: ([ old invokeWith: 'the package'.
			false ]
				on: Error
				do: [ :error | error messageText = 'The command is no longer available in this session' ]).
	self advertise: #() in: session.
	self assert: session availableCommands isEmpty.
	^ session
]

{ #category : #examples }
GtLACPCommandExamples >> restoresAdvertisementsFromHistory [
	<gtExample>
	| session |
	session := GtLACPExamples new session.
	session updates
		add: (GtLACPSessionUpdate new
				timestamp: DateAndTime now;
				data: {'sessionUpdate' -> 'available_commands_update'.
						'availableCommands' -> self advertisement} asDictionary;
				yourself).
	self assert: session availableCommands size equals: 4.
	self assert: session skills size equals: 1.
	^ session
]

{ #category : #examples }
GtLACPCommandExamples >> sendPreparedCommand [
	<gtExample>
	| scripter session |
	scripter := self chatWithCommands.
	session := scripter model.
	scripter requestFocus
		id: #'acp-input';
		play.
	scripter typeStep: [ :step | step text: '/review the ACP package' ].
	scripter click
		id: #'acp-action';
		play.
	self assert: session turns size equals: 1.
	self
		assert: (((session connection transport sentMessages last at: 'params') at: 'prompt')
				first at: 'text')
		equals: '/review the ACP package'.
	GtLACPChatExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPCommandExamples >> session [
	<gtExample>
	| session |
	session := GtLACPExamples new session.
	self advertise: self advertisement in: session.
	self assert: session availableCommands size equals: 4.
	self assert: session commands size equals: 3.
	self assert: session skills size equals: 1.
	self assert: session turns isEmpty.
	self assert: session updates last kind equals: 'available_commands_update'.
	^ session
]

{ #category : #examples }
GtLACPCommandExamples >> skillViewUpdatesFromEmpty [
	<gtExample>
	| session element scripter |
	session := GtLACPExamples new session.
	element := (session gtSkillsFor: GtPhlowView empty)
			asElementDo: [ :widget | widget ].
	scripter := BlScripter new
			extent: 1100 @ 600;
			model: session;
			element: element;
			yourself.
	scripter
		doStep: [ :step | step block: [ self advertise: self advertisement in: session ] ].
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | 
			step
				onPhlowCellWithString: '$explain-code';
				exists ].
	scripter doStep: [ :step | step block: [ self advertise: #() in: session ] ].
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | 
			step
				onPhlowCellWithString: '$explain-code';
				notExists ].
	GtLACPChatExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #'examples - completion' }
GtLACPCommandExamples >> slashCompletionCandidates [
	<gtExample>
	| session strategy |
	session := self session.
	strategy := GtLACPInputCompletionStrategy new session: session.
	self assert: (strategy commandsFor: '/' asRopedText at: 1) size equals: 4.
	self
		assert: (strategy commandsFor: '/ex' asRopedText at: 3) first invocation
		equals: '$explain-code'.
	self assert: (strategy commandsFor: '$' asRopedText at: 1) size equals: 1.
	self
		assert: (strategy commandsFor: '/review arguments/' asRopedText at: 18) isEmpty.
	self assert: (strategy commandsFor: 'path/to' asRopedText at: 7) isEmpty.
	self advertise: #() in: session.
	self assert: (strategy commandsFor: '/' asRopedText at: 1) isEmpty.
	^ strategy
]

{ #category : #'examples - completion' }
GtLACPCommandExamples >> slashCompletionInChat [
	<gtExample>
	| scripter input controller |
	scripter := self chatWithCommands.
	scripter requestFocus
		id: #'acp-input';
		play.
	scripter typeStep: [ :step | step text: '/' ].
	input := scripter element childWithId: #'acp-input'.
	controller := input userData at: GtCompletionController.
	scripter space time wait: GtCompletionController popupDelay.
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | step satisfies: [ :element | controller isShowingPopup ] ].
	GtLACPChatExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]
