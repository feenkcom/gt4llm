Class {
	#name : #GtOpenAIOneLineThreadMessageViewModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer + TGtOpenAIWithThreadMessageViewModel',
	#classTraits : 'TGtAnnouncer classTrait + TGtOpenAIWithThreadMessageViewModel classTrait',
	#instVars : [
		'threadMessageViewModel',
		'announcer',
		'contentText',
		'contentString',
		'styler'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #announcer }
GtOpenAIOneLineThreadMessageViewModel >> announcer [
	<return: #Announcer>
	^ threadMessageViewModel announcer
]

{ #category : #accessing }
GtOpenAIOneLineThreadMessageViewModel >> contentText [
	<return: #BlText>
	^ contentText
		ifNil: [ contentString := self threadMessage contentText.
			contentText := (contentString lines ifNotEmpty: #first ifEmpty: [ '' ])
					asRopedText ]
]

{ #category : #'private - updating' }
GtOpenAIOneLineThreadMessageViewModel >> createdAt [
	^ threadMessageViewModel createdAt
]

{ #category : #testing }
GtOpenAIOneLineThreadMessageViewModel >> isFailure [
	^ threadMessageViewModel isFailure
]

{ #category : #'private - hooks' }
GtOpenAIOneLineThreadMessageViewModel >> onThreadMessageViewModelChanged: anAnnouncement [
	contentString = self threadMessage contentText
		ifFalse: [ contentText := nil.
			contentString := nil ]
]

{ #category : #'private - updating' }
GtOpenAIOneLineThreadMessageViewModel >> styler [
	^ styler ifNil: [ styler := BlTextNullStyler new ]
]

{ #category : #'private - hooks' }
GtOpenAIOneLineThreadMessageViewModel >> subscribeToThreadMessageViewModel [
	threadMessageViewModel weak
		when: GtOpenAIThreadMessageViewModelChanged
		send: #onThreadMessageViewModelChanged:
		to: self
]

{ #category : #accessing }
GtOpenAIOneLineThreadMessageViewModel >> threadMessage [
	^ threadMessageViewModel threadMessage
]

{ #category : #'private - hooks' }
GtOpenAIOneLineThreadMessageViewModel >> unsubscribeFromThreadMessageViewModel [
	threadMessageViewModel unsubscribe: self
]
