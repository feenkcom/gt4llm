Extension { #name : #GtOpenAIClient }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIClient class >> withApiKeyFromClipboard [
	^ self new apiKey: Clipboard clipboardText
]
