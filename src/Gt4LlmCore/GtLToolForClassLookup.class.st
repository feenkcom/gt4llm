Class {
	#name : #GtLToolForClassLookup,
	#superclass : #GtLAbstractFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #'as yet unclassified' }
GtLToolForClassLookup class >> leJsonV4Name [
	^ #gtLToolForClassLookup
]

{ #category : #accessing }
GtLToolForClassLookup >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForClassLookup: self
]

{ #category : #accessing }
GtLToolForClassLookup >> description [
	^ 'Get the details of a class as JSON.'
]

{ #category : #accessing }
GtLToolForClassLookup >> name [
	^ 'lookupClass'
]

{ #category : #accessing }
GtLToolForClassLookup >> parameters [
	^ #('className')
]

{ #category : #accessing }
GtLToolForClassLookup >> privatePerformToolCall: aToolCall [
	| arguments className class serializer |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	className := arguments at: 'className' ifAbsent: [ ^ 'Class name not provided' ].
	class := className asClassIfAbsent: [ ^ 'Class not found' ].
	serializer := GtLValueSerializer new.
	^ STONJSON toString: (serializer serializeClass: class)
]
