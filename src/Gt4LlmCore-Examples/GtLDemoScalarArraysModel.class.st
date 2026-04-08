Class {
	#name : #GtLDemoScalarArraysModel,
	#superclass : #Object,
	#instVars : [
		'arrayOfBooleans',
		'arrayOfStrings'
	],
	#category : 'Gt4LlmCore-Examples-Magritte'
}

{ #category : #comparison }
GtLDemoScalarArraysModel >> = anObject [
	^ self class = anObject class and: [
		self arrayOfStrings = anObject arrayOfStrings and: [
			self arrayOfBooleans = anObject arrayOfBooleans] ]
]

{ #category : #accessing }
GtLDemoScalarArraysModel >> arrayOfBooleans [
	^ arrayOfBooleans
]

{ #category : #accessing }
GtLDemoScalarArraysModel >> arrayOfBooleans: anArray [
	arrayOfBooleans := anArray
]

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

{ #category : #accessing }
GtLDemoScalarArraysModel >> arrayOfStrings [
	^ arrayOfStrings
]

{ #category : #accessing }
GtLDemoScalarArraysModel >> arrayOfStrings: anArray [
	arrayOfStrings := anArray
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

{ #category : #comparing }
GtLDemoScalarArraysModel >> hash [
	^ (self class hash hashMultiply 
		bitXor: self arrayOfStrings hash hashMultiply)
		bitXor: self arrayOfBooleans hash hashMultiply
]
