Class {
	#name : #GtLDemoScalarArraysModel,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Magritte'
}

{ #category : #magritte }
GtLDemoScalarArraysModel >> arrayOfBooleansDescription [
	<magritteDescription>
	^ MAToManyScalarRelationDescription new
		label: 'Array of booleans';
		accessor: #arrayOfBooleans;
		classes: {Boolean};
		beRequired;
		yourself
]

{ #category : #magritte }
GtLDemoScalarArraysModel >> arrayOfStringsDescription [
	<magritteDescription>
	^ MAToManyScalarRelationDescription new
		label: 'Array of strings';
		accessor: #arrayOfStrings;
		classes: {String};
		comment: 'An array of strings';
		beRequired;
		yourself
]
