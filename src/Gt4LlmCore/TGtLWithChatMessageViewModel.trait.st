Trait {
	#name : #TGtLWithChatMessageViewModel,
	#instVars : [
		'messageViewModel'
	],
	#category : #'Gt4LlmCore-UI - View Models'
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

{ #category : #'api - message view model' }
TGtLWithChatMessageViewModel >> message [
	^ messageViewModel message
]

{ #category : #'api - message view model' }
TGtLWithChatMessageViewModel >> messageViewModel [
	^ messageViewModel
]

{ #category : #'api - message view model' }
TGtLWithChatMessageViewModel >> messageViewModel: anObject [
	messageViewModel = anObject ifTrue: [ ^ self ].
	messageViewModel ifNotNil: [ :anOldMessage | 
		self beforeThreadMessageViewModelReset.
		self unsubscribeFromMessageViewModel ].
	messageViewModel := anObject.
	self onMessageViewModelChanged.
	self subscribeToMessageViewModel
]

{ #category : #'private - hooks' }
TGtLWithChatMessageViewModel >> onMessageViewModelChanged [
]

{ #category : #'private - hooks' }
TGtLWithChatMessageViewModel >> subscribeToMessageViewModel [
]

{ #category : #'api - message view model' }
TGtLWithChatMessageViewModel >> threadMessage [
	self
		deprecated: 'Please use #message instead.'
		transformWith: '`@receiver threadMessage' -> '`@receiver message'.

	^ self message
]

{ #category : #'api - message view model' }
TGtLWithChatMessageViewModel >> threadMessageViewModel [
	self
		deprecated: 'Please use #messageViewModel instead.'
		transformWith: '`@receiver threadMessageViewModel' -> '`@receiver messageViewModel'.

	^ self messageViewModel
]

{ #category : #'api - message view model' }
TGtLWithChatMessageViewModel >> threadMessageViewModel: anObject [
	self
		deprecated: 'Please use messageViewModel: instead.'
		transformWith:
			'`@receiver threadMessageViewModel: `@statements1'
				-> '`@receiver messageViewModel: `@statements1'.
				
	self messageViewModel: anObject
]

{ #category : #'private - hooks' }
TGtLWithChatMessageViewModel >> unsubscribeFromMessageViewModel [
]
