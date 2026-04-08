Class {
	#name : #GtLToolForWorldScreenshotExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForWorldScreenshotExamples >> worldScreenshotSerialization [
	<gtExample>
	| stubElement tool domainObject |
	stubElement := BlElement new
		size: 50 @ 50;
		background: Color red.
	tool := GtLToolForWorldScreenshot new worldElementProvider: [ stubElement ].
	domainObject := self
		executeTool: tool
		withArguments: Dictionary new.
	self assert: (domainObject isKindOf: GtLWorldScreenshotDataDomainObject).
	self assert: domainObject encodedBytes size > 0.
	^ domainObject
]

{ #category : #examples }
GtLToolForWorldScreenshotExamples >> worldScreenshotWithoutFocusedWorld [
	<gtExample>
	| tool domainObject |
	tool := GtLToolForWorldScreenshot new worldElementProvider: [ nil ].
	domainObject := self
		executeTool: tool
		withArguments: Dictionary new.
	self assert: domainObject isErrorDomainObject.
	self assert: (domainObject description includesSubstring: 'No focused GtWorldElement').
	^ domainObject
]
