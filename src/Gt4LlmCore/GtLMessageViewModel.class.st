Class {
	#name : #GtLMessageViewModel,
	#superclass : #GtLBasicMessageViewModel,
	#traits : 'TGtLWithMessage',
	#classTraits : 'TGtLWithMessage classTrait',
	#instVars : [
		'isExpanded',
		'userViewMessage'
	],
	#classInstVars : [
		'defaultElementClass'
	],
	#category : 'Gt4LlmCore-UI - View Models'
}

{ #category : #settings }
GtLMessageViewModel class >> elementClass [
	"This is a temporary solution. 
	We will remove it as soon as we finish the new message element."

	^ defaultElementClass
]

{ #category : #settings }
GtLMessageViewModel class >> elementClass: anElementClass [
	"This is a temporary solution. 
	We will remove it as soon as we finish the new message element."

	defaultElementClass := anElementClass
]

{ #category : #visiting }
GtLMessageViewModel >> acceptVisitor: aVisitor [
	^ aVisitor visitMessageViewModel: self
]

{ #category : #'api - accessing' }
GtLMessageViewModel >> contentOneLineMultiLabelSummaryWith: aBuilder [
	^ self message contentOneLineMultiLabelSummaryWith: aBuilder
]

{ #category : #'api - accessing' }
GtLMessageViewModel >> contentOneLineSummary [
	<return: #String>
	^ self message contentOneLineSummary
]

{ #category : #'api - accessing' }
GtLMessageViewModel >> contentText [
	^ self message contentOneLineSummary
]

{ #category : #accessing }
GtLMessageViewModel >> createdAt [
	^ self message createdAt
]

{ #category : #accessing }
GtLMessageViewModel >> dateString [
	^ self message dateString
]

{ #category : #'api - converting' }
GtLMessageViewModel >> defaultElementClass [
	^ GtLUserMessageContentElement
]

{ #category : #'api - converting' }
GtLMessageViewModel >> elementClass [
	^ self class elementClass ifNil: [ self defaultElementClass ]
]

{ #category : #'api - message model' }
GtLMessageViewModel >> isExecutionStateFinished [
	^ self message
		ifNotNil: [ :aMessage | aMessage isExecutionStateFinished ]
		ifNil: [ false ]
]

{ #category : #accessing }
GtLMessageViewModel >> isExpanded [
	^ isExpanded ifNil: [ isExpanded := true ]
]

{ #category : #accessing }
GtLMessageViewModel >> isExpanded: aBoolean [
	self isExpanded: aBoolean source: nil
]

{ #category : #accessing }
GtLMessageViewModel >> isExpanded: aBoolean source: aSource [
	isExpanded = aBoolean ifTrue: [ ^ self ].

	isExpanded := aBoolean.
	self notifyExpandedChangedSource: aSource
]

{ #category : #testing }
GtLMessageViewModel >> isFailure [
	^ self message isFailure
]

{ #category : #'api - message model' }
GtLMessageViewModel >> messageExecutionStateLabel [
	^ self message
		ifNotNil: [ :aMessage | aMessage messageExecutionStateLabel ]
		ifNil: [ '' ]
]

{ #category : #'private - notifying' }
GtLMessageViewModel >> notifyExpandedChangedSource: aSource [
	self announcer
		announce: (GtLMessageViewModelExpansionChanged new
				messageViewModel: self;
				isExpanded: self isExpanded)
]

{ #category : #'private - hooks' }
GtLMessageViewModel >> onMessageChanged [
	self isExpanded: self message isAssistantRole.
	super onMessageChanged
]

{ #category : #'private - event handling' }
GtLMessageViewModel >> onMessageContentsChanged: anAnnouncement [
	self announcer
		announce: (GtLMessageViewModelContentsChanged new messageViewModel: self)
]

{ #category : #'private - event handling' }
GtLMessageViewModel >> onMessageExecutionStateChanged: anAnnouncement [
	self message = anAnnouncement message ifFalse: [ ^ self ].

	self announcer
		announce: (GtLMessageViewModelExecutionStateChanged new
				messageViewModel: self;
				executionState: anAnnouncement executionState)
]

{ #category : #'private - hooks' }
GtLMessageViewModel >> subscribeToMessage [
	self message
		when: GtLMessageContentsChanged
			send: #onMessageContentsChanged:
			to: self;
		when: GtLMessageExecutionStateChanged
			send: #onMessageExecutionStateChanged:
			to: self
]

{ #category : #'api - accessing' }
GtLMessageViewModel >> toolArguments [
	^ self message toolArguments
]

{ #category : #'api - accessing' }
GtLMessageViewModel >> toolDescription [
	^ self message toolDescription
]

{ #category : #'api - accessing' }
GtLMessageViewModel >> toolName [
	^ self message toolName
]

{ #category : #'private - hooks' }
GtLMessageViewModel >> unsubscribeFromMessage [
	self message unsubscribe: self
]

{ #category : #'api - accessing' }
GtLMessageViewModel >> userViewMessage [
	^ userViewMessage
]

{ #category : #'api - initialization' }
GtLMessageViewModel >> userViewMessage: aMessageViewModel [
	"Set previous user view message."

	userViewMessage := aMessageViewModel
]
