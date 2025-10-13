Class {
	#name : #GtLlmToolForSUnitClassesRun,
	#superclass : #GtLlmAbstractFunctionTool,
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #accessing }
GtLlmToolForSUnitClassesRun class >> leJsonV4Name [
	^ #gtLlmToolForSUnitClassesRun
]

{ #category : #'llm-generated' }
GtLlmToolForSUnitClassesRun >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForSUnitClassesRun: self
]

{ #category : #'llm-generated' }
GtLlmToolForSUnitClassesRun >> description [
	^ 'Execute SUnit test classes and report the aggregated results. The argument `classNames` is mandatory and it must not be empty.

Examples:
- Run one class:
    {"classNames": "SomeTestCase"}
- Run multiple classes:
    {"classNames": "SomeTestCase AnotherTestCase"}'
]

{ #category : #'llm-generated' }
GtLlmToolForSUnitClassesRun >> detailForTest: aTest inResult: aResult [
	| status message |
	(aResult skipped includes: aTest)
		ifTrue: [ status := 'skipped'. message := 'Skipped' ]
		ifFalse: [
			(aResult isError: aTest)
				ifTrue: [ status := 'error'. message := 'Error' ]
				ifFalse: [
					(aResult isFailure: aTest)
						ifTrue: [ status := 'failure'. message := 'Failure' ]
						ifFalse: [
							(aResult isPassed: aTest)
								ifTrue: [ status := 'success'. message := 'Passed' ]
								ifFalse: [ status := 'unknown'. message := 'Unknown status' ] ] ] ].
	^ {
		'className' -> aTest class name asString.
		'selector' -> (aTest selector ifNil: [ '' ] ifNotNil: #asString).
		'status' -> status.
		'result' -> message.
		'shouldPass' -> aTest shouldPass.
		'expectedFailure' -> aTest isExpectedFailure } asDictionary
]

{ #category : #'llm-generated' }
GtLlmToolForSUnitClassesRun >> name [
	^ 'testsInClassesRun'
]

{ #category : #'llm-generated' }
GtLlmToolForSUnitClassesRun >> normalizedClassNamesFrom: rawValue [
	| items result |
	rawValue ifNil: [ ^ #() ].
	items := (rawValue isString or: [ rawValue isSymbol ])
		ifTrue: [ { rawValue } ]
		ifFalse: [ rawValue isCollection
			ifTrue: [ rawValue asArray ]
			ifFalse: [ { rawValue } ] ].
	result := OrderedCollection new.
	items do: [ :each |
		each ifNotNil: [
			(each asString findTokens: Character space)
				do: [ :token | | trimmed |
					trimmed := token withBlanksTrimmed.
					trimmed isEmpty ifFalse: [ result add: trimmed ] ] ] ].
	^ result asArray
]

{ #category : #'llm-generated' }
GtLlmToolForSUnitClassesRun >> parameters [
	^ #('classNames')
]

{ #category : #'llm-generated' }
GtLlmToolForSUnitClassesRun >> privatePerformToolCall: aToolCall [
	| arguments rawClassNames classNames details notFound totalRunCount totalSuccessCount totalFailureCount totalErrorCount totalSkippedCount totalUnexpectedPassCount totalUnexpectedFailureCount totalUnexpectedErrorCount totalExpectedPassCount totalExpectedDefectCount summary |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	rawClassNames := arguments at: 'classNames' ifAbsent: [ ^ 'classNames is not provided' ].
	classNames := rawClassNames findTokens: String space.
	classNames isEmpty ifTrue: [ ^ 'classNames is empty' ].
	details := OrderedCollection new.
	notFound := OrderedCollection new.
	totalRunCount := 0.
	totalSuccessCount := 0.
	totalFailureCount := 0.
	totalErrorCount := 0.
	totalSkippedCount := 0.
	totalUnexpectedPassCount := 0.
	totalUnexpectedFailureCount := 0.
	totalUnexpectedErrorCount := 0.
	totalExpectedPassCount := 0.
	totalExpectedDefectCount := 0.
	classNames do: [ :className |
		Smalltalk globals
			at: className asSymbol
			ifPresent: [ :class |
				(class inheritsFrom: TestCase)
					ifFalse: [ notFound add: {
						'type' -> 'class'.
						'name' -> className asString.
						'reason' -> 'Class is not a TestCase subclass' } asDictionary ]
					ifTrue: [ | result |
						result := class suite run.
						totalRunCount := totalRunCount + result runCount.
						totalSuccessCount := totalSuccessCount + result passedCount.
						totalFailureCount := totalFailureCount + result failureCount.
						totalErrorCount := totalErrorCount + result errorCount.
						totalSkippedCount := totalSkippedCount + result skippedCount.
						totalUnexpectedPassCount := totalUnexpectedPassCount + result unexpectedPassCount.
						totalUnexpectedFailureCount := totalUnexpectedFailureCount + result unexpectedFailureCount.
						totalUnexpectedErrorCount := totalUnexpectedErrorCount + result unexpectedErrorCount.
						totalExpectedPassCount := totalExpectedPassCount + result expectedPassCount.
						totalExpectedDefectCount := totalExpectedDefectCount + result expectedDefectCount.
						result tests do: [ :test | details add: (self detailForTest: test inResult: result) ] ] ]
			ifAbsent: [ notFound add: {
				'type' -> 'class'.
				'name' -> className asString.
				'reason' -> 'Class not found' } asDictionary ] ].
	summary := {
		'runCount' -> totalRunCount.
		'successes' -> totalSuccessCount.
		'failures' -> totalFailureCount.
		'errors' -> totalErrorCount.
		'skips' -> totalSkippedCount.
		'unexpectedPasses' -> totalUnexpectedPassCount.
		'unexpectedFailures' -> totalUnexpectedFailureCount.
		'unexpectedErrors' -> totalUnexpectedErrorCount.
		'expectedPasses' -> totalExpectedPassCount.
		'expectedDefects' -> totalExpectedDefectCount.
		'details' -> details asArray.
		'notFound' -> notFound asArray } asDictionary.
	^ NeoJSONWriter toString: summary
]
