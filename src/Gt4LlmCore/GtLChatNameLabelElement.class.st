Class {
	#name : #GtLChatNameLabelElement,
	#superclass : #GtLChatBasicElement,
	#instVars : [
		'labelElement'
	],
	#category : 'Gt4LlmCore-UI - Elements'
}

{ #category : #initialization }
GtLChatNameLabelElement >> defaultLayout [
	^ BlFrameLayout new
]

{ #category : #initialization }
GtLChatNameLabelElement >> initialize [
	super initialize.

	self initializeLabelElement.

	self addChild: labelElement.

	self
		hFitContentLimited;
		vFitContent
]

{ #category : #initialization }
GtLChatNameLabelElement >> initializeLabelElement [
	labelElement := BrLabel new
			hFitContentLimited;
			vFitContent;
			aptitude: BrGlamorousShrinkingLabelAptitude new labelMeasurement;
			text: GtLProviderState idle label
]

{ #category : #'private - hooks' }
GtLChatNameLabelElement >> onChatExecutionStateChanged: anAnnouncement [
	anAnnouncement chat = self chat ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'private - hooks' }
GtLChatNameLabelElement >> onChatViewModelChanged [
	super onChatViewModelChanged.

	self updateElement
]

{ #category : #'private - hooks' }
GtLChatNameLabelElement >> onChatViewModelMessageAdded: anAnnouncement [
	anAnnouncement chatViewModel = self chatViewModel ifFalse: [ ^ self ].
	
	"We just need to update once."
	self unsubscribeFromChatViewModel.
	
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'private - hooks' }
GtLChatNameLabelElement >> subscribeToChatViewModel [
	super subscribeToChatViewModel.
	
	"We just need to subscribe in case it is a new chat."
	self chat messages ifNotEmpty: [ ^ self ].

	self chatViewModel announcer weak
		when: GtLChatViewModelMessageAdded
		send: #onChatViewModelMessageAdded:
		to: self
]

{ #category : #'private - hooks' }
GtLChatNameLabelElement >> unsubscribeFromChatViewModel [
	super unsubscribeFromChatViewModel.
	self chatViewModel announcer unsubscribe: self
]

{ #category : #'private - updating' }
GtLChatNameLabelElement >> updateElement [
	self chatViewModel firstMessageViewModel
		ifNotNil: [ :aMessageViewModel | labelElement text: aMessageViewModel message gtDisplayString ]
		ifNil: [ labelElement text: 'New chat' ]
]
