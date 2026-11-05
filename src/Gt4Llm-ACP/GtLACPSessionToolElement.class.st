"
I present an ACP session with a vertical layout, a header with the session title and actions, collected object views in tabs, and a collapsed playground. I manage session announcements and summarizer tab updates directly.
"
Class {
	#name : #GtLACPSessionToolElement,
	#superclass : #BlElement,
	#instVars : [
		'chat',
		'titleLabel',
		'toolbarElement',
		'headerUpdater'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #building }
GtLACPSessionToolElement >> buildHeaderElement [
	^ BrVerticalPane new
		padding: (BlInsets left: 5);
		vFitContent;
		hMatchParent;
		addChild: self buildToolLabel as: #toolLabel;
		addChild: self buildTitleContainer as: #titleContainer;
		yourself
]

{ #category : #building }
GtLACPSessionToolElement >> buildPlaygroundPageElement [
	| playgroundElement |
	playgroundElement := (GtInspector environment
			at: GtInspector embeddedPlaygroundName) new.
	playgroundElement collapse.
	^ playgroundElement
]

{ #category : #building }
GtLACPSessionToolElement >> buildStateElement [
	^ GtLACPSessionStateElement new
		margin: (BlInsets left: 10 right: 10);
		yourself
]

{ #category : #building }
GtLACPSessionToolElement >> buildTitleContainer [
	titleLabel := self buildTitleLabel.
	toolbarElement := self buildToolbar.
	^ BrHorizontalPane new
		hMatchParent;
		vFitContent;
		alignCenterLeft;
		addChild: titleLabel as: #titleLabel;
		addChild: self buildStateElement as: #sessionState;
		addChild: (BrFrame new
				hMatchParent;
				vExact: 0;
				yourself);
		addChild: toolbarElement as: #toolbar;
		yourself
]

{ #category : #building }
GtLACPSessionToolElement >> buildTitleLabel [
	^ BrLabel new
		aptitude: (BrGlamorousLabelAptitude new
				bold;
				fontSize: 18);
		hFitContentLimited;
		text: ''
]

{ #category : #building }
GtLACPSessionToolElement >> buildToolLabel [
	^ BrLabel new
		aptitude: (BrGlamorousLabelAptitude new glamorousRegularFontAndSize
				foreground: Color gray;
				fontSize: 12);
		text: 'ACP Session'
]

{ #category : #building }
GtLACPSessionToolElement >> buildToolbar [
	^ BrToolbar new
		aptitude: BrGlamorousToolbarAptitude new;
		fitContent
]

{ #category : #building }
GtLACPSessionToolElement >> buildViewsContainerElement [
	^ BrFrame new matchParent
]

{ #category : #accessing }
GtLACPSessionToolElement >> chat [
	^ chat
]

{ #category : #accessing }
GtLACPSessionToolElement >> chat: aSession [
	chat ifNotNil: [ chat announcer unsubscribe: self ].
	chat := aSession.
	self updateContainedViews.
	self updatePlayground.
	aSession
		ifNotNil: [ aSession announcer weak
				when: GtLACPSessionChanged
				send: #onSessionChanged:
				to: self ].
	self stateElement session: aSession.
	self updateHeader
]

{ #category : #updating }
GtLACPSessionToolElement >> collectToolActions [
	chat ifNil: [ ^ #() ].
	^ GtPhlowActionsCollector new
		pragmaName: #gtToolAction;
		fromObject: chat;
		selectUsing: [ :anAction | (anAction isKindOf: GtPhlowNoAction) not ];
		collect
]

{ #category : #views }
GtLACPSessionToolElement >> collectToolViews [
 | views context |
 context := self chat phlowContext.
 views := (GtPhlowViewsCollector new
  fromObject: self chat;
  pragmaNames: GtLSettings messageViewPragmaNames;
  context: context;
  collect),
  (self chat summarizerViewsFor: self chat gtInspectorTargetModels inContext: context).
 GtPhlowUtility sortByPriority: views.
 ^ views
]

{ #category : #views }
GtLACPSessionToolElement >> gtInspectorTargetModels [
 ^ { self chat }, self chat gtInspectorTargetModels
]

{ #category : #initialization }
GtLACPSessionToolElement >> initialize [
	super initialize.
	self layout: BlLinearLayout vertical.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self padding: (BlInsets all: 5).
	self initializeContent.
	headerUpdater := BrElementUpdater new
			element: self selector: #updateHeader;
			postponedDuration: 150 milliseconds;
			yourself.
	self phlow
		accessTool: (GtPhlowToolClassType forClass: GtLACPSession)
		viewModel: #chat
		object: #chat
]

{ #category : #building }
GtLACPSessionToolElement >> initializeContent [
	self addChild: self buildHeaderElement as: #header.
	self addChild: self buildViewsContainerElement as: #viewsContainer.
	self addChild: self buildPlaygroundPageElement as: #playgroundPage
]

{ #category : #events }
GtLACPSessionToolElement >> onSessionChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ headerUpdater requestUpdate ]
]

{ #category : #accessing }
GtLACPSessionToolElement >> playgroundElement [
	^ self childNamed: #playgroundPage
]

{ #category : #accessing }
GtLACPSessionToolElement >> stateElement [
	^ self childNamed: #sessionState
]

{ #category : #updating }
GtLACPSessionToolElement >> updateContainedViews [
 | compositeView tabGroup listener |
 self chat ifNil: [
  self viewsContainerElement removeChildren.
  ^ self ].
 compositeView := GtPhlowCompositeView new views: self collectToolViews.
 tabGroup := compositeView asElementDo: [ :element | element ].
 listener := GtLPhlowSummarizersChangedListener
  installOnCompositeElement: tabGroup forRegistry: self chat summarizersRegistry.
 listener onSummarizersChangedAction: (GtLACPChangeSummarizersTabAction new
  tabGroup: tabGroup;
  session: self chat;
  yourself).
 self viewsContainerElement removeChildren; addChild: tabGroup
]

{ #category : #updating }
GtLACPSessionToolElement >> updateHeader [
	self updateTitle.
	self updateToolbarActions
]

{ #category : #updating }
GtLACPSessionToolElement >> updatePlayground [
	self chat ifNil: [ ^ self ].
	self playgroundElement objectHolder: (GtInspectorObject new object: self chat)
]

{ #category : #updating }
GtLACPSessionToolElement >> updateTitle [
	titleLabel text: (chat ifNil: [ '' ] ifNotNil: #header) asRopedText
]

{ #category : #updating }
GtLACPSessionToolElement >> updateToolbarActions [
	| actions |
	actions := self collectToolActions.
	toolbarElement numberOfItems = actions size ifTrue: [ ^ self ].
	toolbarElement removeAllItems.
	actions
		do: [ :anAction | 
			anAction
				asElement: [ :actionElement | toolbarElement addItem: actionElement ]
				withHostElement: self ]
]

{ #category : #accessing }
GtLACPSessionToolElement >> viewsContainerElement [
	^ self childNamed: #viewsContainer
]
