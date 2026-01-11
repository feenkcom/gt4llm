Class {
	#name : #GtLToolForMethodCompilation,
	#superclass : #GtLAbstractFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForMethodCompilation class >> leJsonV4Name [
	^ #gtLToolForMethodCompilation
]

{ #category : #visiting }
GtLToolForMethodCompilation >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForMethodCompilation: self
]

{ #category : #accessing }
GtLToolForMethodCompilation >> description [
	^ 'Compiles the provided method source code in the specified class or metaclass and reports the result.'
]

{ #category : #accessing }
GtLToolForMethodCompilation >> name [
	^ 'compileMethod'
]

{ #category : #accessing }
GtLToolForMethodCompilation >> parameters [
	^ #('className' 'sourceCode' 'protocol' 'classSide')
]

{ #category : #private }
GtLToolForMethodCompilation >> privatePerformToolCall: aToolCall [
	| arguments className class classSideValue source protocol selector |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	className := arguments at: 'className' ifAbsent: [ ^ 'Class name not provided' ].
	class := className asClassIfAbsent: [ ^ 'Class not found' ].
	classSideValue := arguments at: 'classSide' ifAbsent: [ false ].
	((classSideValue = true) or: [ classSideValue asString = 'true' ])
		ifTrue: [ class := class class ].
	source := arguments at: 'sourceCode' ifAbsent: [ ^ 'Source code not provided' ].
	source := source asString.
	source isEmpty ifTrue: [ ^ 'Source code not provided' ].
	protocol := arguments at: 'protocol' ifAbsent: [ 'as yet unclassified' ].
	protocol := protocol ifNil: [ 'as yet unclassified' ].
	protocol := protocol asString.
	protocol isEmpty ifTrue: [ protocol := 'as yet unclassified' ].
	selector := [
		[ class compile: source classified: protocol ]
			on: CodeError
			do: [ :notification | ^ 'Syntax error: ' , (notification messageText ifNil: [ notification description ]) ]
	] on: Error do: [ :error | ^ 'Compilation error: ' , ((error respondsTo: #messageText)
			ifTrue: [ error messageText ifNil: [ error description ] ]
			ifFalse: [ error description ]) ].
	^ String streamContents: [ :stream |
		stream
			nextPutAll: 'Method compiled: ';
			nextPutAll: class name;
			nextPutAll: '>>#';
			nextPutAll: selector asString ]
]
