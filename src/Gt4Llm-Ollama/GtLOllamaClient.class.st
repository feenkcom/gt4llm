Class {
	#name : #GtLOllamaClient,
	#superclass : #GtLModelClient,
	#category : #'Gt4Llm-Ollama-Client'
}

{ #category : #defaults }
GtLOllamaClient class >> defaultBaseUrl [
	^ 'http://localhost:11434' asZnUrl
]

{ #category : #private }
GtLOllamaClient >> initializeClient [

	^ super initializeClient beOneShot
]

{ #category : #accessing }
GtLOllamaClient >> serializeToolMessageForResponse: aToolMessage [
	self subclassResponsibility
]
