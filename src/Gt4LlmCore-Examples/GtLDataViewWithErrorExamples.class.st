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
		equals: anErrorClassName.
	self 
		assert: (errorDetails at: 'errorMessage')
		equals: anErrorMessage.
	self 
		assert: (errorDetails at: 'stackTrace') notEmpty.
	
	self 
		assert: ((errorDetails at: 'stackTrace') includesSubstring:anErrorClassName)
]

{ #category : #private }
GtLDataViewWithErrorExamples >> assertErrorMessageBlock: dataBlock at: aDataKey errorWithClass: anErrorClassName message: anErrorMessage reason: anErrorReason [
	<gtExample>
	| actualData exceptionData |
	
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock containedJsonDataBlocksCount equals: 2.

	actualData := dataBlock llmJsonData.
	self assert: (actualData includesKey: aDataKey).
	exceptionData := actualData at: aDataKey.
	
	self assert: (exceptionData includesKey: 'dataViewError').
	self 
		assertErrorData: (exceptionData at: 'dataViewError') 
		withClass: anErrorClassName 
		message: anErrorMessage 
		reason: anErrorReason.
]

{ #category : #private }
GtLDataViewWithErrorExamples >> assertErrorMessageBlock: dataBlock errorWithClass: anErrorClassName message: anErrorMessage reason: anErrorReason [
	<gtExample>
	|  actualData |
	
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock containedJsonDataBlocksCount equals: 2.

	actualData := dataBlock llmJsonData.
	self assert: (actualData includesKey: 'dataViewError').
	self 
		assertErrorData: (actualData at: 'dataViewError') 
		withClass: anErrorClassName 
		message: anErrorMessage 
		reason: anErrorReason.
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

	actualData := dataBlock llmJsonData.
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

	actualData := dataBlock llmJsonData.
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

{ #category : #examples }
GtLDataViewWithErrorExamples >> onCollectObjectViewsWithNoIdsWithErrorInViewCreation [
	<gtExample>
	| mainView dataBlock jsonData |
	
	mainView := GtLObjectWithErrorViewsWithNoIdsForExamples new
		llmDataViewsFor: GtLDataView empty  .
		
	self assert: mainView dataViews size equals: 4.
	
	dataBlock := mainView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock containedJsonDataBlocksCount equals: 8.
	
	jsonData := dataBlock llmJsonData.
	self 
		assert: (jsonData keys asSet) 
		equals: #('dataViewError' 'dataViewError_1' 'dataViewError_2' 'dataViewError_3') asSet.

	jsonData values do: [ :anErrroViewData |
		self assert: (anErrroViewData includesKey: 'errorReason').
		self assert: (anErrroViewData includesKey: 'errorDetails') ].
				
	^ mainView
]

{ #category : #examples }
GtLDataViewWithErrorExamples >> onForwardToForwardWithErrorAtObjectCreation [
	<gtExample>
	| forwardView dataBlock |
	
	forwardView := GtLDataView empty 
		on: GtLObjectWithErrorViewsForExamples new 
		perform: #forwardToWorwardObjectCreationErrorFor:.
		
	self assert: forwardView class equals: GtLForwardObjectDataView.
	
	self assert: forwardView title equals: 'Error in forwarded view object computation'.
	self assert: forwardView dataKey equals: nil.
	
	dataBlock := forwardView serializeToLlmPrimiteData.
	self 
		assertErrorMessageBlock: dataBlock 
		errorWithClass: 'ZeroDivide' 
		message: 'ZeroDivide' 
		reason: 'Error computing target object for object forwarded data view'.
		
	^ forwardView
]

{ #category : #examples }
GtLDataViewWithErrorExamples >> onForwardToJsonViewWithObjectCreationError [
	<gtExample>
	| forwardView dataBlock |
	
	forwardView := GtLDataView empty 
		on: GtLObjectWithErrorViewsForExamples new 
		perform: #forwardToJsonViewWithObjectCreationErrorViewFor:.
		
	self assert: forwardView class equals: GtLForwardObjectDataView.
	
	self assert: forwardView title equals: 'Error in forwarded json computation'.
	self assert: forwardView dataKey equals: nil.
	
	dataBlock := forwardView serializeToLlmPrimiteData.
	self 
		assertErrorMessageBlock: dataBlock 
		errorWithClass: 'ZeroDivide' 
		message: 'ZeroDivide' 
		reason: 'Error computing target JSON object'.
		
	^ forwardView
]

{ #category : #examples }
GtLDataViewWithErrorExamples >> onForwardWithErrorAtObjectCreation [
	<gtExample>
	| forwardView dataBlock |
	
	forwardView := GtLDataView empty 
		on: GtLObjectWithErrorViewsForExamples new 
		perform: #forwardWithObjectCreationErrorAndUnknowViewFor:.
		
	self assert: forwardView class equals: GtLForwardObjectDataView.
	
	self assert: forwardView title equals: 'Error in object computation'.
	self assert: forwardView dataKey equals: nil.
	
	dataBlock := forwardView serializeToLlmPrimiteData.
	self 
		assertErrorMessageBlock: dataBlock 
		errorWithClass: 'ZeroDivide' 
		message: 'ZeroDivide' 
		reason: 'Error computing target object for object forwarded data view'.
		
	^ forwardView
]

{ #category : #examples }
GtLDataViewWithErrorExamples >> onJsonViewWithObjectCreationError [
	<gtExample>
	| jsonView dataBlock |
	
	jsonView := GtLDataView empty 
		on: GtLObjectWithErrorViewsForExamples new 
		perform: #jsonWithObjectCreationErrorFor:.
		
	self assert: jsonView class equals: GtLJsonDataView.
	
	self assert: jsonView title equals: 'Error in json data computation'.
	self assert: jsonView dataKey equals: nil.
	
	dataBlock := jsonView serializeToLlmPrimiteData.
	self 
		assertErrorMessageBlock: dataBlock 
		errorWithClass: 'ZeroDivide' 
		message: 'ZeroDivide' 
		reason: 'Error computing target JSON object'.
		
	^ jsonView
]

{ #category : #examples }
GtLDataViewWithErrorExamples >> onPerformForwardWithErrorAtCreation [
	<gtExample>
	| forwardView dataBlock |
	
	forwardView := GtLDataView empty 
		on: GtLObjectWithErrorViewsForExamples new 
		perform: #forwardToDataViewWithErrorFor:.
		
	self assert: forwardView class equals: GtLForwardObjectDataView.
	
	self assert: forwardView viewSymbol equals: #dataViewWithExceptionAtCreationFor:.
	self assert: forwardView dataKey equals: 'forwardToDataViewWithError' .
	
	dataBlock := forwardView serializeToLlmPrimiteData.
	self 
		assertErrorMessageBlock: dataBlock
		at: 'forwardToDataViewWithError'
		errorWithClass: 'ZeroDivide' 
		message: 'ZeroDivide' 
		reason: 'Error executing the view method dataViewWithExceptionAtCreationFor: on the class GtLObjectWithErrorViewsForExamples'.
		
	^ forwardView
]

{ #category : #examples }
GtLDataViewWithErrorExamples >> onPerformForwardWithNonExistingMethodError [
	<gtExample>
	| forwardView dataBlock |
	
	forwardView := GtLDataView empty  
		on: GtLObjectWithErrorViewsForExamples new 
		perform: #forwardToNonExistingViewErrorFor:.
		
	self assert: forwardView class equals: GtLForwardObjectDataView.
	
	self assert: forwardView dataKey equals: 'forwardToNonExistingViewError'.
	self assert: forwardView viewSymbol equals: #nonExistingDataViewFor:.
	
	dataBlock := forwardView serializeToLlmPrimiteData.
	self 
		assertErrorMessageBlock: dataBlock 
		at: 'forwardToNonExistingViewError'
		errorWithClass: 'MessageNotUnderstood' 
		message: 'Instance of GtLObjectWithErrorViewsForExamples did not understand #nonExistingDataViewFor:' 
		reason: 'Error executing the view method nonExistingDataViewFor: on the class GtLObjectWithErrorViewsForExamples'.
		
	^ forwardView
]

{ #category : #examples }
GtLDataViewWithErrorExamples >> onPerformWithErrorAtCreation [
	<gtExample>
	| errorView dataBlock |
	
	errorView := GtLDataView empty 
		on: GtLObjectWithErrorViewsForExamples new 
		perform: #dataViewWithExceptionAtCreationFor:.
		
	self assert: errorView class equals: GtLDataViewWithError.
	
	self assert: errorView title equals: 'Error'.
	self assert: errorView dataKey equals: 'dataViewError'.
	
	dataBlock := errorView serializeToLlmPrimiteData.
	self 
		assertErrorMessageBlock: dataBlock 
		errorWithClass: 'ZeroDivide' 
		message: 'ZeroDivide' 
		reason: 'Error executing the view method dataViewWithExceptionAtCreationFor: on the class GtLObjectWithErrorViewsForExamples'.
		
	^ errorView
]

{ #category : #examples }
GtLDataViewWithErrorExamples >> onPerformWithNonExistingMethodError [
	<gtExample>
	| errorView dataBlock |
	
	errorView := GtLDataView empty 
		on: GtLObjectWithErrorViewsForExamples new 
		perform: #nonExistingDataViewFor:.
		
	self assert: errorView class equals: GtLDataViewWithError.
	
	self assert: errorView title equals: 'Error'.
	self assert: errorView dataKey equals: 'dataViewError'.
	
	dataBlock := errorView serializeToLlmPrimiteData.
	self 
		assertErrorMessageBlock: dataBlock 
		errorWithClass: 'MessageNotUnderstood' 
		message: 'Instance of GtLObjectWithErrorViewsForExamples did not understand #nonExistingDataViewFor:' 
		reason: 'Error executing the view method nonExistingDataViewFor: on the class GtLObjectWithErrorViewsForExamples'.
		
	^ errorView
]
