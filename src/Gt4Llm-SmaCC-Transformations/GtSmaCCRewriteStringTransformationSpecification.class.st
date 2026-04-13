Class {
	#name : #GtSmaCCRewriteStringTransformationSpecification,
	#superclass : #GtSmaCCRewriteTransformationSpecification,
	#instVars : [
		'pattern'
	],
	#category : #'Gt4Llm-SmaCC-Transformations-Domain Objects'
}

{ #category : #accessing }
GtSmaCCRewriteStringTransformationSpecification class >> jsonSchemaLabel [
	^ 'SmaCCTransformationPattern'
]

{ #category : #converting }
GtSmaCCRewriteStringTransformationSpecification >> asSmaCCTransformation [
	^ SmaCCRewriteStringTransformation new
		source: self pattern;
		yourself
]

{ #category : #testing }
GtSmaCCRewriteStringTransformationSpecification >> isValid [
	^ [ SmaCCReplaceExpressionParser parse: self pattern.
	true ] on: Error do: [ :ex | ex return: false ]
]

{ #category : #accessing }
GtSmaCCRewriteStringTransformationSpecification >> pattern [
	^ pattern
]

{ #category : #accessing }
GtSmaCCRewriteStringTransformationSpecification >> pattern: anObject [
	pattern := anObject
]

{ #category : #accessing }
GtSmaCCRewriteStringTransformationSpecification >> patternDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #pattern;
		comment: 'A pattern that is used to generate source that replaces the matched node''s source'
]
