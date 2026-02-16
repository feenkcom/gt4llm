Class {
	#name : #GtOpenAICompleteChatAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'model',
		'messages'
	],
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAICompleteChatAPIClient >> messages [
	^ messages
]

{ #category : #accessing }
GtOpenAICompleteChatAPIClient >> messages: anObject [
	messages := anObject
]

{ #category : #accessing }
GtOpenAICompleteChatAPIClient >> model [
	^ model
]

{ #category : #accessing }
GtOpenAICompleteChatAPIClient >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtOpenAICompleteChatAPIClient >> request [
	^ self client
		post: '/chat/completions'
		withEntity: {'model' -> self model.
				'messages' -> (self messages collect: [:aMessage | aMessage serialize ])} asDictionary
]

{ #category : #accessing }
GtOpenAICompleteChatAPIClient >> serializationClass [
	^ GtOpenAIChatCompletion
]
