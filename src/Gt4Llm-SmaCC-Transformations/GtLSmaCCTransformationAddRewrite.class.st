Class {
	#name : #GtLSmaCCTransformationAddRewrite,
	#superclass : #GtLSmaCCTransformationFileReference,
	#instVars : [
		'rewrite',
		'afterId'
	],
	#category : #'Gt4Llm-SmaCC-Transformations-Tools'
}

{ #category : #actions }
GtLSmaCCTransformationAddRewrite >> addRewrite [
	| newIndex rules newRewrite |
	rules := self rewriteFile rules.
	newIndex := ((1 to: rules size)
			detect: [ :i | (rules at: i) id = afterId ]
			ifNone: [ 0 ]) + 1.
	newRewrite := self rewrite copy.
	newRewrite generateNewId.
	rules add: newRewrite beforeIndex: newIndex.
	^ GtLSmaCCTransformationRewriteChangeResult new
		filename: self filename;
		newRewrite: newRewrite;
		model: self model;
		yourself
]

{ #category : #accessing }
GtLSmaCCTransformationAddRewrite >> afterId [
	^ afterId
]

{ #category : #accessing }
GtLSmaCCTransformationAddRewrite >> afterId: anObject [
	afterId := anObject
]

{ #category : #accessing }
GtLSmaCCTransformationAddRewrite >> afterIdDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #afterId;
		withUUIDFormatCommentWith: 'The id of an existing rewrite where the new rewrite should be inserted into the file. If it is an empty string, then the rule is added at the beginning.'
]

{ #category : #testing }
GtLSmaCCTransformationAddRewrite >> isValid [
	^ super isValid and: [ self rewrite isValid ]
]

{ #category : #accessing }
GtLSmaCCTransformationAddRewrite >> rewrite [
	^ rewrite
]

{ #category : #accessing }
GtLSmaCCTransformationAddRewrite >> rewrite: anObject [
	rewrite := anObject
]

{ #category : #accessing }
GtLSmaCCTransformationAddRewrite >> rewriteDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		accessor: #rewrite;
		classes: GtLSmaCCAbstractRewriteSpecification subclasses;
		comment: 'The new rewrite to insert.';
		beRequired
]
