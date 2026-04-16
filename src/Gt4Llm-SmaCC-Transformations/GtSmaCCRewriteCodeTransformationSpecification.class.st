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

{ #category : #accessing }
GtSmaCCRewriteCodeTransformationSpecification >> errorMessage [
	^ [ RBParser parseExpression: self source.
	nil ] on: Error do: [ :ex | ex return: 'Invalid transformation expression (' , ex messageText , ')' ]
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
