Class {
	#name : #Gt4OpenAIGenerateEmbeddingAPIClient,
	#superclass : #Gt4OpenAIEndpointClient,
	#instVars : [
		'input',
		'model'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
Gt4OpenAIGenerateEmbeddingAPIClient >> input [
	^ input
]

{ #category : #accessing }
Gt4OpenAIGenerateEmbeddingAPIClient >> input: anObject [
	input := anObject
]

{ #category : #accessing }
Gt4OpenAIGenerateEmbeddingAPIClient >> model [
	^ model
]

{ #category : #accessing }
Gt4OpenAIGenerateEmbeddingAPIClient >> model: anObject [
	model := anObject
]

{ #category : #accessing }
Gt4OpenAIGenerateEmbeddingAPIClient >> request [
	^ self client
		post: 'embeddings'
		withEntity: {'model' -> self model.
				'input' -> self input} asDictionary
]

{ #category : #accessing }
Gt4OpenAIGenerateEmbeddingAPIClient >> serializationClass [
	^ Gt4OpenAIEmbeddingsGroup
]
