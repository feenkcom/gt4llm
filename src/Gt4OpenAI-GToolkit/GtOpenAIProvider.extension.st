Extension { #name : #GtOpenAIProvider }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIProvider class >> withApiKeyFromClipboard [
	^ self new apiKey: Clipboard clipboardText
]
