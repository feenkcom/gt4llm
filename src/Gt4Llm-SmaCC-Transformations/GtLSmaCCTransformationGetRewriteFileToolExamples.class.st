Class {
	#name : #GtLSmaCCTransformationGetRewriteFileToolExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4Llm-SmaCC-Transformations-Examples'
}

{ #category : #examples }
GtLSmaCCTransformationGetRewriteFileToolExamples >> delphiRewritesFile [
	^ (GtResourcesUtility
		resourceAtPath: Path * 'feenkcom' / 'gt4smacc' / 'resources' / 'Delphi syntax.rw')
		pathString
]

{ #category : #accessing }
GtLSmaCCTransformationGetRewriteFileToolExamples >> getFile [
	<gtExample>
	| model tool call targetObject |
	model := GtLSmaCCTransformationModel new.
	tool := GtLSmaCCTransformationGetRewriteFileTool new model: model.
	call := self
			executeTool: tool
			withArguments: {'rewriteFile' -> {'filename' -> self delphiRewritesFile} asDictionary}
					asDictionary.
	targetObject := call result targetObject.
	self
		assert: (targetObject isKindOf: GtLSmaCCTransformationGetRewriteFileResult).
	self assert: targetObject rewriteFile rules notEmpty.
	^ call
]
