Class {
	#name : #GtLAddMethodSpecification,
	#superclass : #GtLMethodTransformationSpecification,
	#instVars : [
		'protocolName',
		'sourceCode'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #'as yet unclassified' }
GtLAddMethodSpecification class >> isConcrete [
	^ true
]

{ #category : #'as yet unclassified' }
GtLAddMethodSpecification >> asRefactoringIn: aNamespace [
	^ GtRBAddMethodRefactoring
		model: aNamespace
		sourceCode: sourceCode
		in: methodClassName
		withProtocol: protocolName
]

{ #category : #'as yet unclassified' }
GtLAddMethodSpecification >> descriptionContainer [
	^ super descriptionContainer
		comment: 'The "Add method" transformation adds a method to a class. The transformation must provide the methodClassName, the sourceCode, and protocolName for the new method. The sourceCode should include the entire method, including the name and parameters.'
]

{ #category : #'as yet unclassified' }
GtLAddMethodSpecification >> gtDisplayOn: aStream [
	aStream
		nextPutAll: 'Add method ';
		nextPutAll: (sourceCode lines first);
		nextPutAll: ' in class ';
		nextPutAll: methodClassName;
		nextPutAll: ' protocol ';
		nextPutAll: protocolName
]

{ #category : #accessing }
GtLAddMethodSpecification >> protocolName [
	^ protocolName
]

{ #category : #accessing }
GtLAddMethodSpecification >> protocolName: anObject [
	protocolName := anObject
]

{ #category : #descriptions }
GtLAddMethodSpecification >> protocolNameDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #protocolName
]

{ #category : #accessing }
GtLAddMethodSpecification >> sourceCode [
	^ sourceCode
]

{ #category : #accessing }
GtLAddMethodSpecification >> sourceCode: anObject [
	sourceCode := anObject
]

{ #category : #descriptions }
GtLAddMethodSpecification >> sourceCodeDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #sourceCodeOfMethodToAdd
]

{ #category : #accessing }
GtLAddMethodSpecification >> sourceCodeOfMethodToAdd [
	^ sourceCode
]

{ #category : #accessing }
GtLAddMethodSpecification >> sourceCodeOfMethodToAdd: anObject [
	sourceCode := anObject
]
