"
I display an amber input-needed marker and count. I follow pending requests on a turn or an individual request, including changes originating in subagents.
"
Class {
	#name : #GtLACPInputNeededElement,
	#superclass : #BrHorizontalPane,
	#instVars : [
		'session',
		'pendingBlock',
		'marker',
		'label',
		'updater'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #colors }
GtLACPInputNeededElement class >> amberColor [
	^ Color fromHexString: 'FFC53D'
]

{ #category : #colors }
GtLACPInputNeededElement class >> paleAmberColor [
	^ Color fromHexString: 'FFF7D6'
]

{ #category : #accessing }
GtLACPInputNeededElement >> forRequest: aRequest [
	session := aRequest session.
	pendingBlock := [ aRequest state = #pending
			ifTrue: [ {aRequest} ]
			ifFalse: [ #() ] ].
	self updateAttention
]

{ #category : #accessing }
GtLACPInputNeededElement >> forTool: aTool [
	aTool permissionRequests
		ifNotEmpty: [ :requests | session := requests first session ].
	pendingBlock := [ aTool permissionRequests
			select: [ :each | each state = #pending ] ].
	self updateAttention
]

{ #category : #accessing }
GtLACPInputNeededElement >> forTurn: aTurn [
	session := aTurn session.
	pendingBlock := [ aTurn pendingInteractions ].
	self updateAttention
]

{ #category : #initialization }
GtLACPInputNeededElement >> initialize [
	super initialize.
	pendingBlock := [ #() ].
	self
		fitContent;
		alignCenterLeft;
		margin: (BlInsets left: 8 right: 4);
		visibility: BlVisibility gone.
	label := BrLabel new
			aptitude: (BrGlamorousLabelAptitude new glamorousRegularFont
					fontSize: 11;
					foreground: Color black);
			yourself.
	marker := BrFrame new
			fitContent;
			geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
			padding: (BlInsets
					top: 1
					left: 6
					bottom: 1
					right: 6);
			background: self class amberColor;
			border: (BlBorder paint: self class amberColor width: 1);
			addChild: label;
			constraintsDo: [ :constraints | constraints linear vertical alignCenter ];
			yourself.
	self addChild: marker.
	self addAptitude: (BrGlamorousWithExplicitTooltipAptitude text: 'Input needed').
	updater := BrElementUpdater new
			element: self selector: #updateAttention;
			postponedDuration: 150 milliseconds;
			yourself.
	self
		addAptitude: (GtLACPInputNeededNavigationAptitude new
				pendingBlock: [ pendingBlock value ];
				yourself).
	self when: BlClickEvent do: [ :event | event consumed: true ]
]

{ #category : #events }
GtLACPInputNeededElement >> onAddedToSceneGraph [
	super onAddedToSceneGraph.
	session
		ifNotNil: [ session announcer weak
				when: GtLACPSessionChanged
				send: #onSessionChanged:
				to: self ].
	self updateAttention
]

{ #category : #events }
GtLACPInputNeededElement >> onRemovedFromSceneGraph [
	session ifNotNil: [ session announcer unsubscribe: self ].
	super onRemovedFromSceneGraph
]

{ #category : #events }
GtLACPInputNeededElement >> onSessionChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ updater requestUpdate ]
]

{ #category : #updating }
GtLACPInputNeededElement >> updateAttention [
	| count |
	count := pendingBlock value size.
	count = 0 ifTrue: [ ^ self visibility: BlVisibility gone ].
	label text: count asString.
	self visibility: BlVisibility visible
]
