Class {
	#name : #GtLlmToolForClassSubclasses,
	#superclass : #GtLlmAbstractFunctionTool,
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #'llm-generated' }
GtLlmToolForClassSubclasses >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForClassSubclasses: self
]

{ #category : #'llm-generated' }
GtLlmToolForClassSubclasses >> description [
	^ 'Retrieve all subclasses of the given class'
]

{ #category : #'llm-generated' }
GtLlmToolForClassSubclasses >> name [
	^ 'classSubclasses'
]

{ #category : #'llm-generated' }
GtLlmToolForClassSubclasses >> parameters [
	^ #('className')
]

{ #category : #'llm-generated' }
GtLlmToolForClassSubclasses >> privatePerformToolCall: aToolCall [
	| argument class subclassNames |
	argument := aToolCall anyArgument.
	class := argument
		ifNil: [ nil ]
		ifNotNil: [ argument asSymbol asClassIfAbsent: [ nil ] ].
	^ class
		ifNil: [ 'Class not found' ]
		ifNotNil: [ :c |
			subclassNames := (c subclasses collect: [ :each | each name asString ]).
			subclassNames isEmpty
				ifTrue: [ 'No subclasses found' ]
				ifFalse: [ Character cr join: subclassNames ] ]
]
