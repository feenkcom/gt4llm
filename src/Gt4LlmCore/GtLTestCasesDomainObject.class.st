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

{ #category : #visiting }
GtLTestCasesDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitTestCasesDomainObject: self
]

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
	^ testCases
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
