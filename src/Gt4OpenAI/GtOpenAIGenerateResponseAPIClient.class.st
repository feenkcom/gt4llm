Class {
	#name : #GtOpenAIGenerateResponseAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'model',
		'messages'
	],
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAIGenerateResponseAPIClient >> messages [
	^ messages
]

{ #category : #accessing }
GtOpenAIGenerateResponseAPIClient >> messages: anObject [
	messages := anObject
]

{ #category : #accessing }
GtOpenAIGenerateResponseAPIClient >> model [
	^ model
]

{ #category : #accessing }
GtOpenAIGenerateResponseAPIClient >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtOpenAIGenerateResponseAPIClient >> request [
	^ self client
		post: '/responses'
		withEntity: {'model' -> self model.
				'input' -> (self messages collect: [:aMessage | aMessage serialize ])} asDictionary
]

{ #category : #accessing }
GtOpenAIGenerateResponseAPIClient >> serializationClass [
	^ GtOpenAIResponse
]
