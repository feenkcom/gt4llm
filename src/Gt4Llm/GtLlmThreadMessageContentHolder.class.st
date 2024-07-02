Class {
	#name : #GtLlmThreadMessageContentHolder,
	#superclass : #BrFrame,
	#category : #'Gt4Llm-Widgets'
}

{ #category : #accessing }
GtLlmThreadMessageContentHolder >> initialize [
	super initialize.

	self hMatchParent vFitContentLimited
]

{ #category : #accessing }
GtLlmThreadMessageContentHolder >> views: aCollectionOfViews [
	| views |
	self removeChildren.
	views := aCollectionOfViews
			reject: [ :aView | aView isKindOf: GtPhlowEmptyView ].

	views ifEmpty: [ ^ self ].

	views size > 1
		ifTrue: [ self addChild: (self viewsToTabGroup: aCollectionOfViews) ]
		ifFalse: [ self addChild: views first asElement ]
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
