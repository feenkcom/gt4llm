Class {
	#name : #GtOpenAIAssistantChatViewModel,
	#superclass : #Object,
	#traits : 'TGtOpenAIWithAssistantChat',
	#classTraits : 'TGtOpenAIWithAssistantChat classTrait',
	#instVars : [
		'threadMessageViewModels',
		'newThreadMessageViewModel'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #initialization }
GtOpenAIAssistantChatViewModel >> initialize [
	super initialize.
	newThreadMessageViewModel := GtOpenAINewThreadMessageViewModel new
			threadMessage: GtOpenAINewThreadMessage new
]

{ #category : #private }
GtOpenAIAssistantChatViewModel >> newThreadMessageViewModels [
	| existingMessages |
	existingMessages := assistantChat messages asArray reversed
			collect: [ :aMessage | GtOpenAIThreadMessageViewModel new threadMessage: aMessage ].

	^ existingMessages copyWith: newThreadMessageViewModel
]

{ #category : #'private - hooks' }
GtOpenAIAssistantChatViewModel >> onAssistantChatChanged [
	newThreadMessageViewModel assistantChat: assistantChat
]

{ #category : #accessing }
GtOpenAIAssistantChatViewModel >> threadMessageViewModels [
	^ threadMessageViewModels
		ifNil: [ threadMessageViewModels := self newThreadMessageViewModels ]
]
