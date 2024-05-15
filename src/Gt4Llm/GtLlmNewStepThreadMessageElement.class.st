Class {
	#name : #GtLlmNewStepThreadMessageElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable + TGtLlmWithThreadMessageViewModel',
	#classTraits : 'TBrLayoutResizable classTrait + TGtLlmWithThreadMessageViewModel classTrait',
	#instVars : [
		'contentsElement',
		'sendButton',
		'toolbar',
		'toggleGroup',
		'stepPreviewElement'
	],
	#category : #'Gt4Llm-Widgets'
}

{ #category : #factory }
GtLlmNewStepThreadMessageElement class >> newForChatList [
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
GtLlmNewStepThreadMessageElement >> buildSendButton [
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
GtLlmNewStepThreadMessageElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #'initialization ' }
GtLlmNewStepThreadMessageElement >> initialize [
	super initialize.

	self initializeToggleGroup.
	self initializeStepPreviewElement.
	self initializeContentsElement.
	self initializeToolbar.
	self addChild: toggleGroup as: #toggle.
	self addChild: stepPreviewElement as: #stepPreview.
	self addChild: contentsElement as: #contents.
	self addChild: toolbar as: #toolbar.

	self hMatchParent.
	self vFitContentLimited
]

{ #category : #'initialization ' }
GtLlmNewStepThreadMessageElement >> initializeContentsElement [
	contentsElement := BrEditor new
			hMatchParent;
			vFitContentLimited;
			aptitude: BrGlamorousRegularEditorAptitude.

	contentsElement editor
		when: BrTextEditorModifiedEvent
		do: [ :anEvent | self updateContents: anEvent text ].

	contentsElement
		addShortcut: (BrEditorShortcut new
				name: 'Send message';
				description: 'Send message to the OpenAI assistant chat';
				combination: BlKeyCombination primaryReturn;
				performBlock: [ :aBrTextEditor | self sendMessage ];
				yourself)
]

{ #category : #'initialization ' }
GtLlmNewStepThreadMessageElement >> initializeStepPreviewElement [
	stepPreviewElement := BrEditor new beReadOnlyWithSelection hFitContent
			aptitude: BrGlamorousRegularEditorAptitude;
			visibility: BlVisibility gone;
			border: (BlBorder paint: BrGlamorousColors defaultButtonBorderColor width: 1);
			geometry: (BlRoundedRectangleGeometry
					cornerRadii: (BlCornerRadii new
							topLeft: 0;
							topRight: 0;
							bottomLeft: 5;
							bottomRight: 5));
			margin: (BlInsets
					top: -1
					bottom: 3
					left: 10
					right: 8)
]

{ #category : #'initialization ' }
GtLlmNewStepThreadMessageElement >> initializeToggleGroup [
	toggleGroup := BrToggleGroup new
			aptitude: BrGlamorousToggleGroupAptitude new;
			margin: (BlInsets
					top: 3
					bottom: 0
					left: 8
					right: 8)
]

{ #category : #'initialization ' }
GtLlmNewStepThreadMessageElement >> initializeToolbar [
	toolbar := BrToolbar new aptitude: BrGlamorousToolbarAptitude new
]

{ #category : #'private - actions' }
GtLlmNewStepThreadMessageElement >> maybeSendStepChange [
	| stepName |
	stepName := toggleGroup activatedToggle label.
	stepName asString = self threadMessageViewModel currentStep name
		ifFalse: [ self threadMessageViewModel sendStepChange: stepName ]
]

{ #category : #'private - announcement handling' }
GtLlmNewStepThreadMessageElement >> onThreadMessageContentsChanged: anAnnouncement [
	anAnnouncement requester = self ifTrue: [ ^ self ].
	self enqueueTask: (BlTaskAction new action: [ self updateElement ])
]

{ #category : #'private - hooks' }
GtLlmNewStepThreadMessageElement >> onThreadMessageViewModelChanged [
	self updateElement
]

{ #category : #'private - announcement handling' }
GtLlmNewStepThreadMessageElement >> onThreadMessageViewModelChanged: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [ self updateElement ])
]

{ #category : #'private - updating' }
GtLlmNewStepThreadMessageElement >> onToggleActivated: anEvent [
	| stepName |
	stepName := anEvent toggle widget label.
	stepName = self threadMessageViewModel currentStep name
		ifTrue: [ stepPreviewElement visibility: BlVisibility gone ]
		ifFalse: [ stepPreviewElement
				visibility: BlVisibility visible;
				text: (self threadMessageViewModel stepChangeMessageFor: stepName) ]
]

{ #category : #'private - actions' }
GtLlmNewStepThreadMessageElement >> sendMessage [
	threadMessageViewModel ifNil: [ ^ self ].
	self maybeSendStepChange.
	threadMessageViewModel sendMessage
]

{ #category : #'private - event handling' }
GtLlmNewStepThreadMessageElement >> sendMessageFrom: aButton [
	self sendMessage
]

{ #category : #'private - hooks' }
GtLlmNewStepThreadMessageElement >> subscribeToThreadMessageViewModel [
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
GtLlmNewStepThreadMessageElement >> unsubscribeFromThreadMessageViewModel [
	self threadMessage unsubscribe: self
]

{ #category : #'private - updating' }
GtLlmNewStepThreadMessageElement >> updateContents: aBlText [
	threadMessageViewModel ifNil: [ ^ self ].
	threadMessageViewModel contents: aBlText asString requester: self
]

{ #category : #'private - updating' }
GtLlmNewStepThreadMessageElement >> updateContentsElement [
	contentsElement
		text: threadMessageViewModel contents;
		styler: threadMessageViewModel styler
]

{ #category : #'private - updating' }
GtLlmNewStepThreadMessageElement >> updateElement [
	self updateToggleGroup.
	self updateContentsElement.
	self updateToolbar
]

{ #category : #'private - updating' }
GtLlmNewStepThreadMessageElement >> updateToggleGroup [
	toggleGroup removeToggles.
	self threadMessageViewModel steps
		do: [ :aStep | 
			| toggleElement |
			toggleElement := BrToggle new
					aptitude: BrGlamorousToggleWithLabelAptitude new;
					label: aStep name.
			aStep = self threadMessageViewModel currentStep
				ifTrue: [ toggleElement activate
						aptitude: BrGlamorousToggleWithIconAndLabelAptitude new;
						icon: BrGlamorousVectorIcons accept ].
			toggleElement
				when: BrToggleActivatedEvent
				do: [ :anEvent | self onToggleActivated: anEvent ].
			toggleGroup addToggle: toggleElement ]
]

{ #category : #'private - updating' }
GtLlmNewStepThreadMessageElement >> updateToolbar [
	toolbar removeAllItems.
	toolbar addItems: threadMessageViewModel messageActions.
	toolbar addItem: self buildSendButton
]
