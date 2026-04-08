"
Examples for GtLMagritteToolForSmalltalkCodeEvaluation.
"
Class {
	#name : #GtLMagritteToolForSmalltalkCodeEvaluationExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#traits : 'TGtLExceptionDomainObjectAssertions',
	#classTraits : 'TGtLExceptionDomainObjectAssertions classTrait',
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #assertions }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> assertSmalltalkCodeEvaluationException: aDomainObject withCode: aCodeString exceptionClass: anExceptionClass messageSubstring: aMessageSubstring [
	"Assert that the domain object is a GtLSmalltalkCodeEvaluationExceptionDomainObject with expected values."
	
	self assert: (aDomainObject isKindOf: GtLSmalltalkCodeEvaluationExceptionDomainObject).
	self assert: aDomainObject code equals: aCodeString.
	self assert: aDomainObject errorReason equals: 'Error while evaluating smalltalk code'.
	self 
		assertExceptionDomainObject: aDomainObject 
		withExceptionClass: anExceptionClass 
		messageSubstring: aMessageSubstring
]

{ #category : #'examples - errors' }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> emptyCodeArgument [
	<gtExample>
	<return: #GtLFunctionToolCall>
	| tool call result targetObject |
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'code' -> '   '.
		'bindings' -> #()
	} asDictionary.
	result := tool performToolCall: call.
	
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertMissingArgument: targetObject
		withArgumentName: 'code'
		errorMessage: 'Missing argument called code'.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeReturningBlElement [
	<gtExample>
	<return: #GtLFunctionToolCall>
	"Test execution that returns a BlElement, which has image views."
	| objectStorage tool call result targetObject objectValue |
	objectStorage := GtLObjectStorage new.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'code' -> 'BlElement new'.
		'bindings' -> #()
	} asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self assert: (targetObject isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: (targetObject object isKindOf: BlElement).
	self assert: targetObject code equals: 'BlElement new'.
	
	objectValue := targetObject objectValue.
	self assert: objectValue objectClassName equals: 'BlElement'.
	self assert: objectValue superclassName equals: 'Object'.
	self assert: objectValue packageName equals: 'Bloc'.
	self assert: objectValue phlowViews isNotEmpty.
	self assert: (objectValue phlowViews anySatisfy: [ :v | v title = 'Preview' ]).
	self assert: (objectValue phlowViews anySatisfy: [ :v | v title = 'Print' ]).
	self assert: objectValue allInstanceSlots isNotEmpty.
	
	self assert: targetObject objectId isNotEmpty.
	self assert: objectStorage objectCount equals: 1.
	self assert: (objectStorage objectAt: targetObject objectId) == targetObject object.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeReturningObjectWithSlots [
	<gtExample>
	"Test execution that returns an object with slots and views."
	| objectStorage tool call result targetObject objectValue storedResult |
	objectStorage := GtLObjectStorage new.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'code' -> 'GtLSerializedObjectValueTestObject exampleInstance'.
		'bindings' -> #()
	} asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self assert: (targetObject isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: (targetObject object isKindOf: GtLSerializedObjectValueTestObject).
	self assert: targetObject object name equals: 'TestObject'.
	self assert: targetObject object count equals: 42.
	self assert: targetObject object items equals: #('apple' 'banana' 'cherry').
	
	objectValue := targetObject objectValue.
	self assert: objectValue objectClassName equals: 'GtLSerializedObjectValueTestObject'.
	self assert: objectValue superclassName equals: 'Object'.
	self assert: objectValue packageName equals: 'Gt4LlmCore-Examples'.
	self assert: (objectValue objectPrintString includesSubstring: 'TestObject').
	self assert: objectValue phlowViews isNotEmpty.
	self assert: (objectValue phlowViews anySatisfy: [ :v | v title = 'Details' ]).
	self assert: (objectValue phlowViews anySatisfy: [ :v | v title = 'Items' ]).
	self assert: objectValue allInstanceSlots size equals: 3.
	self assert: (objectValue allInstanceSlots anySatisfy: [ :s | 
		s name = 'name' and: [ s valueClassName = 'ByteString' ] ]).
	self assert: (objectValue allInstanceSlots anySatisfy: [ :s | 
		s name = 'count' and: [ s valuePrintString = '42' ] ]).
	self assert: targetObject objectId isNotEmpty.
	self assert: (objectStorage objectAt: targetObject objectId) == targetObject object.
	storedResult := objectStorage storedObjectAt: targetObject objectId.
	self assert: storedResult reason class equals: GtLStoredObjectCodeExecutionReason.
	self assert: storedResult reason asReasonString equals: 'GtLSerializedObjectValueTestObject exampleInstance'.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeReturningObjectWithSlotsSerialization [
	<gtExample>
	"Test that the result serializes correctly to JSON."
	| call result targetObject jsonObject objectValue slots |
	call := self executeReturningObjectWithSlots.
	result := call result.
	targetObject := result targetObject.
	jsonObject := GtMagritteJSONDataExporter exportObject: targetObject.
	
	"Verify top-level structure"
	self assert: (jsonObject at: 'code') equals: 'GtLSerializedObjectValueTestObject exampleInstance'.
	self assert: (jsonObject at: 'objectId') isNotEmpty.
	
	"Verify object value structure"
	objectValue := jsonObject at: 'objectValue'.
	self assert: (objectValue at: 'objectClassName') equals: 'GtLSerializedObjectValueTestObject'.
	self assert: (objectValue at: 'superclassName') equals: 'Object'.
	self assert: (objectValue at: 'packageName') equals: 'Gt4LlmCore-Examples'.
	
	"Verify views are serialized"
	self assert: (objectValue at: 'phlowViews') isNotEmpty.
	self assert: ((objectValue at: 'phlowViews') anySatisfy: [ :v | 
		(v at: 'title') = 'Details' ]).
	
	"Verify slots are serialized with correct keys"
	slots := objectValue at: 'allInstanceSlots'.
	self assert: slots size equals: 3.
	self assert: (slots anySatisfy: [ :s | 
		(s at: 'name') = 'name' 
			and: [ (s at: 'valueClassName') = 'ByteString'
				and: [ (s at: 'valuePrintString') = 'TestObject' ] ] ]).
	self assert: (slots anySatisfy: [ :s | 
		(s at: 'name') = 'count' 
			and: [ (s at: 'valueClassName') = 'SmallInteger'
				and: [ (s at: 'valuePrintString') = '42' ] ] ]).
	
	^ jsonObject
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeSimpleDoIt [
	<gtExample>
	| objectStorage tool call result targetObject storedResult |
	objectStorage := GtLObjectStorage new.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'code' -> '1 + 2'.
		'bindings' -> #()
	} asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self assert: (targetObject isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: targetObject object equals: 3.
	self assert: targetObject code equals: '1 + 2'.
	self assert: targetObject objectValue objectClassName equals: 'SmallInteger'.
	self assert: targetObject objectValue objectPrintString equals: '3'.
	self assert: targetObject objectId isNotEmpty.
	self assert: objectStorage objectCount equals: 1.
	self assert: (objectStorage objectAt: objectStorage objectIds first) equals: 3.
	storedResult := objectStorage storedObjectAt: targetObject objectId.
	self assert: storedResult reason class equals: GtLStoredObjectCodeExecutionReason.
	self assert: storedResult reason asReasonString equals: '1 + 2'.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeSimpleDoItWithNoBindingKey [
	<gtExample>
	| objectStorage tool call result targetObject storedResult |
	objectStorage := GtLObjectStorage new.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'code' -> '1 + 2'.
	} asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self assert: (targetObject isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: targetObject object equals: 3.
	self assert: targetObject code equals: '1 + 2'.
	self assert: targetObject objectValue objectClassName equals: 'SmallInteger'.
	self assert: targetObject objectValue objectPrintString equals: '3'.
	self assert: targetObject objectId isNotEmpty.
	self assert: objectStorage objectCount equals: 1.
	self assert: (objectStorage objectAt: objectStorage objectIds first) equals: 3.
	storedResult := objectStorage storedObjectAt: targetObject objectId.
	self assert: storedResult reason class equals: GtLStoredObjectCodeExecutionReason.
	self assert: storedResult reason asReasonString equals: '1 + 2'.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeSimpleDoItWithoutObjectStorage [
	<gtExample>
	| tool call result targetObject |
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'code' -> '1 + 2'.
		'bindings' -> #()
	} asDictionary.
	result := tool performToolCall: call.
	
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self assert: (targetObject isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: targetObject object equals: 3.
	self assert: targetObject code equals: '1 + 2'.
	self assert: targetObject objectId equals: ''.
	
	^ call
]

{ #category : #'examples - errors' }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindingEmptyName [
	<gtExample>
	<return: #GtLFunctionToolCall>
	"Test that a binding with empty name is handled."
	| objectStorage tool call result targetObject bindingObjectId |
	objectStorage := GtLObjectStorage new.
	bindingObjectId := objectStorage addNewObject: 40.
	
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'code' -> 'value + 2'.
		'bindings' -> {
			{ 'name' -> ''. 'objectId' -> bindingObjectId } asDictionary
		} asArray
	} asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	targetObject := result targetObject.
	
	"Should fail because binding name is empty - can't create valid symbol"
	self
		assertSmalltalkCodeEvaluationException: targetObject
		withCode: 'value + 2'
		exceptionClass: CodeError
		messageSubstring: 'Undeclared variable'.
	
	^ call
]

{ #category : #'examples - errors' }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindingEmptyObjectId [
	<gtExample>
	<return: #GtLFunctionToolCall>
	"Test that a binding with empty objectId is handled."
	| objectStorage tool call result targetObject |
	objectStorage := GtLObjectStorage new.
	
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'code' -> 'value + 2'.
		'bindings' -> {
			{ 'name' -> 'value'. 'objectId' -> '' } asDictionary
		} asArray
	} asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	targetObject := result targetObject.
	self
		assertMissingObject: targetObject
		withObjectName: ''
		errorMessage: ' is not found'.
	
	^ call
]

{ #category : #'examples - errors' }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindingMissingName [
	<gtExample>
	<return: #GtLFunctionToolCall>
	"Test that a binding with missing name is handled - returns missing required properties error."
	| objectStorage tool call result targetObject bindingObjectId |
	objectStorage := GtLObjectStorage new.
	bindingObjectId := objectStorage addNewObject: 40.
	
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'code' -> 'value + 2'.
		'bindings' -> {
			{ 'objectId' -> bindingObjectId } asDictionary  "missing 'name'"
		} asArray
	} asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	targetObject := result targetObject.
	
	"Should fail - missing required property 'name' in bindings"
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('name')
		path: #(#bindings 1)
		errorMessage: '@[bindings/1] required properties missing [name]'.
	
	^ call
]

{ #category : #'examples - errors' }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindingMissingObjectId [
	<gtExample>
	<return: #GtLFunctionToolCall>
	"Test that a binding with missing objectId is handled - returns missing required properties error."
	| objectStorage tool call result targetObject |
	objectStorage := GtLObjectStorage new.
	
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'code' -> 'value + 2'.
		'bindings' -> {
			{ 'name' -> 'value' } asDictionary  "missing 'objectId'"
		} asArray
	} asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	targetObject := result targetObject.
	
	"Should fail - missing required property 'objectId' in bindings"
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('objectId')
		path: #(#bindings 1)
		errorMessage: '@[bindings/1] required properties missing [objectId]'.
	
	^ call
]

{ #category : #'examples - errors' }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindingNilName [
	<gtExample>
	<return: #GtLFunctionToolCall>
	"Test that a binding with nil name is handled - returns JSON schema validation error."
	| objectStorage tool call result targetObject bindingObjectId |
	objectStorage := GtLObjectStorage new.
	bindingObjectId := objectStorage addNewObject: 40.
	
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'code' -> 'value + 2'.
		'bindings' -> {
			{ 'name' -> nil. 'objectId' -> bindingObjectId } asDictionary
		} asArray
	} asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	targetObject := result targetObject.
	
	"Should fail - nil name returns JSON schema validation error"
	self
		assertJSONSchemaValidationError: targetObject
		withPath: #(#bindings 1 #name)
		errorMessage: '@[bindings/1/name] string expected'.
	
	^ call
]

{ #category : #'examples - errors' }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindingNilObjectId [
	<gtExample>
	<return: #GtLFunctionToolCall>
	"Test that a binding with nil objectId is handled - returns JSON schema validation error."
	| objectStorage tool call result targetObject |
	objectStorage := GtLObjectStorage new.
	
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'code' -> 'value + 2'.
		'bindings' -> {
			{ 'name' -> 'value'. 'objectId' -> nil } asDictionary
		} asArray
	} asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	targetObject := result targetObject.
	
	"Should fail - nil objectId returns JSON schema validation error"
	self
		assertJSONSchemaValidationError: targetObject
		withPath: #(#bindings 1 #objectId)
		errorMessage: '@[bindings/1/objectId] string expected'.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindings [
	<gtExample>
	| objectStorage tool call result targetObject bindingObjectId resultObjectId storedResult |
	objectStorage := GtLObjectStorage new.
	bindingObjectId := objectStorage addNewObject: 40.
	
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'code' -> 'value + 2'.
		'bindings' -> {
			{ 'name' -> 'value'. 'objectId' -> bindingObjectId } asDictionary
		} asArray
	} asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self assert: (targetObject isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: targetObject object equals: 42.
	
	resultObjectId := targetObject objectId.
	self assert: resultObjectId isNotEmpty.
	self assert: resultObjectId ~= bindingObjectId.
	self assert: (objectStorage objectAt: bindingObjectId) equals: 40.
	self assert: (objectStorage objectAt: resultObjectId) equals: 42.
	storedResult := objectStorage storedObjectAt: resultObjectId.
	self assert: storedResult reason class equals: GtLStoredObjectCodeExecutionReason.
	self assert: storedResult reason asReasonString equals: 'value + 2'.
	
	^ call
]

{ #category : #'examples - errors' }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindingsMissingObjectStorage [
	<gtExample>
	<return: #GtLFunctionToolCall>
	| tool call result targetObject |
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'code' -> 'value + 2'.
		'bindings' -> {
			{ 'name' -> 'value'. 'objectId' -> 'missing' } asDictionary
		} asArray
	} asDictionary.
	result := tool performToolCall: call.
	
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertMissingInformation: targetObject
		withModelName: 'objectStorage'
		errorMessage: 'Missing objectStorage'.
	
	^ call
]

{ #category : #'examples - errors' }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithError [
	<gtExample>
	<return: #GtLFunctionToolCall>
	| tool call result targetObject |
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'code' -> '1 / 0'.
		'bindings' -> #()
	} asDictionary.
	result := tool performToolCall: call.
	
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertSmalltalkCodeEvaluationException: targetObject
		withCode: '1 / 0'
		exceptionClass: ZeroDivide
		messageSubstring: 'ZeroDivide'.
	
	^ call
]

{ #category : #'examples - errors' }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> missingCodeArgument [
	<gtExample>
	<return: #GtLFunctionToolCall>
	| tool call result targetObject |
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'bindings' -> #()
	} asDictionary.
	result := tool performToolCall: call.
	
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('code')
		path: #(nil)
		errorMessage: 'required properties missing [code]'.
	
	^ call
]
