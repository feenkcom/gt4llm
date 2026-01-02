Class {
	#name : #GtLRemoveMethodSpecification,
	#superclass : #GtLMethodTransformationSpecification,
	#instVars : [
		'selector'
	],
	#category : #Gt4LlmCore
}

{ #category : #testing }
GtLRemoveMethodSpecification class >> isConcrete [
	^ true
]

{ #category : #refactoring }
GtLRemoveMethodSpecification >> asRefactoringIn: aNamespace [
	^ RBRemoveMethodRefactoring
		model: aNamespace
		selector: (self selector ifNil: [ self error: 'Selector is required' ]) asSymbol
		from: (self methodClassName ifNil: [ self error: 'Method class name is required' ])
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

{ #category : #accessing }
GtLRemoveMethodSpecification >> methodNameToRemove [
	^ selector
]

{ #category : #accessing }
GtLRemoveMethodSpecification >> methodNameToRemove: anObject [
	selector := anObject
]

{ #category : #accessing }
GtLRemoveMethodSpecification >> selector [
	^ selector
]

{ #category : #accessing }
GtLRemoveMethodSpecification >> selector: anObject [
	selector := anObject
]

{ #category : #magritte }
GtLRemoveMethodSpecification >> selectorDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Method name';
		accessor: #methodNameToRemove;
		comment: 'The name of the method to remove.'
]
