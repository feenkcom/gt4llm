Class {
	#name : #GtLCodeTransformations,
	#superclass : #Object,
	#instVars : [
		'transformations'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #accessing }
GtLCodeTransformations >> transformations [
	^ transformations
]

{ #category : #accessing }
GtLCodeTransformations >> transformations: anObject [
	transformations := anObject
]

{ #category : #accessing }
GtLCodeTransformations >> transformationsDescription [
	<magritteDescription>
	
	 ^ MAToManyRelationDescription new
			accessor: #transformations;
			classes: {GtLAddClassSpecification . GtLAddMethodSpecification};
			beRequired
]
