Class {
	#name : #GtLChatRegistryExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLChatRegistryExamples >> chatAnnouncements [
	<gtExample>
	| registry chat added removed |
	registry := GtLChatRegistry new.
	added := OrderedCollection new.
	removed := OrderedCollection new.
	registry announcer
		when: GtLChatAddedAnnouncement
			do: [ :announcement | added add: announcement chat ]
			for: self;
		when: GtLChatRemovedAnnouncement
			do: [ :announcement | removed add: announcement chat ]
			for: self.
	chat := registry newChat.
	self assert: added asArray equals: {chat}.
	registry removeChat: chat.
	self assert: removed asArray equals: {chat}.
	^ chat
]

{ #category : #examples }
GtLChatRegistryExamples >> gtChatRegisters [
	<gtExample>
	| registry chat previous |
	registry := GtLChatRegistry new.
	previous := registry registry copy.
	chat := registry newGtChat.
	self assert: (registry registry includes: chat).
	self assert: registry registry size equals: previous size + 1.
	^ chat
]
