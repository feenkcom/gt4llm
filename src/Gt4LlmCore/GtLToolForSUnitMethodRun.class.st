Class {
	#name : #GtLToolForSUnitMethodRun,
	#superclass : #GtLAbstractFunctionTool,
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #'as yet unclassified' }
GtLToolForSUnitMethodRun class >> leJsonV4Name [
	^ #gtLToolForSUnitMethodRun
]

{ #category : #visiting }
GtLToolForSUnitMethodRun >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForSUnitMethodRun: self
]

{ #category : #accessing }
GtLToolForSUnitMethodRun >> description [
	^ 'Execute a single SUnit test method on a subclass of TestCase (or other test classes that understand #isTestCase) and report the resulting status.'
]

{ #category : #accessing }
GtLToolForSUnitMethodRun >> name [
	^ 'testMethodRun'
]

{ #category : #accessing }
GtLToolForSUnitMethodRun >> parameters [
	^ #('className' 'methodName')
]

{ #category : #private }
GtLToolForSUnitMethodRun >> privatePerformToolCall: aToolCall [
	| arguments rawClassName rawMethodName className methodName testClass testSelector testCase testCaseWithResult |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].

	rawClassName := arguments
		at: 'className'
		ifAbsent: [ ^ GtLMissingArgumentDomainObject new
			receiverName: self name;
			arguments: arguments;
			missingArgument: 'className' ].
	rawMethodName := arguments
		at: 'methodName'
		ifAbsent: [ ^ GtLMissingArgumentDomainObject new
			receiverName: self name;
			arguments: arguments;
			missingArgument: 'methodName' ].

	className := rawClassName asString.
	methodName := rawMethodName asString.

	testClass := Smalltalk globals
		at: className asSymbol
		ifAbsent: [ ^ GtLMissingDomainObject new objectName: className ].

	(testClass isTestCase)
		ifFalse: [ ^ GtLIncorrectArgumentValueDomainObject new
			argumentName: 'className';
			argumentValue: className;
			expectedArgumentValueKind: 'a subclass of LwTestCase' ].

	testSelector := methodName asSymbol.
	(testClass canUnderstand: testSelector)
		ifFalse: [ ^ GtLMissingDomainObject new
			objectName: ('{1}>>#{2}' format: { testClass name. methodName }) ].

	testCase := testClass selector: testSelector.
	[ testCaseWithResult := testCase gtRunWithExplicitResult ]
		on: Error
		do: [ :ex |
			^ GtLExceptionDomainObject new
				freeze: ex;
				description: ('Running test {1}>>#{2} failed' 
					format: { testClass name. methodName }) ].
	
	^ GtLTestCaseWithResultDomainObject new
		testCaseWithResult: testCaseWithResult
]
