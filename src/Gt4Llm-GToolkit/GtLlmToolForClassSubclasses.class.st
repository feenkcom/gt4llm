Class {
	#name : #GtLlmToolForClassSubclasses,
	#superclass : #GtLlmAbstractFunctionTool,
	#category : 'Gt4Llm-GToolkit-Tools'
}

{ #category : #accessing }
GtLlmToolForClassSubclasses class >> leJsonV4Name [
	^ #gtLlmToolForClassSubclasses
]

{ #category : #accessing }
GtLlmToolForClassSubclasses >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForClassSubclasses: self
]

{ #category : #accessing }
GtLlmToolForClassSubclasses >> description [
	^ 'Retrieve all subclasses of the given class'
]

{ #category : #accessing }
GtLlmToolForClassSubclasses >> name [
	^ 'classSubclasses'
]

{ #category : #accessing }
GtLlmToolForClassSubclasses >> parameters [
	^ #('className')
]

{ #category : #accessing }
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
