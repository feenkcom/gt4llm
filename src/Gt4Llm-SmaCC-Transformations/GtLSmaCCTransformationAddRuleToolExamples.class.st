Class {
	#name : #GtLSmaCCTransformationAddRuleToolExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4Llm-SmaCC-Transformations-Examples'
}

{ #category : #examples }
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

{ #category : #examples }
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

{ #category : #examples }
GtLSmaCCTransformationAddRuleToolExamples >> addRewriteToThrowAnError [
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

{ #category : #examples }
GtLSmaCCTransformationAddRuleToolExamples >> addRewriteWithInvalidMatchExpression [
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
												-> {'source' -> '3 + + 4'.
														'nodeClass' -> 'SmaCCParseNode'} asDictionary.
											'transformation' -> {'source' -> 'self continue'} asDictionary}
											asDictionary} asDictionary} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLProblemDomainObject).
	self assert: (targetObject errorMessage includesSubstring: 'Invalid match expression').
	self assert: file rules size equals: size.
	^ call
]

{ #category : #examples }
GtLSmaCCTransformationAddRuleToolExamples >> addRewriteWithInvalidMatchNodeClass [
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
														'nodeClass' -> 'SmaCCParseNode1'} asDictionary.
											'transformation' -> {'source' -> 'self continue'} asDictionary}
											asDictionary} asDictionary} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLProblemDomainObject).
	self assert: (targetObject errorMessage includesSubstring: 'SmaCCParseNode1').
	self assert: file rules size equals: size.
	^ call
]

{ #category : #examples }
GtLSmaCCTransformationAddRuleToolExamples >> addRewriteWithInvalidMethodSource [
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
											'source' -> 'fortyTwo ^ 42 ^'} asDictionary} asDictionary}
					asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLProblemDomainObject).
	self assert: (targetObject errorMessage beginsWith: 'Invalid method source').
	self assert: file rules size equals: size.
	^ call
]

{ #category : #examples }
GtLSmaCCTransformationAddRuleToolExamples >> addRewriteWithInvalidTransformationExpression [
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
												-> {'source' -> '3 == 4'.
														'nodeClass' -> 'SmaCCParseNode'} asDictionary.
											'transformation' -> {'source' -> 'self ^continue'} asDictionary}
											asDictionary} asDictionary} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLProblemDomainObject).
	self assert: (targetObject errorMessage includesSubstring: 'Invalid transformation expression').
	self assert: file rules size equals: size.
	^ call
]

{ #category : #examples }
GtLSmaCCTransformationAddRuleToolExamples >> addRewriteWithInvalidTransformationPattern [
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
												-> {'source' -> '3 == 4'.
														'nodeClass' -> 'SmaCCParseNode'} asDictionary.
											'transformation' -> {'pattern' -> '`a'} asDictionary}
											asDictionary} asDictionary} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLProblemDomainObject).
	self assert: (targetObject errorMessage includesSubstring: 'Invalid transformation pattern').
	self assert: file rules size equals: size.
	^ call
]
