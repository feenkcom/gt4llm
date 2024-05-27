Class {
	#name : #GtLlmActionChatViewModel,
	#superclass : #GtLlmChatViewModel,
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #accessing }
GtLlmActionChatViewModel >> initialize [
	super initialize.
	newThreadMessageViewModel := GtLlmNewActionThreadMessageViewModel new
			threadMessage: GtLlmNewThreadMessage new
]
