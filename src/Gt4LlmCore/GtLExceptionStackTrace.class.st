"
I am the stack trace that the tools give for an exception: the frames from where the exception was signalled down to the root of the code that the agent ran, not the frames of the tool, the example runner, the MCP server or the thread pool below it. {{gtMethod:GtLExceptionStackTrace class>>#stackTraceStringOf:}} answers it as text for {{gtMethod:GtLValueSerializer>>#serializeException:}} and never raises.

I keep the frames from the signal down to ({{gtMethod:GtLExceptionStackTrace>>#endIndexIn:}}):
- the first root: the DoIt of evaluated code, a method with <gtExample> or a test method. From it I extend to the next roots reached with no runner frame in between (an example or test runner, the compiler, a tool; see {{gtMethod:GtLExceptionStackTrace class>>#runnerClasses}}), so that an example that calls a failing example keeps both. Code of the agent that calls a tool keeps showing when the error is inside the tool;
- without a root, the frame above where a tool performs its call (performToolCall:inContext:), for an error in the code of a tool that the MCP server called;
- without either, as in another process, the first frames.

A long stack keeps its first and last frames around a line that counts the others, and a last line counts the frames below the cut. A block frame is written as [] in its home method, without the source of the block. Class-side frames count as frames of their class ({{gtMethod:GtLExceptionStackTrace>>#receiverBehaviorOf:}}).
"
Class {
	#name : #GtLExceptionStackTrace,
	#superclass : #Object,
	#instVars : [
		'frames',
		'omittedCount',
		'scanIsComplete'
	],
	#category : #'Gt4LlmCore-Support'
}

{ #category : #accessing }
GtLExceptionStackTrace class >> fallbackFrames [
	"The frames kept when the stack has neither a root nor a tool boundary"

	^ 30
]

{ #category : #'instance creation' }
GtLExceptionStackTrace class >> forContext: aSignalerContextOrNil [
	^ self new initializeFromContext: aSignalerContextOrNil
]

{ #category : #'instance creation' }
GtLExceptionStackTrace class >> forException: anException [
	"An exception that was never signalled has no stack: its trace is empty"

	^ self forContext: (self signalerContextOf: anException)
]

{ #category : #accessing }
GtLExceptionStackTrace class >> headFrames [
	"The first frames written when a long stack is elided"

	^ 30
]

{ #category : #accessing }
GtLExceptionStackTrace class >> runnerClasses [
	"The classes whose frames run the code of the agent: a root is not extended past them"

	^ {GtExampleProcessor.
		TestResult.
		ExecutionEnvironment.
		CurrentExecutionEnvironment.
		OpalCompiler.
		OCDoItSemanticScope.
		GtLAbstractFunctionTool}
]

{ #category : #accessing }
GtLExceptionStackTrace class >> scannedFrames [
	"The frames read from the signal, which bounds the work for a very deep stack"

	^ 1000
]

{ #category : #private }
GtLExceptionStackTrace class >> signalerContextOf: anException [
	"Return the context that signalled anException, or nil when it was never signalled (signalerContext then raises)"

	^ [ anException signalerContext ] on: Error do: [ :anError | nil ]
]

{ #category : #private }
GtLExceptionStackTrace class >> stackStringOf: anException [
	^ [ (anException stackString ifNil: [ '' ]) takeFirst: 1000 ]
		on: Error
		do: [ :anError | '' ]
]

{ #category : #printing }
GtLExceptionStackTrace class >> stackTraceStringOf: anException [
	"Return the stack trace of anException as the tools give it. This never raises, so that an error is always reported: an exception that was never signalled has no context and gives its stack string, and when trimming raises, the first frames are given untrimmed with a line that says why"

	| aContext |
	aContext := self signalerContextOf: anException.
	aContext ifNil: [ ^ self stackStringOf: anException ].
	^ [ (self forContext: aContext) stackTraceString ]
		on: Error
		do: [ :anError | self untrimmedStackTraceFrom: aContext failure: anError ]
]

{ #category : #accessing }
GtLExceptionStackTrace class >> tailFrames [
	"The last frames written when a long stack is elided"

	^ 10
]

{ #category : #private }
GtLExceptionStackTrace class >> untrimmedStackTraceFrom: aContext failure: anError [
	"Return the first fallbackFrames frames, each written on its own so that one frame that cannot be written does not lose the others, and a last line that says why the stack was not trimmed"

	| aTrace theFrames reason |
	aTrace := self new.
	theFrames := [ aContext stackOfSize: self fallbackFrames ]
			on: Error
			do: [ :aStackError | {aContext} ].
	reason := [ anError messageText asString ]
			on: Error
			do: [ :aTextError | anError class name asString ].
	^ String lf
		join: (theFrames collect: [ :each | aTrace safeLineFor: each ])
				, {'(stack trimming failed: ' , reason , ')'}
]

{ #category : #printing }
GtLExceptionStackTrace >> countText: aNumber [
	^ aNumber printString , ' ' , ('frame' asPluralBasedOn: aNumber)
]

{ #category : #private }
GtLExceptionStackTrace >> endIndexIn: theFrames [
	"Return the index of the last frame to keep: the root of the code of the agent wherever it is; without a root, the frame above the first tool boundary, and at least the first frame; without either, the last of the first frames"

	| root boundary |
	root := self rootIndexIn: theFrames.
	root > 0 ifTrue: [ ^ root ].
	boundary := self toolBoundaryIndexIn: theFrames.
	boundary > 0 ifTrue: [ ^ boundary - 1 max: 1 ].
	^ theFrames size min: self class fallbackFrames
]

{ #category : #accessing }
GtLExceptionStackTrace >> frames [
	"Return the frames I keep, from the signal down"

	^ frames
]

{ #category : #views }
GtLExceptionStackTrace >> gtFramesFor: aView [
	<gtView>
	^ aView list
		title: 'Frames';
		priority: 2;
		items: [ frames ];
		itemText: [ :each | self lineFor: each ]
]

{ #category : #views }
GtLExceptionStackTrace >> gtStackTraceFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Stack trace';
		priority: 1;
		text: [ self stackTraceString ]
]

{ #category : #printing }
GtLExceptionStackTrace >> hiddenCount [
	"Return how many kept frames a long stack does not write, between its first and last frames"

	^ frames size - self class headFrames - self class tailFrames
]

{ #category : #initialization }
GtLExceptionStackTrace >> initialize [
	super initialize.
	frames := #().
	omittedCount := 0.
	scanIsComplete := true
]

{ #category : #initialization }
GtLExceptionStackTrace >> initializeFromContext: aSignalerContextOrNil [
	| allFrames end |
	aSignalerContextOrNil ifNil: [ ^ self ].
	allFrames := (aSignalerContextOrNil stackOfSize: self class scannedFrames)
			asArray.
	end := self endIndexIn: allFrames.
	frames := allFrames first: end.
	omittedCount := allFrames size - end.
	scanIsComplete := allFrames size < self class scannedFrames
			or: [ allFrames last sender isNil ]
]

{ #category : #testing }
GtLExceptionStackTrace >> isRoot: aContext [
	"Return whether aContext runs the code that the agent asked for: evaluated code (a DoIt), an example method or a test method"

	| aMethod |
	aContext isBlockContext ifTrue: [ ^ false ].
	aMethod := aContext method.
	^ aMethod isDoIt
		or: [ (aMethod hasPragmaNamed: #gtExample) or: [ aMethod isTestMethod ] ]
]

{ #category : #testing }
GtLExceptionStackTrace >> isRunner: aContext [
	"Return whether aContext belongs to what runs the code of the agent: an example or test runner, the compiler or a tool, on the instance or the class side. The runner frames of a test, such as TestCase>>#performTest, have a test case as receiver, as the test method has: they are told apart by the class that defines the method"

	| aBehavior |
	aBehavior := self receiverBehaviorOf: aContext.
	(self class runnerClasses
		anySatisfy: [ :aClass | aBehavior includesBehavior: aClass ])
		ifTrue: [ ^ true ].
	^ aContext method methodClass == TestCase
]

{ #category : #testing }
GtLExceptionStackTrace >> isToolBoundary: aContext [
	"Return whether aContext is where a tool performs a call: the frames below belong to whoever called the tool"

	aContext isBlockContext ifTrue: [ ^ false ].
	aContext method selector = #performToolCall:inContext: ifFalse: [ ^ false ].
	^ aContext receiver class includesBehavior: GtLAbstractFunctionTool
]

{ #category : #printing }
GtLExceptionStackTrace >> lineFor: aContext [
	"A method frame as the debugger writes it; a block frame as [] in its home method, without the source of the block"

	aContext isBlockContext ifFalse: [ ^ aContext printString ].
	^ '[] in '
		, (aContext home
				ifNil: [ aContext method method printString ]
				ifNotNil: [ :aHome | aHome printString ])
]

{ #category : #accessing }
GtLExceptionStackTrace >> lines [
	"Return one line per kept frame. A long stack keeps its first and last frames around a line that counts the others; when frames were left out below, a last line counts them"

	| result |
	result := OrderedCollection new.
	self hiddenCount > 1
		ifTrue: [ result
				addAll: (self linesFor: (frames first: self class headFrames));
				add: '... ' , (self countText: self hiddenCount) , ' ...';
				addAll: (self linesFor: (frames last: self class tailFrames)) ]
		ifFalse: [ result addAll: (self linesFor: frames) ].
	omittedCount > 0
		ifTrue: [ result
				add: '... ' , (scanIsComplete ifTrue: [ '' ] ifFalse: [ 'at least ' ])
						, omittedCount printString , ' more '
						, ('frame' asPluralBasedOn: omittedCount) ].
	^ result asArray
]

{ #category : #printing }
GtLExceptionStackTrace >> linesFor: theFrames [
	^ theFrames collect: [ :each | self lineFor: each ]
]

{ #category : #accessing }
GtLExceptionStackTrace >> omittedCount [
	"Return the number of frames below the ones I keep, as far as the stack was read"

	^ omittedCount
]

{ #category : #printing }
GtLExceptionStackTrace >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		print: frames size;
		nextPutAll: ' kept, ';
		print: omittedCount;
		nextPutAll: ' omitted)'
]

{ #category : #testing }
GtLExceptionStackTrace >> receiverBehaviorOf: aContext [
	"Return the class of the receiver of aContext, or the receiver itself when it is a class, so that class-side frames (such as CurrentExecutionEnvironment class>>#activate:for:) count as frames of their class. Only #class is sent to the receiver, which every object understands, proxies included"

	| aClass |
	aClass := aContext receiver class.
	^ aClass isMeta ifTrue: [ aClass instanceSide ] ifFalse: [ aClass ]
]

{ #category : #private }
GtLExceptionStackTrace >> rootIndexIn: theFrames [
	"Return the index of the first root, extended to the next roots that are reached without a runner frame in between, or 0"

	| root |
	root := 0.
	theFrames
		withIndexDo: [ :aFrame :anIndex | 
			(self isRoot: aFrame)
				ifTrue: [ root := anIndex ]
				ifFalse: [ (root > 0 and: [ self isRunner: aFrame ]) ifTrue: [ ^ root ] ] ].
	^ root
]

{ #category : #printing }
GtLExceptionStackTrace >> safeLineFor: aFrame [
	"Return the line of aFrame, or its print string if that fails, or a placeholder"

	^ [ self lineFor: aFrame ]
		on: Error
		do: [ :anError | 
			[ aFrame printString ]
				on: Error
				do: [ :aPrintError | '(a frame that cannot be printed)' ] ]
]

{ #category : #accessing }
GtLExceptionStackTrace >> stackTraceString [
	"Return my lines separated by line feeds, as the tools give the stack trace"

	^ String lf join: self lines
]

{ #category : #private }
GtLExceptionStackTrace >> toolBoundaryIndexIn: theFrames [
	"Return the index of the first frame where a tool performs a call, or 0"

	^ theFrames findFirst: [ :aFrame | self isToolBoundary: aFrame ]
]
