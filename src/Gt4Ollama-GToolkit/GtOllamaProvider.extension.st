Extension { #name : #GtOllamaProvider }

{ #category : #'*Gt4Ollama-GToolkit' }
GtOllamaProvider >> asyncWait [
	executions add: ([self triggerAssistant] asAsyncPromise)
]

{ #category : #'*Gt4Ollama-GToolkit' }
GtOllamaProvider >> gtExecutionsFor: aView [
	<gtView>
	^ aView list
		title: 'Executions';
		items: [ executions ];
		priority: 10
]

{ #category : #'*Gt4Ollama-GToolkit' }
GtOllamaProvider class >> isConnectable [
	^ true"[ ZnClient new get: GtOllamaClient defaultBaseUrl.
	true ] on: ConnectionTimedOut do: [ false ]"
]

{ #category : #'*Gt4Ollama-GToolkit' }
GtOllamaProvider >> uuidClass [
	^ UUID
]
