Class {
	#name : #GtLToolExecutionContext,
	#superclass : #Object,
	#instVars : [
		'objectStorage'
	],
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolExecutionContext >> objectStorage [
	^ objectStorage
]

{ #category : #accessing }
GtLToolExecutionContext >> objectStorage: anObjectStorage [ 
	objectStorage := anObjectStorage 
]
