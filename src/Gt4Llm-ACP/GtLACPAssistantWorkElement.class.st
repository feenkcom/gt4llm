"
I contain the work expander and ordered tools, comments, interactions and delegated agents for an assistant message. I own the summary and refresh delegated expansion. My content pane survives structural updates. The enclosing assistant message supplies cached comment elements shared with its final reply.
"
Class {
	#name : #GtLACPAssistantWorkElement,
	#superclass : #BlElement,
	#instVars : [
		'messageViewModel',
		'commentElementProvider',
		'expander',
		'contentPane',
		'workSummaryElement',
		'workSummaryUpdater',
		'agentElements'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #building }
GtLACPAssistantWorkElement >> addCommentElementFor: aMessage to: elements [
	| comment |
	comment := self commentElementFor: aMessage.
	comment id: ('acp-text-' , aMessage identityHash asString) asSymbol.
	elements add: comment.
	^ comment
]

{ #category : #building }
GtLACPAssistantWorkElement >> addInterSessionLabelFor: aMessage to: elements [
	elements
		add: (BrLabel new
				aptitude: BrGlamorousLabelAptitude;
				text: aMessage chatLabel;
				yourself)
]

{ #category : #accessing }
GtLACPAssistantWorkElement >> agentElements [
	^ agentElements ifNil: [ agentElements := OrderedCollection new ]
]

{ #category : #building }
GtLACPAssistantWorkElement >> agentWorkElementFor: anAssistantMessage [
	| element |
	element := GtLACPAgentMessageElement new
			messageViewModel: (messageViewModel delegatedViewModelFor: anAssistantMessage);
			yourself.
	self agentElements add: element.
	^ element
]

{ #category : #building }
GtLACPAssistantWorkElement >> build [
	expander
		id: messageViewModel workSectionId;
		header: [ self workSummaryElementFor: expander ];
		content: [ self buildContent ].
	((expander childNamed: #sidebar) childNamed: #'expander--toggle')
		id: messageViewModel workToggleId.
	expander expanded: messageViewModel isWorkExpanded.
	expander isExpanded ifTrue: [ messageViewModel workExpanded: true ].
	expander whenExpandedDo: [ messageViewModel workExpanded: true ].
	expander whenCollapsedDo: [ messageViewModel workExpanded: false ]
]

{ #category : #building }
GtLACPAssistantWorkElement >> buildContent [
	| elements message |
	message := messageViewModel message.
	elements := OrderedCollection new.
	message localActivityItems
		do: [ :item | item addWorkElementsTo: elements in: self ].
	message turn elicitationRequests
		select: [ :each | each toolCall isNil ]
		thenDo: [ :each | elements add: each asElement ].
	self agentElements removeAll.
	message delegatedMessages
		do: [ :delegated | elements add: (self agentWorkElementFor: delegated) ].
	contentPane
		ifNil: [ contentPane := BrVerticalPane new
					hMatchParent;
					vFitContent;
					yourself ].
	contentPane id: messageViewModel workContentId.
	self updateContentChildren: elements in: contentPane.
	^ contentPane
]

{ #category : #accessing }
GtLACPAssistantWorkElement >> commentElementFor: aMessage [
	^ commentElementProvider value: aMessage
]

{ #category : #accessing }
GtLACPAssistantWorkElement >> commentElementProvider: aBlock [
	commentElementProvider := aBlock
]

{ #category : #accessing }
GtLACPAssistantWorkElement >> expander [
	^ expander
]

{ #category : #initialization }
GtLACPAssistantWorkElement >> initialize [
	super initialize.
	self
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	expander := BrExpander new
			aptitude: (BrGlamorousExpanderSubtleAptitude new
					padding: (BlInsets
							top: 4
							left: 4
							bottom: 0
							right: 4);
					sidebarExtraPadding: (BlInsets top: 6);
					yourself);
			hMatchParent;
			vFitContent;
			yourself.
	self addChild: expander as: #expander.
	workSummaryUpdater := BrElementUpdater new
			element: self selector: #updateWorkSummary;
			postponedDuration: 150 milliseconds;
			yourself
]

{ #category : #accessing }
GtLACPAssistantWorkElement >> messageViewModel [
	^ messageViewModel
]

{ #category : #accessing }
GtLACPAssistantWorkElement >> messageViewModel: aViewModel [
	messageViewModel := aViewModel.
	self build
]

{ #category : #hooks }
GtLACPAssistantWorkElement >> onAddedToSceneGraph [
	super onAddedToSceneGraph.
	messageViewModel turn session announcer unsubscribe: self.
	messageViewModel turn session announcer weak
		when: GtLACPSessionChanged
		send: #onSessionChanged:
		to: self.
	workSummaryUpdater requestUpdate
]

{ #category : #hooks }
GtLACPAssistantWorkElement >> onRemovedFromSceneGraph [
	messageViewModel turn session announcer unsubscribe: self.
	super onRemovedFromSceneGraph
]

{ #category : #hooks }
GtLACPAssistantWorkElement >> onSessionChanged: anAnnouncement [
	(anAnnouncement message == messageViewModel message
		and: [ anAnnouncement sourceSession ~~ messageViewModel turn session ])
		ifFalse: [ ^ self ].
	self
		enqueueTask: (BlTaskAction new
				action: [ expander ifNotNil: [ expander expanded: messageViewModel isWorkExpanded ].
					workSummaryUpdater requestUpdate ])
]

{ #category : #updating }
GtLACPAssistantWorkElement >> rebuild [
	contentPane ifNotNil: [ self buildContent ].
	self refresh
]

{ #category : #updating }
GtLACPAssistantWorkElement >> refresh [
	expander expanded: messageViewModel isWorkExpanded.
	self agentElements do: [ :element | element refresh ].
	self updateWorkSummary
]

{ #category : #building }
GtLACPAssistantWorkElement >> toolElementFor: aTool [
	^ GtLACPToolCallElement new
		toolCall: aTool;
		yourself
]

{ #category : #updating }
GtLACPAssistantWorkElement >> updateContentChildren: elements in: content [
	content children asArray
		do: [ :child | (elements identityIncludes: child) ifFalse: [ child removeFromParent ] ].
	elements
		withIndexDo: [ :child :index | 
			(content children asArray identityIndexOf: child) = index
				ifFalse: [ child hasParent ifTrue: [ child removeFromParent ].
					content addChild: child at: index ] ]
]

{ #category : #updating }
GtLACPAssistantWorkElement >> updateWorkSummary [
	workSummaryElement ifNil: [ ^ self ].
	workSummaryElement removeChildren.
	messageViewModel message workSummaryCountLabels
		withIndexDo: [ :text :index | 
			workSummaryElement
				addChild: (self workBadge: text id: (messageViewModel workSummaryCountIdAt: index)) ].
	workSummaryElement
		addChild: (BrLabel new
				id: messageViewModel workSummaryTextId;
				aptitude: BrGlamorousLabelAptitude;
				hMatchParent;
				text: messageViewModel message workSummaryDetails;
				constraintsDo: [ :c | c linear vertical alignCenter ];
				yourself).
	messageViewModel hasPendingInteraction
		ifTrue: [ workSummaryElement
				addChild: (GtLACPInputNeededElement new
						id: ('acp-work-input-needed-' , messageViewModel turn identityHash asString)
								asSymbol;
						forTurn: messageViewModel turn;
						yourself) ]
]

{ #category : #building }
GtLACPAssistantWorkElement >> workBadge: aString id: anId [
	^ GtLACPWorkBadgeElement new
		id: anId;
		text: aString;
		yourself
]

{ #category : #building }
GtLACPAssistantWorkElement >> workSummaryElementFor: anExpander [
	workSummaryElement := BrHorizontalPane new
			id: messageViewModel workSummaryId;
			hMatchParent;
			vFitContent;
			yourself.
	self updateWorkSummary.
	workSummaryElement
		when: BlClickEvent
		do: [ :event | 
			event consumed: true.
			anExpander toggleExpanded ].
	^ workSummaryElement
]
