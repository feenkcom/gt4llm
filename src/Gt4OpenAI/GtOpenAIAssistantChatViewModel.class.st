Class {
	#name : #GtOpenAIAssistantChatViewModel,
	#superclass : #Object,
	#traits : 'TGtOpenAIWithAssistantChat',
	#classTraits : 'TGtOpenAIWithAssistantChat classTrait',
	#instVars : [
		'newThreadMessageViewModel',
		'threadMessageViewModelsCache'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #initialization }
GtOpenAIAssistantChatViewModel >> initialize [
	super initialize.
	threadMessageViewModelsCache := Dictionary new.
	newThreadMessageViewModel := GtOpenAINewThreadMessageViewModel new
			threadMessage: GtOpenAINewThreadMessage new
]

{ #category : #'private - hooks' }
GtOpenAIAssistantChatViewModel >> onAssistantChatChanged [
	newThreadMessageViewModel assistantChat: assistantChat
]

{ #category : #accessing }
GtOpenAIAssistantChatViewModel >> threadMessageViewModels [
	| newMessages |
	newMessages := assistantChat messages asArray reversed.
	^ Array
		streamContents: [ :aStream | 
			newMessages
				do: [ :aMessage | 
					| aViewModel |
					aViewModel := threadMessageViewModelsCache
							at: aMessage id
							ifPresent: [ :theViewModel | theViewModel threadMessage: aMessage ]
							ifAbsentPut: [ GtOpenAIThreadMessageViewModel new threadMessage: aMessage ].
					aStream nextPut: aViewModel ].
			aStream nextPut: newThreadMessageViewModel ]
]
