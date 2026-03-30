Class {
	#name : #GtLExampleWithResultDomainObject,
	#superclass : #Object,
	#instVars : [
		'exampleWithResult',
		'objectId'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLExampleWithResultDomainObject >> exampleReference [
	^ GtLExampleReference new 
			methodName: self exampleWithResult selector asString;
			exampleClassName: self exampleWithResult methodClass name asString;
			classSide: self exampleWithResult methodClass isClassSide
]

{ #category : #accessing }
GtLExampleWithResultDomainObject >> exampleWithResult [
	^ exampleWithResult
]

{ #category : #accessing }
GtLExampleWithResultDomainObject >> exampleWithResult: anObject [
	self assert: [ anObject isKindOf: GtExampleWithResult ].

	exampleWithResult := anObject
]

{ #category : #views }
GtLExampleWithResultDomainObject >> gtExampleSourceFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Example source';
		priority: 1;
		object: [ exampleWithResult ];
		view: #gtSourceFor:
]

{ #category : #views }
GtLExampleWithResultDomainObject >> gtExampleWithResultFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Example result';
		priority: 2;
		object: [ exampleWithResult ];
		view: #gtLiveFor:
]

{ #category : #'api - testing' }
GtLExampleWithResultDomainObject >> isErrorResult [
	^ self exampleWithResult isError
]

{ #category : #'api - testing' }
GtLExampleWithResultDomainObject >> isFailureResult [
	^ self exampleWithResult isFailure
]

{ #category : #'api - testing' }
GtLExampleWithResultDomainObject >> isSkippedResult [
	^ self exampleWithResult isSkipped
]

{ #category : #'api - testing' }
GtLExampleWithResultDomainObject >> isSuccessResult [
	^ self exampleWithResult isSuccess
]

{ #category : #'llm views' }
GtLExampleWithResultDomainObject >> llmRawDataViewFor: aDataView [
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
GtLExampleWithResultDomainObject >> llmResultExceptionViewFor: aDataView [
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
GtLExampleWithResultDomainObject >> llmResultObjectViewFor: aDataView [
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
GtLExampleWithResultDomainObject >> objectId [
	^ objectId
]

{ #category : #accessing }
GtLExampleWithResultDomainObject >> objectId: anObject [
	objectId := anObject
]

{ #category : #accessing }
GtLExampleWithResultDomainObject >> statusText [
	self isSkippedResult ifTrue: [ ^ 'skipped' ].
	^ self exampleWithResult statusText asString asLowercase
]
