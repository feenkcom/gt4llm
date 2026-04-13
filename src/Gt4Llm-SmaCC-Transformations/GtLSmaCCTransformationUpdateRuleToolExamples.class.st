Class {
	#name : #GtLSmaCCTransformationUpdateRuleToolExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4Llm-SmaCC-Transformations-Examples'
}

{ #category : #'as yet unclassified' }
GtLSmaCCTransformationUpdateRuleToolExamples >> updateRewrite [
	<gtExample>
	| model file call tool targetObject size oldRule |
	model := GtLSmaCCTransformationGetRewriteFileToolExamples new getFile tool
			model.
	file := model files any.
	size := file rules size.
	oldRule := file rules last.
	tool := GtLSmaCCTransformationUpdateRuleTool new model: model.
	call := self
			executeTool: tool
			withArguments: {'updateRewrite'
						-> {'filename' -> file filename.
								'id' -> oldRule id.
								'rewrite'
									-> {'comment' -> 'This is a method rule'.
											'id' -> UUID nilUUID asString.
											'source' -> 'fortyTwo ^ 42'} asDictionary} asDictionary} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmaCCTransformationRewriteChangeResult).
	self assert: targetObject oldRewrite == oldRule.
	self
		assert: (targetObject newRewrite isKindOf: GtLSmaCCRewriteMethodSpecification).
	self assert: file rules last == targetObject newRewrite.
	self assert: file rules size equals: size.
	^ call
]
