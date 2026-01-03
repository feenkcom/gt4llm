Class {
	#name : #GtLPushUpMethodSpecification,
	#superclass : #GtLMethodTransformationSpecification,
	#instVars : [
		'targetClassName',
		'selectors'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #'as yet unclassified' }
GtLPushUpMethodSpecification class >> isConcrete [
	^ true
]

{ #category : #'as yet unclassified' }
GtLPushUpMethodSpecification >> asRefactoringIn: aNamespace [
	^ GtPushUpMethodRefactoring
		model: aNamespace
		pullUp: (selectors collect: #asSymbol)
		from: methodClassName asSymbol
		to: targetClassName asSymbol
]

{ #category : #'as yet unclassified' }
GtLPushUpMethodSpecification >> descriptionContainer [
	^ super descriptionContainer
		comment: 'The "Push up method" transformation pushes up a method from a subclass to a direct or indirect superclass. If the method exists in other sibling subclasses of the superclass and is equivalently defined, the method will be removed from the sibling subclasses too. The transformation must provide the methodClassName, methodNameToPushUp and targetClassName. The methodClassName is the name of a subclass that implements the methodNameToPushUp. The methodNameToPushUp is the version of the method that is being pushed up to the superclass. The targetClassName is the name of the superclass to which to push.'
]

{ #category : #'as yet unclassified' }
GtLPushUpMethodSpecification >> gtDisplayOn: aStream [
	aStream
		nextPutAll: 'Push up method ';
		nextPutAll: self selector;
		nextPutAll: ' from ';
		nextPutAll: methodClassName
]

{ #category : #'as yet unclassified' }
GtLPushUpMethodSpecification >> initialize [
	super initialize.
	selectors := OrderedCollection new
]

{ #category : #descriptions }
GtLPushUpMethodSpecification >> methodClassNameDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #methodClassName;
		  comment: 'The class of the method to be pushed up. This is required and must not be empty.'
]

{ #category : #accessing }
GtLPushUpMethodSpecification >> methodNameToPushUp [
	^ selectors anyOne
]

{ #category : #accessing }
GtLPushUpMethodSpecification >> methodNameToPushUp: aString [
	selectors add: aString
]

{ #category : #accessing }
GtLPushUpMethodSpecification >> selector [
	^ selectors anyOne
]

{ #category : #accessing }
GtLPushUpMethodSpecification >> selector: aString [
	selectors add: aString
]

{ #category : #description }
GtLPushUpMethodSpecification >> selectorDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  label: 'Method name to push up';
		  accessor: #methodNameToPushUp;
	  	comment: 'The name of the method to push up'
]

{ #category : #accessing }
GtLPushUpMethodSpecification >> selectors [
	^ selectors
]

{ #category : #accessing }
GtLPushUpMethodSpecification >> selectors: anObject [
	selectors := anObject
]

{ #category : #accessing }
GtLPushUpMethodSpecification >> targetClassName [
	^ targetClassName
]

{ #category : #accessing }
GtLPushUpMethodSpecification >> targetClassName: anObject [
	targetClassName := anObject
]

{ #category : #description }
GtLPushUpMethodSpecification >> targetClassNameDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #targetClassName;
		  comment: 'The name of the class in which to push up the methods'
]
