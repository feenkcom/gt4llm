Class {
	#name : #GtOpenAIDeleteModelAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'model'
	],
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAIDeleteModelAPIClient >> model [
	^ model
]

{ #category : #accessing }
GtOpenAIDeleteModelAPIClient >> model: anObject [
	model := anObject
]

{ #category : #'as yet unclassified' }
GtOpenAIDeleteModelAPIClient >> request [
	^ self client delete: 'models/' , model
]

{ #category : #'as yet unclassified' }
GtOpenAIDeleteModelAPIClient >> serializationClass [
	^ GtOpenAIDeletion
]
