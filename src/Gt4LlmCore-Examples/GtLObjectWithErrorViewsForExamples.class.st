Class {
	#name : #GtLObjectWithErrorViewsForExamples,
	#superclass : #GtLObjectWithViewsForExamples,
	#category : 'Gt4LlmCore-Examples-Data Views'
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
GtLObjectWithErrorViewsForExamples >> forwardToJsonViewWithObjectCreationErrorViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView forwardObject
			title: 'Error in forwarded json computation';
			object: [ self  ];
			view: #jsonWithObjectCreationErrorFor:
]

{ #category : #views }
GtLObjectWithErrorViewsForExamples >> forwardToNonExistingViewErrorFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView forwardObject
			object: [ self ];
			dataKey: 'forwardToNonExistingViewError';
			view: #nonExistingDataViewFor:
]

{ #category : #views }
GtLObjectWithErrorViewsForExamples >> forwardToWorwardObjectCreationErrorFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView forwardObject
			title: 'Error in forwarded view object computation';
			object: [ 1/0 ];
			view: #forwardWithObjectCreationErrorAndUnknowViewFor:
]

{ #category : #views }
GtLObjectWithErrorViewsForExamples >> forwardWithObjectCreationErrorAndUnknowViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView forwardObject
			title: 'Error in object computation';
			object: [ 1/0 ];
			view: #someViewThatDoesNotExistOnException:
]

{ #category : #views }
GtLObjectWithErrorViewsForExamples >> jsonWithObjectCreationErrorFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView jsonData
			title: 'Error in json data computation';
			data: [ 1/0 ]
]
