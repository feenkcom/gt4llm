Extension { #name : #GtOllamaProvider }

{ #category : #'*Gt4Ollama-GToolkit' }
GtOllamaProvider >> asyncWait [
	[self triggerAssistant] asAsyncPromise
]

{ #category : #'*Gt4Ollama-GToolkit' }
GtOllamaProvider >> uuidClass [
	^ UUID
]
