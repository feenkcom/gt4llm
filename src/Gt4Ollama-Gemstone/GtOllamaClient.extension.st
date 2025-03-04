Extension { #name : #GtOllamaClient }

{ #category : #'*Gt4Ollama-Gemstone' }
GtOllamaClient >> initializeClient [
	^ GtGemstoneHttpClient new
]
