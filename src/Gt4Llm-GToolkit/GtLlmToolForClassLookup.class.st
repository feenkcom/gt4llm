Class {
	#name : #GtLlmToolForClassLookup,
	#superclass : #GtLlmAbstractFunctionTool,
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #'llm-generated' }
GtLlmToolForClassLookup >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForClassLookup: self
]

{ #category : #'llm-generated' }
GtLlmToolForClassLookup >> description [
	^ 'Get the details of a class as JSON.'
]

{ #category : #'llm-generated' }
GtLlmToolForClassLookup >> name [
	^ 'lookupClass'
]

{ #category : #'llm-generated' }
GtLlmToolForClassLookup >> parameters [
	^ #('className')
]

{ #category : #'llm-generated' }
GtLlmToolForClassLookup >> performToolCall: aToolCall [
	| arguments className class serializer |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	className := arguments at: 'className' ifAbsent: [ ^ 'Class name not provided' ].
	class := className asClassIfAbsent: [ ^ 'Class not found' ].
	serializer := GtLlmValueSerializer new.
	^ STONJSON toString: (serializer serializeClass: class)
]
