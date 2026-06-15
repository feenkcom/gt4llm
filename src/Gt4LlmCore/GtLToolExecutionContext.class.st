Class {
	#name : #GtLToolExecutionContext,
	#superclass : #Object,
	#instVars : [
		'objectStorage',
		'currentChat',
		'lepiterDatabase'
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
GtLToolExecutionContext >> lepiterDatabase [
	^ lepiterDatabase ifNil: [
			 LeDatabasesRegistry defaultLogicalDatabase ]
]

{ #category : #accessing }
GtLToolExecutionContext >> lepiterDatabase: aDatabase [
	lepiterDatabase := aDatabase
]

{ #category : #accessing }
GtLToolExecutionContext >> objectStorage [
	^ objectStorage
]

{ #category : #accessing }
GtLToolExecutionContext >> objectStorage: anObjectStorage [ 
	objectStorage := anObjectStorage 
]
