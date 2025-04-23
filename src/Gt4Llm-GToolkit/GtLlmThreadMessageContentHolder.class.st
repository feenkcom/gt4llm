Class {
	#name : #GtLlmThreadMessageContentHolder,
	#superclass : #BrVerticalPane,
	#instVars : [
		'threadMessageViewModel',
		'header',
		'updater'
	],
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #accessing }
GtLlmThreadMessageContentHolder >> enqueueUpdate [
	self
		enqueueTask: (BlTaskAction new action: [ self onThreadMessageViewModelChanged ])
]

{ #category : #accessing }
GtLlmThreadMessageContentHolder >> header [
	^ header
]

{ #category : #accessing }
GtLlmThreadMessageContentHolder >> header: anObject [
	header := anObject
]

{ #category : #accessing }
GtLlmThreadMessageContentHolder >> initialize [
	super initialize.
	
	self initializeHeader.

	self hMatchParent vFitContentLimited.
	
	self addChild: self header as: #'message-header'
]

{ #category : #accessing }
GtLlmThreadMessageContentHolder >> initializeHeader [
	header := BrHorizontalPane new
			hMatchParent;
			vFitContent
]

{ #category : #accessing }
GtLlmThreadMessageContentHolder >> makeActionToolbar [
	| actionToolbar |
	actionToolbar := BrToolbar new aptitude: BrGlamorousToolbarAptitude new.

	self threadMessageViewModel messageToolbarActions
		do: [ :each | 
			each
				asElement: [ :actionElement | actionToolbar addItem: actionElement beTinySize ]
				withHostElement: self ].

	^ actionToolbar
]

{ #category : #accessing }
GtLlmThreadMessageContentHolder >> onMessageContentsUpdated: anAnnouncement [
	self viewUpdater requestUpdate
]

{ #category : #accessing }
GtLlmThreadMessageContentHolder >> onThreadMessageViewModelChanged [
	self updateHeader.
	self updateViews
]

{ #category : #accessing }
GtLlmThreadMessageContentHolder >> onThreadMessageViewModelChanged: anAnnouncement [
	self enqueueUpdate
]

{ #category : #accessing }
GtLlmThreadMessageContentHolder >> threadMessageViewModel [
	^ threadMessageViewModel
]

{ #category : #accessing }
GtLlmThreadMessageContentHolder >> threadMessageViewModel: anObject [
	threadMessageViewModel = anObject ifTrue: [ ^ self ].

	threadMessageViewModel ifNotNil: [ threadMessageViewModel unsubscribe: self ].

	threadMessageViewModel := anObject.

	threadMessageViewModel weak
		when: GtLlmThreadMessageViewModelChanged
			send: #onThreadMessageViewModelChanged:
			to: self;
		when: GtLlmMessageContentsUpdated
			send: #onMessageContentsUpdated:
			to: self.

	self enqueueUpdate
]

{ #category : #accessing }
GtLlmThreadMessageContentHolder >> updateHeader [
	self header removeChildren.
	self header addChild: self threadMessageViewModel messageHeaderElement.
	self header addChild: self makeActionToolbar
]

{ #category : #accessing }
GtLlmThreadMessageContentHolder >> updateViews [
	self views: self threadMessageViewModel messageViews
]

{ #category : #accessing }
GtLlmThreadMessageContentHolder >> viewUpdater [
	^ updater
		ifNil: [ updater := BrElementUpdater new.
			updater element: self selector: #updateViews.
			updater postponedDuration: 300 milliseconds ]
]

{ #category : #accessing }
GtLlmThreadMessageContentHolder >> views: aCollectionOfViews [
	| views |
	self removeChildNamed: #'message-tabs'.
	views := aCollectionOfViews
			reject: [ :aView | aView isKindOf: GtPhlowEmptyView ].

	views ifEmpty: [ ^ self ].

	self addChild: (self viewsToTabGroup: aCollectionOfViews) as: #'message-tabs'
]

{ #category : #accessing }
GtLlmThreadMessageContentHolder >> viewsToTabGroup: aCollectionOfViews [
	"(GtPhlowCompositeView new views: aCollectionOfViews)
		asElementDo: [ :e | e vFitContentLimited ]  "

	| tabs aTabGroup aListener aBuildContext |
	tabs := OrderedCollection new.
	aCollectionOfViews
		do: [ :view | 
			view
				ifItHasContent: [ | aTab |
					aTab := BrTab new.
					aTab phlow
						beViewTitle;
						entity: view.
					aTab
						aptitude: BrGlamorousTabAptitude
								+ (GtPhlowBrowseDefinitionAptitude new definition: [ view allDefiningMethods ]);
						label: view title;
						stencil: [ view
								asElementDo: [ :anElement | 
									anElement phlow beViewContent.
									(anElement respondsTo: #vFitContentLimited)
										ifTrue: [ anElement vFitContentLimited ]
										ifFalse: [ anElement constraintsDo: [ :c | c vertical fitContentLimited ] ].
									anElement ] ];
						toolbarStencil: [ view actionsToolbarForElement: aTab ].
					view attachTooltipFor: aTab.
					tabs add: aTab ] ].
	aTabGroup := BrTabGroup new
			vFitContentLimited;
			aptitude: BrGlamorousTabGroupAptitude;
			addTabs: tabs.
	aTabGroup phlow entity: (GtPhlowCompositeView new views: aCollectionOfViews).
	aBuildContext := GtPhlowBuildContext new
			object: self threadMessageViewModel threadMessage.

	aListener := GtPhlowChangeMethodSystemAnnouncerListener new
			interestingPragmas: GtLlmBasicThreadMessageViewModel messageViewPragmas
				andObject: aBuildContext object;
			onMethodAddedAction: (GtPhlowChangeTabGroupAddTabAction new
					tabGroup: aTabGroup;
					buildContext: aBuildContext;
					contentsBuilder: [ :aPhlowView | 
						[ aPhlowView
							asElementDo: [ :anElement | 
								anElement phlow beViewContent.
								anElement ] ] ]);
			onMethodRemovedAction: (GtPhlowChangeTabGroupRemoveTabAction new tabGroup: aTabGroup);
			onMethodModifiedAction: (GtPhlowChangeTabGroupModifyTabAction new
					tabGroup: aTabGroup;
					buildContext: aBuildContext;
					contentsBuilder: [ :aPhlowView | 
						[ aPhlowView
							asElementDo: [ :anElement | 
								anElement phlow beViewContent.
								anElement ] ] ]);
			subscribeToSystem.

	aTabGroup userData at: GtPhlowChangeMethodSystemAnnouncerListener put: aListener.

	^ aTabGroup
]
