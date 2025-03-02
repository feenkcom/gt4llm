Class {
	#name : #GtLlmInspectorMethodSummary,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmInspectorMethodSummary >> name [
	^ name
]

{ #category : #accessing }
GtLlmInspectorMethodSummary >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtLlmInspectorMethodSummary >> summaryString [
	^ self name
]
