Class {
	#name : #GtLOllamaCreateEmbeddingsContext,
	#superclass : #GtLEndpointContext,
	#instVars : [
		'input',
		'truncate',
		'dimensions',
		'keepAlive',
		'options'
	],
	#category : #'Gt4Llm-Ollama-Contexts'
}

{ #category : #accessing }
GtLOllamaCreateEmbeddingsContext >> dimensions [
	^ dimensions
]

{ #category : #accessing }
GtLOllamaCreateEmbeddingsContext >> dimensions: anInteger [

	dimensions := anInteger
]

{ #category : #accessing }
GtLOllamaCreateEmbeddingsContext >> input [
	^ input
]

{ #category : #accessing }
GtLOllamaCreateEmbeddingsContext >> input: aStringOrArray [

	input := aStringOrArray
]

{ #category : #accessing }
GtLOllamaCreateEmbeddingsContext >> keepAlive [
	^ keepAlive
]

{ #category : #accessing }
GtLOllamaCreateEmbeddingsContext >> keepAlive: aString [

	keepAlive := aString
]

{ #category : #accessing }
GtLOllamaCreateEmbeddingsContext >> options [
	^ options
]

{ #category : #accessing }
GtLOllamaCreateEmbeddingsContext >> options: aDictionary [

	options := aDictionary
]

{ #category : #accessing }
GtLOllamaCreateEmbeddingsContext >> truncate [
	^ truncate
]

{ #category : #accessing }
GtLOllamaCreateEmbeddingsContext >> truncate: aBoolean [

	truncate := aBoolean
]
