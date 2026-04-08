Class {
	#name : #GtLToolForExampleClassesRunExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #assertions }
GtLToolForExampleClassesRunExamples >> assertExampleStatus: anExampleStatus hasClassName: aClassName selector: aSelector status: aStatusText objectIdExpected: expectObjectId [
	"Assert the properties from llmJsonObject.
	expectObjectId is a boolean: true means objectId should not be nil, false means it should be nil."
	
	self assert: anExampleStatus exampleWithResult methodClass name asString equals: aClassName.
	self assert: anExampleStatus exampleWithResult selector asString equals: aSelector.
	self assert: anExampleStatus statusText equals: aStatusText.
	expectObjectId
		ifTrue: [ self assert: anExampleStatus objectId isNotNil ]
		ifFalse: [ self assert: anExampleStatus objectId isNil ].
]

{ #category : #assertions }
GtLToolForExampleClassesRunExamples >> assertExampleStatus: anExampleStatus isSuccess: isSuccess isFailure: isFailure isError: isError isSkipped: isSkipped [
	"Assert the boolean state flags of an example status."
	
	self assert: anExampleStatus isSuccessResult equals: isSuccess.
	self assert: anExampleStatus isFailureResult equals: isFailure.
	self assert: anExampleStatus isErrorResult equals: isError.
	self assert: anExampleStatus isSkippedResult equals: isSkipped.
]

{ #category : #assertions }
GtLToolForExampleClassesRunExamples >> assertResultStatusesCounts: aDomainObject total: totalCount skipped: skippedCount success: successCount failure: failureCount error: errorCount [
	"Assert all counts on a GtLExampleWithResultStatusesDomainObject."
	
	self assert: (aDomainObject isKindOf: GtLExampleWithResultStatuses).
	self assert: aDomainObject totalCount equals: totalCount.
	self assert: aDomainObject skippedCount equals: skippedCount.
	self assert: aDomainObject successResultCount equals: successCount.
	self assert: aDomainObject failureResultCount equals: failureCount.
	self assert: aDomainObject errorResultCount equals: errorCount.
	self assert: aDomainObject exampleWithStatuses size equals: totalCount.
]

{ #category : #private }
GtLToolForExampleClassesRunExamples >> createDynamicExampleClass [
	"Create a dynamic test class with example methods for testing.
	Returns the created class. Caller is responsible for removing the class."
	| suffix className testClass |
	
	suffix := 'Test', (UUID new asString36 copyFrom: 1 to: 8).
	className := ('ExampleRunDummyExamples_', suffix) asSymbol.
	
	testClass := Object
		subclass: className
		instanceVariableNames: ''
		classVariableNames: ''
		package: 'Gt4LlmCore-Examples-Temporary'.
	
	"Add example methods without <noTest> pragma"
	testClass compile: 'successfulExample
	<gtExample>
	^ 42' classified: 'examples'.
	testClass compile: 'failingExample
	<gtExample>
	self assert: false.' classified: 'examples'.
	testClass compile: 'errorExample
	<gtExample>
	self error: ''Intentional example error''.' classified: 'examples'.
	testClass compile: 'skippedExample
	<gtExample>
	<noTest>
	^ 100' classified: 'examples'.
	
	^ testClass
]

{ #category : #private }
GtLToolForExampleClassesRunExamples >> findExampleStatusFor: aSelector in: aResultStatusesDomainObject [
	"Find an example status by selector name."
	
	^ aResultStatusesDomainObject exampleWithStatuses 
		detect: [ :es | es exampleWithResult selector = aSelector ]
]

{ #category : #examples }
GtLToolForExampleClassesRunExamples >> runExamplesForClass [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForExampleClassesRun new
		withArguments: {
			'classNames' -> {'GtLlmExampleRunDummyExamples'}
		} asDictionary.
	
	self
		assertResultStatusesCounts: targetObject
		total: 3
		skipped: 3
		success: 0
		failure: 0
		error: 0.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForExampleClassesRunExamples >> runExamplesForClassWithNoTestPragma [
	<gtExample>
	"GtLExampleRunDummyExamples has examples annotated with <noTest>, which should be reported as skipped"
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForExampleClassesRun new
		withArguments: {
			'classNames' -> {'GtLExampleRunDummyExamples'}
		} asDictionary.
	
	self
		assertResultStatusesCounts: targetObject
		total: 5
		skipped: 5
		success: 0
		failure: 0
		error: 0.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForExampleClassesRunExamples >> runExamplesForDynamicallyCreatedClass [
	<gtExample>
	| testClass targetObject |
	
	[
		| successExample failureExample errorExample skippedExample className |
		testClass := self createDynamicExampleClass.
		className := testClass name asString.
		
		"Run examples using the tool"
		targetObject := self
			executeTool: GtLToolForExampleClassesRun new
			withArguments: {
				'classNames' -> {className}
			} asDictionary.
		
		self
			assertResultStatusesCounts: targetObject
			total: 4
			skipped: 1
			success: 1
			failure: 1
			error: 1.
		
		"Assert individual example results - state flags and llmJsonObject properties"
		successExample := self findExampleStatusFor: #successfulExample in: targetObject.
		self assertExampleStatus: successExample isSuccess: true isFailure: false isError: false isSkipped: false.
		self assertExampleStatus: successExample hasClassName: className selector: 'successfulExample' status: 'success' objectIdExpected: false.
		
		failureExample := self findExampleStatusFor: #failingExample in: targetObject.
		self assertExampleStatus: failureExample isSuccess: false isFailure: true isError: false isSkipped: false.
		self assertExampleStatus: failureExample hasClassName: className selector: 'failingExample' status: 'failure' objectIdExpected: false.
		
		errorExample := self findExampleStatusFor: #errorExample in: targetObject.
		self assertExampleStatus: errorExample isSuccess: false isFailure: false isError: true isSkipped: false.
		self assertExampleStatus: errorExample hasClassName: className selector: 'errorExample' status: 'error' objectIdExpected: false.
		
		skippedExample := self findExampleStatusFor: #skippedExample in: targetObject.
		self assertExampleStatus: skippedExample isSuccess: false isFailure: false isError: false isSkipped: true.
		self assertExampleStatus: skippedExample hasClassName: className selector: 'skippedExample' status: 'skipped' objectIdExpected: false.
	] ensure: [
		"Clean up: remove the temporary class"
		testClass ifNotNil: [ testClass removeFromSystem ]
	].
	
	^ targetObject
]

{ #category : #examples }
GtLToolForExampleClassesRunExamples >> runExamplesForEmptyClassNames [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForExampleClassesRun new
		withArguments: {
			'classNames' -> {}
		} asDictionary.
	
	self
		assertResultStatusesCounts: targetObject
		total: 0
		skipped: 0
		success: 0
		failure: 0
		error: 0.
	self assert: targetObject notFoundClassNames isEmpty.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForExampleClassesRunExamples >> runExamplesForMissingClassNames [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForExampleClassesRun new
		withArguments: Dictionary new.
	
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('classNames')
		path: #(nil)
		errorMessage: 'required properties missing [classNames]'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForExampleClassesRunExamples >> runExamplesForMultipleClasses [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForExampleClassesRun new
		withArguments: {
			'classNames' -> {
				'GtLExampleRunDummyExamples'.
				'GtLToolForExampleMethodRunExamples'
			}
		} asDictionary.
	
	self
		assertResultStatusesCounts: targetObject
		total: 17
		skipped: 5
		success: 12
		failure: 0
		error: 0.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForExampleClassesRunExamples >> runExamplesForNilClassNames [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForExampleClassesRun new
		withArguments: {
			'classNames' -> nil
		} asDictionary.
	
	self
		assertJSONSchemaValidationError: targetObject
		withPath: #('classNames')
		errorMessage: '@[classNames] array expected'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForExampleClassesRunExamples >> runExamplesStoresObjectIds [
	<gtExample>
	"Examples with <noTest> pragma are now skipped and not stored in object storage.
	GtLlmExampleRunDummyExamples has 3 examples all with <noTest>, so all are skipped."
	| objectStorage targetObject |
	objectStorage := GtLObjectStorage new.
	
	targetObject := self
		executeTool: GtLToolForExampleClassesRun new
		withArguments: {
			'classNames' -> {'GtLlmExampleRunDummyExamples'}
		} asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	
	self
		assertResultStatusesCounts: targetObject
		total: 3
		skipped: 3
		success: 0
		failure: 0
		error: 0.
	targetObject exampleWithStatuses do: [ :exampleStatus |
		exampleStatus objectId ifNotNil: [ :objectId |
			self assert: (objectStorage storedObjectAt: objectId) reason class equals: GtLStoredObjectExampleMethodReason ] ].
	
	^ targetObject
]

{ #category : #examples }
GtLToolForExampleClassesRunExamples >> runExamplesWithMixedExistingAndNonExistingClasses [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForExampleClassesRun new
		withArguments: {
			'classNames' -> {'GtLlmExampleRunDummyExamples'. 'NonExistingClass123'}
		} asDictionary.
	
	self
		assertResultStatusesCounts: targetObject
		total: 3
		skipped: 3
		success: 0
		failure: 0
		error: 0.
	self assert: targetObject notFoundClassNames size equals: 1.
	self assert: (targetObject notFoundClassNames includes: 'NonExistingClass123').
	
	^ targetObject
]

{ #category : #examples }
GtLToolForExampleClassesRunExamples >> runExamplesWithUnknownInputs [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForExampleClassesRun new
		withArguments: {
			'classNames' -> {'NonExistingExampleClass'}
		} asDictionary.
	
	self
		assertResultStatusesCounts: targetObject
		total: 0
		skipped: 0
		success: 0
		failure: 0
		error: 0.
	self assert: targetObject notFoundClassNames size equals: 1.
	self assert: targetObject notFoundClassNames anyOne equals: 'NonExistingExampleClass'.
	
	^ targetObject
]
