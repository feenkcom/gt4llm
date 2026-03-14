Trait {
	#name : #TGtLWithMessage,
	#instVars : [
		'message'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #accessing }
TGtLWithMessage >> hasMessage [
	^ message isNotNil
]

{ #category : #'api - message model' }
TGtLWithMessage >> id [
	^ self message id
]

{ #category : #'api - message model' }
TGtLWithMessage >> message [
	^ message
]

{ #category : #'api - message model' }
TGtLWithMessage >> message: aMessage [
	message = aMessage ifTrue: [ ^ self ].
	message ifNotNil: [ :anOldMessage | 
		self unsubscribeFromMessage ].
	message := aMessage.
	self onMessageChanged.
	self subscribeToMessage
]

{ #category : #'private - hooks' }
TGtLWithMessage >> onMessageChanged [
	
]

{ #category : #'private - hooks' }
TGtLWithMessage >> subscribeToMessage [
]

{ #category : #accessing }
TGtLWithMessage >> threadMessage [
	self
		deprecated: 'Please use #message instead.'
		transformWith: '`@receiver threadMessage' -> '`@receiver message'.
	^ self message
]

{ #category : #accessing }
TGtLWithMessage >> threadMessage: aMessage [
	self
		deprecated: 'Please use message: instead.'
		transformWith: '`@receiver threadMessage: `@statements1' -> '`@receiver message: `@statements1'.

	self message: aMessage
]

{ #category : #'private - hooks' }
TGtLWithMessage >> unsubscribeFromMessage [
]
