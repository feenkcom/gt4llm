Class {
	#name : #GtLSmaCCRewriteSpecification,
	#superclass : #GtLSmaCCAbstractRewriteSpecification,
	#instVars : [
		'match',
		'transformation',
		'comment'
	],
	#category : #'Gt4Llm-SmaCC-Transformations-Domain Objects'
}

{ #category : #accessing }
GtLSmaCCRewriteSpecification class >> jsonSchemaLabel [
	^ 'SmaCCRewrite'
]

{ #category : #converting }
GtLSmaCCRewriteSpecification >> asSmaCCRewriteIn: aModel [
	^ SmaCCRewrite new
		comment: self comment;
		match: self match asSmaCCMatch;
		transformation: self transformation asSmaCCTransformation;
		yourself
]

{ #category : #accessing }
GtLSmaCCRewriteSpecification >> comment [
	^ comment
]

{ #category : #accessing }
GtLSmaCCRewriteSpecification >> comment: aString [
	comment := aString
]

{ #category : #accessing }
GtLSmaCCRewriteSpecification >> commentDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #comment;
		comment: 'An optional comment for the rule. It is used for a label when displayed.'
]

{ #category : #testing }
GtLSmaCCRewriteSpecification >> isValid [
	^ self match isValid and: [ self transformation isValid ]
]

{ #category : #accessing }
GtLSmaCCRewriteSpecification >> match [
	^ match
]

{ #category : #accessing }
GtLSmaCCRewriteSpecification >> match: anObject [
	match := anObject
]

{ #category : #accessing }
GtLSmaCCRewriteSpecification >> matchDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		accessor: #match;
		classes: GtSmaCCRewriteMatchSpecification subclasses;
		beRequired
]

{ #category : #accessing }
GtLSmaCCRewriteSpecification >> transformation [
	^ transformation
]

{ #category : #accessing }
GtLSmaCCRewriteSpecification >> transformation: anObject [
	transformation := anObject
]

{ #category : #accessing }
GtLSmaCCRewriteSpecification >> transformationDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		accessor: #transformation;
		classes: GtSmaCCRewriteTransformationSpecification subclasses;
		beRequired
]
