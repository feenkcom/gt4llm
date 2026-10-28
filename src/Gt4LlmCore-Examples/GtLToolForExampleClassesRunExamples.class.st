Class {
	#name : #GtLToolForExampleClassesRunExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
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
	<gsCode: '	| className testClass |
	className := (''ExampleRunDummyExamples_Test'', (UUID new asString36 copyFrom: 1 to: 8)) asSymbol.
	testClass := Object subclass: className instVarNames: #() inDictionary: UserGlobals.
	testClass category: ''Gt4LlmCore-Examples-Temporary''.
	[ #(''successfulExample
	<gtExample>
	^ 42'' ''failingExample
	<gtExample>
	self assert: false'' ''errorExample
	<gtExample>
	self error: ''''Intentional example error'''''' ''skippedExample
	<gtExample>
	<noTest>
	^ 100'') do: [ :source |
		testClass compileMethod: source category: #examples environmentId: 0 ] ]
		on: Error do: [ :ex | UserGlobals removeKey: className. ex pass ].
	^ testClass'>
	"Create a dynamic test class with example methods for testing.
	Returns the created class. Caller is responsible for removing the class."
	| suffix className testClass |
	
	suffix := 'Test', (UUID new asString36 copyFrom: 1 to: 8).
	className := ('ExampleRunDummyExamples_', suffix) asSymbol.
	
	testClass := ((Object << className)
		slots: {};
		package: 'Gt4LlmCore-Examples-Temporary') install.
	
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

{ #category : #private }
GtLToolForExampleClassesRunExamples >> removeDynamicExampleClass: testClass [
	self
		gtDo: [ testClass removeFromSystem ]
		gemstoneDo: [ UserGlobals removeKey: testClass name ifAbsent: [ ] ]
]

{ #category : #examples }
GtLToolForExampleClassesRunExamples >> runExamplesForClass [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForExampleClassesRun new
		withArguments: {
			'classNames' -> {'GtLExampleRunDummyExamples'}
		} asDictionary.
	self
		assertResultStatusesCounts: call result targetObject
		total: 5
		skipped: 5
		success: 0
		failure: 0
		error: 0.
	^ call
]

{ #category : #examples }
GtLToolForExampleClassesRunExamples >> runExamplesForClassWithNoTestPragma [
	<gtExample>
	"GtLExampleRunDummyExamples has examples annotated with <noTest>, which should be reported as skipped"
	| call |
	call := self
		executeTool: GtLToolForExampleClassesRun new
		withArguments: {
			'classNames' -> {'GtLExampleRunDummyExamples'}
		} asDictionary.
	self
		assertResultStatusesCounts: call result targetObject
		total: 5
		skipped: 5
		success: 0
		failure: 0
		error: 0.
	^ call
]

{ #category : #examples }
GtLToolForExampleClassesRunExamples >> runExamplesForDynamicallyCreatedClass [
	<gtExample>
	| testClass call |
	[
		| successExample failureExample errorExample skippedExample className targetObject |
		testClass := self createDynamicExampleClass.
		className := testClass name asString.
		call := self
			executeTool: GtLToolForExampleClassesRun new
			withArguments: {
				'classNames' -> {className}
			} asDictionary.
		targetObject := call result targetObject.
		self
			assertResultStatusesCounts: targetObject
			total: 4
			skipped: 1
			success: 1
			failure: 1
			error: 1.
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
		testClass ifNotNil: [ self removeDynamicExampleClass: testClass ]
	].
	^ call
]

{ #category : #examples }
GtLToolForExampleClassesRunExamples >> runExamplesForEmptyClassNames [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForExampleClassesRun new
		withArguments: {
			'classNames' -> {}
		} asDictionary.
	self
		assertResultStatusesCounts: call result targetObject
		total: 0
		skipped: 0
		success: 0
		failure: 0
		error: 0.
	self assert: call result targetObject notFoundClassNames isEmpty.
	^ call
]

{ #category : #examples }
GtLToolForExampleClassesRunExamples >> runExamplesForMissingClassNames [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForExampleClassesRun new
		withArguments: Dictionary new.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('classNames')
		path: #(nil)
		errorMessage: 'required properties missing [classNames]'.
	^ call
]

{ #category : #examples }
GtLToolForExampleClassesRunExamples >> runExamplesForMultipleClasses [
	<gtExample>
	| call targetObject |
	call := self
		executeTool: GtLToolForExampleClassesRun new
		withArguments: {
			'classNames' -> {
				'GtLExampleRunDummyExamples'.
				'GtLToolForExampleMethodRunExamples'
			}
		} asDictionary.
	targetObject := call result targetObject.
	self
		assertResultStatusesCounts: targetObject
		total: 18
		skipped: 5
		success: 13
		failure: 0
		error: 0.
	^ call
]

{ #category : #examples }
GtLToolForExampleClassesRunExamples >> runExamplesForNilClassNames [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForExampleClassesRun new
		withArguments: {
			'classNames' -> nil
		} asDictionary.
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('classNames')
		errorMessage: '@[classNames] array expected'.
	^ call
]

{ #category : #examples }
GtLToolForExampleClassesRunExamples >> runExamplesSerializesForMcp [
	<gtExample>
	| call content data |
	call := self runExamplesStoresExecutedObjectIds.
	content := call result serializeForMCPResponseOutput.
	self assert: content size equals: 1.
	data := NeoJSONReader fromString: (content first at: 'text').
	self assert: (data at: 'total') equals: 4.
	#('successes' 'failures' 'errors' 'skips') do: [ :key |
		self assert: (data at: key) equals: 1 ].
	self assert: (data at: 'details') size equals: 4.
	(data at: 'details') do: [ :detail |
		self assert: detail notNil.
		self assert: (detail at: 'className') isString.
		(detail at: 'status') = 'skipped'
			ifTrue: [ self assert: (detail at: 'objectId') isNil ]
			ifFalse: [ self assert: (detail at: 'objectId') isString ].
		(#('failure' 'error') includes: (detail at: 'status')) ifTrue: [
			self assert: ((detail at: 'errorDetails') at: 'errorMessage') isString.
			self assert: ((detail at: 'errorDetails') at: 'errorClass') isString ] ].
	^ call
]

{ #category : #examples }
GtLToolForExampleClassesRunExamples >> runExamplesStoresExecutedObjectIds [
	<gtExample>
	| testClass call storage target successful skipped |
	storage := GtLObjectStorage new.
	[
		testClass := self createDynamicExampleClass.
		call := self executeTool: GtLToolForExampleClassesRun new
			withArguments: { 'classNames' -> { testClass name asString } } asDictionary
			inContext: (GtLToolExecutionContext new objectStorage: storage).
		target := call result targetObject.
		self assertResultStatusesCounts: target total: 4 skipped: 1 success: 1 failure: 1 error: 1.
		successful := self findExampleStatusFor: #successfulExample in: target.
		self assert: successful objectId isString.
		self assert: (storage objectAt: successful objectId) equals: 42.
		skipped := self findExampleStatusFor: #skippedExample in: target.
		self assert: skipped objectId isNil.
		target exampleWithStatuses do: [ :status |
			status isSkippedResult ifFalse: [
				self assert: status objectId isString.
				self assert: (storage storedObjectAt: status objectId) reason class equals: GtLStoredObjectExampleMethodReason ] ]
	] ensure: [ testClass ifNotNil: [ self removeDynamicExampleClass: testClass ] ].
	^ call
]

{ #category : #examples }
GtLToolForExampleClassesRunExamples >> runExamplesStoresObjectIds [
	<gtExample>
	"Examples with <noTest> pragma are now skipped and not stored in object storage.
	GtLlmExampleRunDummyExamples has 3 examples all with <noTest>, so all are skipped."
	| objectStorage call |
	objectStorage := GtLObjectStorage new.
	call := self
		executeTool: GtLToolForExampleClassesRun new
		withArguments: {
			'classNames' -> {'GtLExampleRunDummyExamples'}
		} asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self
		assertResultStatusesCounts: call result targetObject
		total: 5
		skipped: 5
		success: 0
		failure: 0
		error: 0.
	call result targetObject exampleWithStatuses do: [ :exampleStatus |
		exampleStatus objectId ifNotNil: [ :objectId |
			self assert: (objectStorage storedObjectAt: objectId) reason class equals: GtLStoredObjectExampleMethodReason ] ].
	^ call
]

{ #category : #examples }
GtLToolForExampleClassesRunExamples >> runExamplesWithMixedExistingAndNonExistingClasses [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForExampleClassesRun new
		withArguments: {
			'classNames' -> {'GtLExampleRunDummyExamples'. 'NonExistingClass123'}
		} asDictionary.
	self
		assertResultStatusesCounts: call result targetObject
		total: 5
		skipped: 5
		success: 0
		failure: 0
		error: 0.
	self assert: call result targetObject notFoundClassNames size equals: 1.
	self assert: (call result targetObject notFoundClassNames includes: 'NonExistingClass123').
	^ call
]

{ #category : #examples }
GtLToolForExampleClassesRunExamples >> runExamplesWithUnknownInputs [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForExampleClassesRun new
		withArguments: {
			'classNames' -> {'NonExistingExampleClass'}
		} asDictionary.
	self
		assertResultStatusesCounts: call result targetObject
		total: 0
		skipped: 0
		success: 0
		failure: 0
		error: 0.
	self assert: call result targetObject notFoundClassNames size equals: 1.
	self assert: call result targetObject notFoundClassNames anyOne equals: 'NonExistingExampleClass'.
	^ call
]
