Class {
	#name : #GtLlmNullProvider,
	#superclass : #GtLlmProvider,
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmNullProvider >> format: aFormat [
]

{ #category : #'as yet unclassified' }
GtLlmNullProvider >> instructions: aString [
]

{ #category : #'as yet unclassified' }
GtLlmNullProvider >> sendMessage: aMessage [
	self chat addMessage: (GtLlmUserMessage new content: aMessage)
]

{ #category : #'as yet unclassified' }
GtLlmNullProvider >> status [
	^ GtLlmAssistantChatReadyStatus new
]
