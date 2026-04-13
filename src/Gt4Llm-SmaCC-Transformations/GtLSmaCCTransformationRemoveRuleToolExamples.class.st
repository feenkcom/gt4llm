Class {
	#name : #GtLSmaCCTransformationRemoveRuleToolExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4Llm-SmaCC-Transformations-Examples'
}

{ #category : #'as yet unclassified' }
GtLSmaCCTransformationRemoveRuleToolExamples >> removeRewrite [
	<gtExample>
	| model file call tool targetObject size oldRewrite |
	model := GtLSmaCCTransformationGetRewriteFileToolExamples new getFile tool
			model.
	file := model files any.
	size := file rules size.
	oldRewrite := file rules last.
	tool := GtLSmaCCTransformationRemoveRuleTool new model: model.
	call := self
			executeTool: tool
			withArguments: {'rewriteReference'
						-> {'filename' -> file filename.
								'id' -> oldRewrite id} asDictionary} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmaCCTransformationRewriteChangeResult).
	self assert: targetObject oldRewrite == oldRewrite.
	self assert: targetObject newRewrite isNil.
	self assert: (file rules identityIncludes: oldRewrite) not.
	self assert: file rules size equals: size - 1.
	^ call
]
