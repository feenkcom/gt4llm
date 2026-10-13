Class {
	#name : #GtAnthropicListModelsAPICommand,
	#superclass : #GtLAPICommand,
	#category : #'Gt4Llm-Anthropic-Client'
}

{ #category : #'as yet unclassified' }
GtAnthropicListModelsAPICommand >> request [
	^ self client get: '/models'
]

{ #category : #'as yet unclassified' }
GtAnthropicListModelsAPICommand >> serializationClass [
	^ GtLAnthropicModelsGroup
]
