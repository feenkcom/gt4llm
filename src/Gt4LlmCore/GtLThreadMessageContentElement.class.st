Class {
	#name : #GtLThreadMessageContentElement,
	#superclass : #BrVerticalPane,
	#traits : 'TGtLWithChatMessageViewModel',
	#classTraits : 'TGtLWithChatMessageViewModel classTrait',
	#instVars : [
		'header',
		'viewUpdater'
	],
	#category : #'Gt4LlmCore-UI'
}

{ #category : #initialization }
GtLThreadMessageContentElement >> initialize [
	super initialize.

	self initializeViewUpdater.
	self initializeHeader.

	self
		hMatchParent;
		vFitContentLimited.

	self addChild: header as: #'message-header'
]

{ #category : #initialization }
GtLThreadMessageContentElement >> initializeHeader [
	header := BrHorizontalPane new
			hMatchParent;
			vFitContent
]

{ #category : #initialization }
GtLThreadMessageContentElement >> initializeViewUpdater [
	viewUpdater := BrElementUpdater new.
	viewUpdater element: self selector: #updateViews.
	viewUpdater postponedDuration: 300 milliseconds
]

{ #category : #'private - updating' }
GtLThreadMessageContentElement >> makeActionToolbar [
	| actionToolbar |
	actionToolbar := BrToolbar new aptitude: BrGlamorousToolbarAptitude new.

	self threadMessageViewModel messageToolbarActions
		do: [ :each | 
			each
				asElement: [ :actionElement | actionToolbar addItem: actionElement beTinySize ]
				withHostElement: self ].

	^ actionToolbar
]

{ #category : #'private - event handling' }
GtLThreadMessageContentElement >> onMessageContentsUpdated: anAnnouncement [
	viewUpdater requestUpdate
]

{ #category : #'private - hooks' }
GtLThreadMessageContentElement >> onThreadMessageViewModelChanged [
	self updateElement
]

{ #category : #accessing }
GtLThreadMessageContentElement >> onThreadMessageViewModelChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'private - hooks' }
GtLThreadMessageContentElement >> subscribeToThreadMessageViewModel [
	threadMessageViewModel weak
		when: GtLlmThreadMessageViewModelChanged
			send: #onThreadMessageViewModelChanged:
			to: self;
		when: GtLlmMessageContentsUpdated
			send: #onMessageContentsUpdated:
			to: self.
]

{ #category : #'private - hooks' }
GtLThreadMessageContentElement >> unsubscribeFromThreadMessageViewModel [
	threadMessageViewModel unsubscribe: self
]

{ #category : #'private - hooks' }
GtLThreadMessageContentElement >> updateElement [
	self updateHeader.
	self updateViews
]

{ #category : #'private - updating' }
GtLThreadMessageContentElement >> updateHeader [
	header removeChildren.
	header addChild: self threadMessageViewModel messageHeaderElement.
	header addChild: self makeActionToolbar
]

{ #category : #'private - updating' }
GtLThreadMessageContentElement >> updateViews [
	"Called by updater"

	self views: self threadMessageViewModel messageViews
]

{ #category : #'private - updating' }
GtLThreadMessageContentElement >> views: aCollectionOfViews [
	| views |
	self removeChildNamed: #'message-tabs'.

	views := Array
			new: aCollectionOfViews size
			streamContents: [ :aStream | 
				aCollectionOfViews
					do: [ :aView | aView ifItHasContent: [ aStream nextPut: aView ] ] ].
	views ifEmpty: [ ^ self ].

	self addChild: (self viewsToTabGroup: aCollectionOfViews) as: #'message-tabs'
]

{ #category : #'private - updating' }
GtLThreadMessageContentElement >> viewsToTabGroup: aCollectionOfViews [
	"(GtPhlowCompositeView new views: aCollectionOfViews)
		asElementDo: [ :e | e vFitContentLimited ]  "

	| tabs aTabGroup aListener aBuildContext |
	aTabGroup := GtPhlowCompositeView new
			views: aCollectionOfViews;
			asElementDo: [ :e | e vFitContentLimited ].

	true ifTrue: [ ^ aTabGroup ].

	self flag: #remove.

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

	aTabGroup userData
		at: GtPhlowChangeMethodSystemAnnouncerListener
		put: aListener.

	^ aTabGroup
]
