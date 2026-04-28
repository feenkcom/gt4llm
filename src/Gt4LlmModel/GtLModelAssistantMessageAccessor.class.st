Class {
	#name : #GtLModelAssistantMessageAccessor,
	#superclass : #Object,
	#instVars : [
		'assistantMessage'
	],
	#category : #'Gt4LlmModel-MessageAccessors'
}

{ #category : #accessing }
GtLModelAssistantMessageAccessor >> assistantMessage [
	^ assistantMessage
]

{ #category : #accessing }
GtLModelAssistantMessageAccessor >> assistantMessage: anObject [
	assistantMessage := anObject
]

{ #category : #accessing }
GtLModelAssistantMessageAccessor >> rawData [

	^ assistantMessage rawData
]
