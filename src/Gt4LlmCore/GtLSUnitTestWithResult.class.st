Class {
	#name : #GtLSUnitTestWithResult,
	#superclass : #Object,
	#instVars : [
		'testCase',
		'result'
	],
	#category : #Gt4LlmCore
}

{ #category : #views }
GtLSUnitTestWithResult >> gtSourceCodeFor: aView [
	<gtView>
	^(aView forward)
		title: 'Source';
		priority: 5;
		object: [testCase];
		view: #gtSourceCodeFor:
]

{ #category : #views }
GtLSUnitTestWithResult >> gtViewExceptionMessageFor: aView [
	<gtView>
	(self isError or: [ self isFailure ]) ifFalse: [ ^ aView empty ].
	^(aView forward)
		title: 'Exception message';
		priority: 15;
		object: [result];
		view: #gtExceptionMessageFor:
]

{ #category : #views }
GtLSUnitTestWithResult >> gtViewExceptionStackFor: aView [
	<gtView>
	(self isError or: [ self isFailure ]) ifFalse: [ ^ aView empty ].
	^(aView forward)
		title: 'Exception stack';
		priority: 15;
		object: [result];
		view: #gtExceptionStackFor:
]

{ #category : #testing }
GtLSUnitTestWithResult >> hasResult [
	^ result notNil
]

{ #category : #testing }
GtLSUnitTestWithResult >> isError [
	^ self hasResult and: [ self result isError ]
]

{ #category : #testing }
GtLSUnitTestWithResult >> isFailure [
	^ self hasResult and: [ self result isFailure ]
]

{ #category : #testing }
GtLSUnitTestWithResult >> isSuccess [
	^ self hasResult and: [ self result isSuccess ]
]

{ #category : #'as yet unclassified' }
GtLSUnitTestWithResult >> printOn: aStream [
	super printOn: aStream.
	
	aStream parenthesize: [
		aStream 
			<< result state;
			<< '; ';
			print: self testCase ]
]

{ #category : #accessing }
GtLSUnitTestWithResult >> result [
	^result
]

{ #category : #accessing }
GtLSUnitTestWithResult >> result: anObject [
	result := anObject
]

{ #category : #accessing }
GtLSUnitTestWithResult >> run [
	result := GtLSUnitTestResult new.
	result testCase: testCase.
	[ result runCase ] ensure: [ ].
	^result
]

{ #category : #accessing }
GtLSUnitTestWithResult >> selector [
	^ testCase selector
]

{ #category : #accessing }
GtLSUnitTestWithResult >> testCase [
	^testCase
]

{ #category : #accessing }
GtLSUnitTestWithResult >> testCase: anObject [
	testCase := anObject
]
