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
		from: self behaviorName asSymbol
]

{ #category : #magritte }
GtLRemoveMethodSpecification >> descriptionContainer [
	^ super descriptionContainer
		comment: 'Removes the method methodNameToRemove from the class methodClassName, or from its class side when classSide is true.'
]

{ #category : #printing }
GtLRemoveMethodSpecification >> gtDisplayOn: aStream [
	aStream
		nextPutAll: 'Remove method ';
		nextPutAll: (methodNameToRemove ifNil: [ '<selector>' ]) asString;
		nextPutAll: ' from class ';
		nextPutAll: (methodClassName ifNil: [ '<class>' ] ifNotNil: [ self behaviorName ])
]

{ #category : #validation }
GtLRemoveMethodSpecification >> gtProblems [
	^ self gtProblemsWithMethodNamed: methodNameToRemove
]

{ #category : #magritte }
GtLRemoveMethodSpecification >> methodNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Method name to remove';
		accessor: #methodNameToRemove;
		comment: 'The selector of the method to remove.';
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
