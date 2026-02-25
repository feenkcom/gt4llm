Class {
	#name : #GtL,
	#superclass : #Object,
	#instVars : [
		'registry',
		'announcer'
	],
	#classVars : [
		'Current'
	],
	#category : #'Gt4LlmCore-Coree'
}

{ #category : #'instance creation' }
GtL class >> current [
	Current ifNil: [ Current := self new ].
	^ Current
]

{ #category : #'instance creation' }
GtL class >> gt [
	^ self current gtChat
]

{ #category : #'instance creation' }
GtL class >> gtChat [
	^ self current gtChat
]

{ #category : #'instance creation' }
GtL class >> resetCurrent [
	Current := nil
]

{ #category : #announcing }
GtL >> announce: anAnnouncement [
	^ self announcer announce: anAnnouncement
]

{ #category : #accessing }
GtL >> announcer [
	^ announcer
]

{ #category : #registry }
GtL >> clearChats [
	| chats |
	chats := registry copy.
	chats do: [ :each | each announcer unsubscribe: self ].
	registry removeAll.
	chats do: [ :each | self announce: (GtLChatRemovedAnnouncement new chat: each) ]
]

{ #category : #'instance creation' }
GtL >> gtChat [
	| chat |
	chat := GtLChat new
		tools: GtLTools gt;
		markdownResponse;
		gtPageExplanation: 'Examples by example';
		gtPageExplanation: 'Inspector phlow views by example'.
	^ self registerChat: chat
]

{ #category : #'gt-view' }
GtL >> gtViewChatsOn: aView [
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
			text: [ :aChat | aChat messages isEmpty  or: [ aChat isFinishedSuccesss ] ];
		updateWhen: GtLChatAnnouncement in: self announcer;
		updateWhen: GtLChatMessagesChanged in: self announcer
]

{ #category : #initialization }
GtL >> initialize [
	super initialize.
	registry := OrderedCollection new.
	announcer := Announcer new
]

{ #category : #announcing }
GtL >> onChatMessagesChanged: anAnnouncement [
	self announce: anAnnouncement
]

{ #category : #registry }
GtL >> registerChat: aChat [
	registry add: aChat.
	aChat announcer
		when: GtLChatMessagesChanged
		send: #onChatMessagesChanged:
		to: self.
	self announce: (GtLChatAddedAnnouncement new chat: aChat).
	^ aChat
]

{ #category : #accessing }
GtL >> registry [
	^ registry
]

{ #category : #registry }
GtL >> removeChat: aChat [
	(aChat announcer hasSubscriber: self) ifTrue: [ aChat announcer unsubscribe: self ].
	(registry remove: aChat ifAbsent: [ ^ self ]) ifNotNil: [
		self announce: (GtLChatRemovedAnnouncement new chat: aChat) ]
]
