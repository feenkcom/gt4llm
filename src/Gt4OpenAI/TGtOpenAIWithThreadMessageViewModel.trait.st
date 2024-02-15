Trait {
	#name : #TGtOpenAIWithThreadMessageViewModel,
	#instVars : [
		'threadMessageViewModel'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #'private - hooks' }
TGtOpenAIWithThreadMessageViewModel >> onThreadMessageViewModelChanged [
]

{ #category : #'private - hooks' }
TGtOpenAIWithThreadMessageViewModel >> subscribeToThreadMessageViewModel [
]

{ #category : #accessing }
TGtOpenAIWithThreadMessageViewModel >> threadMessage [
	^ threadMessageViewModel threadMessage
]

{ #category : #accessing }
TGtOpenAIWithThreadMessageViewModel >> threadMessageViewModel [
	^ threadMessageViewModel
]

{ #category : #accessing }
TGtOpenAIWithThreadMessageViewModel >> threadMessageViewModel: anObject [
	threadMessageViewModel = anObject ifTrue: [ ^ self ].
	threadMessageViewModel ifNotNil: [ :anOldMessage | 
		self unsubscribeFromThreadMessageViewModel ].
	threadMessageViewModel := anObject.
	self onThreadMessageViewModelChanged.
	self subscribeToThreadMessageViewModel
]

{ #category : #'private - hooks' }
TGtOpenAIWithThreadMessageViewModel >> unsubscribeFromThreadMessageViewModel [
]
