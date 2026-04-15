Class {
	#name : #GtLSmaCCRewriteFileReferenceSpecification,
	#superclass : #GtLSmaCCAbstractRewriteSpecification,
	#instVars : [
		'filename'
	],
	#category : #'Gt4Llm-SmaCC-Transformations-Domain Objects'
}

{ #category : #'json schema' }
GtLSmaCCRewriteFileReferenceSpecification class >> jsonSchemaLabel [
	^ 'SmaCCRewriteFileReference'
]

{ #category : #converting }
GtLSmaCCRewriteFileReferenceSpecification >> asSmaCCRewriteIn: aModel [
	^ (aModel specificationFor: self filename) asSmaCCRewriteIn: aModel
]

{ #category : #accessing }
GtLSmaCCRewriteFileReferenceSpecification >> filename [
	^ filename
]

{ #category : #accessing }
GtLSmaCCRewriteFileReferenceSpecification >> filename: anObject [
	filename := anObject
]

{ #category : #accessing }
GtLSmaCCRewriteFileReferenceSpecification >> filenameDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #filename;
		comment: 'Filename for the rules'
]
