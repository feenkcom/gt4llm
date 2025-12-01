Class {
	#name : #GtLOpenAIDeleteModelAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'model'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIDeleteModelAPIClient >> model [
	^ model
]

{ #category : #accessing }
GtLOpenAIDeleteModelAPIClient >> model: anObject [
	model := anObject
]

{ #category : #'as yet unclassified' }
GtLOpenAIDeleteModelAPIClient >> request [
	^ self client delete: 'models/' , model
]

{ #category : #'as yet unclassified' }
GtLOpenAIDeleteModelAPIClient >> serializationClass [
	^ GtLOpenAIDeletion
]
