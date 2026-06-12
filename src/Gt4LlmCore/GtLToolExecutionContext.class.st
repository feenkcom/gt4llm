Class {
	#name : #GtLToolExecutionContext,
	#superclass : #Object,
	#instVars : [
		'objectStorage',
		'currentChat'
	],
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolExecutionContext >> currentChat [
	^ currentChat
]

{ #category : #accessing }
GtLToolExecutionContext >> currentChat: anObject [
	currentChat := anObject
]

{ #category : #accessing }
GtLToolExecutionContext >> objectStorage [
	^ objectStorage
]

{ #category : #accessing }
GtLToolExecutionContext >> objectStorage: anObjectStorage [ 
	objectStorage := anObjectStorage 
]
