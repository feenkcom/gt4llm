Class {
	#name : #GtLDataViewBuildContext,
	#superclass : #Object,
	#instVars : [
		'object',
		'arguments'
	],
	#category : #'Gt4LlmCore-Data Views'
}

{ #category : #accessing }
GtLDataViewBuildContext >> argument: anArgument [
	self arguments: (Array with: anArgument)
]

{ #category : #accessing }
GtLDataViewBuildContext >> arguments [
	^ arguments
]

{ #category : #accessing }
GtLDataViewBuildContext >> arguments: anObject [
	arguments := anObject
]

{ #category : #accessing }
GtLDataViewBuildContext >> context [
	<return: #GtPhlowContext>
	^ self arguments at: 2 ifAbsent: [ GtPhlowContext new ]
]

{ #category : #'api - accessing' }
GtLDataViewBuildContext >> contextDo: aDoBlock ifAbsent: anAbsentBlock [
	^ self hasContext 
		ifTrue: [ aDoBlock cull: self context ] 
		ifFalse: anAbsentBlock
]

{ #category : #testing }
GtLDataViewBuildContext >> hasContext [

	^ self arguments size = 2
]

{ #category : #initialization }
GtLDataViewBuildContext >> initialize [
	super initialize.
	arguments := Array empty.
]

{ #category : #accessing }
GtLDataViewBuildContext >> object [
	^ object
]

{ #category : #accessing }
GtLDataViewBuildContext >> object: anObject [
	object := anObject
]

{ #category : #'api - accessing' }
GtLDataViewBuildContext >> objectDo: aDoBlock ifAbsent: anAbsentBlock [
	^ aDoBlock cull: self object
]
