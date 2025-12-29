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
