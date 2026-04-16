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

{ #category : #accessing }
GtSmaCCRewriteStringTransformationSpecification >> errorMessage [
	^ [ SmaCCReplaceExpressionParser parse: self pattern.
	nil ] on: Error do: [ :ex | ex return: 'Invalid transformation pattern (' , ex messageText , ')' ]
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
