Class {
	#name : #GtLMethodTransformationSpecification,
	#superclass : #GtLCodeTransformationSpecification,
	#instVars : [
		'methodClassName'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #accessing }
GtLMethodTransformationSpecification >> methodClassName [
	^ methodClassName
]

{ #category : #accessing }
GtLMethodTransformationSpecification >> methodClassName: anObject [
	methodClassName := anObject
]

{ #category : #descriptions }
GtLMethodTransformationSpecification >> methodClassNameDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #methodClassName;
		  comment: 'The class of the method to be pushed down. This is required and must not be empty.'
]
