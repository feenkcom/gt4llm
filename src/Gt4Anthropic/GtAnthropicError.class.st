Class {
	#name : #GtAnthropicError,
	#superclass : #GtLlmError,
	#instVars : [
		'type'
	],
	#category : #'Gt4Anthropic-Client'
}

{ #category : #'as yet unclassified' }
GtAnthropicError class >> from: aDictionary [
	^ self new
		messageText: (aDictionary at: 'message');
		type: (aDictionary at: 'type')
]

{ #category : #accessing }
GtAnthropicError >> type [
	^ type
]

{ #category : #accessing }
GtAnthropicError >> type: anObject [
	type := anObject
]
