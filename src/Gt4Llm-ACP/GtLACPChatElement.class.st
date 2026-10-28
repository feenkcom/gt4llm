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
		'sendButton',
		'stopButton',
		'errorLabel',
		'listUpdater',
		'followEndRequested',
		'scrollFollowingVersion'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #ui }
GtLACPChatElement >> buildComposer [
 | composer toolbar |
 inputElement := BrEditor new
  id: #'acp-input'; aptitude: BrGlamorousRegularEditorAptitude;
  hMatchParent; vExact: 110;
  padding: (BlInsets all: 8);
  border: (BlBorder paint: Color lightGray width: 1);
  background: (Color r: 0.985 g: 0.985 b: 0.985); yourself.
 inputElement editor when: BrTextEditorModifiedEvent do: [ :event |
  viewModel ifNotNil: [ viewModel draft: event text asString. self updateControls ] ].
 inputElement addShortcut: (BrEditorShortcut new
  name: 'Send message'; description: 'Send the prompt to the ACP agent';
  combination: BlKeyCombination primaryReturn;
  performBlock: [ :editor | self sendDraft ]; yourself).
 sendButton := BrButton new id: #'acp-send';
  aptitude: BrGlamorousButtonWithLabelAptitude; label: 'Send';
  action: [ self sendDraft ]; disable; yourself.
 stopButton := BrButton new id: #'acp-stop';
  aptitude: BrGlamorousButtonWithLabelAptitude; label: 'Stop';
  action: [ self stopTurn ]; disable; yourself.
 toolbar := BrHorizontalPane new hMatchParent; vFitContent; yourself.
 toolbar addChild: sendButton; addChild: stopButton.
 toolbar addChild: (BrLabel new aptitude: BrGlamorousLabelAptitude; text: 'Ctrl/Cmd+Enter to send'; margin: (BlInsets left: 12); yourself).
 composer := BrVerticalPane new hMatchParent; vFitContent;
  padding: (BlInsets top: 8); yourself.
 composer addChild: (BrLabel new aptitude: BrGlamorousLabelAptitude; text: 'Message'; yourself).
 composer addChild: inputElement; addChild: toolbar.
 ^ composer
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
 listElement := BrSimpleList vertical
  hMatchParent; vMatchParent;
  itemId: [ :item :index | item id ];
  itemStencil: [ GtLACPChatMessageElement new ];
  itemDataBinder: [ :element :item :index | element id: ('acp-message-', index asString) asSymbol; viewModel: item ];
  yourself.
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

{ #category : #accessing }
GtLACPChatElement >> sendButton [
 ^ sendButton
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

{ #category : #accessing }
GtLACPChatElement >> stopButton [
 ^ stopButton
]

{ #category : #actions }
GtLACPChatElement >> stopTurn [
 viewModel ifNotNil: [ viewModel stop. self updateControls ]
]

{ #category : #ui }
GtLACPChatElement >> updateControls [
 | error |
 viewModel ifNil: [ ^ self ].
 viewModel canSend ifTrue: [ sendButton enable ] ifFalse: [ sendButton disable ].
 viewModel canStop ifTrue: [ stopButton enable ] ifFalse: [ stopButton disable ].
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
