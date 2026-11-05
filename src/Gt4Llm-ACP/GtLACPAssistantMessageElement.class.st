"
I render an assistant response with work and reply disclosures, ordered reasoning, clickable tool-call summaries and explicit permissions. A message view model creates and builds me.
"
Class {
	#name : #GtLACPAssistantMessageElement,
	#superclass : #GtLACPChatMessageElement,
	#instVars : [
		'workSummaryElement',
		'workSummaryUpdater',
		'workExpander'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #building }
GtLACPAssistantMessageElement >> agentWorkElementFor: anAssistantMessage [
	^ GtLACPAgentMessageElement new
		messageViewModel: (viewModel delegatedViewModelFor: anAssistantMessage);
		yourself
]

{ #category : #building }
GtLACPAssistantMessageElement >> buildContent [
	self buildWorkSection.
	self buildFinalReplySection.
	self buildErrorContent
]

{ #category : #building }
GtLACPAssistantMessageElement >> buildErrorContent [
	viewModel turn error
		ifNotNil: [ :error | self addChild: (self textElementFor: error printString) ]
]

{ #category : #building }
GtLACPAssistantMessageElement >> buildFinalReplySection [
	| expander |
	viewModel replyMessages ifEmpty: [ ^ self ].
	expander := BrExpander new
			id: viewModel finalSectionId;
			aptitude: (BrGlamorousExpanderSubtleAptitude new
					sidebarExtraPadding: (BlInsets top: 9);
					yourself);
			hMatchParent;
			vFitContent;
			margin: (BlInsets top: 4 bottom: 4);
			header: [ self finalReplyPreview ];
			content: [ self finalContent ];
			yourself.
	((expander childNamed: #sidebar) childNamed: #'expander--toggle')
		id: viewModel finalToggleId.
	expander expanded: viewModel isFinalReplyExpanded.
	expander whenExpandedDo: [ viewModel finalReplyExpanded: true ].
	expander whenCollapsedDo: [ viewModel finalReplyExpanded: false ].
	self addChild: expander
]

{ #category : #building }
GtLACPAssistantMessageElement >> buildHeader [
 | header |
 header := super buildHeader.
 viewModel turn isActive ifTrue: [
  header addChild: (self workIndicatorFor: viewModel turn id: #'acp-work-indicator') at: 2 ].
 ^ header
]

{ #category : #building }
GtLACPAssistantMessageElement >> buildWorkSection [
	viewModel message hasWork ifFalse: [ ^ self ].
	workExpander := BrExpander new.
	workExpander
		id: viewModel workSectionId;
		aptitude: (BrGlamorousExpanderSubtleAptitude new
				sidebarExtraPadding: (BlInsets top: 6);
				yourself);
		hMatchParent;
		vFitContent;
		margin: (BlInsets top: 4 bottom: 4);
		header: [ self workSummaryElementFor: workExpander ];
		content: [ self workContent ].
	((workExpander childNamed: #sidebar) childNamed: #'expander--toggle')
		id: viewModel workToggleId.
	workExpander expanded: viewModel isWorkExpanded.
	workExpander whenExpandedDo: [ viewModel workExpanded: true ].
	workExpander whenCollapsedDo: [ viewModel workExpanded: false ].
	self addChild: workExpander
]

{ #category : #building }
GtLACPAssistantMessageElement >> finalContent [
 ^ self finalContentFor: viewModel
]

{ #category : #building }
GtLACPAssistantMessageElement >> finalContentFor: model [
	| pane tabs |
	tabs := GtPhlowCompositeView new
			views: (model message finalReplyViewsInContext: model phlowContext);
			asElementDo: [ :element | 
				element
					hMatchParent;
					vFitContentLimited ].
	tabs id: model finalTabsId.
	tabs selectTabWithLabelString: model selectedFinalViewTitle.
	tabs viewModel
		when: BrTabSelectedEvent
		do: [ :event | model selectedFinalViewTitle: event tab tabLabel text asString ].
	pane := BrVerticalPane new
			id: model finalContentId;
			hMatchParent;
			vFitContentLimited;
			addChild: tabs;
			yourself.
	^ pane
]

{ #category : #building }
GtLACPAssistantMessageElement >> finalReplyPreview [
	^ (self textElementFor: self replyPreviewText)
		id: viewModel finalPreviewId;
		vFitContent;
		yourself
]

{ #category : #initialization }
GtLACPAssistantMessageElement >> initialize [
 super initialize.
 workSummaryUpdater := BrElementUpdater new
  element: self selector: #updateWorkSummary;
  postponedDuration: 150 milliseconds; yourself
]

{ #category : #hooks }
GtLACPAssistantMessageElement >> onAddedToSceneGraph [
 super onAddedToSceneGraph.
 viewModel turn session announcer unsubscribe: self.
 viewModel turn session announcer weak
  when: GtLACPSessionChanged send: #onSessionChanged: to: self.
 workSummaryUpdater requestUpdate
]

{ #category : #hooks }
GtLACPAssistantMessageElement >> onRemovedFromSceneGraph [
 viewModel turn session announcer unsubscribe: self.
 super onRemovedFromSceneGraph
]

{ #category : #updating }
GtLACPAssistantMessageElement >> onSessionChanged: anAnnouncement [
	(anAnnouncement message == viewModel message
		and: [ anAnnouncement sourceSession ~~ viewModel turn session ])
		ifFalse: [ ^ self ].
	self
		enqueueTask: (BlTaskAction new
				action: [ workExpander ifNotNil: [ workExpander expanded: viewModel isWorkExpanded ].
					workSummaryUpdater requestUpdate ])
]

{ #category : #building }
GtLACPAssistantMessageElement >> permissionElementFor: permission [
	^ GtLACPInteractionElement new
		permission: permission;
		yourself
]

{ #category : #building }
GtLACPAssistantMessageElement >> questionsElementFor: aTool [
	| pane |
	pane := BrVerticalPane new
			id: ('acp-tool-' , aTool id asString) asSymbol;
			hMatchParent;
			vFitContent;
			yourself.
	aTool elicitationRequests
		do: [ :question | 
			pane
				addChild: (question asElement
						padding: BlInsets empty;
						margin: (BlInsets
								top: 2
								left: 5
								bottom: 2
								right: 5);
						yourself) ].
	^ pane
]

{ #category : #building }
GtLACPAssistantMessageElement >> toolElementFor: aTool [
	| pane line kind summary |
	aTool elicitationRequests ifNotEmpty: [ ^ self questionsElementFor: aTool ].
	kind := self
			workBadge: 'tool'
			id: ('acp-tool-kind-' , aTool id asString) asSymbol.
	summary := BrButton new
			id: ('acp-tool-summary-' , aTool id asString) asSymbol;
			aptitude: BrGlamorousButtonWithLabelAptitude - BrGlamorousButtonExteriorAptitude;
			hMatchParent;
			alignCenterLeft;
			padding: BlInsets empty;
			label: aTool summary;
			action: [ :button | button phlow spawnObject: aTool ];
			yourself.
	line := BrHorizontalPane new
			id: ('acp-tool-line-' , aTool id asString) asSymbol;
			hMatchParent;
			vFitContent;
			addChild: kind;
			addChild: summary;
			yourself.
	line
		when: BlClickEvent
		do: [ :event | 
			event consumed: true.
			line phlow spawnObject: aTool ].
	pane := BrVerticalPane new
			id: ('acp-tool-' , aTool id asString) asSymbol;
			hMatchParent;
			vFitContent;
			margin: (BlInsets
					top: 2
					left: 5
					bottom: 2
					right: 5);
			addChild: line;
			yourself.
	aTool permissionRequests
		do: [ :permission | 
			permission state = #pending
				ifTrue: [ pane addChild: (self permissionElementFor: permission) ] ].
	^ pane
]

{ #category : #updating }
GtLACPAssistantMessageElement >> updateWorkSummary [
	workSummaryElement ifNil: [ ^ self ].
	workSummaryElement removeChildren.
	viewModel message workSummaryCountLabels
		withIndexDo: [ :text :index | 
			workSummaryElement
				addChild: (self workBadge: text id: (viewModel workSummaryCountIdAt: index)) ].
	workSummaryElement
		addChild: (BrLabel new
				id: viewModel workSummaryTextId;
				aptitude: BrGlamorousLabelAptitude;
				hMatchParent;
				text: viewModel message workSummaryDetails;
				constraintsDo: [ :c | c linear vertical alignCenter ];
				yourself)
]

{ #category : #building }
GtLACPAssistantMessageElement >> workBadge: aString id: anId [
	^ GtLACPWorkBadgeElement new
		id: anId;
		text: aString;
		yourself
]

{ #category : #building }
GtLACPAssistantMessageElement >> workContent [
 ^ self workContentFor: viewModel message
]

{ #category : #building }
GtLACPAssistantMessageElement >> workContentFor: anAssistantMessage [
	| pane |
	pane := BrVerticalPane new
			hMatchParent;
			vFitContent;
			yourself.
	anAssistantMessage == viewModel message
		ifTrue: [ pane id: viewModel workContentId ].
	anAssistantMessage localActivityItems
		do: [ :item | 
			(item isKindOf: GtLACPToolCall)
				ifTrue: [ pane addChild: (self toolElementFor: item) ]
				ifFalse: [ item isInterSessionMessage
						ifTrue: [ pane
								addChild: (BrLabel new
										aptitude: BrGlamorousLabelAptitude;
										text: item chatLabel;
										yourself) ].
					pane addChild: (self textElementFor: item text) ] ].
	anAssistantMessage turn elicitationRequests
		select: [ :each | each toolCall isNil ]
		thenDo: [ :each | pane addChild: each asElement ].
	anAssistantMessage delegatedMessages
		do: [ :delegated | pane addChild: (self agentWorkElementFor: delegated) ].
	^ pane
]

{ #category : #building }
GtLACPAssistantMessageElement >> workIndicatorFor: aTurn id: anId [
 ^ BrLabel new
  id: anId;
  aptitude: (BrGlamorousLabelAptitude new foreground: BrGlamorousColors disabledButtonTextColor);
  text: (aTurn state = #cancelling ifTrue: [ 'Stopping…' ] ifFalse: [ 'Working…' ]);
  margin: (BlInsets left: 8);
  constraintsDo: [ :c | c linear vertical alignCenter ];
  yourself
]

{ #category : #building }
GtLACPAssistantMessageElement >> workSummaryElementFor: anExpander [
	workSummaryElement := BrHorizontalPane new
			id: viewModel workSummaryId;
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
