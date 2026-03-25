Class {
	#name : #GtLObjectWithErrorViewsForExamples,
	#superclass : #GtLObjectWithViewsForExamples,
	#category : #'Gt4LlmCore-Examples-Data Views'
}

{ #category : #views }
GtLObjectWithErrorViewsForExamples >> dataViewWithAnotherExceptionAtCreationFor: aDataView [
	<gtLlmDataView>
	1 someMethodThatDoesNotExist.
	^ aDataView title: 'With error during view creation'
]

{ #category : #views }
GtLObjectWithErrorViewsForExamples >> dataViewWithExceptionAtCreationFor: aDataView [
	<gtLlmDataView>
	1/0.
	^ aDataView title: 'With error during view creation'
]

{ #category : #views }
GtLObjectWithErrorViewsForExamples >> forwardToDataViewWithErrorFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView forwardObject
			object: [ self ];
			dataKey: 'forwardToDataViewWithError';
			view: #dataViewWithExceptionAtCreationFor:
]

{ #category : #views }
GtLObjectWithErrorViewsForExamples >> forwardToNonExistingViewErrorFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView forwardObject
			object: [ self ];
			dataKey: 'forwardToNonExistingViewError';
			view: #nonExistingDataViewFor:
]
