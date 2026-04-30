Class {
	#name : #GtLToolForWorldScreenshotExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForWorldScreenshotExamples >> worldScreenshotSerialization [
	<gtExample>
	| stubElement tool call targetObject |
	stubElement := BlElement new
		size: 50 @ 50;
		background: Color red.
	tool := GtLToolForWorldScreenshot new worldElementProvider: [ stubElement ].
	call := self
		executeTool: tool
		withArguments: Dictionary new.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLWorldScreenshotDataDomainObject).
	self assert: targetObject encodedBytes size > 0.
	^ call
]

{ #category : #examples }
GtLToolForWorldScreenshotExamples >> worldScreenshotWithoutFocusedWorld [
	<gtExample>
	| tool call |
	tool := GtLToolForWorldScreenshot new worldElementProvider: [ nil ].
	call := self
		executeTool: tool
		withArguments: Dictionary new.
	self assert: call result targetObject isErrorDomainObject.
	self assert: (call result targetObject description includesSubstring: 'No focused GtWorldElement').
	^ call
]
