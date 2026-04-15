Class {
	#name : #GtLSmaCCTransformationRewriteChangeResult,
	#superclass : #GtLSmaCCTransformationFileReference,
	#instVars : [
		'oldRewrite',
		'newRewrite'
	],
	#category : #'Gt4Llm-SmaCC-Transformations-Tools'
}

{ #category : #views }
GtLSmaCCTransformationRewriteChangeResult >> gtDiffFor: aView [
	<gtView>
	(model isNil or: [ newRewrite isNil and: [ oldRewrite isNil ] ])
		ifTrue: [ ^ aView empty ].
	^ aView explicit
		title: 'Changes';
		stencil: [ oldRewrite
				ifNil: [ BrVerticalPane new
						matchParent;
						addChild: (BrLabel new
								aptitude: BrGlamorousLabelAptitude;
								text: 'New rewrite:';
								yourself);
						addChild: (newRewrite asSmaCCRewriteIn: model) asElement;
						yourself ]
				ifNotNil: [ newRewrite
						ifNil: [ BrVerticalPane new
								matchParent;
								addChild: (BrLabel new
										aptitude: BrGlamorousLabelAptitude;
										text: 'Previous rewrite:';
										yourself);
								addChild: (oldRewrite asSmaCCRewriteIn: model) asElement;
								yourself ]
						ifNotNil: [ BrHorizontalPane new
								matchParent;
								addChild: (BrVerticalPane new
										matchParent;
										addChild: (BrLabel new
												aptitude: BrGlamorousLabelAptitude;
												text: 'Previous rewrite:';
												yourself);
										addChild: (oldRewrite asSmaCCRewriteIn: model) asElement;
										yourself);
								addChild: (BrVerticalPane new
										matchParent;
										addChild: (BrLabel new
												aptitude: BrGlamorousLabelAptitude;
												text: 'New rewrite:';
												yourself);
										addChild: (newRewrite asSmaCCRewriteIn: model) asElement;
										yourself) ] ] ]
]

{ #category : #accessing }
GtLSmaCCTransformationRewriteChangeResult >> newRewrite [
	^ newRewrite
]

{ #category : #accessing }
GtLSmaCCTransformationRewriteChangeResult >> newRewrite: anObject [
	newRewrite := anObject
]

{ #category : #accessing }
GtLSmaCCTransformationRewriteChangeResult >> newRewriteId [
	^ self newRewrite
		ifNil: [ UUID nilUUID asString ]
		ifNotNil: [ self newRewrite id ]
]

{ #category : #accessing }
GtLSmaCCTransformationRewriteChangeResult >> newRewriteIdDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #newRewriteId;
		beReadOnly;
		withUUIDFormatCommentWith: 'The id of the rewrite rule after the change was applied. A nil UUID will be used for a remove rewrite change.'
]

{ #category : #accessing }
GtLSmaCCTransformationRewriteChangeResult >> oldRewrite [
	^ oldRewrite
]

{ #category : #accessing }
GtLSmaCCTransformationRewriteChangeResult >> oldRewrite: anObject [
	oldRewrite := anObject
]

{ #category : #accessing }
GtLSmaCCTransformationRewriteChangeResult >> oldRewriteId [
	^ self oldRewrite
		ifNil: [ UUID nilUUID asString ]
		ifNotNil: [ self oldRewrite id ]
]

{ #category : #accessing }
GtLSmaCCTransformationRewriteChangeResult >> oldRewriteIdDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #oldRewriteId;
		beReadOnly;
		withUUIDFormatCommentWith: 'The id of the original rewrite rule before the change was applied. A nil UUID will be used for an add rewrite change.'
]
