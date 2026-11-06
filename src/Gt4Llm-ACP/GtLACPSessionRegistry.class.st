"
I hold root ACP sessions so that they can be found and inspected in one place. GtLACPSessionRegistry current is the shared instance.

Registration is explicit: sessions started directly on a client are not added to me. Use newSessionWithClient:in:, newClaudeCodeSessionIn: or newCodexSessionIn: to start and register a session, or registerSession: for one that already exists. A session that fails to start is not registered. Subagent sessions are rejected because they are reachable through their parent.

Removing a session does not close it, and closing a session does not remove it, so closed sessions stay listed and their conversations stay readable until they are removed.

I listen to the connections of my sessions and announce GtLACPSessionRegistryChanged when their conversations change. Inspect me to see the sessions, their conversation tree and an overview by state. See GtLACPSessionRegistryExamples for executable usage.
"
Class {
	#name : #GtLACPSessionRegistry,
	#superclass : #GtLACPObject,
	#instVars : [
		'announcer',
		'sessions'
	],
	#classVars : [
		'Current'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #accessing }
GtLACPSessionRegistry class >> current [
	Current ifNil: [ Current := self new ].
	^ Current
]

{ #category : #accessing }
GtLACPSessionRegistry class >> resetCurrent [
	Current := nil
]

{ #category : #announcer }
GtLACPSessionRegistry >> announce: anAnnouncement [
	^ self announcer announce: anAnnouncement
]

{ #category : #private }
GtLACPSessionRegistry >> announceRemovedSession: aSession [
	self
		announce: (GtLACPSessionUnregistered new
				registry: self;
				session: aSession)
]

{ #category : #announcer }
GtLACPSessionRegistry >> announcer [
	^ announcer
]

{ #category : #removing }
GtLACPSessionRegistry >> clearSessions [
	| removedSessions |
	removedSessions := sessions
			lock: [ :theSessions | 
				| aCopy |
				aCopy := theSessions copy.
				aCopy do: [ :each | each connection announcer unsubscribe: self ].
				theSessions removeAll.
				aCopy ].
	removedSessions do: [ :each | self announceRemovedSession: each ]
]

{ #category : #'gt - extensions' }
GtLACPSessionRegistry >> gtDefaultInspectorTool [
	^ GtPhlowCompositeTool new
		addTool: (GtLACPSessionRegistryTool forRegistry: self);
		addTool: super gtDefaultInspectorTool;
		name: 'ACP Sessions'
]

{ #category : #'gt - extensions' }
GtLACPSessionRegistry >> gtNewSessionFor: anAction [
	<gtAction>
	^ anAction dropdown
		id: #'acp-registry-new-session';
		addTarget: GtLACPSessionRegistryActionTarget;
		icon: BrGlamorousIcons add;
		label: 'New session';
		priority: 1;
		menu: [ :aDropdown | self newSessionDropdownFor: aDropdown clients: self sessionClients ]
]

{ #category : #'gt - extensions' }
GtLACPSessionRegistry >> gtOverviewFor: aView [
	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'By state';
		priority: 30;
		items: [ self sessionsByState ];
		column: 'State' text: #key;
		column: 'Sessions' text: [ :anAssociation | anAssociation value size ];
		send: [ :anAssociation | GtLACPSessionGroup withAll: anAssociation value ];
		updateWhen: GtLACPSessionRegistryAnnouncement in: [ self announcer ];
		actionUpdateButtonTooltip: 'Refresh overview'
]

{ #category : #'gt - extensions' }
GtLACPSessionRegistry >> gtRegistryActionsDropdownFor: anAction [
	<gtToolAction>
	(GtLACPSessionRegistryActionTarget actionsForObject: self)
		ifEmpty: [ ^ anAction noAction ].
	^ anAction dropdown
		tooltip: 'Registry actions';
		icon: BrGlamorousVectorIcons hamburger;
		id: #'acp-registry-actions';
		priority: 100;
		menuItemsForObject: self fromTarget: GtLACPSessionRegistryActionTarget
]

{ #category : #'gt - extensions' }
GtLACPSessionRegistry >> gtRemoveClosedSessionsFor: anAction [
	<gtAction>
	^ anAction button
		id: #'acp-registry-remove-closed-sessions';
		addTarget: GtLACPSessionRegistryActionTarget;
		icon: BrGlamorousIcons remove;
		label: 'Remove closed sessions';
		priority: 30;
		action: [ self removeClosedSessions ]
]

{ #category : #'gt - extensions' }
GtLACPSessionRegistry >> gtSessionsFor: aView [
	"Reuse the session actions and confirm registry removal in a submenu."

	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'Sessions';
		priority: 10;
		items: [ self sessions ];
		column: 'Title' text: #conversationTitle;
		column: 'Client'
			text: [ :aSession | aSession client displayName ]
			width: 110;
		column: 'State'
			stencil: [ :aSession | GtLACPSessionStateElement new session: aSession ]
			width: 120;
		column: 'Turns'
			text: [ :aSession | aSession turns size ]
			width: 60;
		column: 'Context used'
			text: [ :aSession | aSession contextWindow usagePercentageString ]
			width: 80;
		dynamicContextItems: [ :anElement :aSession | GtLACPSessionActionTarget menuItemsForObject: aSession hostElement: anElement ];
		dynamicContextItems: [ :anElement :aSession | {self removeSessionMenuItemFor: aSession hostElement: anElement} ];
		updateWhen: GtLACPSessionRegistryAnnouncement in: [ self announcer ];
		actionUpdateButtonTooltip: 'Refresh sessions'
]

{ #category : #testing }
GtLACPSessionRegistry >> hasSessions [
	^ sessions lock: [ :theSessions | theSessions notEmpty ]
]

{ #category : #initialization }
GtLACPSessionRegistry >> initialize [
	super initialize.
	sessions := AsyncMutex for: OrderedCollection new.
	announcer := Announcer new
]

{ #category : #accessing }
GtLACPSessionRegistry >> lastSession [
	^ sessions
		lock: [ :theSessions | theSessions isEmpty ifTrue: [ nil ] ifFalse: [ theSessions last ] ]
]

{ #category : #'instance creation' }
GtLACPSessionRegistry >> newClaudeCodeSessionIn: aDirectory [
	^ self newSessionWithClient: GtLACPClaudeCodeClient new in: aDirectory
]

{ #category : #'instance creation' }
GtLACPSessionRegistry >> newCodexSessionIn: aDirectory [
	^ self newSessionWithClient: GtLACPCodexClient new in: aDirectory
]

{ #category : #'private - interface' }
GtLACPSessionRegistry >> newSessionDropdownFor: aDropdown clients: aCollection [
	"Each client is a submenu containing the shared directory picker. Spawn from the outer action, which remains attached after the menus close."

	| aMenu |
	aMenu := BrMenuItems new.
	aCollection
		do: [ :aClient | 
			aMenu
				addItem: (BrMenuSubmenuItem new
						id: aClient class name;
						label: aClient displayName;
						submenu: (BrMenuExplicit new
								stencil: [ aClient newSessionDirectorySelectorFor: aDropdown registry: self ])) ].
	^ aMenu
]

{ #category : #'instance creation' }
GtLACPSessionRegistry >> newSessionWithClient: aClient in: aDirectory [
	^ self registerSession: (aClient startSessionIn: aDirectory)
]

{ #category : #private }
GtLACPSessionRegistry >> onConversationTreeChanged: anAnnouncement [
	self announce: (GtLACPSessionRegistryChanged new registry: self)
]

{ #category : #adding }
GtLACPSessionRegistry >> registerSession: aSession [
	| isAdded |
	aSession requireRootSession.
	isAdded := sessions
			lock: [ :theSessions | 
				(theSessions identityIncludes: aSession)
					ifTrue: [ false ]
					ifFalse: [ theSessions add: aSession.
						self subscribeToConnectionOf: aSession.
						true ] ].
	isAdded
		ifTrue: [ self
				announce: (GtLACPSessionRegistered new
						registry: self;
						session: aSession) ].
	^ aSession
]

{ #category : #removing }
GtLACPSessionRegistry >> removeClosedSessions [
	(self sessions select: [ :each | each state = #closed ])
		do: [ :each | self removeSession: each ]
]

{ #category : #removing }
GtLACPSessionRegistry >> removeSession: aSession [
	| removedSession |
	removedSession := sessions
			lock: [ :theSessions | 
				| aRemovedSession |
				aRemovedSession := theSessions remove: aSession ifAbsent: [ nil ].
				aRemovedSession
					ifNotNil: [ (theSessions anySatisfy: [ :each | each connection == aSession connection ])
							ifFalse: [ aSession connection announcer unsubscribe: self ] ].
				aRemovedSession ].
	removedSession ifNotNil: [ self announceRemovedSession: removedSession ]
]

{ #category : #'private - menus' }
GtLACPSessionRegistry >> removeSessionMenuItemFor: aSession hostElement: anElement [
	^ (GtPhlowAction noAction dropdown
		id: #'acp-remove-session';
		label: 'Remove from registry';
		icon: BrGlamorousVectorIcons remove;
		menuItemGroup: BrMenuItemGroupConfiguration removal;
		content: [ :anActionElement :aTargetElement :aMenu | 
			GtLACPRemoveSessionConfirmationStencil new
				registry: self;
				session: aSession;
				menuModel: aMenu;
				asElement ]) asMenuItem: [ :anItem | anItem ] withHostElement: anElement
]

{ #category : #'private - interface' }
GtLACPSessionRegistry >> sessionClients [
	^ {GtLACPClaudeCodeClient new.
		GtLACPCodexClient new}
]

{ #category : #accessing }
GtLACPSessionRegistry >> sessions [
	^ sessions lock: [ :theSessions | theSessions copy ]
]

{ #category : #examples }
GtLACPSessionRegistry >> sessionsByState [
	"Answer the total followed by one association per state in alphabetical order, for the overview view."

	| allSessions byState |
	allSessions := self sessions.
	byState := (allSessions groupedBy: #presentationState) associations
			sorted: [ :a :b | a key <= b key ].
	^ {'All' -> allSessions} , byState
]

{ #category : #private }
GtLACPSessionRegistry >> subscribeToConnectionOf: aSession [
	(aSession connection announcer hasSubscriber: self) ifTrue: [ ^ self ].
	aSession connection announcer
		when: GtLACPConversationTreeChanged
		send: #onConversationTreeChanged:
		to: self
]
