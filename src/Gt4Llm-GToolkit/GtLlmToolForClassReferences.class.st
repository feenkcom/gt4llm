Class {
	#name : #GtLlmToolForClassReferences,
	#superclass : #GtLlmAbstractFunctionTool,
	#category : 'Gt4Llm-GToolkit-Tools'
}

{ #category : #accessing }
GtLlmToolForClassReferences class >> leJsonV4Name [
	^ #gtLlmToolForClassReferences
]

{ #category : #accessing }
GtLlmToolForClassReferences >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForClassReferences: self
]

{ #category : #accessing }
GtLlmToolForClassReferences >> description [
	^ 'Search the image for the references to the given class'
]

{ #category : #accessing }
GtLlmToolForClassReferences >> name [
	^ 'classReferences'
]

{ #category : #accessing }
GtLlmToolForClassReferences >> parameters [
	^ #('className')
]

{ #category : #accessing }
GtLlmToolForClassReferences >> privatePerformToolCall: aToolCall [
	| class |
	class := aToolCall anyArgument asSymbol asClassIfAbsent: [ nil ].
	^ class
		ifNil: [ 'Class not found' ]
		ifNotNil: [ :c | Character cr join: (c gtReferences result toArray wait collect: #name) ]
]
