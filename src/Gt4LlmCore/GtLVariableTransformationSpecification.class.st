Class {
	#name : #GtLVariableTransformationSpecification,
	#superclass : #GtLCodeTransformationSpecification,
	#instVars : [
		'variableName',
		'variableClassName'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #accessing }
GtLVariableTransformationSpecification >> variableClassName [
	^ variableClassName
]

{ #category : #accessing }
GtLVariableTransformationSpecification >> variableClassName: anObject [
	variableClassName := anObject
]

{ #category : #description }
GtLVariableTransformationSpecification >> variableClassNameDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #variableClassName;
		  comment: 'The name of the class in which the variable is defined'
]

{ #category : #accessing }
GtLVariableTransformationSpecification >> variableName [
	^ variableName
]

{ #category : #accessing }
GtLVariableTransformationSpecification >> variableName: anObject [
	variableName := anObject
]

{ #category : #description }
GtLVariableTransformationSpecification >> variableNameDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #variableName;
		  comment: 'The name of the variable '
]
