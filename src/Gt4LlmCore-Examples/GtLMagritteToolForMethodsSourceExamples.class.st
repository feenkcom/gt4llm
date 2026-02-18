Class {
	#name : #GtLMagritteToolForMethodsSourceExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesForExistingMethods [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodsSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'methodDescriptors' -> {
			{'methodClassName' -> 'Collection'.
				'methodName' -> 'withAll:'.
				'classSide' -> true} asDictionary.
			{'methodClassName' -> GtLToolForMethodImplementors name.
				'methodName' -> 'privatePerformToolCall:'.
				'classSide' -> false} asDictionary
		} asArray
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	self assert: call arguments size equals: 1.
	self assert: (call arguments anyOne allSatisfy: [:e | e isKindOf: GtLMethodReference]).
	model := result model.
	self assert: model methods size equals: 2.
	self
		assert: model methods first sourceCode
		equals: (Collection class>>#withAll:) sourceCode.
	self
		assert: model methods second sourceCode
		equals: (GtLToolForMethodImplementors>>#privatePerformToolCall:) sourceCode.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesForUnknownClass [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodsSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'methodDescriptors' -> {
			{'methodClassName' -> 'ClassThatDoesNotExist'.
				'methodName' -> 'unknownSelector42'.
				'classSide' -> true} asDictionary.
			{'methodClassName' -> 'Collection'.
				'methodName' -> 'withAll:'.
				'classSide' -> true} asDictionary
		} asArray
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	self assert: call arguments size equals: 1.
	self assert: (call arguments anyOne allSatisfy: [:e | e isKindOf: GtLMethodReference]).
	model := result model.
	self assert: model methods size equals: 2.
	self assert: model methods first isErrorDomainObject.
	self assert: (model methods second isKindOf: GtLMethodWithSource).
	self assert: model methods first objectName equals: 'ClassThatDoesNotExist'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesForUnknownMethod [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodsSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'methodDescriptors' -> {
			{'methodClassName' -> GtLToolForMethodImplementors name.
				'methodName' -> 'unknownSelector42'.
				'classSide' -> false} asDictionary.
			{'methodClassName' -> 'Collection'.
				'methodName' -> 'withAll:'.
				'classSide' -> true} asDictionary
		} asArray
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	self assert: call arguments size equals: 1.
	self assert: (call arguments anyOne allSatisfy: [:e | e isKindOf: GtLMethodReference]).
	model := result model.
	self assert: model methods size equals: 2.
	self assert: model methods first isErrorDomainObject.
	self assert: (model methods second isKindOf: GtLMethodWithSource).
	self
		assert: model methods first objectName
		equals: GtLToolForMethodImplementors name, '>>#unknownSelector42'.
	^ call
]
