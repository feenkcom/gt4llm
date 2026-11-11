"
I present an ACP session with a vertical layout, a header with the session title and actions, a configuration expander with a Magritte form, collected object views in tabs, and a collapsed playground. I manage session announcements and summarizer tab updates directly.
"
Class {
	#name : #GtLACPSessionToolElement,
	#superclass : #BlElement,
	#instVars : [
		'chat',
		'titleLabel',
		'toolbarElement',
		'headerUpdater',
		'interactionToReveal'
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
		addChild: GtLACPSessionConfigurationElement new as: #'acp-configuration';
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

{ #category : #private }
GtLACPSessionToolElement >> collectToolViews [
	| views context |
	context := self chat phlowContext.
	views := self gtInspectorTargetModels
			flatCollect: [ :model | 
				GtPhlowViewsCollector new
					fromObject: model;
					pragmaNames: GtLSettings messageViewPragmaNames;
					context: context;
					collect ].
	views := views
			collect: [ :view | view title = 'Chat' ifTrue: [ self interactionChatView ] ifFalse: [ view ] ].
	GtPhlowUtility sortByPriority: views.
	^ views
]

{ #category : #accessing }
GtLACPSessionToolElement >> configurationElement [
	^ (self childWithId: #header) childWithId: #'acp-configuration'
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
		object: #chat.
	self
		when: GtLACPRevealInteractionWish
		do: [ :wish | 
			(self chat notNil
				and: [ self chat rootSession == wish request session rootSession ])
				ifTrue: [ wish consumed: true.
					self revealInteraction: wish request ] ]
]

{ #category : #building }
GtLACPSessionToolElement >> initializeContent [
	self addChild: self buildHeaderElement as: #header.
	self addChild: self buildViewsContainerElement as: #viewsContainer.
	self addChild: self buildPlaygroundPageElement as: #playgroundPage
]

{ #category : #building }
GtLACPSessionToolElement >> interactionChatView [
	^ GtPhlowView empty explicit
		title: 'Chat';
		priority: 0;
		stencil: [ | element |
			element := self chat asElement.
			interactionToReveal
				ifNotNil: [ element revealInteraction: interactionToReveal.
					interactionToReveal := nil ].
			element ]
]

{ #category : #accessing }
GtLACPSessionToolElement >> interactionToReveal: aRequest [
	interactionToReveal := aRequest
]

{ #category : #events }
GtLACPSessionToolElement >> onSessionChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ headerUpdater requestUpdate ]
]

{ #category : #accessing }
GtLACPSessionToolElement >> playgroundElement [
	^ self childNamed: #playgroundPage
]

{ #category : #navigation }
GtLACPSessionToolElement >> revealInteraction: aRequest [
	| tabGroup chatElement |
	interactionToReveal := aRequest.
	tabGroup := self viewsContainerElement children first.
	tabGroup selectTabWithLabelString: 'Chat'.
	self viewsContainerElement
		withAllChildrenBreadthFirstDo: [ :each | (each isKindOf: GtLACPChatElement) ifTrue: [ chatElement := each ] ].
	chatElement
		ifNotNil: [ interactionToReveal := nil.
			chatElement revealInteraction: aRequest ]
]

{ #category : #accessing }
GtLACPSessionToolElement >> stateElement [
	^ self childNamed: #sessionState
]

{ #category : #private }
GtLACPSessionToolElement >> updateContainedViews [
	| compositeView tabGroup |
	self chat
		ifNil: [ self viewsContainerElement removeChildren.
			^ self ].
	compositeView := GtPhlowCompositeView new views: self collectToolViews.
	tabGroup := compositeView asElementDo: [ :element | element ].
	GtLPhlowSummarizersChangedListener
		installOnCompositeElement: tabGroup
		forRegistry: self chat summarizersRegistry.
	self viewsContainerElement
		removeChildren;
		addChild: tabGroup
]

{ #category : #updating }
GtLACPSessionToolElement >> updateHeader [
	self updateTitle.
	self updateToolbarActions.
	self configurationElement
		session: chat;
		configOptions: (chat ifNil: [ #() ] ifNotNil: #configOptions)
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
