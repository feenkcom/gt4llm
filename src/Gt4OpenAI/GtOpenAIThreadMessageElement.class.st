Class {
	#name : #GtOpenAIThreadMessageElement,
	#superclass : #BlElement,
	#traits : 'TGtOpenAIWithThreadMessage + TBrLayoutResizable',
	#classTraits : 'TGtOpenAIWithThreadMessage classTrait + TBrLayoutResizable classTrait',
	#instVars : [
		'senderElement',
		'contentsElement',
		'progressElement'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #factory }
GtOpenAIThreadMessageElement class >> newForChatList [
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

{ #category : #initialization }
GtOpenAIThreadMessageElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #'private - updating' }
GtOpenAIThreadMessageElement >> hideProgressElement [
	contentsElement visibility: BlVisibility visible.
	progressElement visibility: BlVisibility gone.
]

{ #category : #initialization }
GtOpenAIThreadMessageElement >> initialize [
	super initialize.
	self initializeSenderElement.
	self initializeContentsElement.
	self initializeProgressElement.

	self addChild: senderElement as: #sender.
	self addChild: contentsElement as: #contents.
	self addChild: progressElement as: #progress.

	self hMatchParent.
	self vFitContent.
	self padding: (BlInsets all: 3)
]

{ #category : #initialization }
GtOpenAIThreadMessageElement >> initializeContentsElement [
	contentsElement := BrEditor new
			hMatchParent;
			vFitContent;
			styler: GtLlmMessageStyler new;
			aptitude: BrGlamorousRegularEditorAptitude;
			beReadOnlyWithSelection
]

{ #category : #initialization }
GtOpenAIThreadMessageElement >> initializeProgressElement [
	progressElement := BrLabel new
			fitContent;
			aptitude: (BrGlamorousLabelAptitude new
					foreground: BrGlamorousColors disabledButtonTextColor);
			beSmallSize;
			text: 'Typing...';
			visibility: BlVisibility gone
]

{ #category : #initialization }
GtOpenAIThreadMessageElement >> initializeSenderElement [
	senderElement := BrLabel new
			hFitContentLimited;
			vFitContent;
			aptitude: (BrGlamorousLabelAptitude new
					foreground: BrGlamorousColors disabledButtonTextColor);
			beSmallSize;
			text: ''
]

{ #category : #'private - hooks' }
GtOpenAIThreadMessageElement >> onThreadMessageChanged [
	self updateElement
]

{ #category : #'private - updating' }
GtOpenAIThreadMessageElement >> showProgressElement [
	contentsElement visibility: BlVisibility gone.
	progressElement visibility: BlVisibility visible.
]

{ #category : #'private - updating' }
GtOpenAIThreadMessageElement >> updateContentsElement [
	contentsElement text: threadMessage contentText.
]

{ #category : #'private - updating' }
GtOpenAIThreadMessageElement >> updateElement [
	self updateSenderElement.
	self updateContentsElement.
	self updateProgressElement.
]

{ #category : #'private - updating' }
GtOpenAIThreadMessageElement >> updateProgressElement [
	threadMessage hasResponse
		ifTrue: [ self hideProgressElement ]
		ifFalse: [ self showProgressElement ]
]

{ #category : #'private - updating' }
GtOpenAIThreadMessageElement >> updateSenderElement [
	threadMessage isAssistantRole
		ifTrue: [ senderElement text: 'ChatGPT' ]
		ifFalse: [ senderElement text: 'You' ]
]
