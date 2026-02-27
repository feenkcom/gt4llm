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
	#category : #Gt4LlmCore
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

{ #category : #accessing }
GtLChatRegistry >> chats [
	^ chats
]

{ #category : #accessing }
GtLChatRegistry >> clearChats [
	| chatsCopy |
	chatsCopy := chats copy.
	chatsCopy do: [ :each | each announcer unsubscribe: self ].
	chats removeAll.
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
					ifEmpty: [ '-' ] ];
		column: 'Finished'
			text: [ :aChat | aChat messages isEmpty or: [ aChat isFinishedSuccesss ] ];
		contextItemLabel: 'Inspect chat'
			action: [ :anElement :aChat | anElement phlow spawnObject: aChat ];
		contextItemLabel: 'Remove chat'
			action: [ :anElement :aChat | self removeChat: aChat ];
		updateWhen: GtLChatAnnouncement in: self announcer
]

{ #category : #initialization }
GtLChatRegistry >> initialize [
	super initialize.
	chats := OrderedCollection new.
	announcer := Announcer new
]

{ #category : #accessing }
GtLChatRegistry >> lastChat [
	^ chats last
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
		tools: GtLTools gt, {GtLToolForSmalltalkCodeEvaluation new};
		markdownResponse;
		gtPageExplanation: 'Examples by example';
		gtPageExplanation: 'Inspector phlow views by example'.
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
	chats add: aChat.
	aChat announcer
		when: GtLChatMessagesChanged
		send: #onChatMessagesChanged:
		to: self.
	self announce: (GtLChatAddedAnnouncement new chat: aChat).
	^ aChat
]

{ #category : #accessing }
GtLChatRegistry >> registry [
	^ chats
]

{ #category : #accessing }
GtLChatRegistry >> removeChat: aChat [
	(aChat announcer hasSubscriber: self) ifTrue: [ aChat announcer unsubscribe: self ].
	(chats remove: aChat ifAbsent: [ ^ self ]) ifNotNil: [
		self announce: (GtLChatRemovedAnnouncement new chat: aChat) ]
]
