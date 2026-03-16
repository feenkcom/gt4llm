Class {
	#name : #GtLExampleWithResultDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'exampleWithResult',
		'objectId'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

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
GtLExampleWithResultDomainObject >> llmRawViewFor: aDataView [
	<gtLlmDataView>
	
	^aDataView jsonObject: [ :aJson |
			aJson
				at: #className put: self exampleWithResult methodClass name asString;
				at: #selector put: self exampleWithResult selector asString;
				at: #status put: self statusText;
				at: #objectId put: self objectId	]
]

{ #category : #'llm views' }
GtLExampleWithResultDomainObject >> llmResultExceptionViewFor: aDataView [
	<gtLlmDataView>
	(self isErrorResult not and: [ self isFailureResult not ]) ifTrue: [
		^ aDataView emptyData ].
	
	^aDataView forwardObject
			dataKey: #result;
			object: [ 
				self exampleWithResult returnValue  ]
]

{ #category : #'llm views' }
GtLExampleWithResultDomainObject >> llmResultObject_forwardViewFor: aDataView [
	<gtLlmDataView>
	(self isErrorResult or: [ self isFailureResult ]) ifTrue: [
		^ aDataView emptyData ].
	
	^aDataView forwardObject
			dataKey: #result;
			object: [ 
					GtLValueDomainObject new 
						value: self exampleWithResult returnValue  ]
]

{ #category : #'llm views' }
GtLExampleWithResultDomainObject >> llmResultObject_magritteViewFor: aDataView [
	"<gtLlmDataView>"
	
	(self isErrorResult or: [ self isFailureResult ]) ifFalse: [
		^ aDataView emptyData ].
	
	^aDataView magritteObject: [ 
			GtLSerializedObjectValue 
				fromObject: self exampleWithResult returnValue  ]
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
GtLExampleWithResultDomainObject >> safeReturnValuePrintString [
	^ [ | object |
	object := (self isErrorResult or: [ self isFailureResult ])
		ifTrue: [ self exampleWithResult returnValue 
			serializeToOpenAIResponseOutput ]
		ifFalse: [ GtLValueSerializer new
			serializeValue: self exampleWithResult returnValue ].
	object ] onErrorDo: [ :anError | anError return: 'printString error' ]
]

{ #category : #'api - serializing' }
GtLExampleWithResultDomainObject >> serializeToAnthropicResponseOutput [
	^ super serializeToAnthropicResponseOutput
		, (self serializeToLlmResponseImages collect: [ :anPrimitiveImage |
				anPrimitiveImage serializeToAnthropicResponseOutput ]).
]

{ #category : #serialization }
GtLExampleWithResultDomainObject >> serializeToLlmJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	
	^ NeoJSONObject new
		at: #className put: self exampleWithResult methodClass name asString;
		at: #selector put: self exampleWithResult selector asString;
		at: #status put: self statusText;
		at: #result put: self safeReturnValuePrintString;
		at: #objectId put: self objectId;
		yourself
]

{ #category : #'api - serializing' }
GtLExampleWithResultDomainObject >> serializeToLlmResponseImages [
	^ (self isErrorResult or: [ self isFailureResult ])
		ifFalse: [ #() ]
		ifTrue: [ self exampleWithResult returnValue serializeToLlmResponseImages ]. 
]

{ #category : #'api - serializing' }
GtLExampleWithResultDomainObject >> serializeToOpenAIResponseImages [
	^ (self isErrorResult or: [ self isFailureResult ])
		ifFalse: [ #() ]
		ifTrue: [ self exampleWithResult returnValue serializeToOpenAIResponseImages ]. 
]

{ #category : #'api - serializing' }
GtLExampleWithResultDomainObject >> serializeToOpenAIResponseOutput [
	^ super serializeToOpenAIResponseOutput
		, (self serializeToLlmResponseImages collect: [ :anPrimitiveImage |
				anPrimitiveImage serializeToOpenAIResponseOutput ])
]

{ #category : #accessing }
GtLExampleWithResultDomainObject >> statusText [
	self isSkippedResult ifTrue: [ ^ 'skipped' ].
	^ self exampleWithResult statusText asString asLowercase
]
