Class {
	#name : #GtLToolForTestMethodRunExamples,
	#superclass : #Object,
	#instVars : [
		'environment'
	],
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #'tear down' }
GtLToolForTestMethodRunExamples >> cleanUp [
	environment ifNotNil: [ :anEnvironment | anEnvironment removeFromSystem ]
]

{ #category : #utils }
GtLToolForTestMethodRunExamples >> environment [
	^ environment
		ifNil: [ environment := GtPharoDummiesGenerator new
					amountOfPackages: 1;
					amountOfClasses: 1;
					amountOfMethods: 0;
					generate ]
]

{ #category : #examples }
GtLToolForTestMethodRunExamples >> exampleRunError [
	<gtExample>
	<after: #cleanUp>
	| tool call result tagetClass |
	tool := GtLToolForTestMethodRun new.
	call := GtLFunctionToolCall new.
	
	tagetClass := self environment anyDummyClass realClass.
	tagetClass  superclass: TestCase.
	tagetClass compile: 'testError
	self error: ''an error'''.
	
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> tagetClass name.
			'methodName' -> 'testError'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result isErrorResult.
	self assert: result statusText equals: 'error'.
	^ call
]

{ #category : #examples }
GtLToolForTestMethodRunExamples >> exampleRunFailure [
	<gtExample>
	<after: #cleanUp>
	| tool call result tagetClass |
	tool := GtLToolForTestMethodRun new.
	call := GtLFunctionToolCall new.
	
	tagetClass := self environment anyDummyClass realClass.
	tagetClass  superclass: TestCase.
	tagetClass compile: 'testFail
	self assert: false.'.
	
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> tagetClass name.
			'methodName' -> 'testFail'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result isFailureResult.
	self assert: result statusText equals: 'failure'.
	^ call
]

{ #category : #examples }
GtLToolForTestMethodRunExamples >> exampleRunForNonTestCaseClass [
	<gtExample>
	| tool call result |
	tool := GtLToolForTestMethodRun new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> 'Object'.
			'methodName' -> 'printString'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self assert: result argumentName equals: 'className'.
	self assert: result expectedArgumentValueKind equals: 'a subclass of LwTestCase'.
	^ call
]

{ #category : #examples }
GtLToolForTestMethodRunExamples >> exampleRunSuccess [
	<gtExample>
	| tool call result |
	tool := GtLToolForTestMethodRun new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> 'GtRrSampleTest'.
			'methodName' -> 'testPass'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result isSuccessResult.
	self assert: result statusText equals: 'success'.
	^ call
]
