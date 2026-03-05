Class {
	#name : #GtLMagritteToolForMethodSourceExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForExistingClassSideMethod [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'methodDescriptor' -> {
			'methodClassName' -> 'Collection'.
			'methodName' -> 'withAll:'.
			'classSide' -> true
		} asDictionary
	} asDictionary.
	
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self
		assert: ((call arguments at: 'methodDescriptor') isKindOf: GtLMethodReference).
		
	model := result model.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	self assert: (model isKindOf: GtLMethodWithSource).
	
	self
		assert: model sourceCode
		equals: (Collection class>>#withAll:) sourceCode.
	self
		assert: model methodReference methodClassName
		equals: #Collection.
	self
		assert: model methodReference methodName
		equals: 'withAll:'.
	self
		assert: model methodReference classSide
		equals: true.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForExistingInstanceSideMethod [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'methodDescriptor' -> {
			'methodClassName' -> #GtLMagritteToolForMethodSourceExamples.
			'methodName' -> 'methodSourceForExistingInstanceSideMethod'.
			'classSide' -> false
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self
		assert: ((call arguments at: 'methodDescriptor') isKindOf: GtLMethodReference).
		
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLMethodWithSource).
	
	self
		assert: model sourceCode
		equals: (GtLMagritteToolForMethodSourceExamples>>#methodSourceForExistingInstanceSideMethod) sourceCode.
	self
		assert: model methodReference methodClassName
		equals: #GtLMagritteToolForMethodSourceExamples.
	self
		assert: model methodReference methodName
		equals: 'methodSourceForExistingInstanceSideMethod'.
	self
		assert: model methodReference classSide
		equals: false.
		
	^ call
]

{ #category : #Examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForMissingArguments [
	<gtExample>
	| tool call result model |
	
	tool := GtLMagritteToolForMethodSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: {} asDictionary.
	result := tool performToolCall: call.
	
	self assert: call tool == tool.
	self assert: call arguments size equals: 0.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	
	model := result model.
	self assert: (model isKindOf: GtLMissingArgumentDomainObject).
	self assert: model missingArgument equals: 'methodDescriptor'.
	self assert: model errorMessage equals: 'Missing argument called methodDescriptor'.
	
	^ call
]

{ #category : #Examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForMissingClassSide [
	<gtExample>
	| tool call result model |
	
	tool := GtLMagritteToolForMethodSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'methodDescriptor' -> {
			'methodClassName' -> #GtLMagritteToolForMethodSourceExamples.
			'methodName' -> 'methodSourceForMissingClassSide'
		} asDictionary
	} asDictionary.
	
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: ((call arguments at: 'methodDescriptor') isKindOf: GtLMethodReference).
	self assert: (result isKindOf: GtLMagritteBasedModel).
	
	model := result model.
	self assert: (model isKindOf: GtLMethodWithSource).
	self
		assert: model sourceCode
		equals: (GtLMagritteToolForMethodSourceExamples>>#methodSourceForMissingClassSide) sourceCode.
	self assert: model methodReference classSide equals: false.
	
	^ call
]

{ #category : #Examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForMissingMethodClassName [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'methodDescriptor' -> {
			'methodName' -> 'withAll:'.
			'classSide' -> true
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: ((call arguments at: 'methodDescriptor') isKindOf: GtLMethodReference).
	self assert: (result isKindOf: GtLMagritteBasedModel).
	
	model := result model.
	self assert: (model isKindOf: GtLMissingArgumentDomainObject).
	self assert: model missingArgument equals: 'targetClassName'.
	self assert: model errorMessage equals: 'Missing argument called targetClassName'.
	^ call
]

{ #category : #Examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForMissingMethodName [
	<gtExample>
	| tool call result model |
	
	tool := GtLMagritteToolForMethodSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'methodDescriptor' -> {
			'methodClassName' -> 'Collection'.
			'classSide' -> true
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: ((call arguments at: 'methodDescriptor') isKindOf: GtLMethodReference).
	self assert: (result isKindOf: GtLMagritteBasedModel).
	
	model := result model.
	self assert: (model isKindOf: GtLMissingArgumentDomainObject).
	self assert: model missingArgument equals: 'methodName'.
	self assert: model errorMessage equals: 'Missing argument called methodName'.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForUnknownClass [
	<gtExample>
	| tool call result model |
	
	tool := GtLMagritteToolForMethodSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'methodDescriptor' -> {
			'methodClassName' -> 'ClassThatDoesNotExist'.
			'methodName' -> 'unknownSelector42'.
			'classSide' -> true
		} asDictionary
	} asDictionary.
	
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self
		assert: ((call arguments at: 'methodDescriptor') isKindOf: GtLMethodReference).
		
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: model objectName equals: 'ClassThatDoesNotExist'.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForUnknownClassSideMethod [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'methodDescriptor' -> {
			'methodClassName' -> GtLToolForMethodImplementors name.
			'methodName' -> 'unknownSelector42'.
			'classSide' -> true
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self
		assert: ((call arguments at: 'methodDescriptor') isKindOf: GtLMethodReference).
	
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self
		assert: model objectName
		equals: GtLToolForMethodImplementors name, ' class>>#unknownSelector42'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForUnknownInstanceSideMethod [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'methodDescriptor' -> {
			'methodClassName' -> GtLToolForMethodImplementors name.
			'methodName' -> 'unknownSelector42'.
			'classSide' -> false
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self
		assert: ((call arguments at: 'methodDescriptor') isKindOf: GtLMethodReference).
		
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self
		assert: model missingObjectName
		equals: GtLToolForMethodImplementors name, '>>#unknownSelector42'.
	self
		assert: model errorMessage
		equals: 'GtLToolForMethodImplementors>>#unknownSelector42 is not found'.
		
	^ call
]
