Class {
	#name : #GtLSmaCCTransformationRewriteReference,
	#superclass : #GtLSmaCCTransformationFileReference,
	#instVars : [
		'id'
	],
	#category : #'Gt4Llm-SmaCC-Transformations-Tools'
}

{ #category : #accessing }
GtLSmaCCTransformationRewriteReference >> errorMessage [
	^ self rewrite isNil
		ifTrue: [ 'Could not find rewrite with id: `' , self id , '`' ]
]

{ #category : #accessing }
GtLSmaCCTransformationRewriteReference >> id [
	^ id
]

{ #category : #accessing }
GtLSmaCCTransformationRewriteReference >> id: anInteger [
	id := anInteger
]

{ #category : #accessing }
GtLSmaCCTransformationRewriteReference >> idDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #id;
		withUUIDFormatCommentWith: 'The UUID of the rewrite rule.'
]

{ #category : #actions }
GtLSmaCCTransformationRewriteReference >> removeRewrite [
	| originalRewrite |
	originalRewrite := self rewrite.
	self rewriteFile rules remove: originalRewrite.
	^ GtLSmaCCTransformationRewriteChangeResult new
		filename: self filename;
		oldRewrite: originalRewrite;
		model: self model;
		yourself
]

{ #category : #accessing }
GtLSmaCCTransformationRewriteReference >> rewrite [
	^ self rewriteFile rules detect: [ :each | each id = id ] ifNone: [  ]
]
