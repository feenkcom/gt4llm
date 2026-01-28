Class {
	#name : #GtLMessageViewModel,
	#superclass : #GtLBasicMessageViewModel,
	#traits : 'TGtLWithMessage',
	#classTraits : 'TGtLWithMessage classTrait',
	#instVars : [
		'isExpanded',
		'userViewMessage',
		'toolViewMessages'
	],
	#category : 'Gt4LlmCore-UI - View Models'
}

{ #category : #visiting }
GtLMessageViewModel >> acceptVisitor: aVisitor [
	^ aVisitor visitMessageViewModel: self
]

{ #category : #'api - accessing' }
GtLMessageViewModel >> contentText [
	^ self message contentOneLineSummary
]

{ #category : #accessing }
GtLMessageViewModel >> createdAt [
	^ self message createdAt
]

{ #category : #'api - converting' }
GtLMessageViewModel >> elementClass [
	^ GtLExpandableMessageElement
]

{ #category : #'gt - extensions' }
GtLMessageViewModel >> gtToolViewMessagesFor: aView [
	<gtView>
	<gtLlmView>
	self toolViewMessages ifEmpty: [ ^ aView empty ].

	^ aView columnedList
		title: 'Tools';
		items: [ self toolViewMessages ];
		column: 'Tool' text: #toolName;
		column: 'Arguments'
			text: [ :each | 
				String
					streamContents: [ :aStream | 
						each toolArguments
							do: [ :anAssoc | 
								aStream
									nextPutAll: anAssoc key asString;
									nextPut: $:;
									nextPutAll: anAssoc value asString ]
							separatedBy: [ aStream nextPutAll: ', ' ] ] ];
		column: 'Description' text: #toolDescription;
		send: [ :each | each threadMessage ]
]

{ #category : #accessing }
GtLMessageViewModel >> isExpanded [
	^ isExpanded ifNil: [ isExpanded := true ]
]

{ #category : #accessing }
GtLMessageViewModel >> isExpanded: aBoolean [
	isExpanded = aBoolean ifTrue: [ ^ self ].

	isExpanded := aBoolean.
	self notifyExpandedChanged
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
GtLMessageViewModel >> notifyExpandedChanged [
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

{ #category : #'api - accessing' }
GtLMessageViewModel >> toolViewMessages [
	^ toolViewMessages ifNil: [ #() ]
]

{ #category : #'api - initialization' }
GtLMessageViewModel >> toolViewMessages: someMessageViewModels [
	"Set previous tool view messages."

	toolViewMessages := someMessageViewModels
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
