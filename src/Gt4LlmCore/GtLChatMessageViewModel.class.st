Class {
	#name : #GtLChatMessageViewModel,
	#superclass : #GtLBasicThreadMessageViewModel,
	#instVars : [
		'isExpanded',
		'userViewMessage',
		'toolViewMessages'
	],
	#category : #'Gt4LlmCore-UI'
}

{ #category : #'as yet unclassified' }
GtLChatMessageViewModel >> contentText [
	^ self threadMessage contentText
]

{ #category : #accessing }
GtLChatMessageViewModel >> createdAt [
	^ self threadMessage createdAt
]

{ #category : #accessing }
GtLChatMessageViewModel >> elementClass [
	^ GtLExpandableThreadMessageElement
]

{ #category : #accessing }
GtLChatMessageViewModel >> isExpanded [
	^ isExpanded ifNil: [ true ]
]

{ #category : #accessing }
GtLChatMessageViewModel >> isExpanded: aBoolean [
	isExpanded := aBoolean
]

{ #category : #testing }
GtLChatMessageViewModel >> isFailure [
	^ threadMessage isFailure
]

{ #category : #'private - hooks' }
GtLChatMessageViewModel >> onThreadMessageChanged [
	self isExpanded: self threadMessage isAssistantRole.
	super onThreadMessageChanged
]

{ #category : #'api - accessing' }
GtLChatMessageViewModel >> toolViewMessages [
	^ toolViewMessages ifNil: [ #() ]
]

{ #category : #'api - initialization' }
GtLChatMessageViewModel >> toolViewMessages: someMessageViewModels [
	"Set previous tool view messages."

	toolViewMessages := someMessageViewModels
]

{ #category : #'api - accessing' }
GtLChatMessageViewModel >> userViewMessage [
	^ userViewMessage
]

{ #category : #'api - initialization' }
GtLChatMessageViewModel >> userViewMessage: aMessageViewModel [
	"Set previous user view message."

	userViewMessage := aMessageViewModel
]
