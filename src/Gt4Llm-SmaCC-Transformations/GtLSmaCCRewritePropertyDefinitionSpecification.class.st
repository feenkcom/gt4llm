Class {
	#name : #GtLSmaCCRewritePropertyDefinitionSpecification,
	#superclass : #GtLSmaCCAbstractRewriteSpecification,
	#instVars : [
		'comment',
		'localProperties',
		'globalProperties'
	],
	#category : #'Gt4Llm-SmaCC-Transformations-Domain Objects'
}

{ #category : #accessing }
GtLSmaCCRewritePropertyDefinitionSpecification class >> jsonSchemaLabel [
	^ 'SmaCCRewriteProperties'
]

{ #category : #converting }
GtLSmaCCRewritePropertyDefinitionSpecification >> asSmaCCRewriteIn: aModel [
	| defn |
	defn := SmaCCRewritePropertyDefinition new.
	defn comment: self comment.
	self localProperties do: [ :each | defn addLocal: each ].
	self globalProperties do: [ :each | defn addGlobal: each ].
	^ defn
]

{ #category : #accessing }
GtLSmaCCRewritePropertyDefinitionSpecification >> comment [
	^ comment
]

{ #category : #accessing }
GtLSmaCCRewritePropertyDefinitionSpecification >> comment: aString [
	comment := aString
]

{ #category : #accessing }
GtLSmaCCRewritePropertyDefinitionSpecification >> commentDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #comment;
		comment: 'An optional comment for the rule. It is used for a label when displayed.'
]

{ #category : #accessing }
GtLSmaCCRewritePropertyDefinitionSpecification >> globalProperties [
	^ globalProperties
]

{ #category : #accessing }
GtLSmaCCRewritePropertyDefinitionSpecification >> globalProperties: anObject [
	globalProperties := anObject
]

{ #category : #accessing }
GtLSmaCCRewritePropertyDefinitionSpecification >> globalPropertiesDescription [
	<magritteDescription>
	^ MAToManyScalarRelationDescription new
		label: 'Global globalProperties (keeps value from previous runs)';
		accessor: #globalProperties;
		classes: {String}
]

{ #category : #testing }
GtLSmaCCRewritePropertyDefinitionSpecification >> isValid [
	^ (self localProperties allSatisfy: [ :each | RBScanner isVariable: each ])
		and: [ self globalProperties allSatisfy: [ :each | RBScanner isVariable: each ] ]
]

{ #category : #accessing }
GtLSmaCCRewritePropertyDefinitionSpecification >> localProperties [
	^ localProperties
]

{ #category : #accessing }
GtLSmaCCRewritePropertyDefinitionSpecification >> localProperties: anObject [
	localProperties := anObject
]

{ #category : #accessing }
GtLSmaCCRewritePropertyDefinitionSpecification >> localPropertiesDescription [
	<magritteDescription>
	^ MAToManyScalarRelationDescription new
		label: 'Local localProperties (reset to nil for each run)';
		accessor: #localProperties;
		classes: {String}
]
