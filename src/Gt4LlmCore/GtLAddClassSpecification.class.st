Class {
	#name : #GtLAddClassSpecification,
	#superclass : #GtLClassTransformationSpecification,
	#instVars : [
		'newClassName',
		'packageName',
		'slotNames',
		'tagName',
		'superclassName'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #'as yet unclassified' }
GtLAddClassSpecification class >> isConcrete [
	^ true
]

{ #category : #'as yet unclassified' }
GtLAddClassSpecification >> asRefactoringIn: aNamespace [
	^ (GtRBAddClassWithVarsRefactoring
		model: aNamespace
		addClass: newClassName asSymbol
		superclass: superclassName asSymbol
		subclasses: {}
		category: packageName asSymbol)
		instanceVariableNames: (Character space split: slotNames)
]

{ #category : #'as yet unclassified' }
GtLAddClassSpecification >> descriptionContainer [
	^ super descriptionContainer
		comment: 'The "Add class" transformation adds a class into the system. The transformation must provide the className, packageName, and slotNames.'
]

{ #category : #'as yet unclassified' }
GtLAddClassSpecification >> gtDisplayOn: aStream [
	aStream
		nextPutAll: 'Add class ';
		nextPutAll: (newClassName);
		nextPutAll: ' as subclass of ';
		nextPutAll: superclassName;
		nextPutAll: ' with slots ';
		nextPutAll: slotNames
]

{ #category : #accessing }
GtLAddClassSpecification >> newClassName [
	^ newClassName
]

{ #category : #accessing }
GtLAddClassSpecification >> newClassName: anObject [
	newClassName := anObject
]

{ #category : #description }
GtLAddClassSpecification >> newClassNameDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #newClassName
]

{ #category : #accessing }
GtLAddClassSpecification >> packageName [
	^ packageName
]

{ #category : #accessing }
GtLAddClassSpecification >> packageName: anObject [
	packageName := anObject
]

{ #category : #description }
GtLAddClassSpecification >> packageNameDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #packageName
]

{ #category : #accessing }
GtLAddClassSpecification >> slotNames [
	^ slotNames
]

{ #category : #accessing }
GtLAddClassSpecification >> slotNames: anObject [
	slotNames := anObject
]

{ #category : #description }
GtLAddClassSpecification >> slotNamesDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #slotNames";
		  classes: {String}"
]

{ #category : #accessing }
GtLAddClassSpecification >> superclassName [
	^ superclassName
]

{ #category : #accessing }
GtLAddClassSpecification >> superclassName: anObject [
	superclassName := anObject
]

{ #category : #description }
GtLAddClassSpecification >> superclassNameDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #superclassName
]

{ #category : #accessing }
GtLAddClassSpecification >> tagName [
	^ tagName
]

{ #category : #accessing }
GtLAddClassSpecification >> tagName: anObject [
	tagName := anObject
]

{ #category : #description }
GtLAddClassSpecification >> tagNameDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #tagName
]
