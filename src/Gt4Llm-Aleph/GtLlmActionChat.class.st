Class {
	#name : #GtLlmActionChat,
	#superclass : #GtLlmChat,
	#category : #'Gt4Llm-Aleph-Chats'
}

{ #category : #'as yet unclassified' }
GtLlmActionChat >> asViewModel [
	^ GtLlmActionChatViewModel new assistantChat: self
]
