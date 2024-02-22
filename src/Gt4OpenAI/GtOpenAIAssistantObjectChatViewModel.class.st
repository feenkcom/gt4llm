Class {
	#name : #GtOpenAIAssistantObjectChatViewModel,
	#superclass : #GtOpenAIAssistantChatViewModel,
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #accessing }
GtOpenAIAssistantObjectChatViewModel >> threadMessageViewModels [
	^ super threadMessageViewModels allButFirst
]
