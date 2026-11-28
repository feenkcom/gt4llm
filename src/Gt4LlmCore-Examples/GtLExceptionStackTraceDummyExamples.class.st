"
I hold failing examples for GtLExceptionStackTraceExamples, kept out of the normal example runs with <noTest>.
"
Class {
	#name : #GtLExceptionStackTraceDummyExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Support'
}

{ #category : #examples }
GtLExceptionStackTraceDummyExamples >> exampleCallingAFailingTool [
	"An example that calls a tool whose own code raises (the parser, for a syntax error), and returns the stack trace that the tool gives for it"

	<gtExample>
	<noTest>
	| call |
	call := GtLFunctionToolCall new
			rawArguments: {'methods'
						-> {{'methodClassName' -> self class name asString.
									'classSide' -> false.
									'protocol' -> 'examples'.
									'sourceCode' -> 'brokenSyntax ^ (1 +'} asDictionary}} asDictionary.
	GtLMagritteToolForMethodsCompilation new performToolCall: call.
	^ ((NeoJSONReader
		fromString: (call result serializeForMCPResponseOutput first at: 'text'))
		at: 'methodCompilationResults')
		detect: [ :each | each includesKey: 'errorDetails' ]
		ifFound: [ :each | (each at: 'errorDetails') at: 'stackTrace' ]
		ifNone: [ nil ]
]

{ #category : #examples }
GtLExceptionStackTraceDummyExamples >> exampleUsingFailingExample [
	"An example that calls a failing example"

	<gtExample>
	<noTest>
	^ self failingExample
]

{ #category : #examples }
GtLExceptionStackTraceDummyExamples >> failingExample [
	<gtExample>
	<noTest>
	self error: 'Intentional example error'
]
