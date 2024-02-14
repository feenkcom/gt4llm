Trait {
	#name : #TGtOpenAIWithThreadMessage,
	#instVars : [
		'threadMessage'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #'private - hooks' }
TGtOpenAIWithThreadMessage >> onThreadMessageChanged [
	
]

{ #category : #'private - hooks' }
TGtOpenAIWithThreadMessage >> subscribeToThreadMessage [
]

{ #category : #accessing }
TGtOpenAIWithThreadMessage >> threadMessage [
	^ threadMessage
]

{ #category : #accessing }
TGtOpenAIWithThreadMessage >> threadMessage: aMessage [
	threadMessage = aMessage ifTrue: [ ^ self ].
	threadMessage ifNotNil: [ :anOldMessage | 
		self unsubscribeFromThreadMessage ].
	threadMessage := aMessage.
	self onThreadMessageChanged.
	self subscribeToThreadMessage
]

{ #category : #'private - hooks' }
TGtOpenAIWithThreadMessage >> unsubscribeFromThreadMessage [
]
