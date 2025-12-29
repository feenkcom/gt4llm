Class {
	#name : #GtLPushUpInstanceVariableTransformationSpecification,
	#superclass : #GtLVariableTransformationSpecification,
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #'as yet unclassified' }
GtLPushUpInstanceVariableTransformationSpecification class >> isConcrete [
	^ true
]

{ #category : #'as yet unclassified' }
GtLPushUpInstanceVariableTransformationSpecification >> asRefactoringIn: aGtRBNamespace [
	^ RBPullUpInstanceVariableRefactoring
		model: aGtRBNamespace
		variable: variableName
		class: variableClassName
]

{ #category : #'as yet unclassified' }
GtLPushUpInstanceVariableTransformationSpecification >> descriptionContainer [
	^ super descriptionContainer
		comment: 'The "Push up instance slot" transformation pushes up one slot from the variableClassName to the superclass.'
]

{ #category : #'as yet unclassified' }
GtLPushUpInstanceVariableTransformationSpecification >> gtDisplayOn: aStream [
	aStream
		nextPutAll: 'Push up slot ';
		nextPutAll: variableName;
		nextPutAll: ' to ';
		nextPutAll: variableClassName
]

{ #category : #description }
GtLPushUpInstanceVariableTransformationSpecification >> variableClassNameDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #variableClassName;
		  comment: 'The name of the target superclass to which the variable is to be pushed'
]
