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
	^ true
]

{ #category : #accessing }
GtLRemoveMethodSpecification class >> jsonSchemaLabel [
	^ 'RemoveMethod'
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
		comment: 'Removes the method methodNameToRemove from the class methodClassName.'
]

{ #category : #printing }
GtLRemoveMethodSpecification >> gtDisplayOn: aStream [
	| selectorString className |
	selectorString := (self methodNameToRemove ifNil: [ '<selector>' ]) asString.
	className := self methodClassName ifNil: [ '<class>' ].
	aStream
		nextPutAll: 'Remove method ';
		nextPutAll: selectorString;
		nextPutAll: ' from class ';
		nextPutAll: className
]

{ #category : #validation }
GtLRemoveMethodSpecification >> gtProblems [
	^ self gtProblemsWithMethod: methodNameToRemove inClassNamed: methodClassName
]

{ #category : #descriptions }
GtLRemoveMethodSpecification >> methodClassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #methodClassName;
		comment: 'The class that defines the method.';
		beRequired
]

{ #category : #magritte }
GtLRemoveMethodSpecification >> methodNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Method name';
		accessor: #methodNameToRemove;
		comment: 'The name of the method to remove.';
		beRequired
]

{ #category : #accessing }
GtLRemoveMethodSpecification >> methodNameToRemove [
	^ methodNameToRemove
]

{ #category : #accessing }
GtLRemoveMethodSpecification >> methodNameToRemove: anObject [
	methodNameToRemove := anObject
]
