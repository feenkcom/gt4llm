Class {
	#name : #GtOpenAIAssistantObjectChatElement,
	#superclass : #BlElement,
	#traits : 'TGtOpenAIWithAssistantChatViewModel + TBrLayoutResizable',
	#classTraits : 'TGtOpenAIWithAssistantChatViewModel classTrait + TBrLayoutResizable classTrait',
	#instVars : [
		'messageElement',
		'alternativeMessage',
		'recreateElement'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #accessing }
GtOpenAIAssistantObjectChatElement >> alternativeMessage [
	^ alternativeMessage
]

{ #category : #accessing }
GtOpenAIAssistantObjectChatElement >> alternativeMessage: anObject [
	alternativeMessage := anObject
]

{ #category : #'initialization ' }
GtOpenAIAssistantObjectChatElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #initialization }
GtOpenAIAssistantObjectChatElement >> initialize [
	super initialize.

	self initializeMessageElement.
	self initializeRecreateElement.
	self addChild: messageElement as: #message.
	self addChild: recreateElement as: #recreateButton.
	self padding: (BlInsets all: 3).
	self matchParent
]

{ #category : #initialization }
GtOpenAIAssistantObjectChatElement >> initializeMessageElement [
	messageElement := GtOpenAIThreadMessageElement new
]

{ #category : #initialization }
GtOpenAIAssistantObjectChatElement >> initializeRecreateElement [
	recreateElement := BrButton new
			aptitude: BrGlamorousButtonWithIconAptitude;
			label: 'Generate alternative';
			icon: BrGlamorousVectorIcons refresh;
			action: [ self assistantChatViewModel sendMessage: self alternativeMessage ]
]

{ #category : #'private - hooks' }
GtOpenAIAssistantObjectChatElement >> onAssistantChatViewModelChanged [
	self updateElement
]

{ #category : #'private - event handling' }
GtOpenAIAssistantObjectChatElement >> onThreadRunAnnouncement: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [ self updateElement ])
]

{ #category : #'private - hooks' }
GtOpenAIAssistantObjectChatElement >> subscribeToAssistantChatViewModel [
	self assistantChat weak
		when: GtOpenAIThreadRunAnnouncement
		send: #onThreadRunAnnouncement:
		to: self
]

{ #category : #'private - hooks' }
GtOpenAIAssistantObjectChatElement >> unsubscribeFromAssistantChatViewModel [
	self assistantChat unsubscribe: self
]

{ #category : #'private - updating' }
GtOpenAIAssistantObjectChatElement >> updateElement [
	self updateMessageElement
]

{ #category : #'private - updating' }
GtOpenAIAssistantObjectChatElement >> updateMessageElement [
	messageElement
		threadMessageViewModel: self assistantChatViewModel threadMessageViewModel
]
