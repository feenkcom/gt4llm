Class {
	#name : #GtLlmCoderChatButton,
	#superclass : #BrButton,
	#instVars : [
		'chat',
		'oldAptitude'
	],
	#category : #'Gt4OpenAI-GToolkit'
}

{ #category : #accessing }
GtLlmCoderChatButton >> chat [
	^ chat
]

{ #category : #accessing }
GtLlmCoderChatButton >> chat: anObject [
	chat := anObject.
	self onChatSet
]

{ #category : #accessing }
GtLlmCoderChatButton >> llmFinished [
	self
		label: ''
]

{ #category : #accessing }
GtLlmCoderChatButton >> llmStarted [
	self label: 'LLM is working'
]

{ #category : #accessing }
GtLlmCoderChatButton >> onChatSet [
	self
		aptitude: BrGlamorousButtonWithIconAndLabelAptitude;
		addAptitude: (BrGlamorousWithExplicitTooltipAptitude text: 'Open chat');
		icon: BrGlamorousVectorIcons chat;
		beTinySize;
		action: [ self phlow spawnObject: chat ].

	chat
		when: GtLlmThreadRunStartedAnnouncement
		send: #llmStarted
		to: self.
	chat
		when: GtLlmThreadRunIsDoneAnnouncement
		send: #llmFinished
		to: self.

	chat status isDone ifTrue: [ self llmFinished ] ifFalse: [ self llmStarted ]
]
