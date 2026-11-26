Class {
	#name : #GtLVariableTransformationSpecification,
	#superclass : #GtLCodeTransformationSpecification,
	#instVars : [
		'variableClassName'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #accessing }
GtLVariableTransformationSpecification >> usedClassNames [
	^ {variableClassName} reject: [ :each | each isNil ]
]

{ #category : #accessing }
GtLVariableTransformationSpecification >> variableClassName [
	^ variableClassName
]

{ #category : #accessing }
GtLVariableTransformationSpecification >> variableClassName: anObject [
	variableClassName := anObject
]
