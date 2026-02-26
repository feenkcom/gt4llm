Class {
	#name : #GtLChatRegistry,
	#superclass : #Object,
	#instVars : [
		'registry',
		'announcer'
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
GtLChatRegistry >> chat [
	| chat |
	chat := GtLChat new.
	self registerChat: chat.
	^ chat
]

{ #category : #accessing }
GtLChatRegistry >> clearChats [
	| chats |
	chats := registry copy.
	chats do: [ :each | each announcer unsubscribe: self ].
	registry removeAll.
	chats do: [ :each | self announce: (GtLChatRemovedAnnouncement new chat: each) ]
]

{ #category : #accessing }
GtLChatRegistry >> gtChat [
	| chat |
	chat := GtLChat new
		tools: GtLTools gt, {GtLToolForSmalltalkCodeEvaluation new};
		markdownResponse;
		gtPageExplanation: 'Examples by example';
		gtPageExplanation: 'Inspector phlow views by example'.
	^ self registerChat: chat
]

{ #category : #accessing }
GtLChatRegistry >> gtViewChatsOn: aView [
	<gtView>
	^ aView columnedList
		title: 'Chats';
		priority: 20;
		items: [ self registry ];
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
		updateWhen: GtLChatAnnouncement in: self announcer;
		updateWhen: GtLChatMessagesChanged in: self announcer
]

{ #category : #initialization }
GtLChatRegistry >> initialize [
	super initialize.
	registry := OrderedCollection new.
	announcer := Announcer new
]

{ #category : #accessing }
GtLChatRegistry >> lastChat [
	^ registry last
]

{ #category : #accessing }
GtLChatRegistry >> onChatMessagesChanged: anAnnouncement [
	self announce: anAnnouncement
]

{ #category : #accessing }
GtLChatRegistry >> registerChat: aChat [
	registry add: aChat.
	aChat announcer
		when: GtLChatMessagesChanged
		send: #onChatMessagesChanged:
		to: self.
	self announce: (GtLChatAddedAnnouncement new chat: aChat).
	^ aChat
]

{ #category : #accessing }
GtLChatRegistry >> registry [
	^ registry
]

{ #category : #accessing }
GtLChatRegistry >> removeChat: aChat [
	(aChat announcer hasSubscriber: self) ifTrue: [ aChat announcer unsubscribe: self ].
	(registry remove: aChat ifAbsent: [ ^ self ]) ifNotNil: [
		self announce: (GtLChatRemovedAnnouncement new chat: aChat) ]
]
