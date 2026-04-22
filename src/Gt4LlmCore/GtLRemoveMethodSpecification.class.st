Class {
	#name : #GtLRemoveMethodSpecification,
	#superclass : #GtLMethodTransformationSpecification,
	#instVars : [
		'methodNameToRemove'
	],
	#category : 'Gt4LlmCore-Formats'
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
		comment: 'The "Remove method" transformation removes a method identified by methodNameToRemove from the class named methodClassName. Only use it in case code needs to be removed.'
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

{ #category : #descriptions }
GtLRemoveMethodSpecification >> methodClassNameDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #methodClassName;
		  comment: 'The class holding the method to be removed. This is required and must not be empty.'
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
