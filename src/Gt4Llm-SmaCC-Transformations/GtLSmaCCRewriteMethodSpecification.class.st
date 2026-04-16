Class {
	#name : #GtLSmaCCRewriteMethodSpecification,
	#superclass : #GtLSmaCCAbstractRewriteSpecification,
	#instVars : [
		'source',
		'comment'
	],
	#category : #'Gt4Llm-SmaCC-Transformations-Domain Objects'
}

{ #category : #accessing }
GtLSmaCCRewriteMethodSpecification class >> jsonSchemaLabel [
	^ 'SmaCCRewriteMethod'
]

{ #category : #converting }
GtLSmaCCRewriteMethodSpecification >> asSmaCCRewriteIn: aModel [
	^ SmaCCRewriteMethodDefinition new
		comment: self comment;
		source: self source;
		yourself
]

{ #category : #accessing }
GtLSmaCCRewriteMethodSpecification >> comment [
	^ comment
]

{ #category : #accessing }
GtLSmaCCRewriteMethodSpecification >> comment: aString [
	comment := aString
]

{ #category : #accessing }
GtLSmaCCRewriteMethodSpecification >> commentDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #comment;
		comment: 'An optional comment for the rule. It is used for a label when displayed.'
]

{ #category : #accessing }
GtLSmaCCRewriteMethodSpecification >> errorMessage [
	^ [ RBParser parseMethod: self source.
	nil ]
		on: Error
		do: [ :ex | ex return: 'Invalid method source (' , ex messageText , ')' ]
]

{ #category : #accessing }
GtLSmaCCRewriteMethodSpecification >> source [
	^ source
]

{ #category : #accessing }
GtLSmaCCRewriteMethodSpecification >> source: anObject [
	source := anObject
]

{ #category : #accessing }
GtLSmaCCRewriteMethodSpecification >> sourceDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #source;
		comment: 'The source of a Smalltalk method to create. Only the source for a single method should be provided.'
]
