Class {
	#name : #GtLlmNewActionThreadMessageElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable + TGtLlmWithThreadMessageViewModel',
	#classTraits : 'TBrLayoutResizable classTrait + TGtLlmWithThreadMessageViewModel classTrait',
	#instVars : [
		'contentsElement',
		'sendButton',
		'toolbar',
		'toggleGroup',
		'argument'
	],
	#category : #'Gt4Llm-Widgets'
}

{ #category : #factory }
GtLlmNewActionThreadMessageElement class >> newForChatList [
	^ self new
		geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
		background: Color white;
		addAptitude: BrGlamorousFocusableShadowAptitude new;
		margin: (BlInsets
				top: 3
				bottom: 12
				left: 5
				right: 10)
]

{ #category : #'initialization ' }
GtLlmNewActionThreadMessageElement >> buildSendButton [
	^ BrButton new
			fitContent;
			beSmallSize;
			aptitude: BrGlamorousButtonWithIconAptitude;
			label: 'Send';
			icon: BrGlamorousVectorIcons accept;
			action: [ :aButton | self sendMessageFrom: aButton ];
			margin: (BlInsets all: 3);
			constraintsDo: [ :c | 
				c linear vertical alignBottom.
				c linear horizontal alignLeft ]
]

{ #category : #initialization }
GtLlmNewActionThreadMessageElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #'initialization ' }
GtLlmNewActionThreadMessageElement >> initialize [
	super initialize.

	self initializeToggleGroup.
	self initializeContentsElement.
	self initializeToolbar.
	self
		addChild: (BrScrollPane new
				aptitude: BrScrollPaneAptitude;
				content: toggleGroup)
		as: #toggle.
	self addChild: contentsElement as: #contents.
	self addChild: toolbar as: #toolbar.

	self hMatchParent.
	self vFitContentLimited
]

{ #category : #'initialization ' }
GtLlmNewActionThreadMessageElement >> initializeContentsElement [
	contentsElement := BrEditor new beReadOnlyWithoutSelection
			hMatchParent;
			vFitContentLimited;
			aptitude: (BrGlamorousRegularEditorAptitude new
					foreground: BrGlamorousColors disabledButtonTextColor).

	contentsElement
		addShortcut: (BrEditorShortcut new
				name: 'Send message';
				description: 'Send message to the OpenAI assistant chat';
				combination: BlKeyCombination primaryReturn;
				performBlock: [ :aBrTextEditor | self sendMessage ];
				yourself)
]

{ #category : #'initialization ' }
GtLlmNewActionThreadMessageElement >> initializeToggleGroup [
	toggleGroup := BrToggleGroup new
			aptitude: BrGlamorousToggleGroupAptitude new;
			margin: (BlInsets
					top: 3
					bottom: 0
					left: 8
					right: 8)
]

{ #category : #'initialization ' }
GtLlmNewActionThreadMessageElement >> initializeToolbar [
	toolbar := BrToolbar new aptitude: BrGlamorousToolbarAptitude new
]

{ #category : #'private - announcement handling' }
GtLlmNewActionThreadMessageElement >> onThreadMessageContentsChanged: anAnnouncement [
	anAnnouncement requester = self ifTrue: [ ^ self ].
	self enqueueTask: (BlTaskAction new action: [ self updateElement ])
]

{ #category : #'private - hooks' }
GtLlmNewActionThreadMessageElement >> onThreadMessageViewModelChanged [
	self updateElement
]

{ #category : #'private - announcement handling' }
GtLlmNewActionThreadMessageElement >> onThreadMessageViewModelChanged: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [ self updateElement ])
]

{ #category : #'private - actions' }
GtLlmNewActionThreadMessageElement >> sendMessage [
	threadMessageViewModel ifNil: [ ^ self ].
	threadMessageViewModel currentAction hasArgument
		ifTrue: [ threadMessageViewModel contents: argument string requester: self ].
	threadMessageViewModel sendMessage
]

{ #category : #'private - event handling' }
GtLlmNewActionThreadMessageElement >> sendMessageFrom: aButton [
	self sendMessage
]

{ #category : #'private - hooks' }
GtLlmNewActionThreadMessageElement >> subscribeToThreadMessageViewModel [
	self threadMessage
		when: GtOpenAINewThreadMessageContentsChanged
		send: #onThreadMessageContentsChanged:
		to: self.

	self threadMessageViewModel weak
		when: GtOpenAIThreadMessageViewModelChanged
		send: #onThreadMessageViewModelChanged:
		to: self
]

{ #category : #'private - hooks' }
GtLlmNewActionThreadMessageElement >> unsubscribeFromThreadMessageViewModel [
	self threadMessage unsubscribe: self
]

{ #category : #'private - updating' }
GtLlmNewActionThreadMessageElement >> updateContents: aBlText [
	threadMessageViewModel ifNil: [ ^ self ].
	threadMessageViewModel contents: aBlText asString requester: self
]

{ #category : #'private - updating' }
GtLlmNewActionThreadMessageElement >> updateContentsElement [
	contentsElement
		text: threadMessageViewModel contents;
		styler: threadMessageViewModel styler
]

{ #category : #'private - updating' }
GtLlmNewActionThreadMessageElement >> updateElement [
	self updateToggleGroup.
	self updateContentsElement.
	self updateToolbar
]

{ #category : #'private - updating' }
GtLlmNewActionThreadMessageElement >> updateToggleGroup [
	toggleGroup removeToggles.
	self threadMessageViewModel actions
		do: [ :anAction | 
			| toggleElement |
			toggleElement := BrToggle new
					aptitude: BrGlamorousToggleWithLabelAptitude new;
					label: anAction name.
			toggleElement
				when: BrToggleActivatedEvent
				do: [ :anEvent | 
					| contentText |
					contentText := anAction format asRopedText.
					anAction hasArgument
						ifTrue: [ | index |
							index := anAction format findString: '{1}'.
							argument := GtSharedStringAttributeBuilder new string: 'argument'.
							(contentText from: index to: index + 2)
								attribute: argument editorAttribute ].
					contentsElement text: contentText.
					self threadMessageViewModel currentAction: anAction ].
			toggleGroup addToggle: toggleElement ].
	toggleGroup viewModel toggles
		ifNotEmpty: [ :aGroupOfToggles | aGroupOfToggles first activate ]
]

{ #category : #'private - updating' }
GtLlmNewActionThreadMessageElement >> updateToolbar [
	toolbar removeAllItems.
	toolbar addItems: threadMessageViewModel messageActions.
	toolbar addItem: self buildSendButton
]
