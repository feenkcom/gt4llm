Class {
	#name : #GtLOllamaClient,
	#superclass : #GtLModelClient,
	#category : #'Gt4Llm-Ollama-Client'
}

{ #category : #accessing }
GtLOllamaClient class >> defaultApiKeyFile [
	^ FileLocator home / '.secrets' / 'ollama-api-key.txt'
]

{ #category : #defaults }
GtLOllamaClient class >> defaultBaseUrl [
	^ 'http://localhost:11434' asZnUrl
]

{ #category : #private }
GtLOllamaClient >> initializeClient [

	^ super initializeClient beOneShot
]
