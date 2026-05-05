Class {
	#name : #GtLObjectWithErrorViewsWithNoIdsForExamples,
	#superclass : #GtLObjectWithViewsForExamples,
	#category : #'Gt4LlmCore-Examples-Data Views'
}

{ #category : #views }
GtLObjectWithErrorViewsWithNoIdsForExamples >> dataViewWithAnotherExceptionAtCreationFor: aDataView [
	<gtLlmDataView>
	1 someMethodThatDoesNotExist.
	^ aDataView title: 'With error during view creation'
]

{ #category : #views }
GtLObjectWithErrorViewsWithNoIdsForExamples >> dataViewWithExceptionAtCreationFor: aDataView [
	<gtLlmDataView>
	1/0.
	^ aDataView title: 'With error during view creation'
]

{ #category : #views }
GtLObjectWithErrorViewsWithNoIdsForExamples >> forwardToDataViewWithErrorFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView forwardObject
			object: [ self ];
			view: #dataViewWithExceptionAtCreationFor:
]

{ #category : #views }
GtLObjectWithErrorViewsWithNoIdsForExamples >> forwardToNonExistingViewErrorFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView forwardObject
			object: [ self ];
			view: #nonExistingDataViewFor:
]
