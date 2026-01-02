Class {
	#name : #GtLRemoveMethodSpecification,
	#superclass : #GtLMethodTransformationSpecification,
	#instVars : [
		'methodNameToRemove'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #testing }
GtLRemoveMethodSpecification class >> isConcrete [
	^ false
]

{ #category : #refactoring }
GtLRemoveMethodSpecification >> asRefactoringIn: aNamespace [
	^ RBRemoveMethodRefactoring
		model: aNamespace
		selector: methodNameToRemove asSymbol
		from: methodClassName asSymbol
]

{ #category : #magritte }
GtLRemoveMethodSpecification >> descriptionContainer [
	^ super descriptionContainer
		comment: 'The "Remove method" transformation removes a method identified by methodNameToRemove from the class named methodClassName.'
]

{ #category : #printing }
GtLRemoveMethodSpecification >> gtDisplayOn: aStream [
	| selectorString className |
	selectorString := (self selector ifNil: [ '<selector>' ]) asString.
	className := self methodClassName ifNil: [ '<class>' ].
	aStream
		nextPutAll: 'Remove method ';
		nextPutAll: selectorString;
		nextPutAll: ' from class ';
		nextPutAll: className
]

{ #category : #magritte }
GtLRemoveMethodSpecification >> methodNameDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Method name';
		accessor: #methodNameToRemove;
		comment: 'The name of the method to remove.'
]

{ #category : #accessing }
GtLRemoveMethodSpecification >> methodNameToRemove [
	^ methodNameToRemove
]

{ #category : #accessing }
GtLRemoveMethodSpecification >> methodNameToRemove: anObject [
	methodNameToRemove := anObject
]
