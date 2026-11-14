"
I show a session's presentation state in a colored rounded badge. Pending input anywhere in the session's delegated work appears as amber input needed, including the pending count when there are multiple requests. I update independently of execution-state changes. The session tool header and registry share this element; clicking an input-needed badge opens the relevant interaction.
"
Class {
	#name : #GtLACPSessionStateElement,
	#superclass : #BrHorizontalPane,
	#instVars : [
		'session',
		'state',
		'marker',
		'label',
		'updater',
		'pendingCount'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #initialization }
GtLACPSessionStateElement >> initialize [
	super initialize.
	label := BrLabel new
			id: #'acp-session-state-label';
			aptitude: (BrGlamorousLabelAptitude new glamorousRegularFont
					fontSize: 11;
					foreground: Color black);
			yourself.
	marker := BrFrame new
			id: #'acp-session-state-marker';
			fitContent;
			geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
			padding: (BlInsets
					top: 1
					left: 6
					bottom: 1
					right: 6);
			addChild: label;
			yourself.
	updater := BrElementUpdater new
			element: self selector: #updateState;
			postponedDuration: 150 milliseconds;
			yourself.
	self
		fitContent;
		alignCenterLeft;
		addChild: marker.
	marker
		addAptitude: (GtLACPInputNeededNavigationAptitude new
				pendingBlock: [ session ifNil: [ #() ] ifNotNil: [ session pendingInteractions ] ];
				yourself).
	marker when: BlClickEvent do: [ :event | event consumed: true ]
]

{ #category : #testing }
GtLACPSessionStateElement >> isHollowState [
	^ #(#new #observing #disconnected) includes: state
]

{ #category : #events }
GtLACPSessionStateElement >> onSessionChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ updater requestUpdate ]
]

{ #category : #accessing }
GtLACPSessionStateElement >> session: aSession [
	session ifNotNil: [ session announcer unsubscribe: self ].
	session := aSession.
	session
		ifNotNil: [ session announcer weak
				when: GtLACPSessionChanged
				send: #onSessionChanged:
				to: self ].
	self updateState
]

{ #category : #accessing }
GtLACPSessionStateElement >> stateColor [
	"Keep session states readable while highlighting activity and failures."

	state = #inputNeeded ifTrue: [ ^ GtLACPInputNeededElement amberColor ].
	state = #ready ifTrue: [ ^ BrGlamorousColors successBackgroundColor ].
	state = #prompting ifTrue: [ ^ Color fromHexString: '69C0FF' ].
	(#(#starting #loading #disconnected) includes: state)
		ifTrue: [ ^ BrGlamorousColors failureBackgroundColor ].
	state = #failed ifTrue: [ ^ BrGlamorousColors errorBackgroundColor ].
	^ BrGlamorousColors neutralBackgroundColor
]

{ #category : #updating }
GtLACPSessionStateElement >> updateState [
	| newState count color text |
	newState := session ifNotNil: [ :aSession | aSession presentationState ].
	count := session ifNil: [ 0 ] ifNotNil: [ session pendingInteractions size ].
	(newState = state and: [ count = pendingCount ]) ifTrue: [ ^ self ].
	state := newState.
	pendingCount := count.
	color := self stateColor.
	marker
		background: (self isHollowState ifTrue: [ Color transparent ] ifFalse: [ color ]);
		border: (BlBorder paint: color width: 1).
	text := state = #inputNeeded
			ifTrue: [ count > 1
					ifTrue: [ 'input needed · ' , count asString ]
					ifFalse: [ 'input needed' ] ]
			ifFalse: [ state asString ].
	label text: text asRopedText
]
