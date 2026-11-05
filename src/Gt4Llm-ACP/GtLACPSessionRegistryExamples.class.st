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

{ #category : #'examples - actions' }
GtLACPSessionRegistryExamples >> newClaudeSessionFromRegistryDropdown [
	<gtExample>
	^ self newSessionFromRegistryDropdownWith: self claudeClient
]

{ #category : #'examples - actions' }
GtLACPSessionRegistryExamples >> newCodexSessionFromRegistryDropdown [
	<gtExample>
	^ self
		newSessionFromRegistryDropdownWith: (GtLACPCodexClient new
				transportFactory: [ :aConfiguration :aDirectory | GtLACPExamples new transport ];
				yourself)
]

{ #category : #'examples - actions' }
GtLACPSessionRegistryExamples >> newSessionAction [
	<gtExample>
	| registry button scripter |
	registry := self emptyRegistry.
	self
		assert: (registry sessionClients collect: #class)
		equals: {GtLACPClaudeCodeClient.
				GtLACPCodexClient}.
	button := (registry gtNewSessionFor: GtPhlowAction noAction)
			asElement: [ :anElement | anElement ]
			withHostElement: nil.
	scripter := BlScripter new
			extent: 1000 @ 800;
			model: registry;
			element: (BrFrame new
					matchParent;
					addChild: button);
			yourself.
	scripter click
		// BrButton;
		play.
	{GtLACPClaudeCodeClient.
		GtLACPCodexClient}
		do: [ :aClass | 
			scripter assert
				onSpaceRoot;
				// aClass name;
				exists;
				play ].
	^ scripter
]

{ #category : #private }
GtLACPSessionRegistryExamples >> newSessionFromRegistryDropdownWith: aClient [
	| registry button scripter |
	registry := self emptyRegistry.
	button := (GtPhlowAction noAction dropdown
			label: 'New session';
			menu: [ :aDropdown | registry newSessionDropdownFor: aDropdown clients: {aClient} ])
			asElement: [ :anElement | anElement ]
			withHostElement: nil.
	scripter := BlScripter new
			extent: 1000 @ 800;
			model: registry;
			element: (BrFrame new
					matchParent;
					addChild: button);
			yourself.
	scripter click
		// BrButton;
		play.
	scripter click
		onSpaceRoot;
		// aClient class name;
		play.
	scripter assert
		label: 'The nested picker starts in the image directory';
		value: [ :aSelector | aSelector folder asFileReference fullName ]
			equals: FileLocator imageDirectory asFileReference fullName;
		onSpaceRoot;
		// BrFileSelector;
		play.
	scripter do
		action: [ :aList | aList selectOne: 1 ];
		onSpaceRoot;
		// BrFileSelector;
		// BrColumnedList;
		play.
	scripter click
		onSpaceRoot;
		// #'acp-start-session-button';
		play.
	20 timesRepeat: [ registry hasSessions ifFalse: [ 100 milliSeconds wait ] ].
	self assert: registry sessions size equals: 1.
	self assert: registry lastSession client == aClient.
	self assert: registry lastSession state equals: #ready.
	self assert: registry lastSession directory isDirectory.
	scripter pulseUntilReady.
	scripter assert
		onSpaceRoot;
		// BrFileSelector;
		notExists;
		play.
	^ scripter
]

{ #category : #private }
GtLACPSessionRegistryExamples >> newSessionIn: aRegistry [
	^ aRegistry newSessionWithClient: self claudeClient in: FileLocator temp
]

{ #category : #'examples - actions' }
GtLACPSessionRegistryExamples >> newSessionMenu [
	<gtExample>
	| registry menu |
	registry := self emptyRegistry.
	menu := registry
			newSessionDropdownFor: BlElement new
			clients: registry sessionClients.
	self assert: (menu isKindOf: BrMenuItems).
	self assert: menu items size equals: 2.
	menu items
		do: [ :anItem | 
			self assert: (anItem isKindOf: BrMenuSubmenuItem).
			self assert: (anItem submenu isKindOf: BrMenuExplicit) ].
	^ menu
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
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
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

{ #category : #'examples - actions' }
GtLACPSessionRegistryExamples >> resizableDirectoryPickerSubmenu [
	<gtExample>
	| scripter initialExtent |
	scripter := self newSessionAction.
	scripter click
		onSpaceRoot;
		// #GtLACPClaudeCodeClient;
		play.
	scripter do
		label: 'Resize the directory submenu horizontally';
		action: [ :aPicker | 
			| aResizer |
			initialExtent := aPicker extent.
			aResizer := aPicker children
					detect: [ :each | 
						(each isKindOf: BrResizer)
							and: [ each location isKindOf: BrResizerRightLocation ] ].
			BlSpace simulateDragOn: aResizer by: (BlVector x: 80 y: 0) ];
		onSpaceRoot;
		// BrFileSelector;
		play.
	scripter pulseUntilReady.
	scripter assert
		value: [ :aPicker | aPicker extent ] equals: [ initialExtent + (80 @ 0) ];
		onSpaceRoot;
		// BrFileSelector;
		play.
	scripter do
		label: 'Resize the directory submenu vertically';
		action: [ :aPicker | 
			| aResizer |
			aResizer := aPicker children
					detect: [ :each | 
						(each isKindOf: BrResizer)
							and: [ each location isKindOf: BrResizerBottomLocation ] ].
			BlSpace simulateDragOn: aResizer by: (BlVector x: 0 y: 60) ];
		onSpaceRoot;
		// BrFileSelector;
		play.
	scripter pulseUntilReady.
	scripter assert
		value: [ :aPicker | aPicker extent ] equals: [ initialExtent + (80 @ 60) ];
		onSpaceRoot;
		// BrFileSelector;
		play.
	^ scripter
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

{ #category : #'examples - actions' }
GtLACPSessionRegistryExamples >> sessionActionIcons [
	<gtExample>
	| registry addButton removeButton |
	registry := self emptyRegistry.
	addButton := (registry gtNewSessionFor: GtPhlowAction noAction)
			asElement: [ :anElement | anElement ]
			withHostElement: nil.
	removeButton := (registry gtRemoveClosedSessionsFor: GtPhlowAction noAction)
			asElement: [ :anElement | anElement ]
			withHostElement: nil.
	self assert: addButton icon notNil.
	self assert: removeButton icon notNil.
	self assert: addButton label asString equals: 'New session'.
	self assert: removeButton label asString equals: 'Remove closed sessions'.
	^ BrHorizontalPane new
		fitContent;
		addChildren: {addButton.
				removeButton};
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
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
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
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
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

{ #category : #'examples - actions' }
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
		label: 'The picker starts in the image directory';
		value: [ :aSelector | aSelector folder asFileReference fullName ]
			equals: FileLocator imageDirectory asFileReference fullName;
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
