Trait {
	#name : #TGtLWithMessageViewModel,
	#instVars : [
		'messageViewModel'
	],
	#category : #'Gt4LlmCore-UI - View Models'
}

{ #category : #accessing }
TGtLWithMessageViewModel >> beforeThreadMessageViewModelReset [
]

{ #category : #'gt - extensions' }
TGtLWithMessageViewModel >> gtElementOverviewChatMessageModel [
	<gtInspectorElementOverview>
	^ GtInspectorElementOverviewProperty new
		label: 'Message model';
		object: [ self threadMessage ]
]

{ #category : #'gt - extensions' }
TGtLWithMessageViewModel >> gtElementOverviewChatMessageViewModel [
	<gtInspectorElementOverview>
	^ GtInspectorElementOverviewProperty new
		label: 'Message view model';
		object: [ self threadMessageViewModel ]
]

{ #category : #'gt - extensions' }
TGtLWithMessageViewModel >> gtElementOverviewChatModel [
	<gtInspectorElementOverview>
	^ GtInspectorElementOverviewProperty new
		label: 'Chat model';
		object: [ self threadMessage chat ]
]

{ #category : #'api - message view model' }
TGtLWithMessageViewModel >> message [
	^ messageViewModel message
]

{ #category : #'api - message view model' }
TGtLWithMessageViewModel >> messageViewModel [
	^ messageViewModel
]

{ #category : #'api - message view model' }
TGtLWithMessageViewModel >> messageViewModel: anObject [
	messageViewModel = anObject ifTrue: [ ^ self ].
	messageViewModel ifNotNil: [ :anOldMessage | 
		self beforeThreadMessageViewModelReset.
		self unsubscribeFromMessageViewModel ].
	messageViewModel := anObject.
	self onMessageViewModelChanged.
	self subscribeToMessageViewModel
]

{ #category : #'private - hooks' }
TGtLWithMessageViewModel >> onMessageViewModelChanged [
]

{ #category : #'private - hooks' }
TGtLWithMessageViewModel >> subscribeToMessageViewModel [
]

{ #category : #'api - message view model' }
TGtLWithMessageViewModel >> threadMessage [
	self
		deprecated: 'Please use #message instead.'
		transformWith: '`@receiver threadMessage' -> '`@receiver message'.

	^ self message
]

{ #category : #'api - message view model' }
TGtLWithMessageViewModel >> threadMessageViewModel [
	self
		deprecated: 'Please use #messageViewModel instead.'
		transformWith: '`@receiver threadMessageViewModel' -> '`@receiver messageViewModel'.

	^ self messageViewModel
]

{ #category : #'api - message view model' }
TGtLWithMessageViewModel >> threadMessageViewModel: anObject [
	self
		deprecated: 'Please use messageViewModel: instead.'
		transformWith:
			'`@receiver threadMessageViewModel: `@statements1'
				-> '`@receiver messageViewModel: `@statements1'.
				
	self messageViewModel: anObject
]

{ #category : #'private - hooks' }
TGtLWithMessageViewModel >> unsubscribeFromMessageViewModel [
]
