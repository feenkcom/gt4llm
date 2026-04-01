Class {
	#name : #GtLMagritteToolSerializationExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLMagritteToolSerializationExamples >> toolCallWithJsonDeserializationError [
	<gtExample>
	| tool call result domainObject |
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

	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: domainObject isErrorDomainObject.

	^ call
]
