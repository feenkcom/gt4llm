Class {
	#name : #GtLChatStateLabelElement,
	#superclass : #GtLChatBasicElement,
	#instVars : [
		'labelElement'
	],
	#category : #'Gt4LlmCore-UI - Elements'
}

{ #category : #initialization }
GtLChatStateLabelElement >> defaultLayout [
	^ BlFrameLayout new
]

{ #category : #initialization }
GtLChatStateLabelElement >> initialize [
	super initialize.

	self initializeLabelElement.

	self addChild: labelElement.

	self fitContent
]

{ #category : #initialization }
GtLChatStateLabelElement >> initializeLabelElement [
	labelElement := BrLabel new
			aptitude: BrGlamorousLabelAptitude;
			text: GtLProviderState idle label
]

{ #category : #'private - hooks' }
GtLChatStateLabelElement >> onChatExecutionStateChanged: anAnnouncement [
	anAnnouncement chat = self chat ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'private - hooks' }
GtLChatStateLabelElement >> onChatViewModelChanged [
	super onChatViewModelChanged.

	self updateElement
]

{ #category : #'private - hooks' }
GtLChatStateLabelElement >> subscribeToChatViewModel [
	super subscribeToChatViewModel.

	self chat weak
		when: GtLChatExecutionStateChanged
		send: #onChatExecutionStateChanged:
		to: self
]

{ #category : #'private - hooks' }
GtLChatStateLabelElement >> unsubscribeFromChatViewModel [
	super unsubscribeFromChatViewModel.
	self chatViewModel announcer unsubscribe: self.
	self chat announcer unsubscribe: self
]

{ #category : #'private - updating' }
GtLChatStateLabelElement >> updateElement [
	labelElement text: self chat state label
]
