Class {
	#name : #GtLOpenAICompleteChatAPICommand,
	#superclass : #GtLAPICommand,
	#instVars : [
		'model',
		'messages'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAICompleteChatAPICommand >> messages [
	^ messages
]

{ #category : #accessing }
GtLOpenAICompleteChatAPICommand >> messages: anObject [
	messages := anObject
]

{ #category : #accessing }
GtLOpenAICompleteChatAPICommand >> model [
	^ model
]

{ #category : #accessing }
GtLOpenAICompleteChatAPICommand >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtLOpenAICompleteChatAPICommand >> request [
	^ self client
		post: '/chat/completions'
		withEntity: {'model' -> self model.
				'messages' -> (self messages collect: [:aMessage | aMessage serialize ])} asDictionary
]

{ #category : #accessing }
GtLOpenAICompleteChatAPICommand >> serializationClass [
	^ GtLOpenAIChatCompletion
]
