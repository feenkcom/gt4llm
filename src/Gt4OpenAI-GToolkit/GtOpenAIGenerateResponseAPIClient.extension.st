Extension { #name : #GtOpenAIGenerateResponseAPIClient }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIGenerateResponseAPIClient >> request [
	^ isStreaming
		ifTrue: [ self client postStreaming: '/responses' withEntity: self buildEntity ]
		ifFalse: [ self client post: '/responses' withEntity: self buildEntity ]
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIGenerateResponseAPIClient >> serializationClass [
	^ isStreaming
		ifTrue: [ #GtOpenAIStreamedResponse asClass ]
		ifFalse: [ GtOpenAIResponse ]
]
