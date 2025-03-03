Extension { #name : #GtOllamaClient }

{ #category : #'*Gt4Ollama-GToolkit' }
GtOllamaClient >> initializeClient [
	| aClient |
	aClient := ZnClient new.
	aClient forJsonREST.
	aClient timeout: 600.
	^ aClient
]

{ #category : #'*Gt4Ollama-GToolkit' }
GtOllamaClient >> postStreaming: aString withEntity: anEntity [
	| aClient aResult |
	aClient := self initializeClient
			accept: 'application/jsonl,application/x-ndjson';
			contentReader: [ :entity | (NeoJSONReader on: entity readStream) upToEnd ].
	aClient url: self baseUrl / aString.

	aClient contents: anEntity.

	aResult := aClient post.

	aResult size > 0 ifTrue: [ self checkForErrors: aResult first ].

	^ aResult
]
