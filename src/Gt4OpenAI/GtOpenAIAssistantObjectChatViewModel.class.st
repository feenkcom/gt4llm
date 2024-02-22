Class {
	#name : #GtOpenAIAssistantObjectChatViewModel,
	#superclass : #GtOpenAIAssistantChatViewModel,
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #accessing }
GtOpenAIAssistantObjectChatViewModel >> threadMessageViewModel [
	| newMessage |
	newMessage := assistantChat messages asArray detect: #isAssistantRole.
	^ threadMessageViewModelsCache
			at: newMessage id
			ifPresent: [ :theViewModel | theViewModel threadMessage: newMessage ]
			ifAbsentPut: [ self newThreadMessageViewModelFor: newMessage ]
]
