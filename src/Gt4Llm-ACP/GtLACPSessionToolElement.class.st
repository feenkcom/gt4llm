"
I present an ACP session using the Phlow chat tool structure: a header with the tool label, the session header as title and a toolbar with the session's <gtToolAction> actions, collected object views in tabs, and a collapsed playground. I specialize the ACP view collection and omit GtLChat-specific object storage and summarizer integration.
"
Class {
	#name : #GtLACPSessionToolElement,
	#superclass : #GtPhlowChatToolElement,
	#instVars : [
		'titleLabel',
		'toolbarElement',
		'headerUpdater'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #building }
GtLACPSessionToolElement >> buildHeaderElement [
	^ super buildHeaderElement
		addChild: self buildTitleContainer as: #titleContainer;
		yourself
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

{ #category : #initialization }
GtLACPSessionToolElement >> buildToolLabel [
 ^ super buildToolLabel text: 'ACP Chat'; yourself
]

{ #category : #building }
GtLACPSessionToolElement >> buildToolbar [
	^ BrToolbar new
		aptitude: BrGlamorousToolbarAptitude new;
		fitContent
]

{ #category : #accessing }
GtLACPSessionToolElement >> chat: aSession [
	chat ifNotNil: [ chat announcer unsubscribe: self ].
	super chat: aSession.
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
	headerUpdater := BrElementUpdater new
			element: self selector: #updateHeader;
			postponedDuration: 150 milliseconds;
			yourself.
	self phlow
		accessTool: (GtPhlowToolClassType forClass: GtLACPSession)
		viewModel: #chat
		object: #chat
]

{ #category : #events }
GtLACPSessionToolElement >> onSessionChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ headerUpdater requestUpdate ]
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
