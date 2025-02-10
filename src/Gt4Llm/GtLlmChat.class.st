Class {
	#name : #GtLlmChat,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'model',
		'announcer',
		'context',
		'lastUpdate',
		'tutor',
		'provider',
		'messages',
		'serializer'
	],
	#category : #'Gt4Llm-Chats'
}

{ #category : #accessing }
GtLlmChat >> addMessage: aMessage [
	self updateLastUpdate.
	messages add: (aMessage chat: self)
]

{ #category : #accessing }
GtLlmChat >> ancestorOf: aMessage [
	messages
		withIndexDo: [ :possibleAncestor :index | 
			possibleAncestor id = aMessage id
				ifTrue: [ index = 1 ifTrue: [ ^ nil ] ifFalse: [ ^ messages at: index - 1 ] ] ].

	self error: 'Message not found'
]

{ #category : #accessing }
GtLlmChat >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #'as yet unclassified' }
GtLlmChat >> asViewModel [
	^ GtLlmChatViewModel new assistantChat: self
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
GtLlmChat >> defaultSerializer [
	^ GtLlmMessageSerializer new
]

{ #category : #accessing }
GtLlmChat >> descendantOf: aMessage [
	messages
		withIndexDo: [ :possibleAncestor :index | 
			possibleAncestor id = aMessage id
				ifTrue: [ index = messages size ifTrue: [ ^ nil ] ifFalse: [ ^ messages at: index + 1 ] ] ].

	self error: 'Message not found'
]

{ #category : #accessing }
GtLlmChat >> gtMessagesFor: aView [
	"cannot be a forward because the update wouldn’t work"

	<gtView>
	^ aView columnedList
		title: 'Messages';
		priority: 1;
		items: [ self messages ];
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
	self provider ifNil: [ ^ aView empty ].

	^ aView explicit
		title: 'Chat';
		priority: 0;
		stencil: [ aViewModel ifNil: [ aViewModel := self asViewModel ].
			LlmChatElement new chatViewModel: aViewModel ];
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
	
	self serializer: self defaultSerializer.
	
	self initializeMessages.
	
	self updateLastUpdate
]

{ #category : #accessing }
GtLlmChat >> initializeMessages [
	messages := GtLlmMessagesGroup new
]

{ #category : #accessing }
GtLlmChat >> lastUpdate [
	^ lastUpdate
]

{ #category : #accessing }
GtLlmChat >> lastUpdate: anObject [
	lastUpdate := anObject
]

{ #category : #'as yet unclassified' }
GtLlmChat >> messageFromString: aString [
	^  serializer serialize: aString
]

{ #category : #accessing }
GtLlmChat >> messages [
	^ messages
]

{ #category : #accessing }
GtLlmChat >> messages: anObject [
	messages := anObject.

	messages do: [ :aMessage | aMessage chat: self ]
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
GtLlmChat >> provider [
	^ provider
]

{ #category : #accessing }
GtLlmChat >> provider: anObject [
	provider := anObject.
	provider chat: self
]

{ #category : #'as yet unclassified' }
GtLlmChat >> responseFormat [
	^ self provider format
]

{ #category : #accessing }
GtLlmChat >> sendAssistantMessage: aMessage [
	^ self provider sendAssistantMessage: aMessage
]

{ #category : #accessing }
GtLlmChat >> sendMessage: aMessage [
	self provider sendMessage: aMessage
]

{ #category : #accessing }
GtLlmChat >> serializer [
	^ serializer
]

{ #category : #accessing }
GtLlmChat >> serializer: anObject [
	serializer := anObject
]

{ #category : #'as yet unclassified' }
GtLlmChat >> signalRunHasStarted [
	self announcer announce: (GtOpenAIThreadRunStartedAnnouncement new run: self)
]

{ #category : #'as yet unclassified' }
GtLlmChat >> signalRunIsDone [
	self announcer announce: (GtOpenAIThreadRunIsDoneAnnouncement new run: self)
]

{ #category : #'as yet unclassified' }
GtLlmChat >> signalRunIsDone: aRun [
	self announcer announce: (GtOpenAIThreadRunIsDoneAnnouncement new run: aRun)
]

{ #category : #'as yet unclassified' }
GtLlmChat >> status [
	self provider ifNil: [ ^ GtLlmAssistantChatNotReadyStatus new ].

	^ self provider status
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
