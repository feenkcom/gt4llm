Trait {
	#name : #TGtLWithChatMessageViewModel,
	#instVars : [
		'threadMessageViewModel'
	],
	#category : #'Gt4LlmCore-UI'
}

{ #category : #accessing }
TGtLWithChatMessageViewModel >> beforeThreadMessageViewModelReset [
]

{ #category : #'gt - extensions' }
TGtLWithChatMessageViewModel >> gtElementOverviewChatMessageModel [
	<gtInspectorElementOverview>
	^ GtInspectorElementOverviewProperty new
		label: 'Message model';
		object: [ self threadMessage ]
]

{ #category : #'gt - extensions' }
TGtLWithChatMessageViewModel >> gtElementOverviewChatMessageViewModel [
	<gtInspectorElementOverview>
	^ GtInspectorElementOverviewProperty new
		label: 'Message view model';
		object: [ self threadMessageViewModel ]
]

{ #category : #'gt - extensions' }
TGtLWithChatMessageViewModel >> gtElementOverviewChatModel [
	<gtInspectorElementOverview>
	^ GtInspectorElementOverviewProperty new
		label: 'Chat model';
		object: [ self threadMessage chat ]
]

{ #category : #'private - hooks' }
TGtLWithChatMessageViewModel >> onThreadMessageViewModelChanged [
]

{ #category : #'private - hooks' }
TGtLWithChatMessageViewModel >> subscribeToThreadMessageViewModel [
]

{ #category : #'api - message view model' }
TGtLWithChatMessageViewModel >> threadMessage [
	^ threadMessageViewModel threadMessage
]

{ #category : #'api - message view model' }
TGtLWithChatMessageViewModel >> threadMessageViewModel [
	^ threadMessageViewModel
]

{ #category : #'api - message view model' }
TGtLWithChatMessageViewModel >> threadMessageViewModel: anObject [
	threadMessageViewModel = anObject ifTrue: [ ^ self ].
	threadMessageViewModel ifNotNil: [ :anOldMessage | 
		self beforeThreadMessageViewModelReset.
		self unsubscribeFromThreadMessageViewModel ].
	threadMessageViewModel := anObject.
	self onThreadMessageViewModelChanged.
	self subscribeToThreadMessageViewModel
]

{ #category : #'private - hooks' }
TGtLWithChatMessageViewModel >> unsubscribeFromThreadMessageViewModel [
]
