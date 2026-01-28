Class {
	#name : #GtLPushDownMethodSpecification,
	#superclass : #GtLMethodTransformationSpecification,
	#instVars : [
		'targetClassName',
		'methodNameToPushDown'
	],
	#category : 'Gt4LlmCore-Formats'
}

{ #category : #testing }
GtLPushDownMethodSpecification class >> isConcrete [
	^ false
]

{ #category : #accessing }
GtLPushDownMethodSpecification class >> jsonSchemaLabel [
	^ 'PushDownMethod'
]

{ #category : #'as yet unclassified' }
GtLPushDownMethodSpecification >> asRefactoringIn: aNamespace [
	^ RBPushDownMethodRefactoring
		model: aNamespace
		pushDown: methodNameToPushDown
		from: methodClassName
]

{ #category : #'as yet unclassified' }
GtLPushDownMethodSpecification >> descriptionContainer [
	^ super descriptionContainer
		comment: 'The "Push down method" transformation pushes down one method from a super class to subclasses. The transformation must provide the methodClassName and methodNameToPushDown. The methodClassName is the name of the superclass that implements the methodNameToPushDown. The methodNameToPushDown is the version of the method that is being pushed down to the subclasses.'
]

{ #category : #descriptions }
GtLPushDownMethodSpecification >> methodClassNameDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #methodClassName;
		  comment: 'The class of the method to be pushed down. This is required and must not be empty.'
]

{ #category : #'as yet unclassified' }
GtLPushDownMethodSpecification >> methodNameToPushDown [
	^ methodNameToPushDown
]

{ #category : #'as yet unclassified' }
GtLPushDownMethodSpecification >> methodNameToPushDown: aString [
	methodNameToPushDown := aString
]

{ #category : #description }
GtLPushDownMethodSpecification >> methodNameToPushDownDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Name of the method to push down';
		accessor: #methodNameToPushDown;
		comment: 'The name of method to push down. This is required and must not be empty.';
		beRequired
]
