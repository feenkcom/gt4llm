Class {
	#name : #GtLlmActionChat,
	#superclass : #GtLlmChat,
	#category : #'Gt4Llm-Tutor-Chats'
}

{ #category : #'as yet unclassified' }
GtLlmActionChat >> asViewModel [
	^ GtLlmActionChatViewModel new assistantChat: self
]
