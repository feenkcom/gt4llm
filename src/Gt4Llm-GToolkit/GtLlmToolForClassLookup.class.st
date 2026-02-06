Class {
	#name : #GtLlmToolForClassLookup,
	#superclass : #GtLlmAbstractFunctionTool,
	#category : 'Gt4Llm-GToolkit-Tools'
}

{ #category : #'as yet unclassified' }
GtLlmToolForClassLookup class >> leJsonV4Name [
	^ #gtLlmToolForClassLookup
]

{ #category : #accessing }
GtLlmToolForClassLookup >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForClassLookup: self
]

{ #category : #accessing }
GtLlmToolForClassLookup >> description [
	^ 'Get the details of a class as JSON.'
]

{ #category : #accessing }
GtLlmToolForClassLookup >> name [
	^ 'lookupClass'
]

{ #category : #accessing }
GtLlmToolForClassLookup >> parameters [
	^ #('className')
]

{ #category : #accessing }
GtLlmToolForClassLookup >> privatePerformToolCall: aToolCall [
	| arguments className class serializer |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	className := arguments at: 'className' ifAbsent: [ ^ 'Class name not provided' ].
	class := className asClassIfAbsent: [ ^ 'Class not found' ].
	serializer := GtLlmValueSerializer new.
	^ STONJSON toString: (serializer serializeClass: class)
]
