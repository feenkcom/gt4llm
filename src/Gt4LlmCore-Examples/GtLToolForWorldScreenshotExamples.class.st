Class {
	#name : #GtLToolForWorldScreenshotExamples,
	#superclass : #Object,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForWorldScreenshotExamples >> worldScreenshotSerialization [
	<gtExample>
	| stubElement tool call result domainObject |
	stubElement := BlElement new
		size: 50 @ 50;
		background: Color red.
	tool := GtLToolForWorldScreenshot new worldElementProvider: [ stubElement ].
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLWorldScreenshotDataDomainObject).
	self assert: domainObject encodedBytes size > 0.
	^ domainObject
]

{ #category : #examples }
GtLToolForWorldScreenshotExamples >> worldScreenshotWithoutFocusedWorld [
	<gtExample>
	| tool call result domainObject |
	tool := GtLToolForWorldScreenshot new worldElementProvider: [ nil ].
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: domainObject isErrorDomainObject.
	self assert: (domainObject description includesSubstring: 'No focused GtWorldElement').
	^ domainObject
]
