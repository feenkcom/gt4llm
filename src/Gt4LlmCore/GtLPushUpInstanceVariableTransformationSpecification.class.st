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
	^ GtRBPullUpInstanceVariableRefactoring
		model: aGtRBNamespace
		variable: variableName
		class: variableClassName
]

{ #category : #'as yet unclassified' }
GtLPushUpInstanceVariableTransformationSpecification >> descriptionContainer [
	^ super descriptionContainer
		comment: 'The "Push up instance variable" transformation pulls up instance variable definitions from subclasses into a superclass. The transformation must provide the variableClassName and variableName. The variablClassName specifies the superclass that will define variableName after the transformation is executed.'
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
