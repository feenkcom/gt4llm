Class {
	#name : #GtLSmaCCTransformationCreateRewriteFileToolExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4Llm-SmaCC-Transformations-Examples'
}

{ #category : #examples }
GtLSmaCCTransformationCreateRewriteFileToolExamples >> createFile [
	<gtExample>
	| model tool call targetObject |
	model := GtLSmaCCTransformationModel new.
	tool := GtLSmaCCTransformationCreateRewriteFileTool new model: model.
	call := self
			executeTool: tool
			withArguments: {'createRewriteFile'
						-> {'filename' -> self newRewritesFile.
								'parserClass' -> 'GtPharoParser'} asDictionary} asDictionary.
	targetObject := call result targetObject.
	self
		assert: (targetObject isKindOf: GtLSmaCCTransformationGetRewriteFileResult).
	self assert: targetObject rewriteFile parserClass equals: 'GtPharoParser'.
	self assert: targetObject rewriteFile rules isEmpty.
	^ call
]

{ #category : #examples }
GtLSmaCCTransformationCreateRewriteFileToolExamples >> createWithInvalidParserClass [
	<gtExample>
	| model tool call targetObject |
	model := GtLSmaCCTransformationModel new.
	tool := GtLSmaCCTransformationCreateRewriteFileTool new model: model.
	call := self
			executeTool: tool
			withArguments: {'createRewriteFile'
						-> {'filename' -> self newRewritesFile.
								'parserClass' -> 'SmaCCParseNode'} asDictionary} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLProblemDomainObject).
	self assert: (targetObject errorMessage includesSubstring: 'SmaCCParseNode').
	^ call
]

{ #category : #examples }
GtLSmaCCTransformationCreateRewriteFileToolExamples >> newRewritesFile [
	^ 'new file.rw'
]
