Class {
	#name : #GtLAddMethodSpecification,
	#superclass : #GtLMethodTransformationSpecification,
	#instVars : [
		'methodClassName',
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
		comment: 'The "Add method" transformation adds a method to a class. The transformation must provide the className, source, and protocolName for the method.'
]

{ #category : #accessing }
GtLAddMethodSpecification >> methodClassName [
	^ methodClassName
]

{ #category : #accessing }
GtLAddMethodSpecification >> methodClassName: anObject [
	methodClassName := anObject
]

{ #category : #descriptions }
GtLAddMethodSpecification >> methodClassNameDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #methodClassName
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
		  accessor: #sourceCode
]
