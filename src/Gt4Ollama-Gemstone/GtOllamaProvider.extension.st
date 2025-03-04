Extension { #name : 'GtOllamaProvider' }

{ #category : '*Gt4Ollama-Gemstone' }
GtOllamaProvider >> asyncWait [
	^ self triggerAssistant
]
