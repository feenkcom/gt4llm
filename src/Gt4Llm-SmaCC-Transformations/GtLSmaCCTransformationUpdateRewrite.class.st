Class {
	#name : #GtLSmaCCTransformationUpdateRewrite,
	#superclass : #GtLSmaCCTransformationFileReference,
	#instVars : [
		'rewrite',
		'id'
	],
	#category : #'Gt4Llm-SmaCC-Transformations-Tools'
}

{ #category : #accessing }
GtLSmaCCTransformationUpdateRewrite >> errorMessage [
	^ self rewrite errorMessage
]

{ #category : #accessing }
GtLSmaCCTransformationUpdateRewrite >> id [
	^ id
]

{ #category : #accessing }
GtLSmaCCTransformationUpdateRewrite >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtLSmaCCTransformationUpdateRewrite >> idDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #id;
		withUUIDFormatCommentWith: 'The UUID of the rewrite to be updated.'
]

{ #category : #accessing }
GtLSmaCCTransformationUpdateRewrite >> rewrite [
	^ rewrite
]

{ #category : #accessing }
GtLSmaCCTransformationUpdateRewrite >> rewrite: anObject [
	rewrite := anObject
]

{ #category : #accessing }
GtLSmaCCTransformationUpdateRewrite >> rewriteDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		accessor: #rewrite;
		classes: GtLSmaCCAbstractRewriteSpecification subclasses;
		comment: 'The new rewrite to insert.';
		beRequired
]

{ #category : #actions }
GtLSmaCCTransformationUpdateRewrite >> updateRewrite [
	| index rules originalRewrite newRewrite |
	rules := self rewriteFile rules.
	index := (1 to: rules size) detect: [ :i | (rules at: i) id = id ].
	originalRewrite := rules at: index.
	newRewrite := self rewrite copy.
	newRewrite generateNewId.
	rules at: index put: newRewrite.
	^ GtLSmaCCTransformationRewriteChangeResult new
		filename: self filename;
		oldRewrite: originalRewrite;
		newRewrite: newRewrite;
		model: self model;
		yourself
]
