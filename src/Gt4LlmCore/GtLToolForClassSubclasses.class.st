Class {
	#name : #GtLToolForClassSubclasses,
	#superclass : #GtLAbstractFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForClassSubclasses class >> leJsonV4Name [
	^ #gtLlmToolForClassSubclasses
]

{ #category : #accessing }
GtLToolForClassSubclasses >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForClassSubclasses: self
]

{ #category : #accessing }
GtLToolForClassSubclasses >> description [
	^ 'Retrieve all subclasses of the given class'
]

{ #category : #accessing }
GtLToolForClassSubclasses >> name [
	^ 'classSubclasses'
]

{ #category : #accessing }
GtLToolForClassSubclasses >> parameters [
	^ #('className')
]

{ #category : #accessing }
GtLToolForClassSubclasses >> privatePerformToolCall: aToolCall [
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
