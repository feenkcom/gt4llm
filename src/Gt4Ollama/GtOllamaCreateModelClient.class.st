Class {
	#name : #GtOllamaCreateModelClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'model',
		'modelFile'
	],
	#category : #Gt4Ollama
}

{ #category : #accessing }
GtOllamaCreateModelClient >> model [
	^ model
]

{ #category : #accessing }
GtOllamaCreateModelClient >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtOllamaCreateModelClient >> modelFile [
	^ modelFile
]

{ #category : #accessing }
GtOllamaCreateModelClient >> modelFile: anObject [
	modelFile := anObject
]

{ #category : #accessing }
GtOllamaCreateModelClient >> request [
	^ self client
		postStreaming: '/create'
		withEntity: {'model' -> self model} asDictionary , self modelFile contentDictionary
]

{ #category : #accessing }
GtOllamaCreateModelClient >> serializationClass [
	^ GtOllamaStatusSteps
]
