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
