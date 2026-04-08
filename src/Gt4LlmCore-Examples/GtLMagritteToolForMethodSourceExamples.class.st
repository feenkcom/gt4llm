Class {
	#name : #GtLMagritteToolForMethodSourceExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForExistingClassSideMethod [
	<gtExample>
	| tool call result domainObject |
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
		
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLMethodWithSource).
	
	self
		assert: domainObject sourceCode
		equals: (Collection class>>#withAll:) sourceCode.
	self
		assert: domainObject methodReference methodClassName
		equals: #Collection.
	self
		assert: domainObject methodReference methodName
		equals: 'withAll:'.
	self
		assert: domainObject methodReference classSide
		equals: true.
		
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForExistingInstanceSideMethod [
	<gtExample>
	| tool call result domainObject |
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
		
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLMethodWithSource).
	
	self
		assert: domainObject sourceCode
		equals: (GtLMagritteToolForMethodSourceExamples>>#methodSourceForExistingInstanceSideMethod) sourceCode.
	self
		assert: domainObject methodReference methodClassName
		equals: #GtLMagritteToolForMethodSourceExamples.
	self
		assert: domainObject methodReference methodName
		equals: 'methodSourceForExistingInstanceSideMethod'.
	self
		assert: domainObject methodReference classSide
		equals: false.
		
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodSourceExamples >> methodSourceForMissingArguments [
	<gtExample>
	| tool call result domainObject |
		
	tool := GtLMagritteToolForMethodSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: {} asDictionary.
	result := tool performToolCall: call.
		
	self assert: call tool == tool.
	self assert: call arguments size equals: 0.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
		
	domainObject := result targetObject.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('methodDescriptor') 
		path: #(nil) 
		errorMessage: 'required properties missing [methodDescriptor]'.
		
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodSourceExamples >> methodSourceForMissingClassSide [
	<gtExample>
	| tool call result domainObject |
		
	tool := GtLMagritteToolForMethodSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'methodDescriptor' -> {
			'methodClassName' -> 'GtLMagritteToolForMethodSourceExamples'.
			'methodName' -> 'methodSourceForMissingClassSide'
		} asDictionary
	} asDictionary.
		
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
		
	domainObject := result targetObject.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('classSide') 
		path: #(#methodDescriptor) 
		errorMessage: '@[methodDescriptor] required properties missing [classSide]'.
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodSourceExamples >> methodSourceForMissingMethodClassName [
	<gtExample>
	| tool call result domainObject |
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
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	domainObject := result targetObject.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('methodClassName') 
		path: #(#methodDescriptor) 
		errorMessage: '@[methodDescriptor] required properties missing [methodClassName]'.
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodSourceExamples >> methodSourceForMissingMethodName [
	<gtExample>
	| tool call result domainObject |
		
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
	self assert: (result isKindOf: GTLDataViewWrapperModel).
		
	domainObject := result targetObject.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('methodName') 
		path: #(#methodDescriptor) 
		errorMessage: '@[methodDescriptor] required properties missing [methodName]'.
		
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodSourceExamples >> methodSourceForUnknownClass [
	<gtExample>
	| tool call result domainObject |
	
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
		
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingObject: domainObject 
		withObjectName: 'ClassThatDoesNotExist' 
		errorMessage: 'ClassThatDoesNotExist is not found'.
	
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodSourceExamples >> methodSourceForUnknownClassSideMethod [
	<gtExample>
	| tool call result domainObject expectedSignature |
	tool := GtLMagritteToolForMethodSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'methodDescriptor' -> {
			'methodClassName' -> GtLMagritteToolForMethodImplementors name.
			'methodName' -> 'unknownSelector42'.
			'classSide' -> true
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self
		assert: ((call arguments at: 'methodDescriptor') isKindOf: GtLMethodReference).
	
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	expectedSignature := GtLMagritteToolForMethodImplementors name, ' class>>#unknownSelector42'.
	self 
		assertMissingObject: domainObject 
		withObjectName: expectedSignature 
		errorMessage: expectedSignature, ' is not found'.
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodSourceExamples >> methodSourceForUnknownInstanceSideMethod [
	<gtExample>
	| tool call result domainObject expectedSignature |
	tool := GtLMagritteToolForMethodSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'methodDescriptor' -> {
			'methodClassName' -> GtLMagritteToolForMethodImplementors name.
			'methodName' -> 'unknownSelector42'.
			'classSide' -> false
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self
		assert: ((call arguments at: 'methodDescriptor') isKindOf: GtLMethodReference).
		
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	expectedSignature := GtLMagritteToolForMethodImplementors name, '>>#unknownSelector42'.
	self 
		assertMissingObject: domainObject 
		withObjectName: expectedSignature 
		errorMessage: expectedSignature, ' is not found'.
		
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodSourceExamples >> methodSourceWithEmptyMethodClassName [
	<gtExample>
	| tool call result domainObject |
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
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLMissingDomainObject).
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodSourceExamples >> methodSourceWithEmptyMethodName [
	<gtExample>
	| tool call result domainObject |
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
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLMissingDomainObject).
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodSourceExamples >> methodSourceWithNilDescriptor [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForMethodSource new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'methodDescriptor' -> nil } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertJSONSchemaValidationError: domainObject 
		withPath: #('methodDescriptor') 
		errorMessage: '@[methodDescriptor] object expected'.
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodSourceExamples >> methodSourceWithNilMethodClassName [
	<gtExample>
	| tool call result domainObject |
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
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertJSONSchemaValidationError: domainObject 
		withPath: #('methodDescriptor' 'methodClassName') 
		errorMessage: '@[methodDescriptor/methodClassName] string expected'.
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodSourceExamples >> methodSourceWithNilMethodName [
	<gtExample>
	| tool call result domainObject |
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
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertJSONSchemaValidationError: domainObject 
		withPath: #('methodDescriptor' 'methodName') 
		errorMessage: '@[methodDescriptor/methodName] string expected'.
	^ domainObject
]
