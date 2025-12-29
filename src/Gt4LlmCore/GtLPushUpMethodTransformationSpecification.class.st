Class {
	#name : #GtLPushUpMethodTransformationSpecification,
	#superclass : #GtLMethodTransformationSpecification,
	#instVars : [
		'targetClassName',
		'selectors'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #'as yet unclassified' }
GtLPushUpMethodTransformationSpecification class >> isConcrete [
	^ true
]

{ #category : #'as yet unclassified' }
GtLPushUpMethodTransformationSpecification >> asRefactoringIn: aNamespace [
	^ GtPushUpMethodRefactoring
		model: aNamespace
		pullUp: selectors
		from: methodClassName
		to: targetClassName
]

{ #category : #'as yet unclassified' }
GtLPushUpMethodTransformationSpecification >> descriptionContainer [
	^ super descriptionContainer
		comment: 'The "Push up method" transformation pushes up one or more methods identified with selectors from the methodClassName to the targetClassName.'
]

{ #category : #accessing }
GtLPushUpMethodTransformationSpecification >> selectors [
	^ selectors
]

{ #category : #accessing }
GtLPushUpMethodTransformationSpecification >> selectors: anObject [
	selectors := anObject
]

{ #category : #description }
GtLPushUpMethodTransformationSpecification >> selectorsDescription [
	<magritteDescription>
	
	 ^ MAToManyRelationDescription new
		  label: 'Selectors';
		  accessor: #selectors;
	  	classes: {String};
	  	comment: 'The list of selectors of methods to push up'
]

{ #category : #accessing }
GtLPushUpMethodTransformationSpecification >> targetClassName [
	^ targetClassName
]

{ #category : #accessing }
GtLPushUpMethodTransformationSpecification >> targetClassName: anObject [
	targetClassName := anObject
]

{ #category : #description }
GtLPushUpMethodTransformationSpecification >> targetClassNameDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #targetClassName;
		  comment: 'The name of the class in which to push up the methods'
]
