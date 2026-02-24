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
	registry do: [ :each | self announce: (GtLChatRemovedAnnouncement new chat: each) ].
	registry removeAll
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
	^ aView list
		title: 'Chats';
		priority: 20;
		items: [ self registry ];
		itemText: [ :aChat | aChat ];
		updateWhen: GtLChatAnnouncement in: self announcer
]

{ #category : #initialization }
GtL >> initialize [
	super initialize.
	registry := OrderedCollection new.
	announcer := Announcer new
]

{ #category : #registry }
GtL >> registerChat: aChat [
	registry add: aChat.
	self announce: (GtLChatAddedAnnouncement new chat: aChat).
	^ aChat
]

{ #category : #accessing }
GtL >> registry [
	^ registry
]

{ #category : #registry }
GtL >> removeChat: aChat [
	(registry remove: aChat ifAbsent: [ ^ self ]) ifNotNil: [
		self announce: (GtLChatRemovedAnnouncement new chat: aChat) ]
]
