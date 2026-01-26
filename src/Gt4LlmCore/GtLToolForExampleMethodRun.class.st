Class {
	#name : #GtLToolForExampleMethodRun,
	#superclass : #GtLAbstractFunctionTool,
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForExampleMethodRun class >> leJsonV4Name [
	^ #gtLToolForExampleMethodRun
]

{ #category : #accessing }
GtLToolForExampleMethodRun >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForExampleRun: self
]

{ #category : #accessing }
GtLToolForExampleMethodRun >> description [
	^ 'Execute a gtExample method and report:
- status: Succeess, Error, Failure, Skipped.
- result: 
if it succeeds, it gets the resulting object. 
if there is a failure or error it gets the exception object and the stack trace.'
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
	| arguments className targetClass methodName classSideValue method example exampleResult |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	className := arguments
			at: 'className'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: arguments;
					missingArgument: 'className' ].
	targetClass := className
			asClassIfAbsent: [ ^ GtLMissingDomainObject new objectName: className ].
	methodName := arguments
			at: 'methodName'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: arguments;
					missingArgument: 'methodName' ].
	classSideValue := arguments at: 'classSide' ifAbsent: [ false ].
	(#(true 'true' 't' 'yes' 'y') includes: classSideValue)
		ifTrue: [ targetClass := targetClass classSide ].
	method := targetClass
			compiledMethodAt: methodName asSymbol
			ifAbsent: [ ^ GtLMissingDomainObject new
					objectName: ('{1}>>#{2}'
							format: {targetClass.
									methodName}) ].
	(method pragmas anySatisfy: [ :pragma | pragma selector = #gtExample ])
		ifFalse: [ ^ GtLMethodIsNotExampleDomainObject new method: method ].
	example := method gtExample asExampleWithResult.
	example ifNil: [ ^ GtLMethodIsNotExampleDomainObject new method: method ].
	[ exampleResult := example run ]
		on: Error
		do: [ :ex | 
			^ GtLExceptionDomainObject new
				freeze: ex;
				description: ('Example execution failed: {1}' format: {method name}) ].

	^ GtLExampleWithResultDomainObject new exampleWithResult: example
]
