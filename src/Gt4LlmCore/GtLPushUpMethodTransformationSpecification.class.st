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

{ #category : #'as yet unclassified' }
GtLPushUpMethodTransformationSpecification >> gtDisplayOn: aStream [
	aStream
		nextPutAll: 'Push up method ';
		nextPutAll: self selector;
		nextPutAll: ' from ';
		nextPutAll: methodClassName
]

{ #category : #'as yet unclassified' }
GtLPushUpMethodTransformationSpecification >> initialize [
	super initialize.
	selectors := OrderedCollection new
]

{ #category : #accessing }
GtLPushUpMethodTransformationSpecification >> selector [
	^ selectors anyOne
]

{ #category : #accessing }
GtLPushUpMethodTransformationSpecification >> selector: aString [
	selectors add: aString
]

{ #category : #description }
GtLPushUpMethodTransformationSpecification >> selectorDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  label: 'Selector';
		  accessor: #selector;
	  	comment: 'The selector of the method to push up'
]

{ #category : #accessing }
GtLPushUpMethodTransformationSpecification >> selectors [
	^ selectors
]

{ #category : #accessing }
GtLPushUpMethodTransformationSpecification >> selectors: anObject [
	selectors := anObject
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
