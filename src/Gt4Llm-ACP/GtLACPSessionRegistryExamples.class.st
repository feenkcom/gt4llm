"
I exercise the session registry: registration rules, announcements, shared connections and the live inspector views. I use private registries and in-memory transports, so I neither change GtLACPSessionRegistry current nor start agent processes.
"
Class {
	#name : #GtLACPSessionRegistryExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #private }
GtLACPSessionRegistryExamples >> announcementsOf: anAnnouncementClass in: aRegistry [
	| announcements |
	announcements := OrderedCollection new.
	aRegistry announcer
		when: anAnnouncementClass
		send: #add:
		to: announcements.
	^ announcements
]

{ #category : #private }
GtLACPSessionRegistryExamples >> assertIn: aScripter cellExists: aString [
	aScripter
		assertStep: [ :step | 
			step
				onPhlowCellWithString: aString;
				exists ]
]

{ #category : #private }
GtLACPSessionRegistryExamples >> assertIn: aScripter stateLabelExists: aString [
	aScripter
		assertStep: [ :step | 
			step
				// BrLabel;
				@ [ :aLabel | aLabel text asString = aString ];
				exists ]
]

{ #category : #private }
GtLACPSessionRegistryExamples >> claudeClient [
	^ GtLACPClaudeCodeClient new
		transportFactory: [ :aConfiguration :aDirectory | GtLACPExamples new transport ];
		yourself
]

{ #category : #'examples - model' }
GtLACPSessionRegistryExamples >> clearedSessions [
	<gtExample>
	| registry first second announcements |
	registry := self emptyRegistry.
	first := self newSessionIn: registry.
	second := self newSessionIn: registry.
	announcements := self announcementsOf: GtLACPSessionUnregistered in: registry.
	registry clearSessions.
	self assert: registry hasSessions not.
	self
		assert: (announcements collect: #session) asArray
		equals: {first.
				second}.
	self assert: (announcements allSatisfy: [ :each | each registry == registry ]).
	self assert: (first connection announcer hasSubscriber: registry) not.
	self assert: (second connection announcer hasSubscriber: registry) not.
	^ registry
]

{ #category : #'examples - model' }
GtLACPSessionRegistryExamples >> closedSessionStaysListed [
	<gtExample>
	| registry closed open changes |
	registry := self emptyRegistry.
	closed := self newSessionIn: registry.
	open := self newSessionIn: registry.
	changes := self announcementsOf: GtLACPSessionRegistryChanged in: registry.
	closed close.
	self assert: closed state equals: #closed.
	self assert: changes notEmpty.
	self assert: registry sessions size equals: 2.
	registry removeClosedSessions.
	self assert: registry sessions asArray equals: {open}.
	^ registry
]

{ #category : #'examples - views' }
GtLACPSessionRegistryExamples >> conversationTreeFollowsAllConnections [
	<gtExample>
	| registry second scripter |
	registry := self emptyRegistry.
	scripter := self scripterOn: registry view: #gtConversationTreeFor:.
	scripter pulseUntilReady.
	self in: scripter do: [ self newSessionIn: registry ].
	self assertIn: scripter cellExists: 'Claude Code'.
	self in: scripter do: [ second := self newSessionIn: registry ].
	self assert: registry sessions first connection ~~ second connection.
	self
		in: scripter
		do: [ GtLACPSubagentExamples new
				announce: 'second-connection-child'
				title: 'Second connection worker'
				in: second ].
	self assertIn: scripter cellExists: 'Second connection worker'.
	GtLACPChatExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #'examples - model' }
GtLACPSessionRegistryExamples >> duplicateRegistrationIsIgnored [
	<gtExample>
	| registry announcements session changes |
	registry := self emptyRegistry.
	session := self newSessionIn: registry.
	announcements := self announcementsOf: GtLACPSessionRegistered in: registry.
	changes := self announcementsOf: GtLACPSessionRegistryChanged in: registry.
	self assert: (registry registerSession: session) == session.
	self assert: registry sessions size equals: 1.
	self assert: announcements isEmpty.
	session announceChanged.
	self assert: changes size equals: 1.
	^ registry
]

{ #category : #'examples - model' }
GtLACPSessionRegistryExamples >> emptyRegistry [
	<gtExample>
	| registry |
	registry := GtLACPSessionRegistry new.
	self assert: registry hasSessions not.
	self assert: registry sessions isEmpty.
	self assert: registry lastSession isNil.
	^ registry
]

{ #category : #'examples - model' }
GtLACPSessionRegistryExamples >> failedStartIsNotRegistered [
	<gtExample>
	| registry announcements hasFailed |
	registry := self emptyRegistry.
	announcements := self announcementsOf: GtLACPSessionRegistered in: registry.
	hasFailed := false.
	[ registry
		newSessionWithClient: self claudeClient
		in: FileLocator temp / UUID new asString ]
		on: Error
		do: [ :anError | hasFailed := true ].
	self assert: hasFailed.
	self assert: registry hasSessions not.
	self assert: announcements isEmpty.
	^ registry
]

{ #category : #private }
GtLACPSessionRegistryExamples >> in: aScripter do: aBlock [
	aScripter doStep: [ :step | step block: aBlock ].
	aScripter pulseUntilReady
]

{ #category : #private }
GtLACPSessionRegistryExamples >> newSessionIn: aRegistry [
	^ aRegistry newSessionWithClient: self claudeClient in: FileLocator temp
]

{ #category : #'examples - views' }
GtLACPSessionRegistryExamples >> overviewDisplaysStates [
	<gtExample>
	| registry scripter closed |
	registry := self emptyRegistry.
	self newSessionIn: registry.
	closed := self newSessionIn: registry.
	closed close.
	self
		assert: (registry sessionsByState collect: #key) asArray
		equals: {'All'.
				#closed.
				#ready}.
	self assert: registry sessionsByState first value size equals: 2.
	scripter := self scripterOn: registry view: #gtOverviewFor:.
	#('All' 'closed' 'ready')
		do: [ :aLabel | self assertIn: scripter cellExists: aLabel ].
	GtLACPChatExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #private }
GtLACPSessionRegistryExamples >> registeredSessionOf: aClient [
	"The dropdown starts sessions in a separate process and in the shared registry, so wait for the session to appear there."

	20
		timesRepeat: [ GtLACPSessionRegistry current sessions
				detect: [ :each | each client == aClient ]
				ifFound: [ :aSession | ^ aSession ]
				ifNone: [ 100 milliSeconds wait ] ].
	^ nil
]

{ #category : #'examples - model' }
GtLACPSessionRegistryExamples >> registrationIsAnnounced [
	<gtExample>
	| registry announcements session |
	registry := self emptyRegistry.
	announcements := self announcementsOf: GtLACPSessionRegistered in: registry.
	session := self newSessionIn: registry.
	self assert: announcements size equals: 1.
	self assert: announcements first registry == registry.
	self assert: announcements first session == session.
	^ registry
]

{ #category : #'examples - model' }
GtLACPSessionRegistryExamples >> registryWithClaudeSession [
	<gtExample>
	| registry session |
	registry := self emptyRegistry.
	session := self newSessionIn: registry.
	self assert: session state equals: #ready.
	self assert: session client class equals: GtLACPClaudeCodeClient.
	self assert: registry hasSessions.
	self assert: registry sessions size equals: 1.
	self assert: registry lastSession == session.
	^ registry
]

{ #category : #'examples - model' }
GtLACPSessionRegistryExamples >> removedSessionStaysOpen [
	<gtExample>
	| registry session announcements |
	registry := self registryWithClaudeSession.
	session := registry lastSession.
	announcements := self announcementsOf: GtLACPSessionUnregistered in: registry.
	registry removeSession: session.
	self assert: registry hasSessions not.
	self assert: session state equals: #ready.
	self assert: (session connection announcer hasSubscriber: registry) not.
	self assert: announcements size equals: 1.
	self assert: announcements first registry == registry.
	self assert: announcements first session == session.
	registry removeSession: session.
	self assert: announcements size equals: 1.
	^ registry
]

{ #category : #private }
GtLACPSessionRegistryExamples >> scripterOn: aRegistry view: aViewSelector [
	| element |
	element := (aRegistry perform: aViewSelector with: GtPhlowView empty)
			asElementDo: [ :widget | 
				widget
					background: Color white;
					yourself ].
	^ BlScripter new
		extent: 1100 @ 700;
		model: aRegistry;
		element: element;
		yourself
]

{ #category : #examples }
GtLACPSessionRegistryExamples >> sessionStateVisuals [
	<gtExample>
	| registry scripter |
	registry := self emptyRegistry.
	#(new starting loading ready prompting failed closed observing disconnected futureState)
		do: [ :aState | 
			| session |
			session := self newSessionIn: registry.
			session state: aState ].
	scripter := self scripterOn: registry view: #gtSessionsFor:.
	scripter pulseUntilReady.
	#(new starting loading ready prompting failed closed observing disconnected futureState)
		do: [ :aState | self assertIn: scripter stateLabelExists: aState asString ].
	GtLACPChatExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #'examples - model' }
GtLACPSessionRegistryExamples >> sessionsAnswersACopy [
	<gtExample>
	| registry |
	registry := self registryWithClaudeSession.
	registry sessions removeAll.
	self assert: registry sessions size equals: 1.
	^ registry
]

{ #category : #examples }
GtLACPSessionRegistryExamples >> sessionsViewUpdatesLive [
	<gtExample>
	| registry session scripter |
	registry := self emptyRegistry.
	scripter := self scripterOn: registry view: #gtSessionsFor:.
	scripter pulseUntilReady.
	self in: scripter do: [ session := self newSessionIn: registry ].
	self assertIn: scripter cellExists: 'Claude Code'.
	self assertIn: scripter stateLabelExists: 'ready'.
	self
		in: scripter
		do: [ session state: #prompting.
			session announceConversationTreeChanged ].
	self assertIn: scripter stateLabelExists: 'prompting'.
	self
		in: scripter
		do: [ session state: #ready.
			session close ].
	self assertIn: scripter stateLabelExists: 'closed'.
	GtLACPChatExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #'examples - model' }
GtLACPSessionRegistryExamples >> sharedConnectionKeepsForwarding [
	<gtExample>
	| registry first second changes |
	registry := self registryWithClaudeSession.
	first := registry lastSession.
	second := first client
			newSessionIn: first directory
			connection: first connection.
	second create.
	registry registerSession: second.
	changes := self announcementsOf: GtLACPSessionRegistryChanged in: registry.
	second announceChanged.
	self assert: changes size equals: 1.
	registry removeSession: first.
	self assert: (first connection announcer hasSubscriber: registry).
	second announceChanged.
	self assert: changes size equals: 2.
	registry removeSession: second.
	self assert: (first connection announcer hasSubscriber: registry) not.
	second announceChanged.
	self assert: changes size equals: 2.
	^ registry
]

{ #category : #'examples - views' }
GtLACPSessionRegistryExamples >> startSessionDropdownRegistersSession [
	<gtExample>
	| client button scripter registered |
	client := self claudeClient.
	button := (client gtStartSessionFor: GtPhlowAction noAction)
			asElement: [ :anElement | anElement ]
			withHostElement: nil.
	scripter := BlScripter new
			extent: 800 @ 600;
			model: client;
			element: (BrFrame new
					matchParent;
					addChild: button);
			yourself.
	scripter click
		label: 'Open the directory dropdown';
		// BrButton;
		play.
	scripter assert
		label: 'The picker starts in the home directory';
		value: [ :aSelector | aSelector folder asFileReference fullName ]
			equals: FileLocator home asFileReference fullName;
		onSpaceRoot;
		// BrFileSelector;
		play.
	scripter do
		label: 'Select the first directory';
		action: [ :aList | aList selectOne: 1 ];
		onSpaceRoot;
		// BrFileSelector;
		// BrColumnedList;
		play.
	scripter click
		label: 'Start the session';
		onSpaceRoot;
		// #'acp-start-session-button';
		play.
	registered := self registeredSessionOf: client.
	[ self assert: registered notNil.
	self assert: registered state equals: #ready.
	self assert: registered directory isDirectory ]
		ensure: [ registered
				ifNotNil: [ GtLACPSessionRegistry current removeSession: registered ] ].
	scripter pulseUntilReady.
	scripter assert
		label: 'The dropdown is closed';
		onSpaceRoot;
		// BrFileSelector;
		notExists;
		play.
	^ scripter
]

{ #category : #'examples - model' }
GtLACPSessionRegistryExamples >> subagentChangeIsForwarded [
	<gtExample>
	| registry session changes |
	registry := self registryWithClaudeSession.
	session := registry lastSession.
	changes := self announcementsOf: GtLACPSessionRegistryChanged in: registry.
	GtLACPSubagentExamples new
		announce: 'forwarded-child'
		title: 'Forwarded worker'
		in: session.
	self assert: changes notEmpty.
	self assert: changes first registry == registry.
	^ registry
]

{ #category : #'examples - model' }
GtLACPSessionRegistryExamples >> subagentIsRejected [
	<gtExample>
	| registry root isRejected |
	registry := self emptyRegistry.
	root := GtLACPSubagentExamples new nestedConversations.
	isRejected := false.
	[ registry registerSession: root childSessions first ]
		on: Error
		do: [ :anError | isRejected := true ].
	self assert: isRejected.
	self assert: registry hasSessions not.
	^ registry
]
