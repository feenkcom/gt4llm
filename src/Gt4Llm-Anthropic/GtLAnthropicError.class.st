Class {
	#name : #GtLAnthropicError,
	#superclass : #GtLError,
	#instVars : [
		'type'
	],
	#category : #'Gt4Llm-Anthropic-Model'
}

{ #category : #'as yet unclassified' }
GtLAnthropicError class >> from: aDictionary [
	^ self new
		messageText: (aDictionary at: 'message');
		type: (aDictionary at: 'type')
]

{ #category : #accessing }
GtLAnthropicError >> type [
	^ type
]

{ #category : #accessing }
GtLAnthropicError >> type: anObject [
	type := anObject
]
