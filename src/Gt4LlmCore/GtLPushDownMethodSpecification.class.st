Class {
	#name : #GtLPushDownMethodSpecification,
	#superclass : #GtLMethodTransformationSpecification,
	#instVars : [
		'targetClassName',
		'selectors'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #'as yet unclassified' }
GtLPushDownMethodSpecification class >> isConcrete [
	^ true
]

{ #category : #'as yet unclassified' }
GtLPushDownMethodSpecification >> asRefactoringIn: aNamespace [
	^ RBPushDownMethodRefactoring
		model: aNamespace
		pushDown: selectors
		from: methodClassName
]

{ #category : #'as yet unclassified' }
GtLPushDownMethodSpecification >> descriptionContainer [
	^ super descriptionContainer
		comment: 'The "Push down method" transformation pushes down one method from a super class to subclasses. The transformation must provide the methodClassName and methodNameToPushDown. The methodClassName is the name of the superclass that implements the methodNameToPushDown. The methodNameToPushDown is the version of the method that is being pushed down to the subclasses.'
]

{ #category : #'as yet unclassified' }
GtLPushDownMethodSpecification >> initialize [
	super initialize.
	selectors := OrderedCollection new
]

{ #category : #'as yet unclassified' }
GtLPushDownMethodSpecification >> methodNameToPushDown [
	^ selectors anyOne
]

{ #category : #'as yet unclassified' }
GtLPushDownMethodSpecification >> methodNameToPushDown: aString [
	selectors add: aString
]

{ #category : #description }
GtLPushDownMethodSpecification >> selectorDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Method name to push down';
		accessor: #methodNameToPushDown;
		comment: 'The name of method to push down';
		beRequired
]

{ #category : #accessing }
GtLPushDownMethodSpecification >> selectors [
	^ selectors
]

{ #category : #accessing }
GtLPushDownMethodSpecification >> selectors: anObject [
	selectors := anObject
]
