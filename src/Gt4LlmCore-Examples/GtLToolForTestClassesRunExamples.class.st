Class {
	#name : #GtLToolForTestClassesRunExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #private }
GtLToolForTestClassesRunExamples >> assertResultStatusesCounts: aDomainObject total: totalCount skipped: skippedCount success: successCount failure: failureCount error: errorCount [
	"Assert all counts on a GtLTestCasesWithResultStatuses."
	
	self assert: (aDomainObject isKindOf: GtLTestCasesWithResultStatuses).
	self assert: aDomainObject runCount equals: (successCount + failureCount + errorCount).
	self assert: aDomainObject skippedCount equals: skippedCount.
	self assert: aDomainObject passedCount equals: successCount.
	self assert: aDomainObject failureCount equals: failureCount.
	self assert: aDomainObject errorCount equals: errorCount.
	self assert: aDomainObject testCases size equals: totalCount.
]

{ #category : #examples }
GtLToolForTestClassesRunExamples >> runTestsForEmptyClassNames [
	<gtExample>
	| call targetObject |
	
	call := self
		executeTool: GtLToolForTestClassesRun new
		withArguments: {
			'classNames' -> {}
		} asDictionary.
	targetObject := call result targetObject.
	
	self
		assertResultStatusesCounts: targetObject
		total: 0
		skipped: 0
		success: 0
		failure: 0
		error: 0.
	self assert: targetObject notFoundClassNames isEmpty.
	self assert: targetObject notTestCaseClasses isEmpty.
	
	^ call
]

{ #category : #examples }
GtLToolForTestClassesRunExamples >> runTestsForMissingClassNames [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForTestClassesRun new
		withArguments: Dictionary new.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('classNames')
		path: #(nil)
		errorMessage: 'required properties missing [classNames]'.
	^ call
]

{ #category : #examples }
GtLToolForTestClassesRunExamples >> runTestsForMultipleClasses [
	<gtExample>
	| call targetObject |
	
	call := self
		executeTool: GtLToolForTestClassesRun new
		withArguments: {
			'classNames' -> {'GtLExampleDummyPassingTest'. 'GtLExampleDummyMixedTest'}
		} asDictionary.
	targetObject := call result targetObject.
	
	self
		assertResultStatusesCounts: targetObject
		total: 7
		skipped: 1
		success: 2
		failure: 2
		error: 2.
	
	^ call
]

{ #category : #examples }
GtLToolForTestClassesRunExamples >> runTestsForNilClassNames [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForTestClassesRun new
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
GtLToolForTestClassesRunExamples >> runTestsForSingleClass [
	<gtExample>
	| call targetObject |
	
	call := self
		executeTool: GtLToolForTestClassesRun new
		withArguments: {
			'classNames' -> {'GtLExampleDummyPassingTest'}
		} asDictionary.
	targetObject := call result targetObject.
	
	self
		assertResultStatusesCounts: targetObject
		total: 1
		skipped: 0
		success: 1
		failure: 0
		error: 0.
	
	^ call
]

{ #category : #examples }
GtLToolForTestClassesRunExamples >> runTestsWithMixedExistingAndNonExistingClasses [
	<gtExample>
	| call targetObject |
	
	call := self
		executeTool: GtLToolForTestClassesRun new
		withArguments: {
			'classNames' -> {'GtLExampleDummyPassingTest'. 'NonExistingClass123'}
		} asDictionary.
	targetObject := call result targetObject.
	
	self
		assertResultStatusesCounts: targetObject
		total: 1
		skipped: 0
		success: 1
		failure: 0
		error: 0.
	self assert: targetObject notFoundClassNames size equals: 1.
	self assert: (targetObject notFoundClassNames includes: 'NonExistingClass123').
	
	^ call
]

{ #category : #examples }
GtLToolForTestClassesRunExamples >> runTestsWithUnknownInputs [
	<gtExample>
	| call targetObject |
	
	call := self
		executeTool: GtLToolForTestClassesRun new
		withArguments: {
			'classNames' -> {'NonExistingSUnitClass'. 'Object'}
		} asDictionary.
	targetObject := call result targetObject.
	
	self
		assertResultStatusesCounts: targetObject
		total: 0
		skipped: 0
		success: 0
		failure: 0
		error: 0.
	self assert: targetObject notFoundClassNames size equals: 1.
	self assert: targetObject notFoundClassNames anyOne equals: 'NonExistingSUnitClass'.
	self assert: targetObject notTestCaseClasses size equals: 1.
	self assert: targetObject notTestCaseClasses anyOne equals: Object.
	
	^ call
]
