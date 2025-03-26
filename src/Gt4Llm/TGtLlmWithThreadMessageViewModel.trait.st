Trait {
	#name : #TGtLlmWithThreadMessageViewModel,
	#instVars : [
		'threadMessageViewModel'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
TGtLlmWithThreadMessageViewModel >> beforeThreadMessageViewModelReset [
]

{ #category : #'private - hooks' }
TGtLlmWithThreadMessageViewModel >> onThreadMessageViewModelChanged [
]

{ #category : #'private - hooks' }
TGtLlmWithThreadMessageViewModel >> subscribeToThreadMessageViewModel [
]

{ #category : #accessing }
TGtLlmWithThreadMessageViewModel >> threadMessage [
	^ threadMessageViewModel threadMessage
]

{ #category : #accessing }
TGtLlmWithThreadMessageViewModel >> threadMessageViewModel [
	^ threadMessageViewModel
]

{ #category : #accessing }
TGtLlmWithThreadMessageViewModel >> threadMessageViewModel: anObject [
	threadMessageViewModel = anObject ifTrue: [ ^ self ].
	threadMessageViewModel ifNotNil: [ :anOldMessage | 
		self beforeThreadMessageViewModelReset.
		self unsubscribeFromThreadMessageViewModel ].
	threadMessageViewModel := anObject.
	self onThreadMessageViewModelChanged.
	self subscribeToThreadMessageViewModel
]

{ #category : #'private - hooks' }
TGtLlmWithThreadMessageViewModel >> unsubscribeFromThreadMessageViewModel [
]
