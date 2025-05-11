Extension { #name : #GtOpenAIGenerateResponseAPIClient }

{ #category : #'*Gt4OpenAI-Gemstone' }
GtOpenAIGenerateResponseAPIClient >> request [
	^ self client post: '/responses' withEntity: (self buildEntity at: 'stream' put: false; yourself)
]

{ #category : #'*Gt4OpenAI-Gemstone' }
GtOpenAIGenerateResponseAPIClient >> serializationClass [
	^ GtOpenAIResponse
]
