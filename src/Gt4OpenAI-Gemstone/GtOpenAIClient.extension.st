Extension { #name : 'GtOpenAIClient' }

{ #category : '*Gt4OpenAI-Gemstone' }
GtOpenAIClient >> initializeClient [
	^ GtGemstoneHttpClient new
		authorization: 'Bearer ' , self apiKey;
		headerAt: 'OpenAI-Beta' put: 'assistants=v2'
]
