Class {
	#name : #GtLOpenAIListModelsAPICommand,
	#superclass : #GtLAPICommand,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIListModelsAPICommand >> request [
	^ self client get: '/models'
]

{ #category : #accessing }
GtLOpenAIListModelsAPICommand >> serializationClass [
	^ GtLOpenAIModelsGroup
]
