Class {
	#name : #GtLExampleWithResultStatuses,
	#superclass : #Object,
	#instVars : [
		'notFoundClassNames',
		'exampleWithStatuses'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #'as yet unclassified' }
GtLExampleWithResultStatuses >> asExampleExecutionSummary [
	^ GtLExampleExecutionSummary new
		successes: self successResults;
		failures: self failureResults;
		errors: self errorResults;
		skipped: self skippedResults;
		result: self
]

{ #category : #'api - accessing' }
GtLExampleWithResultStatuses >> errorResultCount [
	^ self exampleWithStatuses count: #isErrorResult
]

{ #category : #'api - accessing' }
GtLExampleWithResultStatuses >> errorResults [
	^ self exampleWithStatuses select: #isErrorResult
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

{ #category : #'api - accessing' }
GtLExampleWithResultStatuses >> failureResults [
	^ self exampleWithStatuses select: #isFailureResult
]

{ #category : #views }
GtLExampleWithResultStatuses >> gtExampleDependenciesFor: aView [
	<gtView>
	^ aView forward
		title: 'Dependencies';
		priority: 30;
		object: [ GtExampleGroup withAll: (exampleWithStatuses collect: #exampleWithResult) ];
		view: #gtDependenciesFor:
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
		column: 'Status'
			stencil: [ :each | 
				BlElement new
					background: each exampleWithResult color;
					size: 16 @ 16 ]
			width: 50;
		column: 'Class' text: [ :each | each exampleWithResult methodClass ];
		column: 'Method' text: [ :each | each exampleWithResult selector ];
		actionStencil: [ GtSpotterDropdownButtonStencil new
					object: self;
					tooltip: 'Search examples by name';
					objectActOn: [ :anEvent :anItem :aButton | 
						anEvent beActed.
						aButton phlow spawnObject: anEvent objectToSend ] ]
			tooltip: 'Search examples by name'
]

{ #category : #'gt - extensions' }
GtLExampleWithResultStatuses >> gtSearchExamplesFor: aSearch [
	"Find example statuses by class and method name, preserving the status as the result."

	<gtSearch>
	^ aSearch list
		title: 'Examples';
		priority: 1;
		items: [ self exampleWithStatuses ];
		itemName: [ :each | 
			each exampleWithResult methodClass name asString , '>>'
				, each exampleWithResult selector asString ];
		filterBySubstring
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
GtLExampleWithResultStatuses >> skippedResults [
	^ self exampleWithStatuses select: #isSkippedResult
]

{ #category : #'api - accessing' }
GtLExampleWithResultStatuses >> successResultCount [
	^ self exampleWithStatuses count: #isSuccessResult
]

{ #category : #'api - accessing' }
GtLExampleWithResultStatuses >> successResults [
	^ self exampleWithStatuses select: #isSuccessResult
]

{ #category : #'api - accessing' }
GtLExampleWithResultStatuses >> totalCount [
	^ self exampleWithStatuses size
]
