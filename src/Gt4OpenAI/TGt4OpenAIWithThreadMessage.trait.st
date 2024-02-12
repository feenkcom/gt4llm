Trait {
	#name : #TGt4OpenAIWithThreadMessage,
	#instVars : [
		'threadMessage'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #'private - hooks' }
TGt4OpenAIWithThreadMessage >> onThreadMessageChanged [
	
]

{ #category : #'private - hooks' }
TGt4OpenAIWithThreadMessage >> subscribeToThreadMessage [
]

{ #category : #accessing }
TGt4OpenAIWithThreadMessage >> threadMessage [
	^ threadMessage
]

{ #category : #accessing }
TGt4OpenAIWithThreadMessage >> threadMessage: aMessage [
	threadMessage = aMessage ifTrue: [ ^ self ].
	threadMessage ifNotNil: [ :anOldMessage | 
		self unsubscribeFromThreadMessage ].
	threadMessage := aMessage.
	self onThreadMessageChanged.
	self subscribeToThreadMessage
]

{ #category : #'private - hooks' }
TGt4OpenAIWithThreadMessage >> unsubscribeFromThreadMessage [
]
