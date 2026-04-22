Class {
	#name : #GtLExampleWithResult,
	#superclass : #Object,
	#instVars : [
		'exampleWithResult',
		'objectId'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLExampleWithResult >> exampleReference [
	^ GtLExampleReference new 
			methodName: self exampleWithResult selector asString;
			exampleClassName: self exampleWithResult methodClass name asString;
			classSide: self exampleWithResult methodClass isClassSide
]

{ #category : #accessing }
GtLExampleWithResult >> exampleWithResult [
	^ exampleWithResult
]

{ #category : #accessing }
GtLExampleWithResult >> exampleWithResult: anObject [
	self assert: [ anObject isKindOf: GtExampleWithResult ].

	exampleWithResult := anObject
]

{ #category : #views }
GtLExampleWithResult >> gtExampleSourceFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Example source';
		priority: 1;
		object: [ exampleWithResult ];
		view: #gtSourceFor:
]

{ #category : #views }
GtLExampleWithResult >> gtExampleWithResultFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Example result';
		priority: 2;
		object: [ exampleWithResult ];
		view: #gtLiveFor:
]

{ #category : #'api - testing' }
GtLExampleWithResult >> isErrorResult [
	^ self exampleWithResult isError
]

{ #category : #'api - testing' }
GtLExampleWithResult >> isFailureResult [
	^ self exampleWithResult isFailure
]

{ #category : #'api - testing' }
GtLExampleWithResult >> isSkippedResult [
	^ self exampleWithResult isSkipped
]

{ #category : #'api - testing' }
GtLExampleWithResult >> isSuccessResult [
	^ self exampleWithResult isSuccess
]

{ #category : #'llm views' }
GtLExampleWithResult >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^aDataView compositeData
		title: 'Example details';
		addDataView: (aDataView magritteObject 
			dataKey: 'exampleReference';
			object: [ self exampleReference ]);
		addDataView: (aDataView jsonObject: [ :aJson |
			aJson
				at: 'exampleStatus' put: self statusText	])
]

{ #category : #'llm views' }
GtLExampleWithResult >> llmResultExceptionViewFor: aDataView [
	<gtLlmDataView>
	
	(self isErrorResult not and: [ self isFailureResult not ]) ifTrue: [
		^ aDataView emptyData ].
	
	^aDataView forwardObject
			title: 'Exception details';
			dataKey: #result;
			object: [ 
				self exampleWithResult returnValue  ]
]

{ #category : #'llm views' }
GtLExampleWithResult >> llmResultObjectViewFor: aDataView [
	<gtLlmDataView>
	
	(self isErrorResult or: [ self isFailureResult ]) ifTrue: [
		^ aDataView emptyData ].
	
	^aDataView forwardObject
			title: 'Object details';
			dataKey: #result;
			object: [ 
					GtLObjectStorageValueResult 
						forObject: self exampleWithResult returnValue
						withId: self objectId  ]
]

{ #category : #accessing }
GtLExampleWithResult >> objectId [
	^ objectId
]

{ #category : #accessing }
GtLExampleWithResult >> objectId: anObject [
	objectId := anObject
]

{ #category : #accessing }
GtLExampleWithResult >> statusText [
	self isSkippedResult ifTrue: [ ^ 'skipped' ].
	^ self exampleWithResult statusText asString asLowercase
]
