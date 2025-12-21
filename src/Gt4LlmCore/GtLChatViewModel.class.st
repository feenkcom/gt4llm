Class {
	#name : #GtLChatViewModel,
	#superclass : #Object,
	#instVars : [
		'newThreadMessageViewModel',
		'threadMessageViewModelsCache',
		'chat'
	],
	#category : #'Gt4LlmCore-UI'
}

{ #category : #accessing }
GtLChatViewModel >> assistantChat [
	<return: #GtLChat>
	^ chat
]

{ #category : #accessing }
GtLChatViewModel >> assistantChat: anObject [
	chat = anObject ifTrue: [ ^ self ].
	chat ifNotNil: [ self unsubscribeFromAssistantChat ].
	chat := anObject.
	self onAssistantChatChanged.
	self subscribeToAssistantChat.
]

{ #category : #'as yet unclassified' }
GtLChatViewModel >> beSync [
	newThreadMessageViewModel beSync
]

{ #category : #initialization }
GtLChatViewModel >> initialize [
	super initialize.
	threadMessageViewModelsCache := Dictionary new.
	newThreadMessageViewModel := GtLNewThreadMessage new asViewModel
]

{ #category : #accessing }
GtLChatViewModel >> newThreadMessageViewModel [
	^ newThreadMessageViewModel
]

{ #category : #accessing }
GtLChatViewModel >> newThreadMessageViewModelFor: aMessage [
	^ GtLThreadMessageViewModel new threadMessage: aMessage
]

{ #category : #'private - hooks' }
GtLChatViewModel >> onAssistantChatChanged [
	newThreadMessageViewModel assistantChat: chat
]

{ #category : #accessing }
GtLChatViewModel >> sendMessage: aString [
	self assistantChat sendMessage: aString
]

{ #category : #'private - hooks' }
GtLChatViewModel >> subscribeToAssistantChat [
]

{ #category : #accessing }
GtLChatViewModel >> threadMessageViewModels [
	| newMessages |
	newMessages := chat messages reject: #isRawMessage.
	^ Array
		streamContents: [ :aStream | 
			| aStatus lastMessage |
			lastMessage := newMessages size > 0
					ifTrue: [ newMessages last ]
					ifFalse: [ nil ].
			newMessages
				do: [ :aMessage | 
					| aViewModel |
					aViewModel := threadMessageViewModelsCache
							at: aMessage id
							ifPresent: [ :theViewModel | theViewModel threadMessage: aMessage ]
							ifAbsentPut: [ aMessage asViewModel
									isExpanded: (lastMessage = aMessage and: [ aMessage isAssistantRole ]) ].
					aStream nextPut: aViewModel ].
			aStatus := chat status.

			aStatus isFailed
				ifTrue: [ | aViewModel |
					aViewModel := self
							newThreadMessageViewModelFor: (GtLFailureThreadMessage new
									failureText: aStatus message;
									createdAt: aStatus createdAt;
									chat: self assistantChat).
					aStream nextPut: aViewModel ].

			aStatus isDone
				ifFalse: [ (newMessages size > 0 and: [ newMessages last isAssistantRole ])
						ifFalse: [ | aViewModel |
							aViewModel := self
									newThreadMessageViewModelFor: (GtLProvisionalThreadMessage new
											createdAt: aStatus createdAt;
											chat: self assistantChat).
							aStream nextPut: aViewModel ] ].

			aStream nextPut: self newThreadMessageViewModel ]
]

{ #category : #'private - hooks' }
GtLChatViewModel >> unsubscribeFromAssistantChat [
]
