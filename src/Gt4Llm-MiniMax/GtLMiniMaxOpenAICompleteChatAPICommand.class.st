Class {
	#name : #GtLMiniMaxOpenAICompleteChatAPICommand,
	#superclass : #GtLAPICommand,
	#instVars : [
		'model',
		'messages'
	],
	#category : #'Gt4Llm-MiniMax'
}

{ #category : #accessing }
GtLMiniMaxOpenAICompleteChatAPICommand >> entity [
	^ {'model' -> self model.
		'messages' -> (self messages collect: [ :aMessage | aMessage serialize ])}
		asDictionary
]

{ #category : #accessing }
GtLMiniMaxOpenAICompleteChatAPICommand >> messages [
	^ messages
]

{ #category : #accessing }
GtLMiniMaxOpenAICompleteChatAPICommand >> messages: anObject [
	messages := anObject
]

{ #category : #accessing }
GtLMiniMaxOpenAICompleteChatAPICommand >> model [
	^ model
]

{ #category : #accessing }
GtLMiniMaxOpenAICompleteChatAPICommand >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtLMiniMaxOpenAICompleteChatAPICommand >> request [
	^ self client post: '/chat/completions' withEntity: self entity
]

{ #category : #accessing }
GtLMiniMaxOpenAICompleteChatAPICommand >> serializationClass [
	^ GtLOpenAIChatCompletion
]
