Class {
	#name : #GtLlmInstanceChatElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'assistantChatViewModel',
		'instanceElement',
		'chatElement',
		'resizerElement'
	],
	#category : #'Gt4OpenAI-Chats'
}

{ #category : #accessing }
GtLlmInstanceChatElement >> assistantChatViewModel [
	^ assistantChatViewModel
]

{ #category : #accessing }
GtLlmInstanceChatElement >> assistantChatViewModel: anObject [
	assistantChatViewModel ifNotNil: [ self unsubcribeFromAssistantChat ].

	assistantChatViewModel := anObject.

	self subscribeToAssistantChat.

	self onAssistantChatViewModelChanged
]

{ #category : #accessing }
GtLlmInstanceChatElement >> initialize [
	super initialize.
	self matchParent.

	self initializeInstanceElement.
	self initializeChatElement.
	self initializeResizerElement.

	self addChild: (self makeLabel: 'Instance') as: #'instance-label'.
	self addChild: instanceElement as: #instance.
	self
		addChild: (chatElement
				addChild: (self makeLabel: 'Chat')
					at: 1
					as: #'chat-label';
				addChild: resizerElement as: #resizer)
		as: #chat
]

{ #category : #accessing }
GtLlmInstanceChatElement >> initializeChatElement [
	chatElement := GtLlmChatElement new
			clipChildren: false;
			background: BrGlamorousColors neutralBackgroundColor
]

{ #category : #accessing }
GtLlmInstanceChatElement >> initializeInstanceElement [
	instanceElement := BrFrame new matchParent
]

{ #category : #accessing }
GtLlmInstanceChatElement >> initializeResizerElement [
	resizerElement := BrResizer new
			aptitude: BrGlamorousHandleBarResizerAptitude;
			elevation: (BlRelativeElevation elevation: 1000);
			constraintsDo: [ :c | c ignoreByLayout ];
			beTop;
			target: chatElement
]

{ #category : #accessing }
GtLlmInstanceChatElement >> makeLabel: aString [
	^ BrLabel new
		aptitude: (BrGlamorousLabelAptitude new glamorousRegularFontAndSize
				foreground: Color gray;
				fontSize: 12);
		text: aString;
		padding: (BlInsets left: 5)
]

{ #category : #accessing }
GtLlmInstanceChatElement >> onAssistantChatViewModelChanged [
	self updateElement
]

{ #category : #accessing }
GtLlmInstanceChatElement >> onLlmExecution: anObject [
	self updateInstanceElement
]

{ #category : #accessing }
GtLlmInstanceChatElement >> subscribeToAssistantChat [
	assistantChatViewModel assistantChat weak
		when: GtLlmExecutionAnnouncement
		send: #onLlmExecution:
		to: self
]

{ #category : #accessing }
GtLlmInstanceChatElement >> unsubcribeFromAssistantChat [
	assistantChatViewModel assistantChat unsubscribe: self
]

{ #category : #accessing }
GtLlmInstanceChatElement >> updateChatElement [
	chatElement assistantChatViewModel: assistantChatViewModel
]

{ #category : #accessing }
GtLlmInstanceChatElement >> updateElement [
	self updateInstanceElement.
	self updateChatElement
]

{ #category : #accessing }
GtLlmInstanceChatElement >> updateInstanceElement [
	instanceElement removeChildren.
	instanceElement
		addChild: (assistantChatViewModel assistantChat gtInstanceFor: GtPhlowEmptyView new)
				asElement
]
