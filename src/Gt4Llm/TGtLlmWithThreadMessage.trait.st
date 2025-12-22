Trait {
	#name : #TGtLlmWithThreadMessage,
	#instVars : [
		'threadMessage'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
TGtLlmWithThreadMessage >> hasThreadMessage [
	^ threadMessage isNotNil
]

{ #category : #'private - hooks' }
TGtLlmWithThreadMessage >> onThreadMessageChanged [
	
]

{ #category : #'private - hooks' }
TGtLlmWithThreadMessage >> subscribeToThreadMessage [
]

{ #category : #accessing }
TGtLlmWithThreadMessage >> threadMessage [
	^ threadMessage
]

{ #category : #accessing }
TGtLlmWithThreadMessage >> threadMessage: aMessage [
	threadMessage = aMessage ifTrue: [ ^ self ].
	threadMessage ifNotNil: [ :anOldMessage | 
		self unsubscribeFromThreadMessage ].
	threadMessage := aMessage.
	self onThreadMessageChanged.
	self subscribeToThreadMessage
]

{ #category : #'private - hooks' }
TGtLlmWithThreadMessage >> unsubscribeFromThreadMessage [
]
