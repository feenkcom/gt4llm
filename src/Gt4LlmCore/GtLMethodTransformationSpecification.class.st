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
		  accessor: #methodClassName
]
