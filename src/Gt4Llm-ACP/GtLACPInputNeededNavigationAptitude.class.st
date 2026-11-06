"
I navigate attention badges directly for one pending interaction or offer a summary dropdown for several. Navigation first asks the enclosing session tool, falling back to opening the session from other surfaces.
"
Class {
	#name : #GtLACPInputNeededNavigationAptitude,
	#superclass : #BrGlamorousWithExplicitDropdownAptitude,
	#instVars : [
		'pendingBlock'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #building }
GtLACPInputNeededNavigationAptitude >> cardFor: aRequest at: anIndex [
	| card notification |
	notification := aRequest inputNotification
			ifNil: [ GtLACPInputNeededNotification new
					request: aRequest;
					yourself ].
	card := notification asElement
			id: ('acp-input-needed-item-' , anIndex asString) asSymbol;
			hMatchParent;
			vFitContent;
			margin: (BlInsets bottom: 5);
			inspectAction: [ self hide.
				self revealRequest: aRequest ];
			yourself.
	card
		addEventFilter: (BlEventHandler
				on: BlClickEvent
				do: [ :event | 
					event consumed: true.
					card inspectObject ]).
	^ card
]

{ #category : #initialization }
GtLACPInputNeededNavigationAptitude >> initialize [
	super initialize.
	pendingBlock := [ #() ].
	self
		doNotHideWidget;
		content: [ self pendingMenu ]
]

{ #category : #accessing }
GtLACPInputNeededNavigationAptitude >> pendingBlock: aBlock [
	pendingBlock := aBlock
]

{ #category : #building }
GtLACPInputNeededNavigationAptitude >> pendingMenu [
	| pane |
	pane := BrVerticalPane new
			id: #'acp-input-needed-menu';
			hExact: 500;
			vFitContent;
			padding: (BlInsets all: 5);
			yourself.
	pendingBlock value
		withIndexDo: [ :request :index | pane addChild: (self cardFor: request at: index) ].
	^ pane
]

{ #category : #actions }
GtLACPInputNeededNavigationAptitude >> revealRequest: aRequest [
	| wish |
	aRequest state = #pending ifFalse: [ ^ self ].
	wish := GtLACPRevealInteractionWish new
			request: aRequest;
			yourself.
	self widget fireEvent: wish.
	wish isConsumed ifTrue: [ ^ self ].
	self widget phlow spawnTool: aRequest navigationTool
]

{ #category : #actions }
GtLACPInputNeededNavigationAptitude >> showDueTo: anEvent [
	| requests |
	requests := pendingBlock value.
	requests ifEmpty: [ ^ self ].
	requests size = 1 ifTrue: [ ^ self revealRequest: requests first ].
	super showDueTo: anEvent
]
