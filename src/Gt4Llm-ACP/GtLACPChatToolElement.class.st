"
I present an ACP session using the Phlow chat tool structure: a labeled header, collected object views in tabs, and a collapsed playground. I specialize the ACP view collection and omit GtLChat-specific object storage and summarizer integration.
"
Class {
	#name : #GtLACPChatToolElement,
	#superclass : #GtPhlowChatToolElement,
	#instVars : [
		'closeSessionButton',
		'closeSessionButtonUpdater'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #building }
GtLACPChatToolElement >> buildHeaderElement [
 | header |
 closeSessionButton := BrButton new id: #'acp-close-session';
  aptitude: BrGlamorousButtonWithLabelAptitude; beSmallSize;
  label: 'Close session'; visibility: BlVisibility gone;
  action: [ self chat close. self updateCloseSessionButton ]; yourself.
 header := BrHorizontalPane new padding: (BlInsets left: 5);
  hMatchParent; vFitContent;
  addChild: self buildToolLabel as: #toolLabel;
  addChild: (BrFrame new hMatchParent; vExact: 0; yourself);
  addChild: closeSessionButton;
  yourself.
 ^ header
]

{ #category : #initialization }
GtLACPChatToolElement >> buildToolLabel [
 ^ super buildToolLabel text: 'ACP Chat'; yourself
]

{ #category : #accessing }
GtLACPChatToolElement >> chat: aSession [
 chat ifNotNil: [ chat announcer unsubscribe: self ].
 super chat: aSession.
 aSession ifNotNil: [
  aSession announcer weak when: GtLACPSessionChanged send: #onSessionChanged: to: self ].
 self updateCloseSessionButton
]

{ #category : #views }
GtLACPChatToolElement >> collectToolViews [
 | views context |
 context := self chat phlowContext.
 views := (GtPhlowViewsCollector new
  fromObject: self chat;
  pragmaNames: GtLSettings messageViewPragmaNames;
  context: context;
  collect),
  (self chat summarizerViewsFor: self chat gtInspectorTargetModels inContext: context).
 GtPhlowUtility sortByPriority: views.
 ^ views
]

{ #category : #views }
GtLACPChatToolElement >> gtInspectorTargetModels [
 ^ { self chat }, self chat gtInspectorTargetModels
]

{ #category : #initialization }
GtLACPChatToolElement >> initialize [
 super initialize.
 closeSessionButtonUpdater := BrElementUpdater new element: self selector: #updateCloseSessionButton;
  postponedDuration: 150 milliseconds; yourself.
 self phlow
  accessTool: (GtPhlowToolClassType forClass: GtLACPSession)
  viewModel: #chat
  object: #chat
]

{ #category : #events }
GtLACPChatToolElement >> onSessionChanged: anAnnouncement [
 BlTaskAction enqueueElement: self action: [ closeSessionButtonUpdater requestUpdate ]
]

{ #category : #updating }
GtLACPChatToolElement >> updateCloseSessionButton [
 (chat notNil and: [ chat canClose ])
  ifTrue: [ closeSessionButton visibility: BlVisibility visible; enable ]
  ifFalse: [ closeSessionButton visibility: BlVisibility gone; disable ]
]

{ #category : #updating }
GtLACPChatToolElement >> updateContainedViews [
 | compositeView tabGroup listener |
 self chat ifNil: [
  self viewsContainerElement removeChildren.
  ^ self ].
 compositeView := GtPhlowCompositeView new views: self collectToolViews.
 tabGroup := compositeView asElementDo: [ :element | element ].
 listener := GtLPhlowSummarizersChangedListener
  installOnCompositeElement: tabGroup forRegistry: self chat summarizersRegistry.
 listener onSummarizersChangedAction: (GtLACPChangeSummarizersTabAction new
  tabGroup: tabGroup;
  session: self chat;
  yourself).
 self viewsContainerElement removeChildren; addChild: tabGroup
]
