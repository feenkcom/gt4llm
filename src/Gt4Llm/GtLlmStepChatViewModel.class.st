Class {
	#name : #GtLlmStepChatViewModel,
	#superclass : #GtLlmChatViewModel,
	#category : #'Gt4Llm-Widgets'
}

{ #category : #accessing }
GtLlmStepChatViewModel >> newThreadMessageViewModel [
	^ GtLlmNewStepThreadMessageViewModel new
		threadMessage: (GtLlmNewStepThreadMessage new assistantChat: self assistantChat)
]
