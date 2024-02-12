Class {
	#name : #Gt4OpenAIThreadMessageElement,
	#superclass : #BlElement,
	#traits : 'TGt4OpenAIWithThreadMessage + TBrLayoutResizable',
	#classTraits : 'TGt4OpenAIWithThreadMessage classTrait + TBrLayoutResizable classTrait',
	#instVars : [
		'senderElement',
		'contentsElement'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #factory }
Gt4OpenAIThreadMessageElement class >> newForChatList [
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
Gt4OpenAIThreadMessageElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #initialization }
Gt4OpenAIThreadMessageElement >> initialize [
	super initialize.
	self initializeSenderElement.
	self initializeContentsElement.

	self addChild: senderElement as: #sender.
	self addChild: contentsElement as: #contents.

	self hMatchParent.
	self vFitContent.
	self padding: (BlInsets all: 3)
]

{ #category : #initialization }
Gt4OpenAIThreadMessageElement >> initializeContentsElement [
	contentsElement := BrEditor new
			hMatchParent;
			vFitContent;
			styler: Gt4LlmMessageStyler new;
			aptitude: BrGlamorousRegularEditorAptitude;
			beReadOnlyWithSelection
]

{ #category : #initialization }
Gt4OpenAIThreadMessageElement >> initializeSenderElement [
	senderElement := BrLabel new
			hFitContentLimited;
			vFitContent;
			aptitude: (BrGlamorousLabelAptitude new
					foreground: BrGlamorousColors disabledButtonTextColor);
			beSmallSize;
			text: ''
]

{ #category : #'private - hooks' }
Gt4OpenAIThreadMessageElement >> onThreadMessageChanged [
	self updateElement
]

{ #category : #'private - updating' }
Gt4OpenAIThreadMessageElement >> updateContentsElement [
	contentsElement text: threadMessage contentText.
]

{ #category : #'private - updating' }
Gt4OpenAIThreadMessageElement >> updateElement [
	self updateSenderElement.
	self updateContentsElement.
]

{ #category : #'private - updating' }
Gt4OpenAIThreadMessageElement >> updateSenderElement [
	threadMessage isAssistantRole
		ifTrue: [ senderElement text: 'ChatGPT' ]
		ifFalse: [ senderElement text: 'You' ]
]
