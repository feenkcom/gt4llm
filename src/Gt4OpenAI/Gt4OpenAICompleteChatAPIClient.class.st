Class {
	#name : #Gt4OpenAICompleteChatAPIClient,
	#superclass : #Gt4OpenAIEndpointClient,
	#instVars : [
		'model',
		'messages'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
Gt4OpenAICompleteChatAPIClient >> messages [
	^ messages
]

{ #category : #accessing }
Gt4OpenAICompleteChatAPIClient >> messages: anObject [
	messages := anObject
]

{ #category : #accessing }
Gt4OpenAICompleteChatAPIClient >> model [
	^ model
]

{ #category : #accessing }
Gt4OpenAICompleteChatAPIClient >> model: anObject [
	model := anObject
]

{ #category : #accessing }
Gt4OpenAICompleteChatAPIClient >> request [
	^ self client
		post: '/chat/completions'
		withEntity: {'model' -> self model.
				'messages' -> (self messages collect: #serialize)} asDictionary
]

{ #category : #accessing }
Gt4OpenAICompleteChatAPIClient >> serializationClass [
	^ Gt4OpenAIChatCompletion
]
