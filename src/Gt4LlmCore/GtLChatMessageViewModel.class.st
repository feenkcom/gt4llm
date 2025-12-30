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

{ #category : #'api - accessing' }
GtLChatMessageViewModel >> contentText [
	^ self message contentText
]

{ #category : #accessing }
GtLChatMessageViewModel >> createdAt [
	^ self message createdAt
]

{ #category : #accessing }
GtLChatMessageViewModel >> elementClass [
	^ GtLExpandableThreadMessageElement
]

{ #category : #'gt - extensions' }
GtLChatMessageViewModel >> gtToolViewMessagesFor: aView [
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
GtLChatMessageViewModel >> onMessageChanged [
	self isExpanded: self message isAssistantRole.
	super onMessageChanged
]

{ #category : #'api - accessing' }
GtLChatMessageViewModel >> toolArguments [
	^ self threadMessage toolArguments
]

{ #category : #'api - accessing' }
GtLChatMessageViewModel >> toolDescription [
	^ self threadMessage toolDescription
]

{ #category : #'api - accessing' }
GtLChatMessageViewModel >> toolName [
	^ self threadMessage toolName
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
