"
I render a chat row with selectable message text and inspect actions. Assistant rows include tool call status, bounded input/output previews, full inspection access and explicit permission buttons. Message styling is shared with GtLChat.
"
Class {
	#name : #GtLACPChatMessageElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'viewModel'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #ui }
GtLACPChatMessageElement >> assistantSection: aName header: aHeaderBlock content: aBlock [
 | expander model aptitude |
 model := viewModel.
 aptitude := BrGlamorousExpanderSubtleAptitude new.
 aName = #work ifTrue: [ aptitude doNotReplaceHeader ].
 expander := BrExpander new.
 expander id: ('acp-', aName asString, '-section') asSymbol;
  aptitude: aptitude;
  hMatchParent; vFitContent; margin: (BlInsets top: 4 bottom: 4);
  header: [ aHeaderBlock value: expander ];
  content: aBlock; yourself.
 ((expander childNamed: #sidebar) childNamed: #'expander--toggle') id: ('acp-', aName asString, '-toggle') asSymbol.
 expander expanded: (model isSectionExpanded: aName).
 expander whenExpandedDo: [ model section: aName expanded: true ].
 expander whenCollapsedDo: [ model section: aName expanded: false ].
 ^ expander
]

{ #category : #ui }
GtLACPChatMessageElement >> finalContent [
 | pane |
 pane := BrVerticalPane new id: #'acp-final-content'; hMatchParent; vFitContent; yourself.
 viewModel replyMessages do: [ :message |
  pane addChild: (self textElementFor: message text markdown: true) ].
 ^ pane
]

{ #category : #ui }
GtLACPChatMessageElement >> initialize [
 super initialize.
 self hMatchParent; vFitContent; padding: (BlInsets all: 10);
  margin: (BlInsets bottom: 12)
]

{ #category : #ui }
GtLACPChatMessageElement >> permissionElementFor: permission [
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
GtLACPChatMessageElement >> previewOf: anObject [
 | text |
 text := anObject isString ifTrue: [ anObject ] ifFalse: [ STONJSON toStringPretty: anObject ].
 ^ text size > 2000 ifTrue: [ (text first: 2000), '… (inspect for full content)' ] ifFalse: [ text ]
]

{ #category : #ui }
GtLACPChatMessageElement >> rebuild [
 | header inspect |
 self removeChildren.
 header := BrHorizontalPane new hMatchParent; vFitContent; yourself.
 header addChild: (BrLabel new
  aptitude: (BrGlamorousLabelAptitude new bold); text: viewModel label; yourself).
 inspect := BrButton new aptitude: BrGlamorousButtonWithLabelAptitude;
  beSmallSize; label: 'Inspect';
  action: [ :button | button phlow spawnObject: viewModel inspectionTarget ]; yourself.
 header addChild: inspect.
 self addChild: header as: #'acp-message-header'.
 viewModel role = #user ifTrue: [
  viewModel replyMessages do: [ :message |
   self addChild: (self textElementFor: message text markdown: true) ].
  ^ self ].
 viewModel activityItems ifNotEmpty: [
  self addChild: (self assistantSection: #work
   header: [ :expander |
    BrLabel new id: #'acp-work-summary'; aptitude: BrGlamorousLabelAptitude;
     text: viewModel message workSummary;
     when: BlClickEvent do: [ :event | event consumed: true. expander toggleExpanded ];
     yourself ]
   content: [ self workContent ]) ].
 viewModel replyMessages ifNotEmpty: [
  self addChild: (self assistantSection: #final
   header: [ :expander |
    (self textElementFor: self replyPreviewText markdown: false)
     id: #'acp-final-preview'; vExact: 24; yourself ]
   content: [ self finalContent ]) ].
 (viewModel messages isEmpty and: [ viewModel turn isActive ])
  ifTrue: [ self addChild: (self textElementFor: 'Working…' markdown: false) ].
 viewModel turn error ifNotNil: [ :error |
  self addChild: (self textElementFor: error printString markdown: false) ]
]

{ #category : #ui }
GtLACPChatMessageElement >> replyPreviewText [
 | text |
 text := String streamContents: [ :stream |
  viewModel replyMessages do: [ :message | stream nextPutAll: message text ] ].
 text := (text copyReplaceAll: String cr with: ' ') copyReplaceAll: String lf with: ' '.
 ^ text size > 180 ifTrue: [ (text first: 180), '…' ] ifFalse: [ text ]
]

{ #category : #ui }
GtLACPChatMessageElement >> textElementFor: aString markdown: aBoolean [
 | editor |
 editor := BrEditor new
  aptitude: BrGlamorousRegularEditorAptitude;
  beReadOnlyWithSelection; hMatchParent; vFitContentLimited;
  text: aString; yourself.
 aBoolean ifTrue: [ editor styler: (GtLMessageStyler new objectRegistry: GtLObjectStorage new; yourself) ].
 ^ editor
]

{ #category : #ui }
GtLACPChatMessageElement >> toolContentFor: aTool [
 | pane |
 pane := BrVerticalPane new hMatchParent; vFitContent;
  padding: (BlInsets all: 8); margin: (BlInsets top: 5);
  border: (BlBorder paint: Color veryLightGray width: 1);
  background: (Color r: 0.98 g: 0.98 b: 0.98); yourself.
 pane addChild: (BrButton new aptitude: BrGlamorousButtonWithLabelAptitude;
  beSmallSize; label: 'Inspect tool call';
  action: [ :button | button phlow spawnObject: aTool ]; yourself).
 (aTool data at: 'rawInput' ifAbsent: [ nil ]) ifNotNil: [ :input |
  pane addChild: (self textElementFor: 'Input: ', (self previewOf: input) markdown: false) ].
 (aTool data at: 'rawOutput' ifAbsent: [ aTool data at: 'content' ifAbsent: [ nil ] ])
  ifNotNil: [ :output |
   pane addChild: (self textElementFor: 'Output: ', (self previewOf: output) markdown: false) ].
 aTool permissionRequests do: [ :permission |
  pane addChild: (self permissionElementFor: permission) ].
 ^ pane
]

{ #category : #ui }
GtLACPChatMessageElement >> toolElementFor: aTool [
 | expander model |
 model := viewModel.
 expander := BrExpander new
  id: ('acp-tool-', aTool id asString) asSymbol;
  aptitude: (BrGlamorousExpanderSubtleAptitude new doNotReplaceHeader);
  hMatchParent; vFitContent;
  margin: (BlInsets top: 4 bottom: 4);
  header: [
   BrButton new
    id: ('acp-tool-toggle-', aTool id asString) asSymbol;
    aptitude: BrGlamorousButtonWithLabelAptitude;
    beSmallSize;
    label: aTool title, ' · ', aTool status,
     ((aTool permissionRequests anySatisfy: [ :request | request state = #pending ])
      ifTrue: [ ' · permission required' ] ifFalse: [ '' ]);
    action: [ expander toggleExpanded ];
    yourself ];
  content: [ self toolContentFor: aTool ];
  yourself.
 expander expanded: (model isToolExpanded: aTool).
 expander whenExpandedDo: [ model tool: aTool expanded: true ].
 expander whenCollapsedDo: [ model tool: aTool expanded: false ].
 ^ expander
]

{ #category : #accessing }
GtLACPChatMessageElement >> viewModel [
 ^ viewModel
]

{ #category : #accessing }
GtLACPChatMessageElement >> viewModel: aViewModel [
 viewModel := aViewModel.
 self rebuild
]

{ #category : #ui }
GtLACPChatMessageElement >> workContent [
 | pane |
 pane := BrVerticalPane new id: #'acp-work-content'; hMatchParent; vFitContent; yourself.
 viewModel activityItems do: [ :item |
  (item isKindOf: GtLACPToolCall)
   ifTrue: [ pane addChild: (self toolElementFor: item) ]
   ifFalse: [
    item role = #thought ifTrue: [
     pane addChild: (BrLabel new aptitude: BrGlamorousLabelAptitude;
      text: 'Thinking'; yourself) ].
    pane addChild: (self textElementFor: item text markdown: item role ~= #thought) ] ].
 ^ pane
]
