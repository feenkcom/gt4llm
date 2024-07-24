Class {
	#name : #GtLlmChat,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'client',
		'messages',
		'model',
		'announcer',
		'context',
		'lastUpdate',
		'tutor'
	],
	#category : #'Gt4Llm-Chats'
}

{ #category : #accessing }
GtLlmChat >> addMessage: aMessage [
	self updateLastUpdate.
	messages addFirst: (aMessage chat: self).
	self announcer announce: (GtOpenAIThreadRunIsDoneAnnouncement new run: self)
]

{ #category : #accessing }
GtLlmChat >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
GtLlmChat >> client [
	^ client
]

{ #category : #accessing }
GtLlmChat >> client: anObject [
	client := anObject
]

{ #category : #accessing }
GtLlmChat >> context [
	^ context
]

{ #category : #accessing }
GtLlmChat >> context: anObject [
	context := anObject.
	context chat: self
]

{ #category : #accessing }
GtLlmChat >> gtMessagesFor: aView [
	"cannot be a forward because the update wouldn’t work"

	<gtView>
	^ aView columnedList
		title: 'Messages';
		priority: 1;
		items: [ self messages reversed ];
		column: 'Role'
			text: #role
			width: 100;
		column: 'Message' text: #content;
		updateWhen: GtOpenAIThreadRunAnnouncement in: self announcer;
		actionUpdateButton
]

{ #category : #accessing }
GtLlmChat >> gtMessagesWidgetFor: aView [
	"cannot be a forward because the update wouldn’t work"

	<gtView>
	| aViewModel |
	^ aView explicit
		title: 'Chat';
		priority: 0;
		stencil: [ aViewModel
				ifNil: [ aViewModel := GtLlmChatViewModel new assistantChat: self ].
			GtLlmChatElement new assistantChatViewModel: aViewModel ];
		actionUpdateButton
]

{ #category : #accessing }
GtLlmChat >> gtWriteFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Write';
		priority: 2;
		text: [ 'Write a message here' ];
		actionButtonIcon: BrGlamorousVectorIcons play
			tooltip: 'Send'
			action: [ :aButton | 
				aButton parent parent parent parent
					allChildrenBreadthFirstDetect: [ :anElement | anElement isKindOf: BrEditor ]
					ifFound: [ :anEditor | 
						self sendMessage: anEditor text asString.
						anEditor text: '' ] ]
]

{ #category : #accessing }
GtLlmChat >> initialize [
	super initialize.
	
	self initializeClient.
	self initializeMessages.
	
	self updateLastUpdate
]

{ #category : #accessing }
GtLlmChat >> initializeClient [
	self subclassResponsibility
]

{ #category : #accessing }
GtLlmChat >> initializeMessages [
	self subclassResponsibility
]

{ #category : #accessing }
GtLlmChat >> lastUpdate [
	^ lastUpdate
]

{ #category : #accessing }
GtLlmChat >> lastUpdate: anObject [
	lastUpdate := anObject
]

{ #category : #accessing }
GtLlmChat >> messages [
	^ messages
]

{ #category : #accessing }
GtLlmChat >> messages: anObject [
	messages := anObject
]

{ #category : #accessing }
GtLlmChat >> model [
	^ model
]

{ #category : #accessing }
GtLlmChat >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtLlmChat >> sendMessage: aMessage [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmChat >> threadActions [
	^ {}
]

{ #category : #accessing }
GtLlmChat >> tutor [
	^ tutor
]

{ #category : #accessing }
GtLlmChat >> tutor: anObject [
	tutor := anObject
]

{ #category : #accessing }
GtLlmChat >> updateLastUpdate [
	lastUpdate := DateAndTime now
]

{ #category : #accessing }
GtLlmChat >> whenReadyFuture [
	^ GtLlmChatReadyFuture new chat: self
]
