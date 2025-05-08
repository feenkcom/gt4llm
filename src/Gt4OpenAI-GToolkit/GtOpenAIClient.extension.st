Extension { #name : #GtOpenAIClient }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIClient >> initializeClient [
	| aClient |
	aClient := ZnClient new.
	aClient forJsonREST.
	aClient headerAt: 'OpenAI-Beta' put: 'assistants=v2'.
	aClient timeout: 60.
	aClient setBearerAuthentication: apiKey.
	^ aClient
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIClient >> postStreaming: aString withEntity: anEntity [
	| aClient |
	aClient := self initializeClient
			streaming: true;
			contentReader: nil.
	aClient url: self baseUrl / aString.

	aClient contents: anEntity.

	^ aClient post
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIClient class >> withApiKeyFromClipboard [
	^ self new apiKey: Clipboard clipboardText
]
