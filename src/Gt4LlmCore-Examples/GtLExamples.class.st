Class {
	#name : #GtLExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Core'
}

{ #category : #examples }
GtLExamples >> chatAnnouncements [
	<gtExample>
	| l chat previous added removed |
	l := GtL current.
	previous := l registry copy.
	added := OrderedCollection new.
	removed := OrderedCollection new.
	l announcer
		when: GtLChatAddedAnnouncement
		do: [ :announcement | added add: announcement chat ];
		when: GtLChatRemovedAnnouncement
		do: [ :announcement | removed add: announcement chat ].
	[
		chat := l gtChat.
		l removeChat: chat.
		self assert: added equals: { chat }.
		self assert: removed equals: { chat }.
		^ chat
	] ensure: [
		l registry removeAll.
		l registry addAll: previous ]
]

{ #category : #examples }
GtLExamples >> current [
	<gtExample>
	| current |
	GtL resetCurrent.
	current := GtL current.
	self assert: current class equals: GtL.
	self assert: current registry isEmpty.
	^ current
]

{ #category : #examples }
GtLExamples >> gtChatRegisters [
	<gtExample>
	| l chat previous |
	l := GtL current.
	previous := l registry copy.
	[
		chat := l gtChat.
		self assert: (l registry includes: chat).
		self assert: l registry size equals: previous size + 1.
		^ chat
	] ensure: [
		l registry removeAll.
		l registry addAll: previous ]
]
