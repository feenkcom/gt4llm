Class {
	#name : #GtLMagritteToolForMethodsSourceExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
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
			{'methodClassName' -> #GtLMagritteToolForMethodsSourceExamples.
				'methodName' -> 'methodSourcesForExistingMethods'.
				'classSide' -> false} asDictionary
		} asArray
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (call arguments anyOne 
		allSatisfy: [:e | e isKindOf: GtLMethodReference]).
		
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model methods size equals: 2.
	self
		assert: model methods first sourceCode
		equals: (Collection class>>#withAll:) sourceCode.
	self
		assert: model methods second sourceCode
		equals: (GtLMagritteToolForMethodsSourceExamples>>#methodSourcesForExistingMethods) sourceCode.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesForMissingArguments [
	<gtExample>
	| tool call result model |
		
	tool := GtLMagritteToolForMethodsSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
		
	self assert: call tool == tool.
	self assert: call arguments isEmpty.
	self assert: (result isKindOf: GtLMagritteBasedModel).
		
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: model class equals: GtLMissingRequiredPropertiesDomainObject.
	self assert: model missingPropertyNames equals: #('methodDescriptors').
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesForMissingMethodArguments [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodsSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'methodDescriptors' -> {
			{'methodClassName' -> 'Collection'.
				'classSide' -> true} asDictionary.
			{'methodName' -> 'withAll:'.
				'classSide' -> true} asDictionary.
			{'methodClassName' -> 'Collection'.
				'methodName' -> 'withAll:'.
				'classSide' -> true} asDictionary
		} asArray
	} asDictionary.
		
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
		
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: model class equals: GtLMissingRequiredPropertiesDomainObject.
	self assert: model missingPropertyNames equals: #('methodName').
	self assert: model path asArray equals: #('methodDescriptors' 1).
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	self assert: call arguments size equals: 1.
	self assert: (call arguments anyOne allSatisfy: [:e | 
		e isKindOf: GtLMethodReference]).
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
	self assert: call arguments size equals: 1.
	self assert: (call arguments anyOne allSatisfy: [:e | e isKindOf: GtLMethodReference]).
	
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model methods size equals: 2.
	self assert: model methods first isErrorDomainObject.
	self assert: (model methods second isKindOf: GtLMethodWithSource).
	self
		assert: model methods first objectName
		equals: GtLToolForMethodImplementors name, '>>#unknownSelector42'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesWithEmptyMethodClassName [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodsSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'methodDescriptors' -> {
			{'methodClassName' -> ''.
				'methodName' -> 'withAll:'.
				'classSide' -> true} asDictionary
		} asArray
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model class equals: GtLMethodsWithSource.
	self assert: model methods size equals: 1.
	self assert: model methods first class equals: GtLMissingDomainObject.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesWithEmptyMethodName [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodsSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'methodDescriptors' -> {
			{'methodClassName' -> 'Collection'.
				'methodName' -> ''.
				'classSide' -> true} asDictionary
		} asArray
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model class equals: GtLMethodsWithSource.
	self assert: model methods size equals: 1.
	self assert: model methods first class equals: GtLMissingDomainObject.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesWithNilDescriptor [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodsSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'methodDescriptors' -> { nil } asArray } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: (model isKindOf: GtLJSONSchemaValidationErrorDomainObject).
	self assert: model path asArray equals: #('methodDescriptors' 1).
	self assert: model errorMessage equals: '@[methodDescriptors/1] object expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesWithNilMethodClassName [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodsSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'methodDescriptors' -> {
			{'methodClassName' -> nil.
				'methodName' -> 'withAll:'.
				'classSide' -> true} asDictionary
		} asArray
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model class equals: GtLJSONSchemaValidationErrorDomainObject.
	self assert: model path asArray equals: #('methodDescriptors' 1 'methodClassName').
	self assert: model messageText equals: '@[methodDescriptors/1/methodClassName] string expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesWithNilMethodName [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodsSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'methodDescriptors' -> {
			{'methodClassName' -> 'Collection'.
				'methodName' -> nil.
				'classSide' -> true} asDictionary
		} asArray
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model class equals: GtLJSONSchemaValidationErrorDomainObject.
	self assert: model path asArray equals: #('methodDescriptors' 1 'methodName').
	self assert: model messageText equals: '@[methodDescriptors/1/methodName] string expected'.
	^ call
]
