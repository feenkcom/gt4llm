Class {
	#name : #Gt4OpenAINewThreadMessageElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable + TGt4OpenAIWithThreadMessage',
	#classTraits : 'TBrLayoutResizable classTrait + TGt4OpenAIWithThreadMessage classTrait',
	#instVars : [
		'contentsElement'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #factory }
Gt4OpenAINewThreadMessageElement class >> newForChatList [
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
Gt4OpenAINewThreadMessageElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #'initialization ' }
Gt4OpenAINewThreadMessageElement >> initialize [
	super initialize.
	
	self initializeContentsElement.
	self addChild: contentsElement as: #contents.
	
	self hMatchParent.
	self vFitContent
]

{ #category : #'initialization ' }
Gt4OpenAINewThreadMessageElement >> initializeContentsElement [
	contentsElement := BrEditor new
			hMatchParent;
			vFitContent;
			styler: Gt4LlmMessageStyler new;
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
Gt4OpenAINewThreadMessageElement >> onThreadMessageChanged [
	self updateElement
]

{ #category : #'private - hooks' }
Gt4OpenAINewThreadMessageElement >> onThreadMessageContentsChanged: anAnnouncement [
	anAnnouncement requester = self ifTrue: [ ^ self ].
	self updateElement
]

{ #category : #'private - actions' }
Gt4OpenAINewThreadMessageElement >> sendMessage [
	threadMessage ifNil: [ ^ self ].
	threadMessage sendMessage
]

{ #category : #'private - hooks' }
Gt4OpenAINewThreadMessageElement >> subscribeToThreadMessage [
	threadMessage
		when: Gt4OpenAINewThreadMessageContentsChanged
		send: #onThreadMessageContentsChanged:
		to: self
]

{ #category : #'private - hooks' }
Gt4OpenAINewThreadMessageElement >> unsubscribeFromThreadMessage [
	threadMessage unsubscribe: self
]

{ #category : #'private - updating' }
Gt4OpenAINewThreadMessageElement >> updateContents: aBlText [
	threadMessage ifNil: [ ^ self ].
	threadMessage contents: aBlText asString requester: self
]

{ #category : #'private - updating' }
Gt4OpenAINewThreadMessageElement >> updateContentsElement [
	contentsElement text: threadMessage contents
]

{ #category : #'private - updating' }
Gt4OpenAINewThreadMessageElement >> updateElement [
	self updateContentsElement
]
