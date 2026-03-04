Class {
	#name : #GtLMagritteToolSerializationExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #'as yet unclassified' }
GtLMagritteToolSerializationExamples >> toolCallWithJsonDeserializationError [
	<gtExample>
	| tool call result |
	tool := GtLMagritteToolForMethodsSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: '{
	"methodDescriptors" : [
		{
			"methodName" : "unknownSelector42",
			"classSide" : true,
		
		{
			"methodName" : "withAll:",
			"classSide" : true,
			"methodClassName" : "Collection"
		}
	]
}'.

	result := tool performToolCall: call.
	self assert: call tool == tool.

	self assert: result isErrorDomainObject.

	^ call
]
