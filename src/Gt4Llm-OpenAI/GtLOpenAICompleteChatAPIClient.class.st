Class {
	#name : #GtLOpenAICompleteChatAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'model',
		'messages'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAICompleteChatAPIClient >> messages [
	^ messages
]

{ #category : #accessing }
GtLOpenAICompleteChatAPIClient >> messages: anObject [
	messages := anObject
]

{ #category : #accessing }
GtLOpenAICompleteChatAPIClient >> model [
	^ model
]

{ #category : #accessing }
GtLOpenAICompleteChatAPIClient >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtLOpenAICompleteChatAPIClient >> request [
	^ self client
		post: '/chat/completions'
		withEntity: {'model' -> self model.
				'messages' -> (self messages collect: [:aMessage | aMessage serialize ])} asDictionary
]

{ #category : #accessing }
GtLOpenAICompleteChatAPIClient >> serializationClass [
	^ GtLOpenAIChatCompletion
]
