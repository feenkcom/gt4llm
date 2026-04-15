Class {
	#name : #GtLSmaCCTransformationAddRuleToolExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4Llm-SmaCC-Transformations-Examples'
}

{ #category : #'as yet unclassified' }
GtLSmaCCTransformationAddRuleToolExamples >> addRewriteAtBeginning [
	<gtExample>
	| model file call tool targetObject size |
	model := GtLSmaCCTransformationGetRewriteFileToolExamples new getFile tool
			model.
	file := model files any.
	size := file rules size.
	tool := GtLSmaCCTransformationAddRuleTool new model: model.
	call := self
			executeTool: tool
			withArguments: {'addRewrite'
						-> {'filename' -> file filename.
								'afterId' -> UUID nilUUID asString.
								'rewrite'
									-> {'comment' -> 'This is a method rule'.
											'id' -> UUID nilUUID asString.
											'source' -> 'fortyTwo ^ 42'} asDictionary} asDictionary} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmaCCTransformationRewriteChangeResult).
	self assert: targetObject oldRewrite isNil.
	self
		assert: (targetObject newRewrite isKindOf: GtLSmaCCRewriteMethodSpecification).
	self assert: file rules first == targetObject newRewrite.
	self assert: file rules size equals: size + 1.
	^ call
]

{ #category : #'as yet unclassified' }
GtLSmaCCTransformationAddRuleToolExamples >> addRewriteEnd [
	<gtExample>
	| model file call tool targetObject size |
	model := GtLSmaCCTransformationGetRewriteFileToolExamples new getFile tool
			model.
	file := model files any.
	size := file rules size.
	tool := GtLSmaCCTransformationAddRuleTool new model: model.
	call := self
			executeTool: tool
			withArguments: {'addRewrite'
						-> {'filename' -> file filename.
								'afterId' -> file rules last id.
								'rewrite'
									-> {'comment' -> 'This is a method rule'.
											'id' -> UUID nilUUID asString.
											'source' -> 'fortyTwo ^ 42'} asDictionary} asDictionary} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmaCCTransformationRewriteChangeResult).
	self assert: targetObject oldRewrite isNil.
	self
		assert: (targetObject newRewrite isKindOf: GtLSmaCCRewriteMethodSpecification).
	self assert: file rules last == targetObject newRewrite.
	self assert: file rules size equals: size + 1.
	^ call
]

{ #category : #'as yet unclassified' }
GtLSmaCCTransformationAddRuleToolExamples >> addRewriteToThrowsAndError [
	<gtExample>
	| model file call tool targetObject size |
	model := GtLSmaCCTransformationGetRewriteFileToolExamples new getFile tool
			model.
	file := model files any.
	size := file rules size.
	tool := GtLSmaCCTransformationAddRuleTool new model: model.
	call := self
			executeTool: tool
			withArguments: {'addRewrite'
						-> {'filename' -> file filename.
								'afterId' -> file rules last id.
								'rewrite'
									-> {'comment' -> ''.
											'id' -> UUID nilUUID asString.
											'match'
												-> {'source' -> ''.
														'nodeClass' -> 'SmaCCParseNode'} asDictionary.
											'transformation'
												-> {'source' -> 'self error: ''testing'''} asDictionary}
											asDictionary} asDictionary} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmaCCTransformationRewriteChangeResult).
	self assert: targetObject oldRewrite isNil.
	self assert: (targetObject newRewrite isKindOf: GtLSmaCCRewriteSpecification).
	self assert: file rules last == targetObject newRewrite.
	self assert: file rules size equals: size + 1.
	^ call
]
