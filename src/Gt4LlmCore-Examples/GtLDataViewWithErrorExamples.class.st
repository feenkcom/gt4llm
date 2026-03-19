Class {
	#name : #GtLDataViewWithErrorExamples,
	#superclass : #GtLDataViewExamples,
	#category : #'Gt4LlmCore-Examples-Data Views'
}

{ #category : #assertions }
GtLDataViewWithErrorExamples >> assertErrorData: anErrorData withClass: anErrorClassName message: anErrorMessage reason: anErrorReason [
	<gtExample>
	| errorDetails |
	
	self assert: (anErrorData includesKey: 'errorDetails').
	self assert: (anErrorData includesKey: 'errorReason').
	self 
		assert: (anErrorData at: 'errorReason')
		equals: anErrorReason.
	
	errorDetails := anErrorData at: 'errorDetails'.
	self 
		assert: (errorDetails at: 'errorClass')
		equals: 'ZeroDivide'.
	self 
		assert: (errorDetails at: 'errorMessage')
		equals: 'ZeroDivide'.
	self 
		assert: (errorDetails at: 'stackTrace') notEmpty.
]

{ #category : #examples }
GtLDataViewWithErrorExamples >> dataViewWithDataKey [
	<gtExample>
	| dataView exception |
	
	exception := self divideByZeroFrozenException.
	
	dataView := GtLDataViewWithError new
		dataKey: 'currentError';
		exception: exception.
	
	self assert: dataView title isNil.
	self assert: dataView dataKey equals: 'currentError'.
	self assert: dataView exception equals: exception.
	
	^ dataView
]

{ #category : #examples }
GtLDataViewWithErrorExamples >> dataViewWithDataKey_serialization [
	<gtExample>
	| dataView dataBlock actualData |
	dataView := self dataViewWithDataKey.
	dataBlock := dataView serializeToLlmPrimiteData.

	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock containedJsonDataBlocksCount equals: 2.

	actualData := dataBlock compositeJsonDataBlock llmJsonData.
	self assert: (actualData includesKey: 'currentError').
	self 
		assertErrorData: (actualData at: 'currentError') 
		withClass: 'ZeroDivide' 
		message: 'ZeroDivide' 
		reason: nil.

	^ actualData
]

{ #category : #examples }
GtLDataViewWithErrorExamples >> dataViewWithoutExplicitDataKey [
	<gtExample>
	| dataView exception |
	
	exception := self divideByZeroFrozenException.
	
	dataView := GtLDataViewWithError new
		exception: exception.
	
	self assert: dataView title isNil.
	self assert: dataView dataKey equals: 'dataViewError'.
	self assert: dataView exception equals: exception.
	
	^ dataView
]

{ #category : #examples }
GtLDataViewWithErrorExamples >> dataViewWithoutExplicitDataKey_serialization [
	<gtExample>
	| dataView dataBlock actualData |
	dataView := self dataViewWithoutExplicitDataKey.
	dataBlock := dataView serializeToLlmPrimiteData.

	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock containedJsonDataBlocksCount equals: 2.

	actualData := dataBlock compositeJsonDataBlock llmJsonData.
	self assert: (actualData includesKey: 'dataViewError').
	self 
		assertErrorData: (actualData at: 'dataViewError') 
		withClass: 'ZeroDivide' 
		message: 'ZeroDivide' 
		reason: nil.

	^ actualData
]

{ #category : #utils }
GtLDataViewWithErrorExamples >> divideByZeroFrozenException [
	^ [1/0] on: Error do:[ :anException |
			GtSystemUtility freeze: anException ]
]
