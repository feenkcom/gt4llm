"
I own the registry sessions list and its subscriptions. I select added sessions and retain selection by identity when sessions change or are removed.
"
Class {
	#name : #GtLACPSessionRegistrySessionsElement,
	#superclass : #BrFrame,
	#instVars : [
		'registry',
		'list'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #updating }
GtLACPSessionRegistrySessionsElement >> addSession: aSession [
	| items index |
	((registry sessions identityIncludes: aSession)
		and: [ (list items identityIncludes: aSession) not ]) ifFalse: [ ^ self ].
	items := list items asOrderedCollection copy.
	items add: aSession.
	items := list sortState orderedItems: items.
	index := items identityIndexOf: aSession.
	self replaceItemsPreservingSelection: items.
	self dataSource notifyItemsInserted: (index to: index).
	list selectOne: index.
	list scrollToItem: index
]

{ #category : #building }
GtLACPSessionRegistrySessionsElement >> contextMenuFor: aSession hostElement: anElement [
	| menu |
	menu := GtLACPSessionActionTarget
			menuItemsForObject: aSession
			hostElement: anElement.
	menu
		addItem: (registry removeSessionMenuItemFor: aSession hostElement: anElement).
	^ menu
]

{ #category : #updating }
GtLACPSessionRegistrySessionsElement >> dataSource [
	^ (list childNamed: #scrollable) dataSource
]

{ #category : #initialization }
GtLACPSessionRegistrySessionsElement >> initialize [
	super initialize.
	self matchParent
]

{ #category : #building }
GtLACPSessionRegistrySessionsElement >> newCellLabel [
	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude;
		hMatchParent;
		vFitContent;
		padding: (BlInsets all: 5)
]

{ #category : #building }
GtLACPSessionRegistrySessionsElement >> newList [
	| aList |
	aList := BrColumnedList new
			matchParent;
			rowStencil: (BrGlamorousColumnedListItemElementWithContextMenuDecorator new
					stencilBuilder: (BrGlamorousColumnedListSelectableRowElementStencilBuilder new cellSpacing: 10);
					contextMenuStencil: [ :anElement :aSession :anIndex :anItemType | self contextMenuFor: aSession hostElement: anElement ]);
			addEventHandler: (GtPhlowListToSelectHandler new transformation: [ :aSession | aSession ]).
	aList column
		title: 'Title';
		weight: 1;
		cellStencil: [ self newCellLabel ];
		dataBinder: [ :aLabel :aSession | aLabel text: aSession conversationTitle ].
	aList column
		title: 'Client';
		width: 110;
		cellStencil: [ self newCellLabel ];
		dataBinder: [ :aLabel :aSession | aLabel text: aSession client displayName ].
	aList column
		title: 'State';
		width: 120;
		cellStencil: [ GtLACPSessionStateElement new ];
		dataBinder: [ :anElement :aSession | anElement session: aSession ].
	aList column
		title: 'Turns';
		width: 60;
		cellStencil: [ self newCellLabel ];
		dataBinder: [ :aLabel :aSession | aLabel text: aSession turns size asString ].
	aList column
		title: 'Context used';
		width: 80;
		cellStencil: [ self newCellLabel ];
		dataBinder: [ :aLabel :aSession | aLabel text: aSession contextWindow usagePercentageString ].
	aList items: registry sessions.
	aList withHeaders.
	^ aList
]

{ #category : #updating }
GtLACPSessionRegistrySessionsElement >> onAddedToSceneGraph [
	super onAddedToSceneGraph.
	self subscribeToRegistry.
	self refresh
]

{ #category : #updating }
GtLACPSessionRegistrySessionsElement >> onRemovedFromSceneGraph [
	registry announcer unsubscribe: self.
	super onRemovedFromSceneGraph
]

{ #category : #updating }
GtLACPSessionRegistrySessionsElement >> onSessionRegistered: anAnnouncement [
	self
		enqueueTask: (BlTaskAction new action: [ self addSession: anAnnouncement session ])
]

{ #category : #updating }
GtLACPSessionRegistrySessionsElement >> onSessionUnregistered: anAnnouncement [
	self
		enqueueTask: (BlTaskAction new action: [ self removeSession: anAnnouncement session ])
]

{ #category : #updating }
GtLACPSessionRegistrySessionsElement >> onSessionsChanged: anAnnouncement [
	self
		enqueueTask: (BlTaskAction new action: [ self updateSessions: anAnnouncement sessions ])
]

{ #category : #updating }
GtLACPSessionRegistrySessionsElement >> refresh [
	| items |
	items := list sortState orderedItems: registry sessions.
	(items size = list items size
		and: [ (1 to: items size)
				allSatisfy: [ :index | (items at: index) == (list items at: index) ] ])
		ifTrue: [ ^ self updateSessions: items ].
	self replaceItemsPreservingSelection: items.
	self dataSource notifyChanged
]

{ #category : #building }
GtLACPSessionRegistrySessionsElement >> registry: aRegistry [
	registry ifNotNil: [ registry announcer unsubscribe: self ].
	registry := aRegistry.
	self removeChildren.
	list := self newList.
	self addChild: list.
	self isAttachedToSceneGraph ifTrue: [ self subscribeToRegistry ]
]

{ #category : #updating }
GtLACPSessionRegistrySessionsElement >> removeSession: aSession [
	| index items |
	index := list items identityIndexOf: aSession ifAbsent: [ ^ self ].
	items := list items asOrderedCollection copy.
	items removeAt: index.
	self replaceItemsPreservingSelection: items.
	self dataSource notifyItemsRemoved: (index to: index)
]

{ #category : #updating }
GtLACPSessionRegistrySessionsElement >> replaceItemsPreservingSelection: newItems [
	"Keep the selection when its items survive. Only rebase indices when rows move."

	| selected indices request selectionModel |
	selected := list selectedItems asArray.
	indices := OrderedCollection new.
	newItems
		withIndexDo: [ :item :index | (selected identityIncludes: item) ifTrue: [ indices add: index ] ].
	indices asArray = list selectedIndices asArray
		ifFalse: [ indices
				ifEmpty: [ list deselectAll ]
				ifNotEmpty: [ selectionModel := list viewModel widgetModels
							detect: [ :each | each isKindOf: BrSelectionModel ].
					request := BrSelectionRequest oneWay.
					selectionModel dispatchEvent: request.
					request response
						selectionDo: [ :selection | 
							selection removeAll.
							indices do: [ :index | selection select: index - 1 to: index ].
							self dataSource selection: selection copy ] ] ].
	list itemsProvider collection: newItems
]

{ #category : #updating }
GtLACPSessionRegistrySessionsElement >> subscribeToRegistry [
	registry announcer unsubscribe: self.
	registry announcer weak
		when: GtLACPSessionRegistered
			send: #onSessionRegistered:
			to: self;
		when: GtLACPSessionUnregistered
			send: #onSessionUnregistered:
			to: self;
		when: GtLACPSessionRegistryChanged
			send: #onSessionsChanged:
			to: self
]

{ #category : #updating }
GtLACPSessionRegistrySessionsElement >> updateSessions: affectedSessions [
	| items affected |
	items := list sortState orderedItems: list items.
	((1 to: items size)
		allSatisfy: [ :index | (items at: index) == (list items at: index) ])
		ifFalse: [ self replaceItemsPreservingSelection: items.
			^ self dataSource notifyChanged ].
	affected := affectedSessions ifNil: [ list items ].
	list items
		withIndexDo: [ :session :index | 
			(affected identityIncludes: session)
				ifTrue: [ self dataSource notifyItemsChanged: (index to: index) ] ]
]
