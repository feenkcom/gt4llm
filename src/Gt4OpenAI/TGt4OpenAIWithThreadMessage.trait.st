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

{ #category : #accessing }
TGt4OpenAIWithThreadMessage >> threadMessage [
	^ threadMessage
]

{ #category : #accessing }
TGt4OpenAIWithThreadMessage >> threadMessage: aMessage [
	threadMessage = aMessage ifTrue: [ ^ self ].
	threadMessage := aMessage.
	self onThreadMessageChanged
]
