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
	self assert: model class equals: GtLMissingArgumentDomainObject.
	self assert: model missingArgument equals: 'methodDescriptors'.
	self assert: model arguments isEmpty.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesForMissingMethodArguments [
	<gtExample>
	| tool call result model missingMethodName missingClassName |
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
	self assert: call arguments size equals: 1.
	self assert: (call arguments anyOne 
		allSatisfy: [:e | e isKindOf: GtLMethodReference]).
	self assert: (result isKindOf: GtLMagritteBasedModel).
	
	model := result model.
	self assert: model methods size equals: 3.
	missingMethodName := model methods first.
	missingClassName := model methods second.
	
	self assert: missingMethodName isErrorDomainObject.
	self assert: missingMethodName class equals: GtLMissingArgumentDomainObject.
	self assert: missingMethodName missingArgument equals: 'methodName'.
	
	self assert: missingClassName isErrorDomainObject.
	self assert: missingClassName class equals: GtLMissingArgumentDomainObject.
	self assert: missingClassName missingArgument equals: 'targetClassName'.
	
	self assert: (model methods third isKindOf: GtLMethodWithSource).
	self assert: model methods third sourceCode equals: (Collection class>>#withAll:) sourceCode.
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
