Extension { #name : #GtOpenAIProvider }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIProvider classSide >> withApiKeyFromClipboard [
	^ self new apiKey: Clipboard clipboardText
]
