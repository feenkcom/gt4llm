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

{ #category : #examples }
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
	self assert: model isErrorDomainObject.
	self assert: (model isKindOf: GtLMissingRequiredPropertiesDomainObject).
	self assert: model missingPropertyNames asArray equals: #('methodDescriptor').
		
	^ call
]

{ #category : #examples }
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
		
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: (model isKindOf: GtLMissingRequiredPropertiesDomainObject).
	self assert: model missingPropertyNames asArray equals: #('classSide').
	self assert: model path asArray equals: #('methodDescriptor').
		
	^ call
]

{ #category : #examples }
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: (model isKindOf: GtLMissingRequiredPropertiesDomainObject).
	self assert: model missingPropertyNames asArray equals: #('methodClassName').
	self assert: model path asArray equals: #('methodDescriptor').
	^ call
]

{ #category : #examples }
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
		
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: (model isKindOf: GtLMissingRequiredPropertiesDomainObject).
	self assert: model missingPropertyNames asArray equals: #('methodName').
	self assert: model path asArray equals: #('methodDescriptor').
		
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

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceWithEmptyMethodClassName [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'methodDescriptor' -> {
			'methodClassName' -> ''.
			'methodName' -> 'withAll:'.
			'classSide' -> true
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: model class equals: GtLMissingDomainObject.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceWithEmptyMethodName [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'methodDescriptor' -> {
			'methodClassName' -> 'Collection'.
			'methodName' -> ''.
			'classSide' -> true
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: model class equals: GtLMissingDomainObject.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceWithNilDescriptor [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'methodDescriptor' -> nil } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: (model isKindOf: GtLJSONSchemaValidationErrorDomainObject).
	self assert: model path asArray equals: #('methodDescriptor').
	self assert: model errorMessage equals: '@[methodDescriptor] object expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceWithNilMethodClassName [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'methodDescriptor' -> {
			'methodClassName' -> nil.
			'methodName' -> 'withAll:'.
			'classSide' -> true
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: model class equals: GtLJSONSchemaValidationErrorDomainObject.
	self assert: model path asArray equals: #('methodDescriptor' 'methodClassName').
	self assert: model messageText equals: '@[methodDescriptor/methodClassName] string expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceWithNilMethodName [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'methodDescriptor' -> {
			'methodClassName' -> 'Collection'.
			'methodName' -> nil.
			'classSide' -> true
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: model class equals: GtLJSONSchemaValidationErrorDomainObject.
	self assert: model path asArray equals: #('methodDescriptor' 'methodName').
	self assert: model messageText equals: '@[methodDescriptor/methodName] string expected'.
	^ call
]
