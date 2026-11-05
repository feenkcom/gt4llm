"
I present a session registry with a tool header, registry actions, live views in tabs and a collapsed playground.
"
Class {
	#name : #GtLACPSessionRegistryToolElement,
	#superclass : #BlElement,
	#instVars : [
		'registry'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #building }
GtLACPSessionRegistryToolElement >> buildHeaderElement [
	^ BrHorizontalPane new
		padding: (BlInsets left: 5);
		vFitContent;
		hMatchParent;
		alignCenterLeft;
		addChild: self buildToolLabel as: #toolLabel;
		addChild: (BrFrame new
				hMatchParent;
				vExact: 0;
				yourself);
		addChild: self buildToolbar as: #toolbar;
		yourself
]

{ #category : #building }
GtLACPSessionRegistryToolElement >> buildPlaygroundPageElement [
	| element |
	element := (GtInspector environment at: GtInspector embeddedPlaygroundName) new.
	element collapse.
	^ element
]

{ #category : #building }
GtLACPSessionRegistryToolElement >> buildToolLabel [
	^ BrLabel new
		aptitude: (BrGlamorousLabelAptitude new glamorousRegularFontAndSize
				foreground: Color gray;
				fontSize: 12);
		text: 'ACP Sessions'
]

{ #category : #building }
GtLACPSessionRegistryToolElement >> buildToolbar [
	^ BrToolbar new
		aptitude: BrGlamorousToolbarAptitude new;
		fitContent
]

{ #category : #collecting }
GtLACPSessionRegistryToolElement >> collectToolActions [
	registry ifNil: [ ^ #() ].
	^ GtPhlowActionsCollector new
		pragmaName: #gtToolAction;
		fromObject: registry;
		selectUsing: [ :anAction | (anAction isKindOf: GtPhlowNoAction) not ];
		collect
]

{ #category : #collecting }
GtLACPSessionRegistryToolElement >> collectToolViews [
	| views |
	registry ifNil: [ ^ #() ].
	views := GtPhlowViewsCollector new
			fromObject: registry;
			pragmaNames: GtLSettings messageViewPragmaNames;
			context: GtPhlowContext new;
			collect.
	GtPhlowUtility sortByPriority: views.
	^ views
]

{ #category : #accessing }
GtLACPSessionRegistryToolElement >> gtInspectorTargetModels [
	^ registry ifNil: [ #() ] ifNotNil: [ {registry} ]
]

{ #category : #initialization }
GtLACPSessionRegistryToolElement >> initialize [
	super initialize.
	self layout: BlLinearLayout vertical.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self padding: (BlInsets all: 5).
	self addChild: self buildHeaderElement as: #header.
	self addChild: BrFrame new matchParent as: #viewsContainer.
	self addChild: self buildPlaygroundPageElement as: #playgroundPage.
	self phlow
		accessTool: (GtPhlowToolClassType forClass: GtLACPSessionRegistry)
		viewModel: #registry
		object: #registry
]

{ #category : #accessing }
GtLACPSessionRegistryToolElement >> playgroundElement [
	^ self childNamed: #playgroundPage
]

{ #category : #accessing }
GtLACPSessionRegistryToolElement >> registry [
	^ registry
]

{ #category : #accessing }
GtLACPSessionRegistryToolElement >> registry: aRegistry [
	registry := aRegistry.
	self updateToolbarActions.
	self updateContainedViews.
	self updatePlayground
]

{ #category : #updating }
GtLACPSessionRegistryToolElement >> updateContainedViews [
	| compositeView |
	self viewsContainerElement removeChildren.
	registry ifNil: [ ^ self ].
	compositeView := GtPhlowCompositeView new views: self collectToolViews.
	compositeView
		asElementDo: [ :element | self viewsContainerElement addChild: element ]
]

{ #category : #updating }
GtLACPSessionRegistryToolElement >> updatePlayground [
	registry ifNil: [ ^ self ].
	self playgroundElement objectHolder: (GtInspectorObject new object: registry)
]

{ #category : #updating }
GtLACPSessionRegistryToolElement >> updateToolbarActions [
	| toolbar |
	toolbar := (self childNamed: #header) childNamed: #toolbar.
	toolbar removeAllItems.
	self collectToolActions
		do: [ :anAction | 
			anAction
				asElement: [ :element | toolbar addItem: element ]
				withHostElement: self ]
]

{ #category : #accessing }
GtLACPSessionRegistryToolElement >> viewsContainerElement [
	^ self childNamed: #viewsContainer
]
