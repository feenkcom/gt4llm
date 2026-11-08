"
I exercise ACP session registry views, menus, selection and startup through BlScripter. I use GtLACPSessionRegistryExamples for private registries and in-memory client fixtures.
"
Class {
	#name : #GtLACPSessionRegistryScripterExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> addedSessionIsSelected [
	<gtExample>
	| registry scripter list session |
	scripter := self firstSessionIsSelected.
	registry := scripter model.
	list := (scripter element query // BrColumnedList) anyOne.
	scripter
		doStep: [ :step | 
			step
				block: [ session := GtLACPSessionRegistryExamples new newSessionIn: registry ] ].
	self assert: registry sessions size equals: 2.
	self assert: list selectedItems asArray equals: {session}.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> addedSessionIsSelectedInSortedList [
	<gtExample>
	| registry scripter list session |
	scripter := self sessionsSortedByTitle.
	registry := scripter model.
	list := (scripter element query // BrColumnedList) anyOne.
	scripter
		doStep: [ :step | 
			step
				block: [ session := GtLACPSessionRegistryExamples new claudeClient
							startSessionIn: FileLocator temp.
					session conversationTitle: 'A'.
					registry registerSession: session ] ].
	self assert: list selectedItems asArray equals: {session}.
	self assert: list selectedIndices asArray equals: #(1).
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #'private - scripter' }
GtLACPSessionRegistryScripterExamples >> assertIn: aScripter cellExists: aString [
	aScripter
		assertStep: [ :step | 
			step
				// BrLabel;
				@ [ :aLabel | aLabel text asString = aString ];
				exists ]
]

{ #category : #'private - scripter' }
GtLACPSessionRegistryScripterExamples >> assertIn: aScripter stateLabelExists: aString [
	aScripter
		assertStep: [ :step | 
			step
				// BrLabel;
				@ [ :aLabel | aLabel text asString = aString ];
				exists ]
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> confirmedSessionIsRemoved [
	<gtExample>
	| scripter registry session |
	scripter := self removeSessionRequiresConfirmation.
	registry := scripter model.
	session := registry lastSession.
	scripter click
		onSpaceRoot;
		// #'acp-remove-session-accept';
		play.
	self assert: registry hasSessions not.
	self assert: session isReady.

	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #'private - scripter' }
GtLACPSessionRegistryScripterExamples >> directoryPickerIn: scripter clientClass: aClass [
	scripter click
		onSpaceRoot;
		// aClass name;
		play.
	scripter assert
		label: 'The nested picker starts in the image directory';
		value: [ :aSelector | aSelector folder asFileReference fullName ]
			equals: FileLocator imageDirectory asFileReference fullName;
		onSpaceRoot;
		// BrFileSelector;
		play.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> directoryPickerResizedHorizontally [
	<gtExample>
	| scripter initialExtent |
	scripter := self registryDirectoryPicker.
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

	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> earlierSessionIsSelected [
	<gtExample>
	| registry scripter list session |
	scripter := self addedSessionIsSelected.
	registry := scripter model.
	list := (scripter element query // BrColumnedList) anyOne.
	session := registry sessions first.
	scripter
		doStep: [ :step | 
			step
				block: [ session conversationTitle: 'Earlier'.
					registry lastSession conversationTitle: 'Later'.
					list selectOne: 1 ] ].
	self assert: list selectedItems asArray equals: {session}.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> earlierSessionSelectedInPager [
	<gtExample>
	| scripter pager registryElement list session |
	scripter := self sessionAddedNavigatesOnceInPager.
	pager := scripter element.
	registryElement := (pager query // GtLACPSessionRegistryToolElement) anyOne.
	list := (registryElement query // BrColumnedList) anyOne.
	session := scripter model sessions first.
	scripter doStep: [ :step | step block: [ list selectOne: 1 ] ].
	scripter pulseUntilReady.
	self assert: (pager query // GtLACPSessionToolElement) anyOne chat == session.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> emptyRegistryTool [
	<gtExample>
	| registry scripter |
	registry := GtLACPSessionRegistryExamples new emptyRegistry.
	scripter := BlScripter new
			extent: 1100 @ 700;
			model: registry;
			element: ((GtLACPSessionRegistryTool forRegistry: registry)
					asElementDo: [ :widget | widget ]);
			yourself.
	scripter pulseUntilReady.
	self assert: registry hasSessions not.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> emptySessionsView [
	<gtExample>
	| registry scripter list |
	registry := GtLACPSessionRegistryExamples new emptyRegistry.
	scripter := self scripterOn: registry view: #gtSessionsFor:.
	scripter pulseUntilReady.
	list := (scripter element query // BrColumnedList) anyOne.
	self assert: list items isEmpty.
	self assert: list selectedItems isEmpty.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> explicitSessionsViewRefreshPreservesSelection [
	<gtExample>
	| scripter list session |
	scripter := self explicitSessionsViewWithSelection.
	list := (scripter element query // BrColumnedList) anyOne.
	session := scripter model lastSession.
	scripter click
		// GtPhlowViewRefreshContentButtonId;
		play.
	self assert: list selectedItems asArray equals: {session}.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> explicitSessionsViewRetainsClosedSelection [
	<gtExample>
	| scripter list session |
	scripter := self explicitSessionsViewRefreshPreservesSelection.
	list := (scripter element query // BrColumnedList) anyOne.
	session := scripter model lastSession.
	scripter doStep: [ :step | step block: [ session close ] ].
	self assert: list selectedItems asArray equals: {session}.
	self assertIn: scripter stateLabelExists: 'closed'.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> explicitSessionsViewWithSelection [
	<gtExample>
	| registry view element tab button scripter list session |
	registry := GtLACPSessionRegistryExamples new registryWithClaudeSession.
	session := registry lastSession.
	view := registry gtSessionsFor: GtPhlowView empty.
	self assert: view class equals: GtPhlowExplicitView.
	element := view asElementDo: [ :aWidget | aWidget ].
	self assert: element class equals: GtLACPSessionRegistrySessionsElement.
	tab := BrVerticalPane new matchParent.
	button := view actions first
			asElement: [ :aWidget | aWidget ]
			withHostElement: tab.
	tab
		addChild: button;
		addChild: element.
	scripter := BlScripter new
			extent: 1000 @ 700;
			model: registry;
			element: tab;
			yourself.
	scripter pulseUntilReady.
	list := (element query // BrColumnedList) anyOne.
	scripter doStep: [ :step | step block: [ list selectOne: 1 ] ].

	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> firstSessionIsSelected [
	<gtExample>
	| registry scripter list session |
	scripter := self emptySessionsView.
	registry := scripter model.
	list := (scripter element query // BrColumnedList) anyOne.
	scripter
		doStep: [ :step | 
			step
				block: [ session := GtLACPSessionRegistryExamples new newSessionIn: registry ] ].
	self assert: list selectedItems asArray equals: {session}.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> newClaudeSessionDirectoryPicker [
	<gtExample>
	| scripter |
	scripter := self newClaudeSessionMenu.
	^ self directoryPickerIn: scripter clientClass: GtLACPClaudeCodeClient
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> newClaudeSessionDirectorySelected [
	<gtExample>
	^ self selectDirectoryIn: self newClaudeSessionDirectoryPicker
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> newClaudeSessionFromRegistryDropdown [
	<gtExample>
	| scripter |
	scripter := self
			startSessionInRegistryDropdown: self newClaudeSessionDirectorySelected.
	self
		assert: scripter model lastSession client class
		equals: GtLACPClaudeCodeClient.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> newClaudeSessionMenu [
	<gtExample>
	^ self
		registryDropdownWithClient: GtLACPSessionRegistryExamples new claudeClient
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> newCodexSessionDirectoryPicker [
	<gtExample>
	| scripter |
	scripter := self newCodexSessionMenu.
	^ self directoryPickerIn: scripter clientClass: GtLACPCodexClient
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> newCodexSessionDirectorySelected [
	<gtExample>
	^ self selectDirectoryIn: self newCodexSessionDirectoryPicker
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> newCodexSessionFromRegistryDropdown [
	<gtExample>
	| scripter |
	scripter := self
			startSessionInRegistryDropdown: self newCodexSessionDirectorySelected.
	self assert: scripter model lastSession client class equals: GtLACPCodexClient.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> newCodexSessionMenu [
	<gtExample>
	^ self
		registryDropdownWithClient: (GtLACPCodexClient new
				transportFactory: [ :aConfiguration :aDirectory | GtLACPExamples new transport ];
				yourself)
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> newSessionAction [
	<gtExample>
	| registry button scripter |
	registry := GtLACPSessionRegistryExamples new emptyRegistry.
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

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> overviewDisplaysStates [
	<gtExample>
	| registry scripter closed |
	registry := GtLACPSessionRegistryExamples new emptyRegistry.
	GtLACPSessionRegistryExamples new newSessionIn: registry.
	closed := GtLACPSessionRegistryExamples new newSessionIn: registry.
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

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> pendingSessionBecomesReady [
	<gtExample>
	| scripter session list |
	scripter := self pendingSessionIsVisibleBeforeCreation.
	session := scripter model lastSession.
	scripter
		doStep: [ :step | 
			step
				block: [ session create.
					session client applyPreferencesTo: session.
					session announceConversationTreeChanged ] ].
	self assert: session isReady.
	self assertIn: scripter stateLabelExists: 'ready'.
	list := (scripter element query // BrColumnedList) anyOne.
	self assert: list selectedItems asArray equals: {session}.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> pendingSessionChatBeforeCreation [
	<gtExample>
	| pendingScripter session scripter |
	pendingScripter := self pendingSessionIsVisibleBeforeCreation.
	session := pendingScripter model lastSession.
	scripter := BlScripter new
			extent: 1000 @ 700;
			model: session;
			element: ((GtLACPSessionTool forSession: session) asElementDo: [ :widget | widget ]);
			yourself.
	scripter pulseUntilReady.
	self assert: session isNew.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> pendingSessionIsVisibleBeforeCreation [
	<gtExample>
	| scripter registry client session list |
	scripter := self emptySessionsView.
	registry := scripter model.
	client := GtLACPSessionRegistryExamples new claudeClient.
	session := client
			newSessionIn: FileLocator temp
			connection: (client connectionIn: FileLocator temp).
	scripter doStep: [ :step | step block: [ registry registerSession: session ] ].
	self assert: session isNew.
	self assert: session remoteSessionId isNil.
	self assertIn: scripter cellExists: 'Claude Code'.
	self assertIn: scripter stateLabelExists: 'new'.
	list := (scripter element query // BrColumnedList) anyOne.
	self assert: list selectedItems asArray equals: {session}.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #'private - scripter' }
GtLACPSessionRegistryScripterExamples >> registeredSessionOf: aClient [
	"The dropdown starts sessions in a separate process and in the shared registry, so wait for the registered session to finish starting."

	20
		timesRepeat: [ GtLACPSessionRegistry current sessions
				detect: [ :each | each client == aClient and: [ each isReady ] ]
				ifFound: [ :aSession | ^ aSession ]
				ifNone: [ 100 milliSeconds wait ] ].
	^ nil
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> registryDirectoryPicker [
	<gtExample>
	| scripter initialExtent |
	scripter := self newSessionAction.
	scripter click
		onSpaceRoot;
		// #GtLACPClaudeCodeClient;
		play.

	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #'private - scripter' }
GtLACPSessionRegistryScripterExamples >> registryDropdownWithClient: aClient [
	| registry button scripter |
	registry := GtLACPSessionRegistryExamples new emptyRegistry.
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
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> registryRefreshPreservesOpenedChat [
	<gtExample>
	| scripter pager tool registryElement |
	scripter := self sessionOpenedFromRegistryInPager.
	pager := scripter element.
	tool := (pager query // GtLACPSessionToolElement) anyOne.
	registryElement := (pager query // GtLACPSessionRegistrySessionsElement) anyOne.
	scripter doStep: [ :step | step block: [ registryElement refresh ] ].
	scripter pulseUntilReady.
	self assert: (pager query // GtLACPSessionToolElement) anyOne == tool.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> registrySortedInPager [
	<gtExample>
	| scripter list |
	scripter := self earlierSessionSelectedInPager.
	list := (scripter element query // BrColumnedList) anyOne.
	scripter
		doStep: [ :step | 
			step
				block: [ scripter model sessions first conversationTitle: 'B'.
					scripter model lastSession conversationTitle: 'C'.
					list columns first
						sortBy: [ :a :b | a conversationTitle <= b conversationTitle ].
					list sortByColumn: list columns first ] ].
	scripter pulseUntilReady.
	self assert: list selectedItems asArray equals: {scripter model sessions first}.
	self assert: list selectedIndices asArray equals: #(1).
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> registryToolActionsMenu [
	<gtExample>
	| registry element scripter |
	registry := GtLACPSessionRegistryExamples new emptyRegistry.
	self
		assert: (GtLACPSessionRegistryActionTarget actionsForObject: registry) size
		equals: 2.
	element := (GtLACPSessionRegistryTool forRegistry: registry)
			asElementDo: [ :widget | widget ].
	scripter := BlScripter new
			extent: 1100 @ 700;
			model: registry;
			element: element;
			yourself.
	scripter menuStep
		openDropdownWithId: #'acp-registry-actions';
		assertMenuContainerExist;
		play.
	#(#'acp-registry-new-session' #'acp-registry-remove-closed-sessions')
		do: [ :anId | 
			scripter assert
				onSpaceRoot;
				// anId;
				exists;
				play ].

	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> registryToolMenuWithoutLabel [
	<gtExample>
	| scripter |
	scripter := self registryToolWithoutLabel.
	scripter menuStep
		openDropdownWithId: #'acp-registry-actions';
		assertMenuContainerExist;
		play.

	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> registryToolNewSessionSubmenu [
	<gtExample>
	| scripter |
	scripter := self registryToolActionsMenu.
	scripter menuStep
		hoverMenuItemWithId: #'acp-registry-new-session';
		onPopover;
		play.
	{GtLACPClaudeCodeClient.
		GtLACPCodexClient}
		do: [ :aClass | 
			scripter assert
				onSpaceRoot;
				// aClass name;
				exists;
				play ].

	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> registryToolShowsClosedSession [
	<gtExample>
	| scripter session |
	scripter := self registryToolShowsPromptingSession.
	session := scripter model lastSession.
	scripter
		doStep: [ :step | 
			step
				block: [ session state: GtLACPSessionReadyState new.
					session close ] ].
	self assertIn: scripter stateLabelExists: 'closed'.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> registryToolShowsPromptingSession [
	<gtExample>
	| scripter session |
	scripter := self registryToolUpdatesLive.
	session := scripter model lastSession.
	scripter
		doStep: [ :step | 
			step
				block: [ session state: GtLACPSessionPromptingState new.
					session announceConversationTreeChanged ] ].
	self assertIn: scripter stateLabelExists: 'prompting'.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> registryToolUpdatesLive [
	<gtExample>
	| scripter registry |
	scripter := self emptyRegistryTool.
	registry := scripter model.
	scripter
		doStep: [ :step | step block: [ GtLACPSessionRegistryExamples new newSessionIn: registry ] ].
	self assertIn: scripter cellExists: 'Claude Code'.
	self assertIn: scripter stateLabelExists: 'ready'.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> registryToolWithoutLabel [
	<gtExample>
	| registry element header toolbar scripter |
	registry := GtLACPSessionRegistryExamples new emptyRegistry.
	element := (GtLACPSessionRegistryTool forRegistry: registry)
			asElementDo: [ :widget | widget ].
	header := element childNamed: #header.
	header removeChild: (header childNamed: #toolLabel).
	toolbar := header childNamed: #toolbar.
	scripter := BlScripter new
			extent: 1100 @ 700;
			model: registry;
			element: element;
			yourself.
	scripter pulseUntilReady.
	self assert: (toolbar bounds inParent right - header width) abs < 1.
	self assert: toolbar bounds inParent top < 1.

	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> removeSessionRequiresConfirmation [
	<gtExample>
	| scripter registry |
	scripter := self sessionContextMenu.
	registry := scripter model.
	scripter menuStep
		hoverMenuItemWithId: #'acp-remove-session';
		onPopover;
		play.
	self assert: registry hasSessions.
	scripter assert
		onSpaceRoot;
		// #'acp-remove-session-confirmation';
		exists;
		play.

	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> removingAnotherSessionPreservesOpenedChat [
	<gtExample>
	| scripter pager tool |
	scripter := self earlierSessionSelectedInPager.
	pager := scripter element.
	tool := (pager query // GtLACPSessionToolElement) anyOne.
	scripter
		doStep: [ :step | step block: [ scripter model removeSession: scripter model lastSession ] ].
	scripter pulseUntilReady.
	self assert: (pager query // GtLACPSessionToolElement) anyOne == tool.
	self assert: scripter model sessions size equals: 1.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> removingPrecedingSessionKeepsOpenedChat [
	<gtExample>
	| scripter pager registryElement list provider selected tool events |
	scripter := self sessionAddedNavigatesOnceInPager.
	pager := scripter element.
	registryElement := (pager query // GtLACPSessionRegistrySessionsElement) anyOne.
	list := (registryElement query // BrColumnedList) anyOne.
	provider := list itemsProvider.
	selected := list selectedItems first.
	tool := (pager query // GtLACPSessionToolElement) anyOne.
	events := OrderedCollection new.
	list when: BrSelectionChanged do: [ :event | events add: event ].
	scripter
		doStep: [ :step | step block: [ scripter model removeSession: scripter model sessions first ] ].
	scripter pulseUntilReady.
	self assert: (registryElement query // BrColumnedList) anyOne == list.
	self assert: list itemsProvider == provider.
	self assert: list selectedItems asArray equals: {selected}.
	self assert: list selectedIndices asArray equals: #(1).
	self assert: (pager query // GtLACPSessionToolElement) anyOne == tool.
	self assert: events isEmpty.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> removingSelectedSessionClearsSelection [
	<gtExample>
	| registry scripter list |
	scripter := self selectionSurvivesManualRefresh.
	registry := scripter model.
	list := (scripter element query // BrColumnedList) anyOne.
	scripter
		doStep: [ :step | step block: [ registry removeSession: registry lastSession ] ].
	self assert: list items isEmpty.
	self assert: list selectedItems isEmpty.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> resizableDirectoryPickerSubmenu [
	<gtExample>
	| scripter initialExtent |
	scripter := self directoryPickerResizedHorizontally.
	scripter do
		label: 'Resize the directory submenu vertically';
		action: [ :aPicker | 
			| aResizer |
			initialExtent := aPicker extent.
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
		value: [ :aPicker | aPicker extent ] equals: [ initialExtent + (0 @ 60) ];
		onSpaceRoot;
		// BrFileSelector;
		play.

	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #'private - scripter' }
GtLACPSessionRegistryScripterExamples >> scripterOn: aRegistry view: aViewSelector [
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

{ #category : #'private - scripter' }
GtLACPSessionRegistryScripterExamples >> selectDirectoryIn: scripter [
	scripter do
		action: [ :aList | aList selectOne: 1 ];
		onSpaceRoot;
		// BrFileSelector;
		// BrColumnedList;
		play.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> selectionFollowsSessionIdentity [
	<gtExample>
	| scripter list session |
	scripter := self addedSessionIsSelectedInSortedList.
	list := (scripter element query // BrColumnedList) anyOne.
	session := scripter model lastSession.
	scripter
		doStep: [ :step | 
			step
				block: [ session conversationTitle: 'Z'.
					session announceConversationTreeChanged ] ].
	self assert: list selectedItems asArray equals: {session}.
	self assert: list selectedIndices asArray equals: #(2).
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> selectionSurvivesManualRefresh [
	<gtExample>
	| scripter list session |
	scripter := self selectionSurvivesRemovingAnotherSession.
	list := (scripter element query // BrColumnedList) anyOne.
	session := scripter model lastSession.
	scripter doStep: [ :step | step block: [ scripter element refresh ] ].
	self assert: list selectedItems asArray equals: {session}.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> selectionSurvivesRemovingAnotherSession [
	<gtExample>
	| registry scripter list session |
	scripter := self sessionSelectionSurvivesRegistryUpdates.
	registry := scripter model.
	list := (scripter element query // BrColumnedList) anyOne.
	session := registry sessions first.
	scripter
		doStep: [ :step | step block: [ registry removeSession: registry lastSession ] ].
	self assert: list items asArray equals: {session}.
	self assert: list selectedItems asArray equals: {session}.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> selectionSurvivesRemovingPrecedingSession [
	<gtExample>
	| registry scripter list session |
	scripter := self addedSessionIsSelected.
	registry := scripter model.
	list := (scripter element query // BrColumnedList) anyOne.
	session := registry lastSession.
	scripter
		doStep: [ :step | step block: [ registry removeSession: registry sessions first ] ].
	self assert: list selectedItems asArray equals: {session}.
	self assert: list selectedIndices asArray equals: #(1).
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> sessionAddedNavigatesOnceInPager [
	<gtExample>
	| scripter pager registry registryElement session navigation |
	scripter := self sessionOpenedFromRegistryInPager.
	pager := scripter element.
	registry := scripter model.
	registryElement := (pager query // GtLACPSessionRegistryToolElement) anyOne.
	navigation := OrderedCollection new.
	registryElement
		when: GtPhlowObjectToSelect
		do: [ :event | navigation add: event tool ].
	scripter
		doStep: [ :step | 
			step
				block: [ session := GtLACPSessionRegistryExamples new newSessionIn: registry ] ].
	scripter pulseUntilReady.
	self assert: navigation size equals: 1.
	self assert: pager pages size equals: 2.
	self assert: (pager query // GtLACPSessionToolElement) anyOne chat == session.
	self
		assert: (registryElement query // BrColumnedList) anyOne selectedItems asArray
		equals: {session}.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> sessionChangePreservesOpenedChat [
	<gtExample>
	| scripter pager session tool chat viewModel input userRow |
	scripter := self sessionOpenedFromRegistryInPager.
	pager := scripter element.
	session := scripter model lastSession.
	tool := (pager query // GtLACPSessionToolElement) anyOne.
	chat := (tool query // GtLACPChatElement) anyOne.
	viewModel := chat viewModel.
	input := chat inputElement.
	userRow := (chat query // #'acp-message-1') anyOne.
	scripter doStep: [ :step | step block: [ session announceChanged ] ].
	scripter pulseUntilReady.
	self
		assert: (pager query // GtLACPSessionToolElement) anyOne == tool
		description: 'An ordinary session change must preserve the tool opened from the registry'.
	self
		assert: (tool query // GtLACPChatElement) anyOne == chat
		description: 'The existing chat must receive incremental updates'.
	self assert: chat viewModel == viewModel.
	self assert: chat inputElement == input.
	self assert: (chat query // #'acp-message-1') anyOne == userRow.
	self assert: pager pages size equals: 2.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> sessionContextMenu [
	<gtExample>
	| registry session view button scripter |
	registry := GtLACPSessionRegistryExamples new registryWithClaudeSession.
	session := registry lastSession.
	view := GtLACPSessionRegistrySessionsElement new registry: registry.
	button := (GtPhlowAction noAction dropdown
			id: #'acp-test-session-context-menu';
			label: 'Session menu';
			menu: [ :anActionElement :aTargetElement | view contextMenuFor: session hostElement: aTargetElement ])
			asElement: [ :anElement | anElement ]
			withHostElement: BlElement new.
	scripter := BlScripter new
			extent: 1100 @ 700;
			model: registry;
			element: (BrVerticalPane new
					matchParent;
					addChild: button;
					yourself);
			yourself.
	scripter menuStep
		openDropdownWithId: #'acp-test-session-context-menu';
		assertMenuContainerExist;
		play.

	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> sessionMenuItemsHaveIcons [
	<gtExample>
	| registry session menu scripter |
	registry := GtLACPSessionRegistryExamples new registryWithClaudeSession.
	session := registry lastSession.
	menu := (GtLACPSessionRegistrySessionsElement new registry: registry)
			contextMenuFor: session
			hostElement: BlElement new.
	#(#'acp-copy-session-id' #'acp-inspect-directory' #'acp-rename-session' #'acp-close-session' #'acp-remove-session')
		do: [ :anId | 
			| item |
			item := menu items detect: [ :each | each id = anId ].
			self assert: (item labelModel isKindOf: BrMenuIconTextLabelModel) ].
	scripter := BlScripter new
			extent: 1100 @ 700;
			model: registry;
			element: ((GtLACPSessionTool forSession: session) asElementDo: [ :widget | widget ]);
			yourself.
	scripter menuStep
		openDropdownWithId: #'acp-session-actions';
		assertMenuContainerExist;
		play.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> sessionOpenedFromRegistryInPager [
	<gtExample>
	| session registry registryElement pager scripter list tool chat |
	session := GtLACPSessionExamples new completedChat viewModel session.
	registry := GtLACPSessionRegistryExamples new emptyRegistry.
	registry registerSession: session.
	registryElement := (GtLACPSessionRegistryTool forRegistry: registry)
			asElementDo: [ :element | element ].
	pager := GtPager createWrappedOn: registryElement.
	scripter := BlScripter new
			extent: 1600 @ 1000;
			model: registry;
			element: pager;
			yourself.
	scripter pulseUntilReady.
	list := (registryElement query // BrColumnedList) anyOne.
	scripter
		doStep: [ :step | 
			step
				block: [ list selectOne: 1.
					registryElement phlow spawnObject: session ] ].
	scripter pulseUntilReady.
	self assert: pager pages size equals: 2.
	self assert: list selectedItems asArray equals: {session}.
	tool := (pager query // GtLACPSessionToolElement) anyOne.
	self assert: tool chat == session.
	chat := (tool query // GtLACPChatElement) anyOne.
	self assert: chat viewModel session == session.
	self assert: (chat query // #'acp-message-1') anyOne notNil.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> sessionSelectionSurvivesRegistryUpdates [
	<gtExample>
	| registry scripter list session |
	scripter := self earlierSessionIsSelected.
	registry := scripter model.
	list := (scripter element query // BrColumnedList) anyOne.
	session := registry sessions first.
	scripter
		doStep: [ :step | step block: [ registry lastSession announceConversationTreeChanged ] ].
	self assert: list selectedItems asArray equals: {session}.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> sessionStateVisuals [
	<gtExample>
	| registry scripter states |
	registry := GtLACPSessionRegistryExamples new emptyRegistry.
	states := {GtLACPSessionNewState new.
			GtLACPSessionStartingState new.
			GtLACPSessionLoadingState new.
			GtLACPSessionReadyState new.
			GtLACPSessionPromptingState new.
			GtLACPSessionFailedState new.
			GtLACPSessionClosedState new.
			GtLACPSessionObservingState new.
			GtLACPSessionDisconnectedState new.
			GtLACPSessionUnknownState new
				name: #futureState;
				yourself}.
	states
		do: [ :aState | (GtLACPSessionRegistryExamples new newSessionIn: registry) state: aState ].
	scripter := self scripterOn: registry view: #gtSessionsFor:.
	scripter pulseUntilReady.
	states
		do: [ :aState | self assertIn: scripter stateLabelExists: aState asString ].
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> sessionUpdateKeepsListAndSelection [
	<gtExample>
	| scripter pager registryElement list provider selected events |
	scripter := self sessionChangePreservesOpenedChat.
	pager := scripter element.
	registryElement := (pager query // GtLACPSessionRegistrySessionsElement) anyOne.
	list := (registryElement query // BrColumnedList) anyOne.
	provider := list itemsProvider.
	selected := list selectedItems asArray.
	events := OrderedCollection new.
	list when: BrSelectionChanged do: [ :event | events add: event ].
	scripter
		doStep: [ :step | step block: [ scripter model lastSession announceChanged ] ].
	scripter pulseUntilReady.
	self assert: (registryElement query // BrColumnedList) anyOne == list.
	self assert: list itemsProvider == provider.
	self assert: list selectedItems asArray equals: selected.
	self assert: events isEmpty.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> sessionsSortedByTitle [
	<gtExample>
	| scripter list session |
	scripter := self selectionSurvivesRemovingPrecedingSession.
	list := (scripter element query // BrColumnedList) anyOne.
	session := scripter model lastSession.
	scripter
		doStep: [ :step | 
			step
				block: [ session conversationTitle: 'C'.
					list columns first
						sortBy: [ :a :b | a conversationTitle <= b conversationTitle ].
					list sortByColumn: list columns first ] ].
	self assert: list sortState isAscending.
	self assert: list selectedItems asArray equals: {session}.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> sessionsViewShowsClosedSession [
	<gtExample>
	| scripter session |
	scripter := self sessionsViewShowsPromptingSession.
	session := scripter model lastSession.
	scripter
		doStep: [ :step | 
			step
				block: [ session state: GtLACPSessionReadyState new.
					session close ] ].
	self assertIn: scripter stateLabelExists: 'closed'.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> sessionsViewShowsPromptingSession [
	<gtExample>
	| scripter session |
	scripter := self sessionsViewUpdatesLive.
	session := scripter model lastSession.
	scripter
		doStep: [ :step | 
			step
				block: [ session state: GtLACPSessionPromptingState new.
					session announceConversationTreeChanged ] ].
	self assertIn: scripter stateLabelExists: 'prompting'.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> sessionsViewUpdatesLive [
	<gtExample>
	| scripter |
	scripter := self firstSessionIsSelected.
	self assertIn: scripter cellExists: 'Claude Code'.
	self assertIn: scripter stateLabelExists: 'ready'.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> sortedRegistryUpdateKeepsOpenedChat [
	<gtExample>
	| scripter pager list provider selected tool events |
	scripter := self registrySortedInPager.
	pager := scripter element.
	list := (pager query // BrColumnedList) anyOne.
	provider := list itemsProvider.
	selected := list selectedItems first.
	tool := (pager query // GtLACPSessionToolElement) anyOne.
	events := OrderedCollection new.
	list when: BrSelectionChanged do: [ :event | events add: event ].
	scripter doStep: [ :step | step block: [ selected conversationTitle: 'Z' ] ].
	scripter pulseUntilReady.
	self assert: (pager query // BrColumnedList) anyOne == list.
	self assert: list itemsProvider == provider.
	self assert: list selectedItems asArray equals: {selected}.
	self assert: list selectedIndices asArray equals: #(2).
	self assert: (pager query // GtLACPSessionToolElement) anyOne == tool.
	self assert: events isEmpty.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> startSessionDirectoryPicker [
	<gtExample>
	| client button scripter registered |
	client := GtLACPSessionRegistryExamples new claudeClient.
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

	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> startSessionDirectorySelected [
	<gtExample>
	| scripter |
	scripter := self startSessionDirectoryPicker.
	scripter do
		label: 'Select the first directory';
		action: [ :aList | aList selectOne: 1 ];
		onSpaceRoot;
		// BrFileSelector;
		// BrColumnedList;
		play.

	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> startSessionDropdownRegistersSession [
	<gtExample>
	| client scripter registered |
	scripter := self startSessionDirectorySelected.
	client := scripter model.
	scripter click
		label: 'Start the session';
		onSpaceRoot;
		// #'acp-start-session-button';
		play.
	registered := self registeredSessionOf: client.
	[ self assert: registered notNil.
	self assert: registered isReady.
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

{ #category : #'private - scripter' }
GtLACPSessionRegistryScripterExamples >> startSessionInRegistryDropdown: scripter [
	| registry |
	registry := scripter model.
	scripter click
		onSpaceRoot;
		// #'acp-start-session-button';
		play.
	20
		timesRepeat: [ (registry hasSessions and: [ registry lastSession isReady ])
				ifFalse: [ 100 milliSeconds wait ] ].
	self assert: registry sessions size equals: 1.
	self assert: registry lastSession isReady.
	self assert: registry lastSession directory isDirectory.
	scripter pulseUntilReady.
	scripter assert
		onSpaceRoot;
		// BrFileSelector;
		notExists;
		play.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> toolCallPreservesOpenedChat [
	<gtExample>
	| scripter pager session tool chat input userRow |
	scripter := self sessionChangePreservesOpenedChat.
	pager := scripter element.
	session := scripter model lastSession.
	tool := (pager query // GtLACPSessionToolElement) anyOne.
	chat := (tool query // GtLACPChatElement) anyOne.
	input := chat inputElement.
	userRow := (chat query // #'acp-message-1') anyOne.
	scripter
		doStep: [ :step | 
			step
				block: [ session
						receiveUpdate: {'sessionUpdate' -> 'tool_call'.
								'toolCallId' -> 'registry-refresh-probe'.
								'title' -> 'Probe tool'.
								'status' -> 'completed'} asDictionary ] ].
	scripter pulseUntilReady.
	self
		assert: (session currentTurn toolCalls anySatisfy: [ :call | call title = 'Probe tool' ]).
	self assert: (pager query // GtLACPSessionToolElement) anyOne == tool.
	self assert: (tool query // GtLACPChatElement) anyOne == chat.
	self assert: chat inputElement == input.
	self assert: (chat query // #'acp-message-1') anyOne == userRow.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionRegistryScripterExamples >> unrelatedSessionChangePreservesOpenedChat [
	<gtExample>
	| scripter pager tool chat input |
	scripter := self earlierSessionSelectedInPager.
	pager := scripter element.
	tool := (pager query // GtLACPSessionToolElement) anyOne.
	chat := (tool query // GtLACPChatElement) anyOne.
	input := chat inputElement.
	scripter
		doStep: [ :step | step block: [ scripter model lastSession announceChanged ] ].
	scripter pulseUntilReady.
	self assert: (pager query // GtLACPSessionToolElement) anyOne == tool.
	self assert: (tool query // GtLACPChatElement) anyOne == chat.
	self assert: chat inputElement == input.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]
