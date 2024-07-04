Class {
	#name : #GtOllamaCreateModelClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'model',
		'modelFileString'
	],
	#category : #'Gt4Ollama-Chat'
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
GtOllamaCreateModelClient >> modelFileString [
	^ modelFileString
]

{ #category : #accessing }
GtOllamaCreateModelClient >> modelFileString: anObject [
	modelFileString := anObject
]

{ #category : #accessing }
GtOllamaCreateModelClient >> request [
	^ self client
		postStreaming: '/create'
		withEntity: {'model' -> self model.
				'modelfile' -> self modelFileString} asDictionary
]

{ #category : #accessing }
GtOllamaCreateModelClient >> serializationClass [
	^ GtOllamaStatusSteps
]
