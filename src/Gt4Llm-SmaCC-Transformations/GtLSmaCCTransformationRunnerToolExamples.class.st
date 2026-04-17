Class {
	#name : #GtLSmaCCTransformationRunnerToolExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4Llm-SmaCC-Transformations-Examples'
}

{ #category : #examples }
GtLSmaCCTransformationRunnerToolExamples >> runRules [
	<gtExample>
	| model tool call targetObject source file |
	model := GtLSmaCCTransformationGetRewriteFileToolExamples new getFile tool
			model.
	file := model files any.
	tool := GtLSmaCCTransformationRunnerTool new model: model.
	source := 'program HelloWorld;

begin
  if 1 <> 2 then
    Inc(X);
end.'.
	call := self
			executeTool: tool
			withArguments: {'runner'
						-> {'parserClass' -> 'DelphiParser'.
								'source' -> source.
								'filename' -> file filename} asDictionary} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmaCCTransformationResult).
	CSharpParser parse: targetObject transformedSource.
	^ call
]

{ #category : #examples }
GtLSmaCCTransformationRunnerToolExamples >> runRulesWithError [
	<gtExample>
	| model tool call targetObject source file |
	model := GtLSmaCCTransformationAddRuleToolExamples new
			addRewriteToThrowAnError tool model.
	file := model files any.
	tool := GtLSmaCCTransformationRunnerTool new model: model.
	source := 'program HelloWorld;

begin
  if 1 <> 2 then
    Inc(X);
end.'.
	call := self
			executeTool: tool
			withArguments: {'runner'
						-> {'parserClass' -> 'DelphiParser'.
								'source' -> source.
								'filename' -> file filename} asDictionary} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmaCCTransformationRunnerException).
	self assert: targetObject rewriteId equals: file rules last id.
	^ call
]

{ #category : #examples }
GtLSmaCCTransformationRunnerToolExamples >> runRulesWithParseError [
	<gtExample>
	| model tool call targetObject source file |
	model := GtLSmaCCTransformationAddRuleToolExamples new
			addRewriteToThrowAnError tool model.
	file := model files any.
	tool := GtLSmaCCTransformationRunnerTool new model: model.
	source := 'program Hello..World;

begin
  if 1 <> 2 then
    Inc(X);
end.'.
	call := self
			executeTool: tool
			withArguments: {'runner'
						-> {'parserClass' -> 'DelphiParser'.
								'source' -> source.
								'filename' -> file filename} asDictionary} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmaCCTransformationRunnerException).
	self assert: targetObject rewriteId isNil.
	^ call
]
