Class {
	#name : #GtLlmChatViewModel,
	#superclass : #Object,
	#traits : 'TGtLlmWithAssistantChat',
	#classTraits : 'TGtLlmWithAssistantChat classTrait',
	#instVars : [
		'newThreadMessageViewModel',
		'threadMessageViewModelsCache'
	],
	#category : #'Gt4Llm-Widgets'
}

{ #category : #initialization }
GtLlmChatViewModel >> initialize [
	super initialize.
	threadMessageViewModelsCache := Dictionary new.
	newThreadMessageViewModel := GtLlmNewThreadMessageViewModel new
			threadMessage: GtLlmNewThreadMessage new
]

{ #category : #accessing }
GtLlmChatViewModel >> newThreadMessageViewModel [
	^ newThreadMessageViewModel
]

{ #category : #accessing }
GtLlmChatViewModel >> newThreadMessageViewModelFor: aMessage [
	| aViewModel |
	aViewModel := GtLlmThreadMessageViewModel new threadMessage: aMessage.

	aViewModel weak
		when: GtLlmAddMessageContentsRequest
		send: #onAddMessageContents:
		to: self.

	^ aViewModel
]

{ #category : #'private - announcement handling' }
GtLlmChatViewModel >> onAddMessageContents: anAnnouncement [
	newThreadMessageViewModel addMessageContents: anAnnouncement messageContents
]

{ #category : #'private - hooks' }
GtLlmChatViewModel >> onAssistantChatChanged [
	newThreadMessageViewModel assistantChat: assistantChat
]

{ #category : #accessing }
GtLlmChatViewModel >> sendMessage: aString [
	self assistantChat sendMessage: aString
]

{ #category : #accessing }
GtLlmChatViewModel >> threadMessageViewModels [
	| newMessages |
	newMessages := assistantChat messages.
	^ Array
		streamContents: [ :aStream | 
			| aStatus lastMessage |
			lastMessage := newMessages size > 0 ifTrue: [newMessages last ] ifFalse: [nil]. 
			newMessages
				do: [ :aMessage | 
					| aViewModel |
					aViewModel := threadMessageViewModelsCache
							at: aMessage id
							ifPresent: [ :theViewModel | theViewModel threadMessage: aMessage ]
							ifAbsentPut: [ self newThreadMessageViewModelFor: aMessage ].
					aViewModel isExpanded: (lastMessage = aMessage).
					aStream nextPut: aViewModel ].
			aStatus := assistantChat status.

			aStatus isFailed
				ifTrue: [ | aViewModel |
					aViewModel := self
							newThreadMessageViewModelFor: (GtOpenAIFailureThreadMessage new
									failureText: aStatus message;
									createdAt: aStatus createdAt;
									chat: self assistantChat).
					aStream nextPut: aViewModel ].

			aStatus isDone
				ifFalse: [ newMessages last isAssistantRole
						ifFalse: [ | aViewModel |
							aViewModel := self
									newThreadMessageViewModelFor: (GtLlmProvisionalThreadMessage new
											createdAt: aStatus createdAt;
											chat: self assistantChat).
							aStream nextPut: aViewModel ] ].

			aStream nextPut: self newThreadMessageViewModel ]
]
