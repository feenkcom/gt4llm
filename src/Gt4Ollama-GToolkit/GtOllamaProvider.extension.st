Extension { #name : #GtOllamaProvider }

{ #category : #'*Gt4Ollama-GToolkit' }
GtOllamaProvider >> asyncWait [
	[self triggerAssistant] asAsyncPromise
]

{ #category : #'*Gt4Ollama-GToolkit' }
GtOllamaProvider class >> isConnectable [
	^ [ ZnClient new get: GtOllamaClient defaultBaseUrl.
	true ] on: ConnectionTimedOut do: [ false ]
]

{ #category : #'*Gt4Ollama-GToolkit' }
GtOllamaProvider >> uuidClass [
	^ UUID
]
