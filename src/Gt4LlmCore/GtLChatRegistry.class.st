Class {
	#name : #GtLChatRegistry,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'chats'
	],
	#classVars : [
		'Current'
	],
	#category : #'Gt4LlmCore-Registry - Model'
}

{ #category : #'instance creation' }
GtLChatRegistry class >> current [
	Current ifNil: [ Current := self new ].
	^ Current
]

{ #category : #'instance creation' }
GtLChatRegistry class >> resetCurrent [
	Current := nil
]

{ #category : #accessing }
GtLChatRegistry >> announce: anAnnouncement [
	^ self announcer announce: anAnnouncement
]

{ #category : #accessing }
GtLChatRegistry >> announcer [
	^ announcer
]

{ #category : #'api - converting' }
GtLChatRegistry >> asViewModel [
	^ GtLChatRegistryViewModel new registry: self
]

{ #category : #accessing }
GtLChatRegistry >> chats [
	^ chats value
]

{ #category : #accessing }
GtLChatRegistry >> chatsStream [
	^ GtLAsyncChatStream forChatRegistry: self
]

{ #category : #accessing }
GtLChatRegistry >> clearChats [
	| chatsCopy |
	chats lock: [ :theChats | 
		chatsCopy := theChats copy.
		chatsCopy do: [ :each | each announcer unsubscribe: self ].
		theChats removeAll ].
	chatsCopy do: [ :each | self announce: (GtLChatRemovedAnnouncement new chat: each) ]
]

{ #category : #accessing }
GtLChatRegistry >> gtViewChatsOn: aView [
	<gtView>
	^ aView columnedList
		title: 'Chats';
		priority: 20;
		items: [ self chats ];
		column: 'Chat' text: [ :aChat | aChat ];
		column: 'Started'
			text: [ :aChat | 
				aChat messages
					ifNotEmpty: [ :messages | messages first createdAt asLocalStringYMDHMS ]
					ifEmpty: [ '-' ] ]
			width: 130;
		column: 'Finished'
			text: [ :aChat | aChat messages isEmpty or: [ aChat isFinishedSuccesss ] ]
			width: 100;
		dynamicContextItems: [ :anElement :aChat | 
			GtLChatRegistryActionTarget
				menuItemsForObject: aChat
				inContext: (GtPhlowContext new
						at: #chatRegistry put: self;
						yourself)
				hostElement: anElement ];
		updateWhen: GtLChatAnnouncement in: self announcer
]

{ #category : #'as yet unclassified' }
GtLChatRegistry >> hasChats [
	^ chats lock: [ :theChat | theChat notEmpty ]
]

{ #category : #initialization }
GtLChatRegistry >> initialize [
	super initialize.
	chats := AsyncMutex for: OrderedCollection new.
	announcer := Announcer new
]

{ #category : #accessing }
GtLChatRegistry >> lastChat [
	^ chats lock: [ :theChat | theChat last ]
]

{ #category : #convenience }
GtLChatRegistry >> newChat [
	| chat |
	chat := GtLChat new.
	self registerChat: chat.
	^ chat
]

{ #category : #accessing }
GtLChatRegistry >> newGtChat [
	| chat |
	chat := GtLChat new
		tools: GtLTools gt;
		markdownResponse;
		gtPageExplanation: 'Rules for Moldable Development for Glamorous Toolkit';
		gtPageExplanation: 'Examples by example'";
		gtPageExplanation: 'Inspector phlow views by example'".
	^ self registerChat: chat
]

{ #category : #accessing }
GtLChatRegistry >> newGtDevelopmentChat [ 
	^ self newGtChat
		gtPageExplanation: 'Chat for the development of Glamorous Toolkit itself'
]

{ #category : #accessing }
GtLChatRegistry >> onChatMessagesChanged: anAnnouncement [
	self announce: anAnnouncement
]

{ #category : #accessing }
GtLChatRegistry >> registerChat: aChat [
	aChat announcer
		when: GtLChatMessagesChanged
		send: #onChatMessagesChanged:
		to: self.
	chats lock: [ :theChats | theChats add: aChat ].
	self
		announce: (GtLChatAddedAnnouncement new
				registry: self;
				chat: aChat).
	^ aChat
]

{ #category : #accessing }
GtLChatRegistry >> registry [
	^ self chats
]

{ #category : #accessing }
GtLChatRegistry >> removeChat: aChat [
	| removedChat |
	(aChat announcer hasSubscriber: self)
		ifTrue: [ aChat announcer unsubscribe: self ].
	chats
		lock: [ :theChat | removedChat := theChat remove: aChat ifAbsent: [ nil ] ].
	removedChat
		ifNotNil: [ self
				announce: (GtLChatRemovedAnnouncement new
						registry: self;
						chat: aChat) ]
]
