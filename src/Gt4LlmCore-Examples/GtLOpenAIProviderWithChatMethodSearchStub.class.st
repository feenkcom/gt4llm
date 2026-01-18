Class {
	#name : #GtLOpenAIProviderWithChatMethodSearchStub,
	#superclass : #Object,
	#instVars : [
		'chat',
		'responseData'
	],
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #'as yet unclassified' }
GtLOpenAIProviderWithChatMethodSearchStub >> chat: aGtLChat [ 
	chat := aGtLChat
]

{ #category : #'as yet unclassified' }
GtLOpenAIProviderWithChatMethodSearchStub >> defaultUserMessageClass [
	^ GtLOpenAIUserMessage
]

{ #category : #accessing }
GtLOpenAIProviderWithChatMethodSearchStub >> responseData: anObject [
	responseData := anObject
]

{ #category : #'as yet unclassified' }
GtLOpenAIProviderWithChatMethodSearchStub >> sendMessage: aMessage [
	chat signalRunHasStarted.
	chat addAssistantMessage: (GtLOpenAIAssistantMessage new rawData: responseData).
	chat signalRunIsDone.
]
