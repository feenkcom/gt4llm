Extension { #name : #GtOpenAIGetFileContentsAPIClient }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIGetFileContentsAPIClient >> perform [
	^ ZnClient new
		url: self client baseUrl / 'files' / self file / 'content';
		setBearerAuthentication: self client apiKey;
		get
]
