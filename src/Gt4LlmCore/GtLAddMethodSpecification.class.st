Class {
	#name : #GtLAddMethodSpecification,
	#superclass : #GtLMethodTransformationSpecification,
	#instVars : [
		'protocolName',
		'sourceCode'
	],
	#category : 'Gt4LlmCore-Formats'
}

{ #category : #testing }
GtLAddMethodSpecification class >> isConcrete [
	^ true
]

{ #category : #accessing }
GtLAddMethodSpecification class >> jsonSchemaLabel [
	^ 'AddMethod'
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

{ #category : #descriptions }
GtLAddMethodSpecification >> methodClassNameDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #methodClassName;
		  comment: 'The class of the method to be added. This is required and must not be empty.'
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
		  accessor: #sourceCodeOfMethodToAdd;
		  comment: 'The method source code in plain text; do not include the name of the class as the beginning'
]

{ #category : #accessing }
GtLAddMethodSpecification >> sourceCodeOfMethodToAdd [
	^ sourceCode
]

{ #category : #accessing }
GtLAddMethodSpecification >> sourceCodeOfMethodToAdd: anObject [
	sourceCode := anObject
]
