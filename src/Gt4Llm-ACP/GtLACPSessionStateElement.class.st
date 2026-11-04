"
I show the state of a GtLACPSession as a label inside a colored rounded rectangle, and I follow the session as its state changes. I am used in the ACP chat tool header (GtLACPChatToolElement>>#buildTitleContainer) and in the sessions list (GtLACPSessionRegistry>>#gtSessionsFor:).
"
Class {
	#name : #GtLACPSessionStateElement,
	#superclass : #BrHorizontalPane,
	#instVars : [
		'session',
		'state',
		'marker',
		'label',
		'updater'
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
		addChild: marker
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

	state = #ready ifTrue: [ ^ BrGlamorousColors successBackgroundColor ].
	state = #prompting ifTrue: [ ^ Color fromHexString: '69C0FF' ].
	(#(#starting #loading #disconnected) includes: state)
		ifTrue: [ ^ BrGlamorousColors failureBackgroundColor ].
	state = #failed ifTrue: [ ^ BrGlamorousColors errorBackgroundColor ].
	^ BrGlamorousColors neutralBackgroundColor
]

{ #category : #updating }
GtLACPSessionStateElement >> updateState [
	"Session updates arrive while streaming, so I only touch the elements when the state really changes."

	| newState color |
	newState := session ifNotNil: #state.
	newState = state ifTrue: [ ^ self ].
	state := newState.
	color := self stateColor.
	marker
		background: (self isHollowState ifTrue: [ Color transparent ] ifFalse: [ color ]);
		border: (BlBorder paint: color width: 1).
	label text: state asString asRopedText
]
