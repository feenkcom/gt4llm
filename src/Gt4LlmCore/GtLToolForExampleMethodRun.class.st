Class {
	#name : #GtLToolForExampleMethodRun,
	#superclass : #GtLAbstractFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForExampleMethodRun class >> leJsonV4Name [
	^ #gtLlmToolForExampleRun
]

{ #category : #accessing }
GtLToolForExampleMethodRun >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForExampleRun: self
]

{ #category : #accessing }
GtLToolForExampleMethodRun >> description [
	^ 'Execute a gtExample method and report if it succeeds, fails, or errors'
]

{ #category : #accessing }
GtLToolForExampleMethodRun >> name [
	^ 'exampleMethodRun'
]

{ #category : #accessing }
GtLToolForExampleMethodRun >> parameters [
	^ #('className' 'methodName' 'classSide')
]

{ #category : #accessing }
GtLToolForExampleMethodRun >> privatePerformToolCall: aToolCall [
	| arguments className class methodName classSideValue method example exampleResult |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	className := arguments at: 'className' ifAbsent: [ ^ 'Class name not provided' ].
	class := className asClassIfAbsent: [ ^ 'Class not found' ].
	methodName := arguments at: 'methodName' ifAbsent: [ ^ 'Method name not provided' ].
	classSideValue := arguments at: 'classSide' ifAbsent: [ false ].
	((classSideValue = true) or: [ classSideValue asString = 'true' ])
		ifTrue: [ class := class class ].
	method := class
		compiledMethodAt: methodName asSymbol
		ifAbsent: [ ^ 'Method not found' ].
	(method pragmas anySatisfy: [ :pragma | pragma selector = #gtExample ])
		ifFalse: [ ^ 'Method is not an example' ].
	example := method gtExample.
	example ifNil: [ ^ 'Could not build example' ].
	[ 
		exampleResult := example run.
		exampleResult ifNil: [ ^ 'error' ].
		exampleResult isFailure ifTrue: [ ^ 'failure' ].
		exampleResult isError ifTrue: [ ^ 'error' ].
		exampleResult hasProblems ifTrue: [ ^ 'error' ].
		exampleResult isSuccess ifTrue: [ ^ 'success' ].
		^ 'error'
	] on: Error do: [ :ex | ^ 'error' ]
]
