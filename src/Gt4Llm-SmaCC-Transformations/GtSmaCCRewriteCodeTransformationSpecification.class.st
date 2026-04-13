Class {
	#name : #GtSmaCCRewriteCodeTransformationSpecification,
	#superclass : #GtSmaCCRewriteTransformationSpecification,
	#instVars : [
		'source'
	],
	#category : #'Gt4Llm-SmaCC-Transformations-Domain Objects'
}

{ #category : #accessing }
GtSmaCCRewriteCodeTransformationSpecification class >> jsonSchemaLabel [
	^ 'SmaCCTransformationExpression'
]

{ #category : #converting }
GtSmaCCRewriteCodeTransformationSpecification >> asSmaCCTransformation [
	^ SmaCCRewriteCodeTransformation new
		code: self source;
		yourself
]

{ #category : #testing }
GtSmaCCRewriteCodeTransformationSpecification >> isValid [
	^ [ RBParser parseExpression: self source.
	true ] on: Error do: [ :ex | ex return: false ]
]

{ #category : #accessing }
GtSmaCCRewriteCodeTransformationSpecification >> source [
	^ source
]

{ #category : #accessing }
GtSmaCCRewriteCodeTransformationSpecification >> source: anObject [
	source := anObject
]

{ #category : #accessing }
GtSmaCCRewriteCodeTransformationSpecification >> sourceDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #source;
		comment: 'Smalltalk source that performs the transformation'
]
