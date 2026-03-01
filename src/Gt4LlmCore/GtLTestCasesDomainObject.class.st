Class {
	#name : #GtLTestCasesDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'testCases',
		'notFoundClassNames',
		'notTestCaseClasses'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLTestCasesDomainObject >> errorCount [
	^ self testCases count: #isErrorResult
]

{ #category : #accessing }
GtLTestCasesDomainObject >> expectedDefectCount [
	^ self testCases count: #isExpectedDefectResult
]

{ #category : #accessing }
GtLTestCasesDomainObject >> expectedPassCount [
	^ self testCases count: #isExpectedPassResult
]

{ #category : #accessing }
GtLTestCasesDomainObject >> failureCount [
	^ self testCases count: #isFailureResult
]

{ #category : #'gt - extensions' }
GtLTestCasesDomainObject >> gtTestCasesFor: aView [
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

{ #category : #accessing }
GtLTestCasesDomainObject >> notFoundClassNames [
	^ notFoundClassNames ifNil: [ #() ]
]

{ #category : #accessing }
GtLTestCasesDomainObject >> notFoundClassNames: anObject [
	notFoundClassNames := anObject
]

{ #category : #accessing }
GtLTestCasesDomainObject >> notTestCaseClasses [
	^ notTestCaseClasses ifNil: [ #() ]
]

{ #category : #accessing }
GtLTestCasesDomainObject >> notTestCaseClasses: anObject [
	notTestCaseClasses := anObject
]

{ #category : #accessing }
GtLTestCasesDomainObject >> passedCount [
	^ self testCases count: #isPassedResult
]

{ #category : #accessing }
GtLTestCasesDomainObject >> runCount [
	^ self passedCount + self failureCount + self errorCount
]

{ #category : #'api - serializing' }
GtLTestCasesDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
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
			put: (self testCases collect: #serializeToOpenAIResponseJsonObject as: Array);
		yourself
]

{ #category : #accessing }
GtLTestCasesDomainObject >> skippedCount [
	^ self testCases count: #isSkippedResult
]

{ #category : #accessing }
GtLTestCasesDomainObject >> testCases [
	<return: #Array of: #GtLTestCaseDomainObject>
	^ testCases ifNil: [ #() ]
]

{ #category : #accessing }
GtLTestCasesDomainObject >> testCases: anObject [
	testCases := anObject
]

{ #category : #accessing }
GtLTestCasesDomainObject >> unexpectedErrorCount [
	^ self testCases count: #isUnexpectedErrorResult
]

{ #category : #accessing }
GtLTestCasesDomainObject >> unexpectedFailureCount [
	^ self testCases count: #isUnexpectedFailureResult
]

{ #category : #accessing }
GtLTestCasesDomainObject >> unexpectedPassCount [
	^ self testCases count: #isUnexpectedPassResult
]
