"
I exercise session registry registration rules, announcements, shared connections and session actions. I provide private registry and in-memory client fixtures. GtLACPSessionRegistryScripterExamples covers live views and interactions through BlScripter.
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
	self assert: closed isClosed.
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

{ #category : #examples }
GtLACPSessionRegistryExamples >> earlySessionIsRegisteredBeforeCreation [
	<gtExample>
	| registry pending session |
	registry := self emptyRegistry.
	session := registry
			newSessionWithClient: self claudeClient
			in: FileLocator temp
			onCreated: [ :aSession | 
				pending := aSession.
				self assert: aSession isNew.
				self assert: aSession remoteSessionId isNil.
				self assert: registry lastSession == aSession ].
	self assert: pending == session.
	self assert: session isReady.
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

{ #category : #examples }
GtLACPSessionRegistryExamples >> failedEarlySessionIsRemoved [
	<gtExample>
	| registry client pending hasFailed |
	registry := self emptyRegistry.
	client := self claudeClient.
	hasFailed := false.
	[ registry
		newSessionWithClient: client
		in: FileLocator temp
		onCreated: [ :aSession | 
			pending := aSession.
			self assert: registry lastSession == pending.
			self error: 'Aborted creation' ] ]
		on: Error
		do: [ :ex | hasFailed := ex messageText = 'Aborted creation' ].
	self assert: hasFailed.
	self assert: pending notNil.
	self assert: registry hasSessions not.
	self assert: pending connection isStopped.
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

{ #category : #examples }
GtLACPSessionRegistryExamples >> registryChangeIdentifiesAffectedSessions [
	<gtExample>
	| registry first second changes change |
	registry := self emptyRegistry.
	first := self newSessionIn: registry.
	second := self newSessionIn: registry.
	changes := self announcementsOf: GtLACPSessionRegistryChanged in: registry.
	first announceConversationTreeChanged.
	self assert: changes size equals: 1.
	change := changes first.
	self assert: change registry == registry.
	self assert: change connection == first connection.
	self assert: change sessions asArray equals: {first}.
	self assert: (change sessions identityIncludes: second) not.
	^ registry
]

{ #category : #examples }
GtLACPSessionRegistryExamples >> registryInspectorTool [
	<gtExample>
	| registry composite tool element |
	registry := self emptyRegistry.
	composite := registry gtDefaultInspectorTool.
	self assert: (composite isKindOf: GtPhlowCompositeTool).
	self assert: composite tools size equals: 2.
	tool := composite tools first.
	self assert: tool class equals: GtLACPSessionRegistryTool.
	self assert: GtLACPSessionRegistryTool superclass equals: GtPhlowTool.
	self assert: tool registry == registry.
	self assert: tool object == registry.
	self assert: tool name equals: 'ACP Sessions'.
	element := tool asElementDo: [ :widget | widget ].
	self assert: element class equals: GtLACPSessionRegistryToolElement.
	self assert: element registry == registry.
	self
		assert: ((element childNamed: #header) childNamed: #toolLabel) text asString
		equals: 'ACP Sessions'.
	self
		assert: (element collectToolViews anySatisfy: [ :view | view title = 'Sessions' ]).
	self
		assert: (element collectToolViews
				allSatisfy: [ :view | view definingMethod compiledMethod hasPragmaNamed: #gtLlmView ]).
	self assert: element collectToolActions size equals: 1.
	self
		assert: ((element childNamed: #header) childNamed: #toolbar) numberOfItems
		equals: 1.
	^ tool
]

{ #category : #'examples - model' }
GtLACPSessionRegistryExamples >> registryWithClaudeSession [
	<gtExample>
	| registry session |
	registry := self emptyRegistry.
	session := self newSessionIn: registry.
	self assert: session isReady.
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
	self assert: session isReady.
	self assert: (session connection announcer hasSubscriber: registry) not.
	self assert: announcements size equals: 1.
	self assert: announcements first registry == registry.
	self assert: announcements first session == session.
	registry removeSession: session.
	self assert: announcements size equals: 1.
	^ registry
]

{ #category : #examples }
GtLACPSessionRegistryExamples >> reopenActionForClosedSession [
	<gtExample>
	| client registry session menu item |
	client := GtLACPReopenExamples new client.
	registry := self emptyRegistry.
	session := registry newSessionWithClient: client in: FileLocator temp.
	[ menu := GtLACPSessionActionTarget
			menuItemsForObject: session
			hostElement: BlElement new.
	self
		assert: (menu items noneSatisfy: [ :each | each id = #'acp-reopen-session' ]).
	session close.
	menu := (GtLACPSessionRegistrySessionsElement new registry: registry)
			contextMenuFor: session
			hostElement: BlElement new.
	item := menu items detect: [ :each | each id = #'acp-reopen-session' ].
	self assert: (item labelModel isKindOf: BrMenuIconTextLabelModel).
	session reopen.
	menu := GtLACPSessionActionTarget
			menuItemsForObject: session
			hostElement: BlElement new.
	self
		assert: (menu items noneSatisfy: [ :each | each id = #'acp-reopen-session' ]) ]
		ensure: [ client stop ].
	^ registry
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
GtLACPSessionRegistryExamples >> sessionsViewReusesSessionActions [
	<gtExample>
	| registry session view menu sessionItems |
	registry := self registryWithClaudeSession.
	session := registry lastSession.
	view := GtLACPSessionRegistrySessionsElement new registry: registry.
	sessionItems := GtLACPSessionActionTarget
			menuItemsForObject: session
			hostElement: BlElement new.
	self
		assert: (sessionItems items anySatisfy: [ :each | each id = #'acp-rename-session' ]).
	self
		assert: (sessionItems items anySatisfy: [ :each | each id = #'acp-close-session' ]).
	menu := view contextMenuFor: session hostElement: BlElement new.
	self assert: menu items size equals: sessionItems items size + 1.
	self
		assert: ((menu items first: sessionItems items size) collect: #id)
		equals: (sessionItems items collect: #id).
	session close.
	sessionItems := GtLACPSessionActionTarget
			menuItemsForObject: session
			hostElement: BlElement new.
	menu := view contextMenuFor: session hostElement: BlElement new.
	self assert: menu items size equals: sessionItems items size + 1.
	self
		assert: (menu items noneSatisfy: [ :each | each id = #'acp-close-session' ]).
	^ registry
]

{ #category : #examples }
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
	self assert: changes last connection == first connection.
	self
		assert: changes last sessions asArray
		equals: {first.
				second}.
	registry removeSession: first.
	self assert: (first connection announcer hasSubscriber: registry).
	second announceChanged.
	self assert: changes size equals: 2.
	self assert: changes last sessions asArray equals: {second}.
	registry removeSession: second.
	self assert: (first connection announcer hasSubscriber: registry) not.
	second announceChanged.
	self assert: changes size equals: 2.
	^ registry
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
