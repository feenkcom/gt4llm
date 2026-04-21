Class {
	#name : #GtLTestCasesWithResultStatuses,
	#superclass : #Object,
	#instVars : [
		'testCases',
		'notFoundClassNames',
		'notTestCaseClasses'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLTestCasesWithResultStatuses >> errorCount [
	^ self testCases count: #isErrorResult
]

{ #category : #accessing }
GtLTestCasesWithResultStatuses >> expectedDefectCount [
	^ self testCases count: #isExpectedDefectResult
]

{ #category : #accessing }
GtLTestCasesWithResultStatuses >> expectedPassCount [
	^ self testCases count: #isExpectedPassResult
]

{ #category : #accessing }
GtLTestCasesWithResultStatuses >> failureCount [
	^ self testCases count: #isFailureResult
]

{ #category : #'gt - extensions' }
GtLTestCasesWithResultStatuses >> gtTestCasesFor: aView [
	<gtView>
	<gtLlmView>
	testCases ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'TestCases';
		items: [ self testCases ];
		column: 'Class'
			text: [ :eachTestCase | eachTestCase testCase class ]
			weight: 2;
		column: 'Method'
			text: [ :eachTestCase | eachTestCase testCase selector ]
			weight: 2;
		column: 'State' text: [ :eachTestCase | eachTestCase statusText ];
		column: 'Expected defect'
			text: [ :eachTestCase | 
				GtPhlowOverviewItem new
					boolean: eachTestCase isExpectedDefectResult;
					description ]
]

{ #category : #'api - serializing' }
GtLTestCasesWithResultStatuses >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView 
			title: 'Example results';
			jsonObject: [ :json | 
				json 
					at: #runCount put: self runCount;
					at: #successes put: self passedCount;
					at: #failures put: self failureCount;
					at: #errors put: self errorCount;
					at: #skips put: self skippedCount;
					at: #unexpectedPasses put: self unexpectedPassCount;
					at: #unexpectedFailures put: self unexpectedFailureCount;
					at: #unexpectedErrors put: self unexpectedErrorCount;
					at: #expectedPasses put: self expectedPassCount;
					at: #expectedDefects put: self expectedDefectCount;
					at: #notFound put: self notFoundClassNames;
					at: #notTestCaseClasses put: self notTestCaseClasses;
					at: #details
						put: (self testCases 
							collect: [ :each | each serializeToLlmJsonObject] 
							as: Array);
					yourself ]
]

{ #category : #accessing }
GtLTestCasesWithResultStatuses >> notFoundClassNames [
	^ notFoundClassNames ifNil: [ #() ]
]

{ #category : #accessing }
GtLTestCasesWithResultStatuses >> notFoundClassNames: anObject [
	notFoundClassNames := anObject
]

{ #category : #accessing }
GtLTestCasesWithResultStatuses >> notTestCaseClasses [
	^ notTestCaseClasses ifNil: [ #() ]
]

{ #category : #accessing }
GtLTestCasesWithResultStatuses >> notTestCaseClasses: anObject [
	notTestCaseClasses := anObject
]

{ #category : #accessing }
GtLTestCasesWithResultStatuses >> passedCount [
	^ self testCases count: #isPassedResult
]

{ #category : #accessing }
GtLTestCasesWithResultStatuses >> runCount [
	^ self passedCount + self failureCount + self errorCount
]

{ #category : #accessing }
GtLTestCasesWithResultStatuses >> skippedCount [
	^ self testCases count: #isSkippedResult
]

{ #category : #accessing }
GtLTestCasesWithResultStatuses >> testCases [
	<return: #Array of: #GtLTestCaseWithResultStatus>
	^ testCases ifNil: [ #() ]
]

{ #category : #accessing }
GtLTestCasesWithResultStatuses >> testCases: anObject [
	testCases := anObject
]

{ #category : #accessing }
GtLTestCasesWithResultStatuses >> unexpectedErrorCount [
	^ self testCases count: #isUnexpectedErrorResult
]

{ #category : #accessing }
GtLTestCasesWithResultStatuses >> unexpectedFailureCount [
	^ self testCases count: #isUnexpectedFailureResult
]

{ #category : #accessing }
GtLTestCasesWithResultStatuses >> unexpectedPassCount [
	^ self testCases count: #isUnexpectedPassResult
]
