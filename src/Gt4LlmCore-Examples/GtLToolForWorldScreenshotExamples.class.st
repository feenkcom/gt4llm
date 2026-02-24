Class {
	#name : #GtLToolForWorldScreenshotExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForWorldScreenshotExamples >> worldScreenshotSerialization [
	<gtExample>
	| stubElement tool call result encoded |
	stubElement := BlElement new
			size: 50 @ 50;
			background: Color red.
	tool := GtLToolForWorldScreenshot new worldElementProvider: [ stubElement ].
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments' -> Dictionary new} asDictionary.
	result := tool performToolCall: call.
	self assert: result isErrorDomainObject not.
	encoded := result encodedBytes.
	self assert: encoded size > 0.
	^ call
]

{ #category : #examples }
GtLToolForWorldScreenshotExamples >> worldScreenshotWithoutFocusedWorld [
	<gtExample>
	| tool call result |
	tool := GtLToolForWorldScreenshot new worldElementProvider: [ nil ].
	call := GtLFunctionToolCall new.
	call function: {'name' -> tool name.
			'arguments' -> Dictionary new} asDictionary.
	result := tool performToolCall: call.
	self assert: result isErrorDomainObject.
	self
		assert: ((result serializeToOpenAIResponseJsonObject at: #error)
				includesSubstring: 'No focused GtWorldElement').
	^ call
]
