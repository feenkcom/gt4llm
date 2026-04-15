Class {
	#name : #GtSmaCCRewriteTypeMatchSpecification,
	#superclass : #GtSmaCCRewriteMatchSpecification,
	#instVars : [
		'nodeClass',
		'source'
	],
	#category : #'Gt4Llm-SmaCC-Transformations-Domain Objects'
}

{ #category : #accessing }
GtSmaCCRewriteTypeMatchSpecification class >> jsonSchemaLabel [
	^ 'SmaCCExpressionMatch'
]

{ #category : #converting }
GtSmaCCRewriteTypeMatchSpecification >> asSmaCCMatch [
	^ SmaCCRewriteTypeMatch new
		nodeClass: (Smalltalk at: self nodeClass asSymbol ifAbsent: [ SmaCCParseNode ]);
		code: self source;
		yourself
]

{ #category : #testing }
GtSmaCCRewriteTypeMatchSpecification >> isValid [
	^ (Smalltalk globals includesKey: self nodeClass asSymbol)
		and: [ [ RBParser parseExpression: self source.
			true ] on: Error do: [ :ex | ex return: false ] ]
]

{ #category : #accessing }
GtSmaCCRewriteTypeMatchSpecification >> nodeClass [
	^ nodeClass
]

{ #category : #accessing }
GtSmaCCRewriteTypeMatchSpecification >> nodeClass: anObject [
	nodeClass := anObject
]

{ #category : #accessing }
GtSmaCCRewriteTypeMatchSpecification >> nodeClassDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #nodeClass;
		comment: 'Only match nodes of this class or its subclasses. Use SmaCCParseNode to match any node.'
]

{ #category : #accessing }
GtSmaCCRewriteTypeMatchSpecification >> source [
	^ source
]

{ #category : #accessing }
GtSmaCCRewriteTypeMatchSpecification >> source: anObject [
	source := anObject
]

{ #category : #accessing }
GtSmaCCRewriteTypeMatchSpecification >> sourceDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #source;
		comment: 'The source of the Smalltalk expression to evaluate to test if the transformation should be run on the current node. Return true if the transformation should be run. Use an empty string if the transformation should always be run.'
]
