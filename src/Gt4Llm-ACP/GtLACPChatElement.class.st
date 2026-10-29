"
I display an ACP conversation and persistent input area. A virtualized list contains message elements. Weak session announcements and BrElementUpdater refresh streamed content on the UI thread. Send, Stop and the primary+Return shortcut operate on the session.
"
Class {
	#name : #GtLACPChatElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'viewModel',
		'listElement',
		'inputElement',
		'actionButton',
		'errorLabel',
		'listUpdater',
		'followEndRequested',
		'scrollFollowingVersion'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #accessing }
GtLACPChatElement >> actionButton [
 ^ actionButton
]

{ #category : #ui }
GtLACPChatElement >> buildComposer [
 | composer toolbar |
 inputElement := BrEditor new
  id: #'acp-input'; aptitude: BrGlamorousRegularEditorAptitude;
  hMatchParent; vExact: 70;
  padding: (BlInsets all: 5); yourself.
 inputElement editor when: BrTextEditorModifiedEvent do: [ :event |
  viewModel ifNotNil: [ viewModel draft: event text asString. self updateControls ] ].
 inputElement addShortcut: (BrEditorShortcut new
  name: 'Send message'; description: 'Send the prompt to the ACP agent';
  combination: BlKeyCombination primaryReturn;
  performBlock: [ :editor | self sendDraft ]; yourself).
 actionButton := BrButton new id: #'acp-action';
  aptitude: BrGlamorousButtonWithIconAptitude;
  beSmallSize; label: 'Send'; icon: BrGlamorousVectorIcons accept;
  action: [ self sendOrStop ]; disable;
  margin: (BlInsets all: 3); yourself.
 toolbar := BrHorizontalPane new hMatchParent; vFitContent; addChild: actionButton; yourself.
 composer := BrVerticalPane new hMatchParent; vFitContent;
  padding: (BlInsets all: 5); margin: (BlInsets top: 8 bottom: 4 left: 2 right: 2);
  background: self theme default contentBackground;
  addAptitude: BrGlamorousFocusableShadowAptitude new; yourself.
 composer addChild: inputElement; addChild: toolbar.
 ^ composer
]

{ #category : #ui }
GtLACPChatElement >> configureMessageList [
 listElement padding: (BlInsets all: 5).
 listElement
  itemId: [ :item :index | item id ];
  itemType: [ :factory :item :index | factory named: item renderingKey ];
  itemStencil: [ :type | type name first asElement ];
  itemDataBinder: [ :element :item :index |
   element id: ('acp-message-', index asString) asSymbol ]
]

{ #category : #accessing }
GtLACPChatElement >> errorLabel [
 ^ errorLabel
]

{ #category : #scrolling }
GtLACPChatElement >> followStreamAfterLayout [
 | viewport lastChild delta |
 followEndRequested == true ifFalse: [ ^ self ].
 listElement items isEmpty ifTrue: [ followEndRequested := false. ^ self ].
 viewport := self messageViewport.
 lastChild := viewport layout childAtPosition: listElement items size.
 lastChild ifNil: [
  viewport scrollToPosition: listElement items size.
  ^ self ].
 delta := lastChild bounds inParent bottom - (viewport height - viewport layout paddingBottom).
 followEndRequested := false.
 delta > 0 ifTrue: [ viewport scrollBy: 0 @ delta ]
]

{ #category : #ui }
GtLACPChatElement >> initialize [
 super initialize.
 self hMatchParent; vMatchParent; padding: (BlInsets all: 8).
 errorLabel := BrEditor new
  aptitude: BrGlamorousRegularEditorAptitude;
  beReadOnlyWithSelection; hMatchParent; vFitContent;
  visibility: BlVisibility gone; yourself.
 listElement := BrSimpleList vertical hMatchParent; vMatchParent; yourself.
 self configureMessageList.
 self initializeScrollFollowing.
 listUpdater := BrElementUpdater new element: self selector: #updateMessages;
  postponedDuration: 150 milliseconds; yourself.
 self addChild: listElement as: #'acp-messages'.
 self addChild: errorLabel as: #'acp-error'.
 self addChild: self buildComposer as: #'acp-composer'
]

{ #category : #scrolling }
GtLACPChatElement >> initializeScrollFollowing [
 scrollFollowingVersion = 1 ifTrue: [ ^ self ].
 self messageViewport
  when: BlElementLayoutComputedEvent
  do: [ :event | self followStreamAfterLayout ].
 self messageViewport
  when: BlElementScrolledEvent
  do: [ :event | event delta y < 0 ifTrue: [ followEndRequested := false ] ].
 scrollFollowingVersion := 1
]

{ #category : #accessing }
GtLACPChatElement >> inputElement [
 ^ inputElement
]

{ #category : #scrolling }
GtLACPChatElement >> isAtStreamEnd [
 listElement items isEmpty ifTrue: [ ^ true ].
 ^ self messageViewport canScrollDown not
]

{ #category : #accessing }
GtLACPChatElement >> listElement [
 ^ listElement
]

{ #category : #scrolling }
GtLACPChatElement >> messageViewport [
 ^ listElement childNamed: #scrollable
]

{ #category : #lifecycle }
GtLACPChatElement >> onAddedToSceneGraph [
 super onAddedToSceneGraph.
 viewModel ifNotNil: [
  viewModel session announcer unsubscribe: self.
  viewModel session announcer weak when: GtLACPSessionChanged send: #onSessionChanged: to: self.
  listUpdater requestUpdate ]
]

{ #category : #lifecycle }
GtLACPChatElement >> onRemovedFromSceneGraph [
 viewModel ifNotNil: [ viewModel session announcer unsubscribe: self ].
 super onRemovedFromSceneGraph
]

{ #category : #announcing }
GtLACPChatElement >> onSessionChanged: anAnnouncement [
 self enqueueTask: (BlTaskAction new action: [ listUpdater requestUpdate ])
]

{ #category : #actions }
GtLACPChatElement >> sendDraft [
 | turn |
 viewModel ifNil: [ ^ self ].
 viewModel draft: inputElement text asString.
 turn := viewModel send.
 turn ifNotNil: [ inputElement text: viewModel draft ].
 self updateMessages.
 ^ turn
]

{ #category : #actions }
GtLACPChatElement >> sendOrStop [
 viewModel ifNil: [ ^ self ].
 viewModel canStop
  ifTrue: [ self stopTurn ]
  ifFalse: [ self sendDraft ]
]

{ #category : #actions }
GtLACPChatElement >> stopTurn [
 viewModel ifNotNil: [ viewModel stop. self updateControls ]
]

{ #category : #ui }
GtLACPChatElement >> updateControls [
 | error |
 viewModel ifNil: [ ^ self ].
 viewModel session state = #prompting
  ifTrue: [
   actionButton label: (viewModel canStop ifTrue: [ 'Stop' ] ifFalse: [ 'Stopping…' ]);
    icon: BrGlamorousVectorIcons stop.
   viewModel canStop ifTrue: [ actionButton enable ] ifFalse: [ actionButton disable ] ]
  ifFalse: [
   actionButton label: 'Send'; icon: BrGlamorousVectorIcons accept.
   viewModel canSend ifTrue: [ actionButton enable ] ifFalse: [ actionButton disable ] ].
 viewModel session state = #closed
  ifTrue: [ inputElement beReadOnlyWithSelection ]
  ifFalse: [ inputElement beEditable ].
 error := viewModel errorText.
 errorLabel text: error.
 errorLabel visibility: (error isEmpty ifTrue: [ BlVisibility gone ] ifFalse: [ BlVisibility visible ])
]

{ #category : #scrolling }
GtLACPChatElement >> updateMessages [
 | items follow |
 viewModel ifNil: [ ^ self ].
 self initializeScrollFollowing.
 follow := followEndRequested == true or: [ self isAtStreamEnd ].
 items := viewModel messageViewModels.
 followEndRequested := follow and: [ items notEmpty ].
 listElement items: items.
 self updateControls
]

{ #category : #accessing }
GtLACPChatElement >> viewModel [
 ^ viewModel
]

{ #category : #accessing }
GtLACPChatElement >> viewModel: aViewModel [
 viewModel ifNotNil: [ viewModel session announcer unsubscribe: self ].
 viewModel := aViewModel.
 inputElement text: viewModel draft.
 viewModel session announcer weak
  when: GtLACPSessionChanged send: #onSessionChanged: to: self.
 self updateMessages
]
