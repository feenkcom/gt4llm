Class {
	#name : #GtLlmActionChatViewModel,
	#superclass : #GtLlmChatViewModel,
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #'as yet unclassified' }
GtLlmActionChatViewModel >> asElement [
	^ GtLlmChatElement new chatViewModel: self
]

{ #category : #accessing }
GtLlmActionChatViewModel >> initialize [
	super initialize.
	newThreadMessageViewModel := GtLlmNewActionThreadMessageViewModel new
			threadMessage: GtLlmNewActionThreadMessage new
]

{ #category : #accessing }
GtLlmActionChatViewModel >> newThreadMessageViewModelFor: aMessage [
	^ GtLlmActionThreadMessageViewModel new threadMessage: aMessage.
]
