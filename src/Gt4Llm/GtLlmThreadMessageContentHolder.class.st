Class {
	#name : #GtLlmThreadMessageContentHolder,
	#superclass : #BrVerticalPane,
	#instVars : [
		'threadMessageViewModel',
		'header'
	],
	#category : #'Gt4Llm-Widgets'
}

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
GtLlmThreadMessageContentHolder >> initializeActionElement [
]

{ #category : #accessing }
GtLlmThreadMessageContentHolder >> initializeHeader [
	header := BrHorizontalPane new
			hMatchParent;
			vFitContent
]

{ #category : #accessing }
GtLlmThreadMessageContentHolder >> onThreadMessageViewModelChanged [
	self updateHeader.

	self views: self threadMessageViewModel messageViews
]

{ #category : #accessing }
GtLlmThreadMessageContentHolder >> threadMessageViewModel [
	^ threadMessageViewModel
]

{ #category : #accessing }
GtLlmThreadMessageContentHolder >> threadMessageViewModel: anObject [
	threadMessageViewModel := anObject.
	
	self onThreadMessageViewModelChanged
]

{ #category : #accessing }
GtLlmThreadMessageContentHolder >> updateHeader [
	self header addChildren: self threadMessageViewModel messageHeaderItems
]

{ #category : #accessing }
GtLlmThreadMessageContentHolder >> views: aCollectionOfViews [
	| views |
	self removeChildNamed: #'message-tabs'.
	views := aCollectionOfViews
			reject: [ :aView | aView isKindOf: GtPhlowEmptyView ].

	views ifEmpty: [ ^ self ].

	views size > 1
		ifTrue: [ self addChild: (self viewsToTabGroup: aCollectionOfViews) as: #'message-tabs' ]
		ifFalse: [ self addChild: views first asElement as: #'message-tabs' ]
]

{ #category : #accessing }
GtLlmThreadMessageContentHolder >> viewsToTabGroup: aCollectionOfViews [
	| tabs |
	tabs := OrderedCollection new.
	aCollectionOfViews
		do: [ :view | 
			view
				ifItHasContent: [ | aTab |
					aTab := BrTab new.
					aTab phlow
						beView;
						entity: view.
					aTab
						aptitude: BrGlamorousTabAptitude
								+ (GtPhlowBrowseDefinitionAptitude new definition: [ view allDefiningMethods ]);
						label: view title;
						stencil: [ view
								asElementDo: [ :anElement | 
									anElement phlow beViewContent.
									anElement ] ];
						toolbarStencil: [ view actionsToolbarForElement: aTab ].
					view attachTooltipFor: aTab.
					tabs add: aTab ] ].
	^ BrTabGroup new vFitContentLimited
		aptitude: BrGlamorousTabGroupAptitude;
		addTabs: tabs
]
