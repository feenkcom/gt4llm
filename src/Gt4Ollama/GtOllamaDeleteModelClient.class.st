Class {
	#name : #GtOllamaDeleteModelClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'model'
	],
	#category : #Gt4Ollama
}

{ #category : #accessing }
GtOllamaDeleteModelClient >> model [
	^ model
]

{ #category : #accessing }
GtOllamaDeleteModelClient >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtOllamaDeleteModelClient >> perform [
	^ self client delete: 'delete' withEntity: {'name' -> self model} asDictionary
]
