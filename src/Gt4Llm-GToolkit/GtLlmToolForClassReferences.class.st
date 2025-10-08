Class {
	#name : #GtLlmToolForClassReferences,
	#superclass : #GtLlmAbstractFunctionTool,
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #'as yet unclassified' }
GtLlmToolForClassReferences class >> leJsonV4Name [
	^ #gtLlmToolForClassReferences
]

{ #category : #'as yet unclassified' }
GtLlmToolForClassReferences >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForClassReferences: self
]

{ #category : #'as yet unclassified' }
GtLlmToolForClassReferences >> description [
	^ 'Search the image for the references to the given class'
]

{ #category : #'as yet unclassified' }
GtLlmToolForClassReferences >> name [
	^ 'classReferences'
]

{ #category : #'as yet unclassified' }
GtLlmToolForClassReferences >> parameters [
	^ #('className')
]

{ #category : #'llm-generated' }
GtLlmToolForClassReferences >> privatePerformToolCall: aToolCall [
	| class |
	class := aToolCall anyArgument asSymbol asClassIfAbsent: [ nil ].
	^ class
		ifNil: [ 'Class not found' ]
		ifNotNil: [ :c | Character cr join: (c gtReferences result toArray wait collect: #name) ]
]
