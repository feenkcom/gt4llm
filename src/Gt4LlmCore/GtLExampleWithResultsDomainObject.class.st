Class {
	#name : #GtLExampleWithResultsDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'exampleWithResults',
		'notFoundClassNames'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLExampleWithResultsDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitExampleWithResultsDomainObject: self
]

{ #category : #'api - accessing' }
GtLExampleWithResultsDomainObject >> errorResultCount [
	^ self exampleWithResults count: #isErrorResult
]

{ #category : #accessing }
GtLExampleWithResultsDomainObject >> exampleWithResults [
	<return: #Collection of: #GtLExampleWithResultDomainObject>
	^ exampleWithResults ifNil: [ #() ]
]

{ #category : #accessing }
GtLExampleWithResultsDomainObject >> exampleWithResults: aCollection [
	exampleWithResults := aCollection
]

{ #category : #'api - accessing' }
GtLExampleWithResultsDomainObject >> failureResultCount [
	^ self exampleWithResults count: #isFailureResult
]

{ #category : #'gt - extensions' }
GtLExampleWithResultsDomainObject >> gtExampleWithResultsFor: aView [
	<gtView>
	<gtLlmView>
	exampleWithResults ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Examples';
		priority: 1;
		items: [ self exampleWithResults ];
		column: 'Class' text: [ :each | each exampleWithResult methodClass ];
		column: 'Method' text: [ :each | each exampleWithResult selector ];
		column: 'Status' text: [ :each | each statusText ]
]

{ #category : #accessing }
GtLExampleWithResultsDomainObject >> notFoundClassNames [
	^ notFoundClassNames ifNil: [ #() ]
]

{ #category : #accessing }
GtLExampleWithResultsDomainObject >> notFoundClassNames: anObject [
	notFoundClassNames := anObject
]

{ #category : #'api - serializing' }
GtLExampleWithResultsDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: #total put: self totalCount;
		at: #successes put: self successResultCount;
		at: #failures put: self failureResultCount;
		at: #errors put: self errorResultCount;
		at: #skips put: self skippedCount;
		at: #notFound put: self notFoundClassNames;
		at: #details
			put: (self exampleWithResults collect: #serializeToOpenAIResponseJsonObject as: Array);
		yourself
]

{ #category : #'api - accessing' }
GtLExampleWithResultsDomainObject >> skippedCount [
	^ self exampleWithResults count: #isSkippedResult
]

{ #category : #'api - accessing' }
GtLExampleWithResultsDomainObject >> successResultCount [
	^ self exampleWithResults count: #isSuccessResult
]

{ #category : #'api - accessing' }
GtLExampleWithResultsDomainObject >> totalCount [
	^ self exampleWithResults size
]
