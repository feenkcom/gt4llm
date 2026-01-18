Class {
	#name : #GtLAnthropicListModelsAPICommand,
	#superclass : #GtLAPICommand,
	#category : #'Gt4Llm-Anthropic-Client'
}

{ #category : #'as yet unclassified' }
GtLAnthropicListModelsAPICommand >> request [
	^ self client get: '/models'
]

{ #category : #'as yet unclassified' }
GtLAnthropicListModelsAPICommand >> serializationClass [
	^ GtAnthropicModelsGroup
]
