Class {
	#name : #GtOpenAINewThreadMessageElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable + TGtOpenAIWithThreadMessageViewModel',
	#classTraits : 'TBrLayoutResizable classTrait + TGtOpenAIWithThreadMessageViewModel classTrait',
	#instVars : [
		'contentsElement'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #factory }
GtOpenAINewThreadMessageElement class >> newForChatList [
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
GtOpenAINewThreadMessageElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #'initialization ' }
GtOpenAINewThreadMessageElement >> initialize [
	super initialize.
	
	self initializeContentsElement.
	self addChild: contentsElement as: #contents.
	
	self hMatchParent.
	self vFitContent
]

{ #category : #'initialization ' }
GtOpenAINewThreadMessageElement >> initializeContentsElement [
	contentsElement := BrEditor new
			hMatchParent;
			vFitContent;
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

{ #category : #'private - hooks' }
GtOpenAINewThreadMessageElement >> onThreadMessageContentsChanged: anAnnouncement [
	anAnnouncement requester = self ifTrue: [ ^ self ].
	self updateElement
]

{ #category : #'private - hooks' }
GtOpenAINewThreadMessageElement >> onThreadMessageViewModelChanged [
	self updateElement
]

{ #category : #'private - actions' }
GtOpenAINewThreadMessageElement >> sendMessage [
	threadMessageViewModel ifNil: [ ^ self ].
	threadMessageViewModel sendMessage
]

{ #category : #'private - hooks' }
GtOpenAINewThreadMessageElement >> subscribeToThreadMessageViewModel [
	self threadMessage
		when: GtOpenAINewThreadMessageContentsChanged
		send: #onThreadMessageContentsChanged:
		to: self
]

{ #category : #'private - hooks' }
GtOpenAINewThreadMessageElement >> unsubscribeFromThreadMessageViewModel [
	self threadMessage unsubscribe: self
]

{ #category : #'private - updating' }
GtOpenAINewThreadMessageElement >> updateContents: aBlText [
	threadMessageViewModel ifNil: [ ^ self ].
	threadMessageViewModel contents: aBlText asString requester: self
]

{ #category : #'private - updating' }
GtOpenAINewThreadMessageElement >> updateContentsElement [
	contentsElement
		text: threadMessageViewModel contents;
		styler: threadMessageViewModel styler
]

{ #category : #'private - updating' }
GtOpenAINewThreadMessageElement >> updateElement [
	self updateContentsElement
]
