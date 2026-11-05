"
I present a delegated assistant message behind an independently updating agent header. When expanded, I use the same assistant-message element as the top-level chat. Descendant activity updates my header without recreating my body.
"
Class {
	#name : #GtLACPAgentMessageElement,
	#superclass : #BrExpander,
	#instVars : [
		'messageViewModel',
		'agentHeader',
		'messageElement',
		'headerUpdater',
		'contentUpdater',
		'renderedVersion',
		'expanderAptitude'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #building }
GtLACPAgentMessageElement >> buildContent [
	messageViewModel expandCompletedFinalReply.
	messageElement := messageViewModel asElement.
	renderedVersion := messageViewModel renderingVersion.
	^ messageElement
]

{ #category : #building }
GtLACPAgentMessageElement >> buildHeader [
	agentHeader := BrHorizontalPane new
			id: messageViewModel agentHeaderId;
			hMatchParent;
			vFitContent;
			yourself.
	self updateHeader.
	agentHeader
		when: BlClickEvent
		do: [ :event | 
			event consumed: true.
			agentHeader phlow spawnObject: messageViewModel turn session ].
	^ agentHeader
]

{ #category : #initialization }
GtLACPAgentMessageElement >> initialize [
	super initialize.
	expanderAptitude := GtLACPAgentMessageAptitude new
			sidebarExtraPadding: (BlInsets top: 6);
			yourself.
	self aptitude: expanderAptitude.
	self
		hMatchParent;
		vFitContent;
		margin: (BlInsets top: 4 bottom: 4).
	headerUpdater := BrElementUpdater new
			element: self selector: #updateHeader;
			postponedDuration: 150 milliseconds;
			yourself.
	contentUpdater := BrElementUpdater new
			element: self selector: #updateContent;
			postponedDuration: 150 milliseconds;
			yourself
]

{ #category : #accessing }
GtLACPAgentMessageElement >> messageElement [
	^ messageElement
]

{ #category : #accessing }
GtLACPAgentMessageElement >> messageViewModel [
 ^ messageViewModel
]

{ #category : #accessing }
GtLACPAgentMessageElement >> messageViewModel: aViewModel [
	messageViewModel := aViewModel.
	self
		id: messageViewModel agentSectionId;
		header: [ self buildHeader ];
		content: [ self buildContent ].
	((self childNamed: #sidebar) childNamed: #'expander--toggle')
		id: messageViewModel agentToggleId.
	self expanded: messageViewModel isAgentExpanded.
	self
		whenExpandedDo: [ messageViewModel agentExpanded: true.
			self updateContent ].
	self whenCollapsedDo: [ messageViewModel agentExpanded: false ]
]

{ #category : #updating }
GtLACPAgentMessageElement >> onAddedToSceneGraph [
 super onAddedToSceneGraph.
 messageViewModel turn session announcer unsubscribe: self.
 messageViewModel turn session announcer weak
  when: GtLACPSessionChanged send: #onSessionChanged: to: self.
 headerUpdater requestUpdate.
 contentUpdater requestUpdate
]

{ #category : #hooks }
GtLACPAgentMessageElement >> onRemovedFromSceneGraph [
 messageViewModel turn session announcer unsubscribe: self.
 super onRemovedFromSceneGraph
]

{ #category : #updating }
GtLACPAgentMessageElement >> onSessionChanged: anAnnouncement [
	anAnnouncement message == messageViewModel message ifFalse: [ ^ self ].
	self
		enqueueTask: (BlTaskAction new
				action: [ messageViewModel hasPendingQuestions
						ifTrue: [ self expanded: messageViewModel isAgentExpanded ].
					headerUpdater requestUpdate.
					anAnnouncement sourceSession == messageViewModel turn session
						ifTrue: [ contentUpdater requestUpdate ] ])
]

{ #category : #updating }
GtLACPAgentMessageElement >> updateContent [
	(self isExpanded and: [ messageElement notNil ]) ifFalse: [ ^ self ].
	renderedVersion = messageViewModel renderingVersion ifTrue: [ ^ self ].
	expanderAptitude refreshContent
]

{ #category : #updating }
GtLACPAgentMessageElement >> updateHeader [
	| kind name counts |
	agentHeader ifNil: [ ^ self ].
	agentHeader removeChildren.
	kind := self workBadge: 'agent' id: messageViewModel agentKindId.
	name := BrButton new
			id: messageViewModel agentNameId;
			aptitude: BrGlamorousButtonWithLabelAptitude - BrGlamorousButtonExteriorAptitude;
			label: messageViewModel message chatLabel;
			padding: BlInsets empty;
			action: [ :button | button phlow spawnObject: messageViewModel turn session ];
			yourself.
	agentHeader
		addChild: kind;
		addChild: name.
	messageViewModel turn isActive
		ifTrue: [ agentHeader
				addChild: (BrLabel new
						id: messageViewModel agentWorkIndicatorId;
						aptitude: (BrGlamorousLabelAptitude new
								foreground: BrGlamorousColors disabledButtonTextColor);
						text: (messageViewModel turn state = #cancelling
								ifTrue: [ 'Stopping…' ]
								ifFalse: [ 'Working…' ]);
						margin: (BlInsets left: 8);
						constraintsDo: [ :c | c linear vertical alignCenter ];
						yourself) ].
	counts := BrHorizontalPane new
			id: messageViewModel agentCountsId;
			hFitContent;
			vFitContent;
			margin: (BlInsets left: 8);
			constraintsDo: [ :c | c linear vertical alignCenter ];
			yourself.
	messageViewModel message workSummaryCountLabels
		withIndexDo: [ :text :index | 
			counts
				addChild: (self workBadge: text id: (messageViewModel agentCountIdAt: index)) ].
	agentHeader addChild: counts
]

{ #category : #building }
GtLACPAgentMessageElement >> workBadge: aString id: anId [
	^ BrLabel new
		id: anId;
		aptitude: BrGlamorousLabelAptitude;
		beSmallSize;
		text: aString;
		background: self theme default backdropBackground;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
		padding: (BlInsets left: 2 right: 2);
		margin: (BlInsets right: 6);
		constraintsDo: [ :c | c linear vertical alignCenter ];
		yourself
]
