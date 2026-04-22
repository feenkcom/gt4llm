Class {
	#name : #GtLDataViewWithError,
	#superclass : #GtLDataView,
	#instVars : [
		'exception',
		'cachedTargetDataView',
		'errorReason'
	],
	#category : 'Gt4LlmCore-Data Views'
}

{ #category : #'as yet unclassified' }
GtLDataViewWithError >> computeTargetView [
	^ cachedTargetDataView := (self compositeData
			dataKey: self dataKey;
			addDataView: (self jsonData
				data: [ {'errorReason' -> self errorReason } asDictionary]);
			addDataView: (self forwardObject
				dataKey: 'errorDetails';
				object: [ exception ]))
]

{ #category : #accessing }
GtLDataViewWithError >> errorReason [
	^ errorReason
]

{ #category : #accessing }
GtLDataViewWithError >> errorReason: anObject [
	errorReason := anObject
]

{ #category : #accessing }
GtLDataViewWithError >> exception [
	^ exception
]

{ #category : #accessing }
GtLDataViewWithError >> exception: anException [
	exception := anException.
]

{ #category : #initialization }
GtLDataViewWithError >> initialize [
	super initialize.
	
	self dataKey: 'dataViewError'
]

{ #category : #serialization }
GtLDataViewWithError >> serializeToLlmPrimiteDataOn: aBuilder [
	self computeTargetView serializeToLlmPrimiteDataOn: aBuilder 
]
