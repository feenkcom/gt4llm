"
I render an assistant response with work and final-reply disclosures. I retain one text editor per conversation-message object, whose identity is resolved from the protocol role and message ID by the turn. When message text changes, I assign freshly styled text to the existing editor. Unchanged text skips the update. Text-only updates retain the row and its structure; changes to tools, interactions, or turn state rebuild the necessary presentation while reusing message editors, including when the final reply moves out of work.
"
Class {
	#name : #GtLACPAssistantMessageElement,
	#superclass : #GtLACPChatMessageElement,
	#instVars : [
		'workSummaryElement',
		'workSummaryUpdater',
		'workExpander',
		'messageEditors',
		'structuralSnapshot',
		'renderedVersion',
		'workContents'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #building }
GtLACPAssistantMessageElement >> agentWorkElementFor: anAssistantMessage [
	^ GtLACPAgentMessageElement new
		messageViewModel: (viewModel delegatedViewModelFor: anAssistantMessage);
		yourself
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
GtLACPAssistantMessageElement >> finalContent [
 ^ self finalContentFor: viewModel
]

{ #category : #updating }
GtLACPAssistantMessageElement >> finalContentFor: model [
	| pane tabs views |
	views := model message finalReplyViewsInContext: model phlowContext.
	views := views
			collect: [ :view | 
				view title = 'Markdown'
					ifTrue: [ view
							stencil: [ | editor |
								editor := self textEditorForMessage: model replyMessages first.
								editor removeFromParent.
								editor id: #'acp-final-text'.
								editor ] ]
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

{ #category : #updating }
GtLACPAssistantMessageElement >> messageEditors [
	^ messageEditors ifNil: [ messageEditors := IdentityDictionary new ]
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
	^ permission asElement
]

{ #category : #updating }
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
		viewModel isWorkExpanded.
		viewModel isFinalReplyExpanded.
		turn error}
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

{ #category : #private }
GtLACPAssistantMessageElement >> refresh [
	| snapshot version |
	version := viewModel renderingVersion.
	renderedVersion = version ifTrue: [ ^ self ].
	self messageEditors
		keysAndValuesDo: [ :message :editor | self updateEditor: editor forMessage: message ].
	snapshot := self presentationStructure.
	snapshot = structuralSnapshot
		ifFalse: [ self removeChildren.
			workSummaryElement := nil.
			workExpander := nil.
			self addChild: self buildHeader as: #'acp-message-header'.
			self buildContent.
			structuralSnapshot := snapshot ].
	self updateWorkSummary.
	renderedVersion := version
]

{ #category : #private }
GtLACPAssistantMessageElement >> textEditorForMessage: aMessage [
	| editor |
	editor := self messageEditors
			at: aMessage
			ifAbsentPut: [ self textElementFor: aMessage text ].
	self updateEditor: editor forMessage: aMessage.
	^ editor
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
	aTool permissionRequests
		ifNotEmpty: [ line
				addChild: (GtLACPInputNeededElement new
						id: ('acp-tool-input-needed-' , aTool id asString) asSymbol;
						margin: (BlInsets right: 6);
						constraintsDo: [ :constraints | constraints linear vertical alignCenter ];
						forTool: aTool;
						yourself)
				at: 2 ].
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
		do: [ :permission | pane addChild: (self permissionElementFor: permission) ].
	^ pane
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

{ #category : #private }
GtLACPAssistantMessageElement >> updateEditor: anEditor forMessage: aMessage [
	| text |
	text := aMessage text.
	text = anEditor text asString ifTrue: [ ^ self ].
	anEditor
		text: (GtLMessageStyler new
				objectRegistry: viewModel phlowContext objectRegistry;
				privateStyle: text asRopedText)
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

{ #category : #private }
GtLACPAssistantMessageElement >> workContentFor: anAssistantMessage [
	| elements content |
	elements := OrderedCollection new.
	anAssistantMessage localActivityItems
		do: [ :item | 
			(item isKindOf: GtLACPToolCall)
				ifTrue: [ elements add: (self toolElementFor: item) ]
				ifFalse: [ item isInterSessionMessage
						ifTrue: [ elements
								add: (BrLabel new
										aptitude: BrGlamorousLabelAptitude;
										text: item chatLabel;
										yourself) ].
					elements
						add: ((self textEditorForMessage: item)
								id: ('acp-text-' , item identityHash asString) asSymbol;
								yourself) ] ].
	anAssistantMessage turn elicitationRequests
		select: [ :each | each toolCall isNil ]
		thenDo: [ :each | elements add: each asElement ].
	anAssistantMessage delegatedMessages
		do: [ :delegated | elements add: (self agentWorkElementFor: delegated) ].
	(elements size = 1 and: [ elements first isKindOf: BrEditor ])
		ifTrue: [ content := elements first ]
		ifFalse: [ content := self workContents
					at: anAssistantMessage
					ifAbsentPut: [ BrVerticalPane new
							hMatchParent;
							vFitContent;
							yourself ].
			self updateContentChildren: elements in: content ].
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
