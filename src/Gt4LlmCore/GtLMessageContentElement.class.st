Class {
	#name : #GtLMessageContentElement,
	#superclass : #BrVerticalPane,
	#traits : 'TGtLWithMessageViewModel',
	#classTraits : 'TGtLWithMessageViewModel classTrait',
	#instVars : [
		'viewUpdater',
		'headerElement'
	],
	#category : 'Gt4LlmCore-UI - Elements'
}

{ #category : #initialization }
GtLMessageContentElement >> initialize [
	super initialize.

	self initializeViewUpdater.
	self initializeHeader.

	self
		hMatchParent;
		vFitContentLimited.

	self addChild: headerElement as: #'message-header'.
]

{ #category : #initialization }
GtLMessageContentElement >> initializeHeader [
	headerElement := BrHorizontalPane new
			hMatchParent;
			vFitContent
]

{ #category : #initialization }
GtLMessageContentElement >> initializeViewUpdater [
	viewUpdater := BrElementUpdater new.
	viewUpdater element: self selector: #updateViews.
	viewUpdater postponedDuration: 300 milliseconds
]

{ #category : #'private - updating' }
GtLMessageContentElement >> makeActionToolbar [
	| actionToolbar |
	actionToolbar := BrToolbar new aptitude: BrGlamorousToolbarAptitude new.

	self messageViewModel messageToolbarActions
		do: [ :each | 
			each
				asElement: [ :actionElement |
					actionElement states addState: BrSizeAdjustmentState tiny.
					 actionToolbar addItem: actionElement ]
				withHostElement: self ].

	^ actionToolbar
]

{ #category : #'private - event handling' }
GtLMessageContentElement >> onMessageContentsUpdated: anAnnouncement [
	BlTaskAction
		enqueueElement: self
		action: [ 
			viewUpdater requestUpdate.
			self updateHeader ]
]

{ #category : #'private - hooks' }
GtLMessageContentElement >> onMessageViewModelChanged [
	self updateElement
]

{ #category : #accessing }
GtLMessageContentElement >> onThreadMessageViewModelChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'private - hooks' }
GtLMessageContentElement >> subscribeToMessageViewModel [
	self messageViewModel weak
		when: GtLlmThreadMessageViewModelChanged
			send: #onThreadMessageViewModelChanged:
			to: self;
		when: GtLMessageViewModelContentsChanged
			send: #onMessageContentsUpdated:
			to: self
]

{ #category : #'private - hooks' }
GtLMessageContentElement >> unsubscribeFromMessageViewModel [
	self messageViewModel unsubscribe: self
]

{ #category : #'private - hooks' }
GtLMessageContentElement >> updateElement [
	self updateHeader.
	self updateViews
]

{ #category : #'private - updating' }
GtLMessageContentElement >> updateHeader [
	headerElement removeChildren.
	headerElement addChildFirst: self messageViewModel messageHeaderElement.
]

{ #category : #'private - updating' }
GtLMessageContentElement >> updateViews [
	"Called by updater"

	self views: self messageViewModel messageViews
]

{ #category : #'private - updating' }
GtLMessageContentElement >> views: aCollectionOfViews [
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
GtLMessageContentElement >> viewsToTabGroup: aCollectionOfViews [
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
