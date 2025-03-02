Class {
	#name : #GtOllamaGetModelInformationAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'model'
	],
	#category : #Gt4Ollama
}

{ #category : #accessing }
GtOllamaGetModelInformationAPIClient >> model [
	^ model
]

{ #category : #accessing }
GtOllamaGetModelInformationAPIClient >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtOllamaGetModelInformationAPIClient >> request [
	^ (self client
		postStreaming: '/show'
		withEntity: {'model' -> self model.
				'verbose' -> true} asDictionary) first
]

{ #category : #accessing }
GtOllamaGetModelInformationAPIClient >> serializationClass [
	^ GtOllamaModelInformation
]
