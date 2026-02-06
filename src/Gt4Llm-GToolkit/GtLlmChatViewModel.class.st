Class {
	#name : #GtLlmChatViewModel,
	#superclass : #Object,
	#traits : 'TGtLlmWithAssistantChat',
	#classTraits : 'TGtLlmWithAssistantChat classTrait',
	#instVars : [
		'newThreadMessageViewModel',
		'threadMessageViewModelsCache'
	],
	#category : 'Gt4Llm-GToolkit-UI'
}

{ #category : #'as yet unclassified' }
GtLlmChatViewModel >> beSync [
	newThreadMessageViewModel beSync
]

{ #category : #initialization }
GtLlmChatViewModel >> initialize [
	super initialize.
	threadMessageViewModelsCache := Dictionary new.
	newThreadMessageViewModel := GtLlmNewThreadMessage new asViewModel
]

{ #category : #accessing }
GtLlmChatViewModel >> newThreadMessageViewModel [
	^ newThreadMessageViewModel
]

{ #category : #accessing }
GtLlmChatViewModel >> newThreadMessageViewModelFor: aMessage [
	^ GtLlmThreadMessageViewModel new threadMessage: aMessage
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
	newMessages := assistantChat messages reject: #isRawMessage.
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
			aStatus := assistantChat status.

			aStatus isFailed
				ifTrue: [ | aViewModel |
					aViewModel := self
							newThreadMessageViewModelFor: (GtLlmFailureThreadMessage new
									failureText: aStatus message;
									createdAt: aStatus createdAt;
									chat: self assistantChat).
					aStream nextPut: aViewModel ].

			aStatus isDone
				ifFalse: [ (newMessages size > 0 and: [ newMessages last isAssistantRole ])
						ifFalse: [ | aViewModel |
							aViewModel := self
									newThreadMessageViewModelFor: (GtLlmProvisionalThreadMessage new
											createdAt: aStatus createdAt;
											chat: self assistantChat).
							aStream nextPut: aViewModel ] ].

			aStream nextPut: self newThreadMessageViewModel ]
]
