Class {
	#name : #GtLlmToolForExampleMethodRun,
	#superclass : #GtLlmAbstractFunctionTool,
	#category : #'Gt4Llm-GToolkit-Tools'
}

{ #category : #accessing }
GtLlmToolForExampleMethodRun class >> leJsonV4Name [
	^ #gtLlmToolForExampleRun
]

{ #category : #accessing }
GtLlmToolForExampleMethodRun >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForExampleRun: self
]

{ #category : #accessing }
GtLlmToolForExampleMethodRun >> description [
	^ 'Execute a gtExample method and report if it succeeds, fails, or errors'
]

{ #category : #accessing }
GtLlmToolForExampleMethodRun >> name [
	^ 'exampleMethodRun'
]

{ #category : #accessing }
GtLlmToolForExampleMethodRun >> parameters [
	^ #('className' 'methodName' 'classSide')
]

{ #category : #accessing }
GtLlmToolForExampleMethodRun >> privatePerformToolCall: aToolCall [
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
