Class {
	#name : #GtAnthropicGroup,
	#superclass : #GtLlmGroup,
	#instVars : [
		'client'
	],
	#category : #Gt4Anthropic
}

{ #category : #'as yet unclassified' }
GtAnthropicGroup class >> from: aList [
	^ self
		withAll: ((aList at: 'data') collect: [ :aModel | self itemClass from: aModel ])
]

{ #category : #'as yet unclassified' }
GtAnthropicGroup class >> itemClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtAnthropicGroup >> client [
	^ client
]

{ #category : #accessing }
GtAnthropicGroup >> client: anObject [
	client := anObject
]
