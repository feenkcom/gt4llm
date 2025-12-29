Class {
	#name : #GtLPushDownMethodTransformationSpecification,
	#superclass : #GtLMethodTransformationSpecification,
	#instVars : [
		'targetClassName',
		'selectors'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #'as yet unclassified' }
GtLPushDownMethodTransformationSpecification class >> isConcrete [
	^ true
]

{ #category : #'as yet unclassified' }
GtLPushDownMethodTransformationSpecification >> asRefactoringIn: aNamespace [
	^ GtPushUpMethodRefactoring
		model: aNamespace
		pullUp: selectors
		from: methodClassName
		to: targetClassName
]

{ #category : #'as yet unclassified' }
GtLPushDownMethodTransformationSpecification >> descriptionContainer [
	^ super descriptionContainer
		comment: 'The "Push down method" transformation pushes down one or more methods identified with selectors from the methodClassName to the targetClassName.'
]

{ #category : #accessing }
GtLPushDownMethodTransformationSpecification >> selectors [
	^ selectors
]

{ #category : #accessing }
GtLPushDownMethodTransformationSpecification >> selectors: anObject [
	selectors := anObject
]

{ #category : #description }
GtLPushDownMethodTransformationSpecification >> selectorsDescription [
	<magritteDescription>
	
	 ^ MAToManyRelationDescription new
		  label: 'Selectors';
		  accessor: #selectors;
	  	classes: {String};
	  	comment: 'The list of selectors of methods to push down'
]

{ #category : #accessing }
GtLPushDownMethodTransformationSpecification >> targetClassName [
	^ targetClassName
]

{ #category : #accessing }
GtLPushDownMethodTransformationSpecification >> targetClassName: anObject [
	targetClassName := anObject
]

{ #category : #description }
GtLPushDownMethodTransformationSpecification >> targetClassNameDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #targetClassName;
		  comment: 'The name of the class in which to push down the methods'
]
