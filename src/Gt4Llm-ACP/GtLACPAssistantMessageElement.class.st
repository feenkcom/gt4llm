"
I render an assistant response with work and reply disclosures, ordered reasoning, clickable tool-call summaries and explicit permissions. A message view model creates and builds me.
"
Class {
	#name : #GtLACPAssistantMessageElement,
	#superclass : #GtLACPChatMessageElement,
	#instVars : [
		'workSummaryElement',
		'workSummaryUpdater'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #building }
GtLACPAssistantMessageElement >> agentWorkElementFor: anAssistantMessage [
 ^ GtLACPAgentMessageElement new
  messageViewModel: (viewModel delegatedViewModelFor: anAssistantMessage) parentViewModel: viewModel;
  yourself
]

{ #category : #building }
GtLACPAssistantMessageElement >> buildContent [
 viewModel message hasWork ifTrue: [
  self addChild: (self messageSection: #work
   header: [ :expander | self workSummaryElementFor: expander ]
   content: [ self workContent ]) ].
 viewModel replyMessages ifNotEmpty: [
  self addChild: (self messageSection: #final
   header: [ :expander |
    (self textElementFor: self replyPreviewText)
     id: #'acp-final-preview'; vFitContent; yourself ]
   content: [ self finalContent ]) ].
 viewModel turn error ifNotNil: [ :error |
  self addChild: (self textElementFor: error printString) ]
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
GtLACPAssistantMessageElement >> finalContent [
 ^ self finalContentFor: viewModel
]

{ #category : #building }
GtLACPAssistantMessageElement >> finalContentFor: model [
 ^ self finalContentFor: model idPrefix: model elementIdPrefix
]

{ #category : #building }
GtLACPAssistantMessageElement >> finalContentFor: model idPrefix: aPrefix [
 | pane tabs |
 tabs := (GtPhlowCompositeView new
  views: (model message finalReplyViewsInContext: model phlowContext);
  asElementDo: [ :element | element hMatchParent; vFitContentLimited ]).
 tabs id: (aPrefix, '-final-tabs') asSymbol.
 tabs selectTabWithLabelString: model selectedFinalViewTitle.
 tabs viewModel when: BrTabSelectedEvent do: [ :event |
  model selectedFinalViewTitle: event tab tabLabel text asString ].
 pane := BrVerticalPane new
  id: (aPrefix, '-final-content') asSymbol; hMatchParent; vFitContentLimited;
  addChild: tabs; yourself.
 ^ pane
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
  and: [ anAnnouncement sourceSession ~~ viewModel turn session ]) ifFalse: [ ^ self ].
 self enqueueTask: (BlTaskAction new action: [ workSummaryUpdater requestUpdate ])
]

{ #category : #ui }
GtLACPAssistantMessageElement >> permissionElementFor: permission [
 | pane choices |
 pane := BrVerticalPane new hMatchParent; vFitContent; yourself.
 permission state = #pending ifFalse: [
  pane addChild: (BrLabel new aptitude: BrGlamorousLabelAptitude;
   text: 'Permission: ', permission state asString; yourself).
  ^ pane ].
 pane addChild: (BrLabel new aptitude: BrGlamorousLabelAptitude; text: 'Permission required'; yourself).
 choices := BrHorizontalPane new hMatchParent; vFitContent; yourself.
 permission options do: [ :option |
  choices addChild: (BrButton new
   id: ('acp-permission-', option id asString) asSymbol;
   aptitude: BrGlamorousButtonWithLabelAptitude; label: option name;
   action: [
    [ option select ] on: Error do: [ :ex |
     viewModel turn session announceChanged.
     self phlow spawnObject: ex ] ];
   yourself) ].
 pane addChild: choices.
 ^ pane
]

{ #category : #building }
GtLACPAssistantMessageElement >> toolElementFor: aTool [
	| pane line kind summary |
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
			margin: (BlInsets top: 4 bottom: 4);
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
 viewModel message workSummaryCountLabels withIndexDo: [ :text :index |
  workSummaryElement addChild: (self workBadge: text
   id: (viewModel elementIdFor: 'work-summary-count-', index asString)) ].
 workSummaryElement addChild: (BrLabel new
  id: (viewModel elementIdFor: 'work-summary-text');
  aptitude: BrGlamorousLabelAptitude; hMatchParent;
  text: viewModel message workSummaryDetails;
  constraintsDo: [ :c | c linear vertical alignCenter ]; yourself)
]

{ #category : #building }
GtLACPAssistantMessageElement >> workBadge: aString id: anId [
	^ BrLabel new
		id: anId;
		aptitude: (BrGlamorousLabelAptitude new
				foreground: "BrGlamorousColors disabledButtonTextColor" Color black);
		beSmallSize;
		text: aString;
		background: self theme default backdropBackground;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
		padding: (BlInsets left: 2 right: 2);
		margin: (BlInsets right: 6);
		constraintsDo: [ :c | c linear vertical alignCenter ];
		yourself
]

{ #category : #building }
GtLACPAssistantMessageElement >> workContent [
 ^ self workContentFor: viewModel message
]

{ #category : #building }
GtLACPAssistantMessageElement >> workContentFor: anAssistantMessage [
 | pane |
 pane := BrVerticalPane new hMatchParent; vFitContent; yourself.
 anAssistantMessage == viewModel message ifTrue: [ pane id: (viewModel elementIdFor: 'work-content') ].
 anAssistantMessage localActivityItems do: [ :item |
  (item isKindOf: GtLACPToolCall)
   ifTrue: [ pane addChild: (self toolElementFor: item) ]
   ifFalse: [
    item isInterSessionMessage ifTrue: [
     pane addChild: (BrLabel new aptitude: BrGlamorousLabelAptitude; text: item chatLabel; yourself) ].
    pane addChild: (self textElementFor: item text) ] ].
 anAssistantMessage delegatedMessages do: [ :delegated |
  pane addChild: (self agentWorkElementFor: delegated) ].
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
  id: (viewModel elementIdFor: 'work-summary'); hMatchParent; vFitContent; yourself.
 self updateWorkSummary.
 workSummaryElement when: BlClickEvent do: [ :event |
  event consumed: true. anExpander toggleExpanded ].
 ^ workSummaryElement
]
