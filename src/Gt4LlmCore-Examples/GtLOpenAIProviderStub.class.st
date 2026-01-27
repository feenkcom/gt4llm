Class {
	#name : #GtLOpenAIProviderStub,
	#superclass : #Object,
	#instVars : [
		'chat'
	],
	#category : #'Gt4LlmCore-Examples-OpenAI'
}

{ #category : #'as yet unclassified' }
GtLOpenAIProviderStub >> chat: aGtLChat [ 
	chat := aGtLChat
]

{ #category : #'as yet unclassified' }
GtLOpenAIProviderStub >> defaultUserMessageClass [
	^ GtLOpenAIUserMessage
]

{ #category : #'api - accessing' }
GtLOpenAIProviderStub >> modelName [
	^ 'stub'
]

{ #category : #'api - accessing' }
GtLOpenAIProviderStub >> status [
	^ GtLlmAssistantChatReadyStatus new
]
