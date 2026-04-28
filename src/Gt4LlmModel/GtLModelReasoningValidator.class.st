"
Reasoning values are split into none (no reasoning) and other values to allow for some automatic translation at a later time.
"
Class {
	#name : #GtLModelReasoningValidator,
	#superclass : #Object,
	#instVars : [
		'noneValues',
		'reasoningValues'
	],
	#category : #'Gt4LlmModel-Model'
}

{ #category : #accessing }
GtLModelReasoningValidator >> noneValues [
	^ noneValues
]

{ #category : #accessing }
GtLModelReasoningValidator >> noneValues: anObject [
	noneValues := anObject
]

{ #category : #accessing }
GtLModelReasoningValidator >> reasoningValues [
	^ reasoningValues
]

{ #category : #accessing }
GtLModelReasoningValidator >> reasoningValues: anObject [
	reasoningValues := anObject
]

{ #category : #validation }
GtLModelReasoningValidator >> validate: aValue [

	(aValue isNil or:
	[ (noneValues includes: aValue) or:
	[ reasoningValues includes: aValue ] ])
		ifTrue: [ ^ self ].
		
	self error: 'Invalid reasoning value: ', aValue printString.
]
