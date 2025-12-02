Class {
	#name : #GtLOpenAIDeleteModelAPICommand,
	#superclass : #GtLAPICommand,
	#instVars : [
		'model'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIDeleteModelAPICommand >> model [
	^ model
]

{ #category : #accessing }
GtLOpenAIDeleteModelAPICommand >> model: anObject [
	model := anObject
]

{ #category : #'as yet unclassified' }
GtLOpenAIDeleteModelAPICommand >> request [
	^ self client delete: 'models/' , model
]

{ #category : #'as yet unclassified' }
GtLOpenAIDeleteModelAPICommand >> serializationClass [
	^ GtLOpenAIDeletion
]
