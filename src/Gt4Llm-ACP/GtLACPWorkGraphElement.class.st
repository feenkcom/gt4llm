"
I display an agent work graph in a virtualized columned list. I coalesce connection announcements on the UI thread and append or invalidate only rows whose displayed data or lane segments changed.
"
Class {
	#name : #GtLACPWorkGraphElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'graph',
		'listElement',
		'graphColumn',
		'updater',
		'renderedKeys'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #building }
GtLACPWorkGraphElement >> configureColumns [
	listElement
		rowStencil: ([ GtLACPWorkGraphListRowElement new ]
				asStencilBuilder: BrColumnedListRowElementStencilBuilder);
		rowDataBinder: [ :element :event :index | element row: event ];
		addEventHandler: (GtPhlowListToSelectHandler new transformation: [ :event | event object ]).
	graphColumn := listElement column
			title: 'Graph';
			cellStencil: [ GtLACPWorkGraphRowElement new ];
			dataBinder: [ :element :event | 
				element
					row: event;
					build ];
			width: 80.
	listElement column
		title: 'Agent';
		cellStencil: [ self newCellLabel ];
		dataBinder: [ :cell :event | cell text: event lane label ];
		width: 150.
	listElement column
		title: 'Event';
		cellStencil: [ self newCellLabel ];
		dataBinder: [ :cell :event | cell text: event kind asString ];
		width: 75.
	listElement column
		title: 'Details';
		weight: 1;
		cellStencil: [ self newCellLabel ];
		dataBinder: [ :cell :event | cell text: event description ].
	listElement column
		title: 'State';
		cellStencil: [ self newCellLabel ];
		dataBinder: [ :cell :event | cell text: event state ];
		width: 95.
	listElement column
		title: 'Time';
		cellStencil: [ self newCellLabel ];
		dataBinder: [ :cell :event | cell text: event timestamp asTime print24 ];
		width: 100.
	listElement addAptitude: BrColumnedListHeaderAptitude
]

{ #category : #accessing }
GtLACPWorkGraphElement >> graph [
	^ graph
]

{ #category : #accessing }
GtLACPWorkGraphElement >> graph: aGraph [
	graph := aGraph.
	self updateRows
]

{ #category : #initialization }
GtLACPWorkGraphElement >> initialize [
	super initialize.
	self
		hMatchParent;
		vMatchParent.
	renderedKeys := #().
	listElement := BrColumnedList new
			id: #'acp-work-graph-list';
			hMatchParent;
			vMatchParent;
			items: OrderedCollection new;
			yourself.
	self configureColumns.
	updater := BrElementUpdater new
			element: self selector: #updateRows;
			postponedDuration: 150 milliseconds;
			yourself.
	self addChild: listElement
]

{ #category : #accessing }
GtLACPWorkGraphElement >> listElement [
	^ listElement
]

{ #category : #building }
GtLACPWorkGraphElement >> newCellLabel [
	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude;
		hMatchParent;
		vFitContent;
		yourself
]

{ #category : #hooks }
GtLACPWorkGraphElement >> onAddedToSceneGraph [
	super onAddedToSceneGraph.
	graph session connection announcer unsubscribe: self.
	graph session connection announcer weak
		when: GtLACPConversationTreeChanged
		send: #onWorkChanged:
		to: self.
	updater requestUpdate
]

{ #category : #hooks }
GtLACPWorkGraphElement >> onRemovedFromSceneGraph [
	graph session connection announcer unsubscribe: self.
	super onRemovedFromSceneGraph
]

{ #category : #updating }
GtLACPWorkGraphElement >> onWorkChanged: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [ updater requestUpdate ])
]

{ #category : #updating }
GtLACPWorkGraphElement >> updateRows [
	| items previous oldCount changed keys source |
	graph ifNil: [ ^ self ].
	graph refresh.
	items := graph rows.
	keys := items collect: #renderingKey as: Array.
	previous := listElement items.
	oldCount := previous size.
	graphColumn columnWidth = graph graphWidth
		ifFalse: [ graphColumn width: graph graphWidth ].
	(oldCount <= items size
		and: [ (1 to: oldCount)
				allSatisfy: [ :index | (previous at: index) == (items at: index) ] ])
		ifFalse: [ listElement items: items asOrderedCollection.
			renderedKeys := keys.
			^ self ].
	changed := (1 to: oldCount)
			select: [ :index | (renderedKeys at: index) ~= (keys at: index) ].
	source := (listElement childNamed: #scrollable) dataSource.
	items size > oldCount
		ifTrue: [ previous addAll: (items copyFrom: oldCount + 1 to: items size).
			source notifyItemsInserted: (oldCount + 1 to: items size) ].
	changed do: [ :index | source notifyItemsChanged: (index to: index) ].
	renderedKeys := keys
]
