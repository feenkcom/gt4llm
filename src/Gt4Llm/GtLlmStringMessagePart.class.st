Class {
	#name : #GtLlmStringMessagePart,
	#superclass : #GtLlmMessagePart,
	#instVars : [
		'string'
	],
	#category : #'Gt4Llm-Models'
}

{ #category : #'as yet unclassified' }
GtLlmStringMessagePart >> content [
	^ self string
]

{ #category : #'as yet unclassified' }
GtLlmStringMessagePart >> isString [
	^ true
]

{ #category : #'as yet unclassified' }
GtLlmStringMessagePart >> serialize [
	^ {'type' -> 'text'.
		'text' -> self string} asDictionary
]

{ #category : #'as yet unclassified' }
GtLlmStringMessagePart >> serializeInline [
	^ self serialize
]

{ #category : #accessing }
GtLlmStringMessagePart >> string [
	^ string
]

{ #category : #accessing }
GtLlmStringMessagePart >> string: anObject [
	string := anObject
]

{ #category : #'as yet unclassified' }
GtLlmStringMessagePart >> type [
	^ 'String'
]
