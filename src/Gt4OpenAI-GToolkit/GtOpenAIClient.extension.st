Extension { #name : #GtOpenAIClient }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIClient >> initializeClient [
	| aClient |
	aClient := ZnClient new.
	aClient forJsonREST.
	aClient headerAt: 'OpenAI-Beta' put: 'assistants=v2'.
	aClient timeout: 600.
	aClient setBearerAuthentication: apiKey.
	^ aClient
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIClient >> postStreaming: aString withEntity: anEntity [
	| aClient response |
	aClient := self initializeClient
			streaming: true;
			contentReader: nil.
	aClient url: self baseUrl / aString.

	aClient contents: anEntity.
.
	response := aClient post.
	
	history add: (aClient request -> aClient response).

	^ response
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIClient class >> withApiKeyFromClipboard [
	^ self new apiKey: Clipboard clipboardText
]
