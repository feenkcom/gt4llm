Extension { #name : #GtOpenAIGenerateResponseAPIClient }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIGenerateResponseAPIClient >> request [
	^ format
		ifNil: [ self client postStreaming: '/responses' withEntity: self buildEntity ]
		ifNotNil: [ self client post: '/responses' withEntity: self buildEntity ]
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIGenerateResponseAPIClient >> serializationClass [
	^ format ifNil: [ #GtOpenAIStreamedResponse asClass ] ifNotNil: [ GtOpenAIResponse ]
]
