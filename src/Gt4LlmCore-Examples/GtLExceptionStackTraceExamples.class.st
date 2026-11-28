"
I show the stack traces that the tools give for exceptions ({{gtClass:GtLExceptionStackTrace}}): they stop at the root of the code of the agent (evaluated code, an example, a test) or at the tool, and write blocks briefly.
"
Class {
	#name : #GtLExceptionStackTraceExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Support'
}

{ #category : #examples }
GtLExceptionStackTraceExamples >> blockFramesAreShort [
	"A block frame is written as [] in its home method, without the source of the block"

	<gtExample>
	| blockLines |
	blockLines := self deepStackTrace lines
			select: [ :each | each beginsWith: '[' ].
	self assert: blockLines notEmpty.
	self
		assert: (blockLines
				allSatisfy: [ :each | each = '[] in GtLExceptionStackTraceExamples>>deepStackTraceOfDepth:' ]).
	^ blockLines
]

{ #category : #private }
GtLExceptionStackTraceExamples >> compileBrokenSyntaxWith: aTool [
	"Call the compilation tool with a method that has a syntax error, so that the parser raises inside the code of the tool, and return the lines of the stack trace of that error"

	| call entry |
	call := self
			executeTool: aTool
			withArguments: {'methods'
						-> {{'methodClassName' -> 'GtLExceptionStackTraceDummyExamples'.
									'classSide' -> false.
									'protocol' -> 'examples'.
									'sourceCode' -> 'brokenSyntax ^ (1 +'} asDictionary}} asDictionary.
	entry := ((self jsonOf: call) at: 'methodCompilationResults')
			detect: [ :each | each includesKey: 'errorDetails' ].
	^ self linesOf: ((entry at: 'errorDetails') at: 'stackTrace')
]

{ #category : #examples }
GtLExceptionStackTraceExamples >> deepStackKeepsHeadAndTail [
	"A long stack above its root keeps its first and last frames around a line that counts the others, so that both the failure and the root show"

	<gtExample>
	| trace lines head tail |
	trace := self deepStackTrace.
	lines := trace lines.
	head := GtLExceptionStackTrace headFrames.
	tail := GtLExceptionStackTrace tailFrames.
	self assert: trace frames size > (head + tail + 1).
	self assert: lines size equals: head + 1 + tail + 1.
	self assert: lines first equals: 'ZeroDivide(Exception)>>signal'.
	self
		assert: (lines at: head + 1)
		equals: '... ' , (trace frames size - head - tail) printString , ' frames ...'.
	self
		assert: ((lines copyFrom: head + 2 to: lines size - 1)
				includes: 'GtLExceptionStackTraceExamples>>deepStackKeepsHeadAndTail').
	^ trace
]

{ #category : #private }
GtLExceptionStackTraceExamples >> deepStackTrace [
	"The stack trace of an exception signalled 60 block frames deep"

	^ self deepStackTraceOfDepth: 60
]

{ #category : #private }
GtLExceptionStackTraceExamples >> deepStackTraceOfDepth: aDepth [
	"The stack trace of an exception signalled aDepth block frames deep"

	| recurse exception |
	recurse := nil.
	recurse := [ :aLevel | aLevel = 0 ifTrue: [ 1 / 0 ] ifFalse: [ recurse value: aLevel - 1 ] ].
	exception := [ recurse value: aDepth ]
			on: ZeroDivide
			do: [ :anError | GtSystemUtility freeze: anError ].
	^ GtLExceptionStackTrace forException: exception
]

{ #category : #examples }
GtLExceptionStackTraceExamples >> evaluationErrorStopsAtTheDoIt [
	"The stack of an error in evaluated code ends with its DoIt: the compiler, the tool and what called the tool are counted in a last line"

	<gtExample>
	| lines |
	lines := self stackTraceOfEvaluating: 'nil foo'.
	self
		assert: (lines first: 3)
		equals: #('MessageNotUnderstood(Exception)>>signal' 'UndefinedObject(Object)>>doesNotUnderstand: #foo' 'UndefinedObject>>DoIt').
	self assert: lines size equals: 4.
	self
		assert: ((lines last beginsWith: '... ') and: [ lines last endsWith: ' more frames' ]).
	^ lines
]

{ #category : #examples }
GtLExceptionStackTraceExamples >> exampleCallingAFailingExampleKeepsBoth [
	"An example that calls a failing example keeps both example methods"

	<gtExample>
	| lines |
	lines := self stackTraceOfExampleNamed: #exampleUsingFailingExample.
	self
		assert: (lines copyFrom: lines size - 2 to: lines size - 1)
		equals: #('GtLExceptionStackTraceDummyExamples>>failingExample' 'GtLExceptionStackTraceDummyExamples>>exampleUsingFailingExample').
	self
		assert: (lines noneSatisfy: [ :each | each includesSubstring: 'GtExampleEvaluator' ]).
	^ lines
]

{ #category : #examples }
GtLExceptionStackTraceExamples >> exampleRunFromCodeStopsBeforeTheRunner [
	"An example run from code, through the example runner, stops at the example method: the root is not extended past the runner to the code that ran it"

	<gtExample>
	| anExample exception trace |
	anExample := (GtLExceptionStackTraceDummyExamples >> #failingExample) gtExample
			asExampleWithResult.
	anExample run.
	exception := anExample result returnValue.
	trace := GtLExceptionStackTrace forException: exception.
	self
		assert: trace frames last printString
		equals: 'GtLExceptionStackTraceDummyExamples>>failingExample'.
	self assert: trace omittedCount > 0.
	^ trace
]

{ #category : #examples }
GtLExceptionStackTraceExamples >> failingExampleStopsAtTheExampleMethod [
	"The stack of a failing example ends with the example method: the example runner is counted in a last line"

	<gtExample>
	| lines |
	lines := self stackTraceOfExampleNamed: #failingExample.
	self assert: lines first equals: 'Error(Exception)>>signal'.
	self
		assert: (lines at: lines size - 1)
		equals: 'GtLExceptionStackTraceDummyExamples>>failingExample'.
	self assert: (lines last endsWith: ' more frames').
	self
		assert: (lines noneSatisfy: [ :each | each includesSubstring: 'GtExampleEvaluator' ]).
	^ lines
]

{ #category : #examples }
GtLExceptionStackTraceExamples >> failingTestStopsAtTheTestMethod [
	"The stack of a failing test ends with the test method: the test runner, whose frames are methods of TestCase, is counted in a last line"

	<gtExample>
	| call lines |
	call := self
			executeTool: GtLToolForTestMethodRun new
			withArguments: {'testReference'
						-> {'testClassName' -> 'GtLExampleDummyMixedTest'.
								'methodName' -> 'testError'.
								'classSide' -> false} asDictionary} asDictionary.
	lines := self linesOf: (((self jsonOf: call) at: 'exception') at: 'stackTrace').
	self assert: lines first equals: 'Error(Exception)>>signal'.
	self
		assert: (lines at: lines size - 1)
		equals: 'GtLExampleDummyMixedTest>>testError'.
	self assert: (lines last endsWith: ' more frames').
	self
		assert: (lines noneSatisfy: [ :each | each includesSubstring: '(TestCase)>>' ]).
	^ lines
]

{ #category : #private }
GtLExceptionStackTraceExamples >> frameOf: aReceiver running: aMethod [
	"Return a context of aMethod with aReceiver, made for classifying it, not for running it"

	^ Context
		sender: nil
		receiver: aReceiver
		method: aMethod
		arguments: (Array new: aMethod numArgs)
]

{ #category : #examples }
GtLExceptionStackTraceExamples >> framesAreClassified [
	"Roots, runner frames and tool boundaries, on frames made for the purpose: a runner is recognized on the instance side and on the class side, and the runner frames of a test by the class TestCase that defines their method"

	<gtExample>
	| trace aTest aTool |
	trace := GtLExceptionStackTrace new.
	aTest := GtLExampleDummyMixedTest selector: #testError.
	aTool := GtLMagritteToolForMethodsCompilation new.
	self
		assert: (trace
				isRoot: (self
						frameOf: GtLExceptionStackTraceDummyExamples new
						running: GtLExceptionStackTraceDummyExamples >> #failingExample)).
	self
		assert: (trace
				isRoot: (self frameOf: aTest running: GtLExampleDummyMixedTest >> #testError)).
	self
		assert: (trace
				isRunner: (self frameOf: aTest running: GtLExampleDummyMixedTest >> #testError))
				not.
	self
		assert: (trace isRunner: (self frameOf: aTest running: TestCase >> #performTest)).
	self
		assert: (trace
				isRunner: (self frameOf: GtExampleEvaluator basicNew running: GtExampleProcessor >> #value)).
	self
		assert: (trace
				isRunner: (self
						frameOf: CurrentExecutionEnvironment
						running: CurrentExecutionEnvironment class >> #activate:for:)).
	self
		assert: (trace
				isToolBoundary: (self
						frameOf: aTool
						running: GtLAbstractMagritteFunctionTool >> #performToolCall:inContext:)).
	self
		assert: (trace
				isToolBoundary: (self
						frameOf: aTool
						running: GtLMagritteToolForMethodsCompilation >> #privatePerformToolCall:inContext:))
				not.
	^ trace
]

{ #category : #private }
GtLExceptionStackTraceExamples >> linesOf: aStackTraceString [
	^ aStackTraceString lines asArray
]

{ #category : #examples }
GtLExceptionStackTraceExamples >> nestedEvaluationStopsAtTheInnerDoIt [
	"Code that evaluates code: the root is the DoIt of the inner evaluation, and the compiler frames below it stop the extension to the outer DoIt"

	<gtExample>
	| lines |
	lines := self
			stackTraceOfEvaluating: 'Smalltalk compiler evaluate: ''nil bar'''.
	self
		assert: (lines first: 3)
		equals: #('MessageNotUnderstood(Exception)>>signal' 'UndefinedObject(Object)>>doesNotUnderstand: #bar' 'UndefinedObject>>DoIt').
	self assert: lines size equals: 4.
	^ lines
]

{ #category : #examples }
GtLExceptionStackTraceExamples >> onlyMoreThanOneHiddenFrameIsElided [
	"Up to headFrames + tailFrames + 1 kept frames are all written; with one more, the frames between the first and the last ones are counted in a line"

	<gtExample>
	| limit traces full elided |
	limit := GtLExceptionStackTrace headFrames + GtLExceptionStackTrace tailFrames
			+ 1.
	traces := (20 to: 60) collect: [ :aDepth | self deepStackTraceOfDepth: aDepth ].
	full := traces detect: [ :each | each frames size = limit ].
	elided := traces detect: [ :each | each frames size = (limit + 1) ].
	self
		assert: (full lines reject: [ :each | each beginsWith: '... ' ]) size
		equals: limit.
	self assert: (full lines noneSatisfy: [ :each | each endsWith: ' ...' ]).
	self
		assert: (elided lines at: GtLExceptionStackTrace headFrames + 1)
		equals: '... 2 frames ...'.
	^ {full.
		elided}
]

{ #category : #private }
GtLExceptionStackTraceExamples >> stackTraceOfEvaluating: aCodeString [
	"Evaluate aCodeString with smalltalkCodeEvaluation and return the lines of the stack trace of its error"

	| call |
	call := self
			executeTool: GtLMagritteToolForSmalltalkCodeEvaluation new
			withArguments: {'code' -> aCodeString.
					'bindings' -> #()} asDictionary.
	^ self linesOf: (((self jsonOf: call) at: 'errorDetails') at: 'stackTrace')
]

{ #category : #private }
GtLExceptionStackTraceExamples >> stackTraceOfExampleNamed: aSelector [
	"Run the example of GtLExceptionStackTraceDummyExamples with exampleMethodRun and return the lines of the stack trace of its failure"

	| call json |
	call := self
			executeTool: GtLToolForExampleMethodRun new
			withArguments: {'exampleReference'
						-> {'exampleClassName' -> 'GtLExceptionStackTraceDummyExamples'.
								'methodName' -> aSelector asString.
								'classSide' -> false} asDictionary} asDictionary.
	json := self jsonOf: call.
	^ self linesOf: (((json at: 'result') at: 'objectDetails') at: 'stackTrace')
]

{ #category : #examples }
GtLExceptionStackTraceExamples >> stackWithoutRootOrToolKeepsItsFirstFrames [
	"An exception in another process has neither a root nor a tool: its first frames are kept, and the others counted"

	<gtExample>
	| trace |
	trace := self valueInAnotherProcess: [ self deepStackTrace ].
	self assert: trace frames size equals: GtLExceptionStackTrace fallbackFrames.
	self assert: trace omittedCount > 0.
	self assert: trace lines first equals: 'ZeroDivide(Exception)>>signal'.
	self
		assert: trace lines last
		equals: '... ' , trace omittedCount printString , ' more frames'.
	^ trace
]

{ #category : #examples }
GtLExceptionStackTraceExamples >> testRunDirectlyStopsAtTheTestMethod [
	"A test run with runCase, without a tool, stops at the test method, before the TestCase frames that run it"

	<gtExample>
	| exception trace |
	exception := [ (GtLExampleDummyMixedTest selector: #testError) runCase ]
			on: Error
			do: [ :anError | GtSystemUtility freeze: anError ].
	trace := GtLExceptionStackTrace forException: exception.
	self
		assert: trace frames last printString
		equals: 'GtLExampleDummyMixedTest>>testError'.
	self
		assert: (trace lines noneSatisfy: [ :each | each includesSubstring: '(TestCase)>>' ]).
	^ trace
]

{ #category : #examples }
GtLExceptionStackTraceExamples >> toolErrorInAnExampleKeepsTheExample [
	"Code of the agent that calls a tool, here an example, still shows when the error is in the code of the tool: the frames of the tool, where it performs the call and the example are kept. This holds with no tool below, as when the example runs in a Playground or a build, and with the tool that runs it"

	<gtExample>
	| standalone lines |
	standalone := self
			linesOf: (self
					valueInAnotherProcess: [ GtLExceptionStackTraceDummyExamples new exampleCallingAFailingTool ]).
	self assert: standalone first equals: 'SmaCCParserError(Exception)>>signal'.
	self
		assert: (standalone
				includes: 'GtLMagritteToolForMethodsCompilation(GtLAbstractMagritteFunctionTool)>>performToolCall:inContext:').
	self
		assert: (standalone at: standalone size - 1)
		equals: 'GtLExceptionStackTraceDummyExamples>>exampleCallingAFailingTool'.
	lines := self compileBrokenSyntaxWith: GtLMagritteToolForMethodsCompilation new.
	self
		assert: (lines
				includes: 'GtLMagritteToolForMethodsCompilation(GtLAbstractMagritteFunctionTool)>>performToolCall:inContext:').
	self
		assert: (lines
				anySatisfy: [ :each | each includesSubstring: '>>toolErrorInAnExampleKeepsTheExample' ]).
	self
		assert: (GtLExceptionStackTraceDummyExamples includesSelector: #brokenSyntax) not.
	^ standalone
]

{ #category : #examples }
GtLExceptionStackTraceExamples >> toolErrorWithoutRootStopsAtTheTool [
	"An error in the code of a tool that no code of the agent called, as the MCP server calls tools from its own process, ends with the frame above where the tool performs the call"

	<gtExample>
	| lines |
	lines := self
			valueInAnotherProcess: [ self compileBrokenSyntaxWith: GtLMagritteToolForMethodsCompilation new ].
	self assert: lines first equals: 'SmaCCParserError(Exception)>>signal'.
	self
		assert: (lines at: lines size - 1)
		equals: 'GtLMagritteToolForMethodsCompilation>>privatePerformToolCall:inContext:'.
	self assert: (lines last endsWith: ' more frames').
	^ lines
]

{ #category : #examples }
GtLExceptionStackTraceExamples >> unsignalledExceptionHasAnEmptyStackTrace [
	"An exception that was never signalled has no stack: it is serialized with an empty stack trace instead of raising"

	<gtExample>
	| json |
	json := GtLValueSerializer new
			serializeException: (Error new messageText: 'Never signalled').
	self assert: (json at: 'errorClass') equals: 'Error'.
	self assert: (json at: 'stackTrace') equals: ''.
	self assert: (GtLExceptionStackTrace forException: Error new) lines isEmpty.
	^ json
]

{ #category : #examples }
GtLExceptionStackTraceExamples >> untrimmedFallbackWhenTrimmingRaises [
	"When trimming the stack raises, here because the signaler context is not a context, the stack trace is still given: the frames that can be read, untrimmed, and a last line that says why"

	<gtExample>
	| json lines |
	json := GtLValueSerializer new
			serializeException: GtLExceptionStackTraceDummyError new.
	lines := self linesOf: (json at: 'stackTrace').
	self assert: lines size equals: 2.
	self assert: lines first equals: 'an Object'.
	self assert: (lines last beginsWith: '(stack trimming failed: ').
	self assert: (json at: 'errorClass') equals: 'GtLExceptionStackTraceDummyError'.
	^ json
]

{ #category : #private }
GtLExceptionStackTraceExamples >> valueInAnotherProcess: aBlock [
	"Return the value of aBlock evaluated in a new process, as the MCP server runs tools, so that no code of this example is on its stack. An error in it is raised here, and the process ends either way"

	| done result failure |
	done := Semaphore new.
	[ [ [ result := aBlock value ]
		on: Error
		do: [ :anError | 
			failure := anError description.
			anError return: nil ] ] ensure: [ done signal ] ] fork.
	self assert: (done waitTimeoutMilliseconds: 10000) not.
	failure ifNotNil: [ self error: 'Failed in another process: ' , failure ].
	^ result
]

{ #category : #examples }
GtLExceptionStackTraceExamples >> veryDeepStackCountsAtLeastTheScannedFrames [
	"A stack deeper than the scanned frames is not searched for its root: its first frames are kept, and the last line says that at least the other scanned frames were left out"

	<gtExample>
	| trace |
	trace := self deepStackTraceOfDepth: GtLExceptionStackTrace scannedFrames + 100.
	self assert: trace frames size equals: GtLExceptionStackTrace fallbackFrames.
	self
		assert: trace lines last
		equals: '... at least '
				, (GtLExceptionStackTrace scannedFrames - GtLExceptionStackTrace fallbackFrames)
						printString , ' more frames'.
	^ trace
]
