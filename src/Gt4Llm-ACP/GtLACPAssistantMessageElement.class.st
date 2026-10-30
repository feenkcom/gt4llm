"
I render an assistant response with work and reply disclosures, ordered reasoning, clickable tool-call summaries and explicit permissions. A message view model creates and builds me.
"
Class {
	#name : #GtLACPAssistantMessageElement,
	#superclass : #GtLACPChatMessageElement,
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #ui }
GtLACPAssistantMessageElement >> buildContent [
 viewModel activityItems ifNotEmpty: [
  self addChild: (self messageSection: #work
   header: [ :expander |
    BrLabel new id: #'acp-work-summary'; aptitude: BrGlamorousLabelAptitude;
     text: viewModel message workSummary;
     when: BlClickEvent do: [ :event | event consumed: true. expander toggleExpanded ];
     yourself ]
   content: [ self workContent ]) ].
 viewModel replyMessages ifNotEmpty: [
  self addChild: (self messageSection: #final
   header: [ :expander |
    (self textElementFor: self replyPreviewText)
     id: #'acp-final-preview'; vExact: 24; yourself ]
   content: [ self finalContent ]) ].
 viewModel turn error ifNotNil: [ :error |
  self addChild: (self textElementFor: error printString) ]
]

{ #category : #ui }
GtLACPAssistantMessageElement >> buildHeader [
 | header |
 header := super buildHeader.
 viewModel turn isActive ifTrue: [
  header addChild: (BrLabel new
   id: #'acp-work-indicator';
   aptitude: (BrGlamorousLabelAptitude new foreground: BrGlamorousColors disabledButtonTextColor);
   text: (viewModel turn state = #cancelling
    ifTrue: [ 'Stopping…' ] ifFalse: [ 'Working…' ]);
   margin: (BlInsets left: 8);
   constraintsDo: [ :c | c linear vertical alignCenter ];
   yourself) at: 2 ].
 ^ header
]

{ #category : #ui }
GtLACPAssistantMessageElement >> finalContent [
 | pane |
 pane := BrVerticalPane new id: #'acp-final-content'; hMatchParent; vFitContent; yourself.
 viewModel replyMessages do: [ :message |
  pane addChild: (self textElementFor: message text) ].
 ^ pane
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

{ #category : #ui }
GtLACPAssistantMessageElement >> toolElementFor: aTool [
 | pane line kind summary |
 kind := BrLabel new
  id: ('acp-tool-kind-', aTool id asString) asSymbol;
  aptitude: (BrGlamorousLabelAptitude new foreground: BrGlamorousColors disabledButtonTextColor);
  beSmallSize; text: 'tool';
  background: self theme default backdropBackground;
  geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
  padding: (BlInsets left: 2 right: 2); margin: (BlInsets right: 6);
  constraintsDo: [ :c | c linear vertical alignCenter ]; yourself.
 summary := BrLabel new
  id: ('acp-tool-summary-', aTool id asString) asSymbol;
  aptitude: BrGlamorousLabelAptitude;
  hMatchParent; text: aTool summary; yourself.
 line := BrHorizontalPane new
  id: ('acp-tool-line-', aTool id asString) asSymbol;
  hMatchParent; vFitContent;
  addChild: kind; addChild: summary; yourself.
 line when: BlClickEvent do: [ :event |
  event consumed: true.
  line phlow spawnObject: aTool ].
 pane := BrVerticalPane new
  id: ('acp-tool-', aTool id asString) asSymbol;
  hMatchParent; vFitContent; margin: (BlInsets top: 4 bottom: 4);
  addChild: line; yourself.
 aTool permissionRequests do: [ :permission |
  permission state = #pending ifTrue: [ pane addChild: (self permissionElementFor: permission) ] ].
 ^ pane
]

{ #category : #ui }
GtLACPAssistantMessageElement >> workContent [
 | pane |
 pane := BrVerticalPane new id: #'acp-work-content'; hMatchParent; vFitContent; yourself.
 viewModel activityItems do: [ :item |
  (item isKindOf: GtLACPToolCall)
   ifTrue: [ pane addChild: (self toolElementFor: item) ]
   ifFalse: [
    item role = #thought ifTrue: [
     pane addChild: (BrLabel new aptitude: BrGlamorousLabelAptitude;
      text: 'Thinking'; yourself) ].
    pane addChild: (self textElementFor: item text) ] ].
 ^ pane
]
