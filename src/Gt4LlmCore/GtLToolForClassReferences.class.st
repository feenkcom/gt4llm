Class {
	#name : #GtLToolForClassReferences,
	#superclass : #GtLAbstractFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForClassReferences class >> leJsonV4Name [
	^ #gtLlmToolForClassReferences
]

{ #category : #accessing }
GtLToolForClassReferences >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForClassReferences: self
]

{ #category : #accessing }
GtLToolForClassReferences >> description [
	^ 'Search the image for the references to the given class'
]

{ #category : #accessing }
GtLToolForClassReferences >> name [
	^ 'classReferences'
]

{ #category : #accessing }
GtLToolForClassReferences >> parameters [
	^ #('className')
]

{ #category : #accessing }
GtLToolForClassReferences >> privatePerformToolCall: aToolCall [
	| class |
	class := aToolCall anyArgument asSymbol asClassIfAbsent: [ nil ].
	^ class
		ifNil: [ 'Class not found' ]
		ifNotNil: [ :c | Character cr join: (c gtReferences result toArray wait collect: #name) ]
]
