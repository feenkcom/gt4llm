Extension { #name : #GtOllamaClient }

{ #category : #'*Gt4Ollama-GToolkit' }
GtOllamaClient >> delete: aString withEntity: anEntity [
	| aClient |
	aClient := ZnClient new.
	
	aClient
		timeout: 600;
		beOneShot;
		url: self baseUrl / aString;
		method: #DELETE;
		entity: (ZnEntity json: (STONJSON toString: anEntity));
		execute.

	history add: (aClient request -> aClient response).
]

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

	history add: (aClient request -> aClient response).
	
	^ aResult
]
