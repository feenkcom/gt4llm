Extension { #name : #GtOllamaProvider }

{ #category : #'*Gt4Ollama-Gemstone' }
GtOllamaProvider >> asyncWait [
	^ self triggerAssistant
]

{ #category : #'*Gt4Ollama-Gemstone' }
GtOllamaProvider >> uuidClass [
	^ GsUuidV4
]
