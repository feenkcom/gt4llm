Class {
	#name : #GtLExampleWithResultStatuses,
	#superclass : #Object,
	#instVars : [
		'notFoundClassNames',
		'exampleWithStatuses'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #'api - accessing' }
GtLExampleWithResultStatuses >> errorResultCount [
	^ self exampleWithStatuses count: #isErrorResult
]

{ #category : #accessing }
GtLExampleWithResultStatuses >> exampleWithStatuses [
	<return: #Collection of: #GtLExampleWithResultStatus>
	^ exampleWithStatuses ifNil: [ #() ]
]

{ #category : #accessing }
GtLExampleWithResultStatuses >> exampleWithStatuses: aCollection [
	exampleWithStatuses := aCollection
]

{ #category : #'api - accessing' }
GtLExampleWithResultStatuses >> failureResultCount [
	^ self exampleWithStatuses count: #isFailureResult
]

{ #category : #'gt - extensions' }
GtLExampleWithResultStatuses >> gtExampleWithStatusesFor: aView [
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
GtLExampleWithResultStatuses >> llmJsonObject [
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
			put: (self exampleWithStatuses 
				collect: [ :each | each llmJsonObject ] as: Array);
		yourself
]

{ #category : #accessing }
GtLExampleWithResultStatuses >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView 
			title: 'Example results';
			jsonData: [ self llmJsonObject ]
]

{ #category : #accessing }
GtLExampleWithResultStatuses >> notFoundClassNames [
	^ notFoundClassNames ifNil: [ #() ]
]

{ #category : #accessing }
GtLExampleWithResultStatuses >> notFoundClassNames: anObject [
	notFoundClassNames := anObject
]

{ #category : #'api - accessing' }
GtLExampleWithResultStatuses >> skippedCount [
	^ self exampleWithStatuses count: #isSkippedResult
]

{ #category : #'api - accessing' }
GtLExampleWithResultStatuses >> successResultCount [
	^ self exampleWithStatuses count: #isSuccessResult
]

{ #category : #'api - accessing' }
GtLExampleWithResultStatuses >> totalCount [
	^ self exampleWithStatuses size
]
