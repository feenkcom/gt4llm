Extension { #name : 'GtOllamaClient' }

{ #category : '*Gt4Ollama-Gemstone' }
GtOllamaClient >> initializeClient [
	^ GtGemstoneHttpClient new
]

{ #category : '*Gt4Ollama-Gemstone' }
GtOllamaClient >> postStreaming: aString withEntity: anEntity [
	| aClient |
	aClient := self initializeClient beOneShot.
	aClient url: self baseUrl / aString.

	aClient contents: anEntity.

	^ self checkForErrors: aClient postStreaming
]
