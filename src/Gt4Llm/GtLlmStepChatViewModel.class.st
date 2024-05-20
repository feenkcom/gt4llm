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

{ #category : #accessing }
GtLlmStepChatViewModel >> newThreadMessageViewModelFor: aMessage [
	| aViewModel |
	aViewModel := GtLlmStepThreadMessageViewModel new threadMessage: aMessage.

	aViewModel weak
		when: GtLlmAddMessageContentsRequest
		send: #onAddMessageContents:
		to: self.

	^ aViewModel
]
