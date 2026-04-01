Class {
	#name : #GtLMagritteToolForMethodsSourceExamples,
	#superclass : #Object,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesForExistingMethods [
	<gtExample>
	| tool call result domainObject |
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
		
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLMethodsWithSource).
	self assert: domainObject methods size equals: 2.
	self
		assert: domainObject methods first sourceCode
		equals: (Collection class>>#withAll:) sourceCode.
	self
		assert: domainObject methods second sourceCode
		equals: (GtLMagritteToolForMethodsSourceExamples>>#methodSourcesForExistingMethods) sourceCode.
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesForMissingArguments [
	<gtExample>
	| tool call result domainObject |
		
	tool := GtLMagritteToolForMethodsSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
		
	self assert: call tool == tool.
	self assert: call arguments isEmpty.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
		
	domainObject := result targetObject.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('methodDescriptors') 
		path: #(nil) 
		errorMessage: 'required properties missing [methodDescriptors]'.
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesForMissingMethodArguments [
	<gtExample>
	| tool call result domainObject |
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
	self assert: (result isKindOf: GTLDataViewWrapperModel).
		
	domainObject := result targetObject.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('methodName') 
		path: #('methodDescriptors' 1) 
		errorMessage: '@[methodDescriptors/1] required properties missing [methodName]'.
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesForUnknownClass [
	<gtExample>
	| tool call result domainObject |
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
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	self assert: call arguments size equals: 1.
	self assert: (call arguments anyOne allSatisfy: [:e | 
		e isKindOf: GtLMethodReference]).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLMethodsWithSource).
	self assert: domainObject methods size equals: 2.
	self assert: domainObject methods first isErrorDomainObject.
	self assert: (domainObject methods second isKindOf: GtLMethodWithSource).
	self assert: domainObject methods first objectName equals: 'ClassThatDoesNotExist'.
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesForUnknownMethod [
	<gtExample>
	| tool call result domainObject expectedSignature |
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
	
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLMethodsWithSource).
	self assert: domainObject methods size equals: 2.
	self assert: domainObject methods first isErrorDomainObject.
	self assert: (domainObject methods second isKindOf: GtLMethodWithSource).
	expectedSignature := GtLToolForMethodImplementors name, '>>#unknownSelector42'.
	self assert: domainObject methods first objectName equals: expectedSignature.
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesWithEmptyMethodClassName [
	<gtExample>
	| tool call result domainObject |
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
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLMethodsWithSource).
	self assert: domainObject methods size equals: 1.
	self assert: (domainObject methods first isKindOf: GtLMissingDomainObject).
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesWithEmptyMethodName [
	<gtExample>
	| tool call result domainObject |
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
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLMethodsWithSource).
	self assert: domainObject methods size equals: 1.
	self assert: (domainObject methods first isKindOf: GtLMissingDomainObject).
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesWithNilDescriptor [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForMethodsSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'methodDescriptors' -> { nil } asArray } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertJSONSchemaValidationError: domainObject 
		withPath: #('methodDescriptors' 1) 
		errorMessage: '@[methodDescriptors/1] object expected'.
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesWithNilMethodClassName [
	<gtExample>
	| tool call result domainObject |
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
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertJSONSchemaValidationError: domainObject 
		withPath: #('methodDescriptors' 1 'methodClassName') 
		errorMessage: '@[methodDescriptors/1/methodClassName] string expected'.
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesWithNilMethodName [
	<gtExample>
	| tool call result domainObject |
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
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertJSONSchemaValidationError: domainObject 
		withPath: #('methodDescriptors' 1 'methodName') 
		errorMessage: '@[methodDescriptors/1/methodName] string expected'.
	^ domainObject
]
