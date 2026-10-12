Class {
	#name : #GtLAnthropicGroup,
	#superclass : #GtLGroup,
	#instVars : [
		'client'
	],
	#category : #'Gt4Llm-Anthropic-Model'
}

{ #category : #'as yet unclassified' }
GtLAnthropicGroup class >> from: aList [
	^ self
		withAll: ((aList at: 'data') collect: [ :aModel | self itemClass from: aModel ])
]

{ #category : #'as yet unclassified' }
GtLAnthropicGroup class >> itemClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLAnthropicGroup class >> leJsonV4Name [

	^ #gtLAnthropicGroup
]

{ #category : #accessing }
GtLAnthropicGroup >> client [
	^ client
]

{ #category : #accessing }
GtLAnthropicGroup >> client: anObject [
	client := anObject
]
