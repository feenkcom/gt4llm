Class {
	#name : #GtLExampleWithResultStatusesDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'notFoundClassNames',
		'exampleWithStatuses'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #'api - accessing' }
GtLExampleWithResultStatusesDomainObject >> errorResultCount [
	^ self exampleWithStatuses count: #isErrorResult
]

{ #category : #accessing }
GtLExampleWithResultStatusesDomainObject >> exampleWithStatuses [
	<return: #Collection of: #GtLExampleWithResultStatusDomainObject>
	^ exampleWithStatuses ifNil: [ #() ]
]

{ #category : #accessing }
GtLExampleWithResultStatusesDomainObject >> exampleWithStatuses: aCollection [
	exampleWithStatuses := aCollection
]

{ #category : #'api - accessing' }
GtLExampleWithResultStatusesDomainObject >> failureResultCount [
	^ self exampleWithStatuses count: #isFailureResult
]

{ #category : #'gt - extensions' }
GtLExampleWithResultStatusesDomainObject >> gtExampleWithStatusesFor: aView [
	<gtView>
	<gtLlmView>
	
	exampleWithStatuses ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Examples';
		priority: 1;
		items: [ self exampleWithStatuses ];
		column: 'Class' text: [ :each | each exampleWithResult methodClass ];
		column: 'Method' text: [ :each | each exampleWithResult selector ];
		column: 'Status' text: [ :each | each statusText ]
]

{ #category : #accessing }
GtLExampleWithResultStatusesDomainObject >> notFoundClassNames [
	^ notFoundClassNames ifNil: [ #() ]
]

{ #category : #accessing }
GtLExampleWithResultStatusesDomainObject >> notFoundClassNames: anObject [
	notFoundClassNames := anObject
]

{ #category : #'api - serializing' }
GtLExampleWithResultStatusesDomainObject >> serializeToLlmJsonObject [
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
			put: (self exampleWithStatuses collect: #serializeToLlmJsonObject as: Array);
		yourself
]

{ #category : #'api - accessing' }
GtLExampleWithResultStatusesDomainObject >> skippedCount [
	^ self exampleWithStatuses count: #isSkippedResult
]

{ #category : #'api - accessing' }
GtLExampleWithResultStatusesDomainObject >> successResultCount [
	^ self exampleWithStatuses count: #isSuccessResult
]

{ #category : #'api - accessing' }
GtLExampleWithResultStatusesDomainObject >> totalCount [
	^ self exampleWithStatuses size
]
