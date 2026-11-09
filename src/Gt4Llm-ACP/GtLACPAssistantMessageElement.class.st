"
I render an assistant response with work and final-reply disclosures. I retain one assistant comment element per message identity. Each comment element owns its editor and refreshes streamed text. Text-only updates retain the row and its structure; structural changes rebuild the presentation while reusing comment elements, including when the final reply moves out of work.
"
Class {
	#name : #GtLACPAssistantMessageElement,
	#superclass : #GtLACPChatMessageElement,
	#instVars : [
		'workSummaryElement',
		'workSummaryUpdater',
		'workExpander',
		'commentElements',
		'structuralSnapshot',
		'renderedVersion',
		'workContents',
		'finalExpander',
		'agentElements'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #building }
GtLACPAssistantMessageElement >> addCommentElementFor: aMessage to: elements [
	| comment |
	comment := self commentElementFor: aMessage.
	comment id: ('acp-text-' , aMessage identityHash asString) asSymbol.
	elements add: comment.
	^ comment
]

{ #category : #building }
GtLACPAssistantMessageElement >> addInterSessionLabelFor: aMessage to: elements [
	elements
		add: (BrLabel new
				aptitude: BrGlamorousLabelAptitude;
				text: aMessage chatLabel;
				yourself)
]

{ #category : #accessing }
GtLACPAssistantMessageElement >> agentElements [
	^ agentElements ifNil: [ agentElements := OrderedCollection new ]
]

{ #category : #building }
GtLACPAssistantMessageElement >> agentWorkElementFor: anAssistantMessage [
	| element |
	element := GtLACPAgentMessageElement new
			messageViewModel: (viewModel delegatedViewModelFor: anAssistantMessage);
			yourself.
	self agentElements add: element.
	^ element
]

{ #category : #updating }
GtLACPAssistantMessageElement >> build [
	super build.
	structuralSnapshot := self presentationStructure.
	renderedVersion := viewModel renderingVersion
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
	viewModel replyMessages ifEmpty: [ ^ self ].
	finalExpander := BrExpander new
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
	((finalExpander childNamed: #sidebar) childNamed: #'expander--toggle')
		id: viewModel finalToggleId.
	finalExpander expanded: viewModel isFinalReplyExpanded.
	finalExpander whenExpandedDo: [ viewModel finalReplyExpanded: true ].
	finalExpander whenCollapsedDo: [ viewModel finalReplyExpanded: false ].
	self addChild: finalExpander
]

{ #category : #building }
GtLACPAssistantMessageElement >> buildHeader [
	| header |
	header := super buildHeader.
	viewModel turn isActive
		ifTrue: [ header
				addChild: (self workIndicatorFor: viewModel turn id: #'acp-work-indicator')
				at: 2 ].
	header
		addChild: (GtLACPInputNeededElement new
				id: viewModel inputNeededId;
				forTurn: viewModel turn;
				yourself)
		at: 2.
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
	workExpander isExpanded ifTrue: [ viewModel workExpanded: true ].
	workExpander whenExpandedDo: [ viewModel workExpanded: true ].
	workExpander whenCollapsedDo: [ viewModel workExpanded: false ].
	self addChild: workExpander
]

{ #category : #building }
GtLACPAssistantMessageElement >> commentElementFor: aMessage [
	| element |
	element := self commentElements
			at: aMessage
			ifAbsentPut: [ GtLACPAssistantCommentElement new
					phlowContext: viewModel phlowContext;
					message: aMessage;
					yourself ].
	element refresh.
	^ element
]

{ #category : #accessing }
GtLACPAssistantMessageElement >> commentElements [
	^ commentElements ifNil: [ commentElements := IdentityDictionary new ]
]

{ #category : #building }
GtLACPAssistantMessageElement >> finalContent [
 ^ self finalContentFor: viewModel
]

{ #category : #building }
GtLACPAssistantMessageElement >> finalContentFor: model [
	| pane tabs views |
	views := model message finalReplyViewsInContext: model phlowContext.
	views := views
			collect: [ :view | 
				view title = 'Markdown'
					ifTrue: [ view
							stencil: [ | element |
								element := self commentElementFor: model replyMessages first.
								element removeFromParent.
								element id: #'acp-final-message'.
								element editor id: #'acp-final-text'.
								element ] ]
					ifFalse: [ view ] ].
	tabs := GtPhlowCompositeView new
			views: views;
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
GtLACPAssistantMessageElement >> presentationStructure [
	| turn |
	turn := viewModel turn.
	^ {turn stateName.
		viewModel message localActivityItems asArray.
		viewModel replyMessages asArray.
		viewModel message delegatedMessages asArray.
		(viewModel toolCalls
			collect: [ :tool | 
				{tool summary.
					(tool permissionRequests
						collect: [ :request | 
							{request.
								request state} ]) asArray.
					(tool elicitationRequests
						collect: [ :request | 
							{request.
								request state} ]) asArray} ]) asArray.
		(turn permissionRequests
			collect: [ :request | 
				{request.
					request state} ]) asArray.
		(turn elicitationRequests
			collect: [ :request | 
				{request.
					request state} ]) asArray.
		turn error}
]

{ #category : #updating }
GtLACPAssistantMessageElement >> refresh [
	| snapshot version |
	version := viewModel renderingVersion.
	renderedVersion = version ifTrue: [ ^ self ].
	self commentElements valuesDo: [ :element | element refresh ].
	snapshot := self presentationStructure.
	snapshot = structuralSnapshot
		ifFalse: [ self removeChildren.
			workSummaryElement := nil.
			workExpander := nil.
			finalExpander := nil.
			self agentElements removeAll.
			self addChild: self buildHeader as: #'acp-message-header'.
			self buildContent.
			structuralSnapshot := snapshot ].
	self updateExpansion.
	self updateWorkSummary.
	renderedVersion := version
]

{ #category : #building }
GtLACPAssistantMessageElement >> toolElementFor: aTool [
	^ GtLACPToolCallElement new
		toolCall: aTool;
		yourself
]

{ #category : #private }
GtLACPAssistantMessageElement >> updateContentChildren: elements in: content [
	content children asArray
		do: [ :child | (elements identityIncludes: child) ifFalse: [ child removeFromParent ] ].
	elements
		withIndexDo: [ :child :index | 
			(content children asArray identityIndexOf: child) = index
				ifFalse: [ child hasParent ifTrue: [ child removeFromParent ].
					content addChild: child at: index ] ]
]

{ #category : #updating }
GtLACPAssistantMessageElement >> updateExpansion [
	workExpander ifNotNil: [ workExpander expanded: viewModel isWorkExpanded ].
	finalExpander
		ifNotNil: [ finalExpander expanded: viewModel isFinalReplyExpanded ].
	self agentElements do: [ :element | element refresh ]
]

{ #category : #building }
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
				yourself).
	viewModel hasPendingInteraction
		ifTrue: [ workSummaryElement
				addChild: (GtLACPInputNeededElement new
						id: ('acp-work-input-needed-' , viewModel turn identityHash asString) asSymbol;
						forTurn: viewModel turn;
						yourself) ]
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
	| elements content |
	elements := OrderedCollection new.
	anAssistantMessage localActivityItems
		do: [ :item | item addWorkElementsTo: elements in: self ].
	anAssistantMessage turn elicitationRequests
		select: [ :each | each toolCall isNil ]
		thenDo: [ :each | elements add: each asElement ].
	self agentElements removeAll.
	anAssistantMessage delegatedMessages
		do: [ :delegated | elements add: (self agentWorkElementFor: delegated) ].
	content := self workContents
			at: anAssistantMessage
			ifAbsentPut: [ BrVerticalPane new
					hMatchParent;
					vFitContent;
					yourself ].
	self updateContentChildren: elements in: content.
	anAssistantMessage == viewModel message
		ifTrue: [ content id: viewModel workContentId ].
	^ content
]

{ #category : #private }
GtLACPAssistantMessageElement >> workContents [
	^ workContents ifNil: [ workContents := IdentityDictionary new ]
]

{ #category : #building }
GtLACPAssistantMessageElement >> workIndicatorFor: aTurn id: anId [
	^ BrLabel new
		id: anId;
		aptitude: (BrGlamorousLabelAptitude new
				foreground: BrGlamorousColors disabledButtonTextColor);
		text: (aTurn isCancelling ifTrue: [ 'Stopping…' ] ifFalse: [ 'Working…' ]);
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
