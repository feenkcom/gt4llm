"
Examples for GtLMagritteToolForMethodImplementors.
"
Class {
	#name : #GtLMagritteToolForMethodImplementorsExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForMethodImplementorsExamples >> implementorsForExistingMethodName [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodImplementors new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'methodName' -> 'performToolCall:' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLMethodsSearchResult).
	self assert: model foundMethods isNotEmpty.
	self
		assert: (model foundMethods anySatisfy: [ :each |
			each methodSignature = 'GtLAbstractFunctionTool>>#performToolCall:' ]).
	self assert: model mayHaveMore not.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodImplementorsExamples >> implementorsForGtDisplayOnReturns200 [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodImplementors new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'methodName' -> 'gtDisplayOn:' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLMethodsSearchResult).
	self assert: model foundMethods size equals: 200.
	self assert: model mayHaveMore.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodImplementorsExamples >> implementorsForUnknownMethodName [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodImplementors new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'methodName' -> 'unknownMethodName42' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLMethodsSearchResult).
	self assert: model foundMethods equals: #().
	self assert: model mayHaveMore not.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodImplementorsExamples >> implementorsWithEmptyMethodName [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodImplementors new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'methodName' -> '' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: (model isKindOf: GtLMissingArgumentDomainObject).
	self assert: model missingArgument equals: 'methodName'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodImplementorsExamples >> implementorsWithMissingMethodName [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodImplementors new.
	call := GtLFunctionToolCall new.
	call rawArguments: {} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 0.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: (model isKindOf: GtLMissingRequiredPropertiesDomainObject).
	self assert: model missingPropertyNames equals: #('methodName').
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodImplementorsExamples >> implementorsWithNilMethodName [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodImplementors new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'methodName' -> nil } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: (model isKindOf: GtLJSONSchemaValidationErrorDomainObject).
	self assert: model path asArray equals: #('methodName').
	self assert: model errorMessage equals: '@[methodName] string expected'.
	^ call
]
