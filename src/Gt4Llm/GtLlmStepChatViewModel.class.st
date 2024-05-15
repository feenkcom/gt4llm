Class {
	#name : #GtLlmStepChatViewModel,
	#superclass : #GtLlmChatViewModel,
	#category : #'Gt4Llm-Widgets'
}

{ #category : #accessing }
GtLlmStepChatViewModel >> onAssistantChatChanged [
	super onAssistantChatChanged.

	newThreadMessageViewModel := GtLlmNewStepThreadMessageViewModel new
			threadMessage: (GtLlmNewStepThreadMessage new assistantChat: self assistantChat)
]
