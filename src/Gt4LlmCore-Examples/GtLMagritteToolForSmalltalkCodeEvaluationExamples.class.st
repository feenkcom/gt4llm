"
Examples for GtLMagritteToolForSmalltalkCodeEvaluation.
"
Class {
	#name : #GtLMagritteToolForSmalltalkCodeEvaluationExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#traits : 'TGtLWithLepiterPageReferenceForDomainObjectExamples',
	#classTraits : 'TGtLWithLepiterPageReferenceForDomainObjectExamples classTrait',
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #asserting }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> assertExceptionDomainObject: aDomainObject withExceptionClass: anExceptionClass messageSubstring: aMessageSubstring [
	self assert: aDomainObject exception class equals: anExceptionClass.
	self assert: (aDomainObject messageText includesSubstring: aMessageSubstring).
]

{ #category : #asserting }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> assertPlaygroundPageReference: aPlaygroundPageReference [ 
	self assert: aPlaygroundPageReference notNil.
	
	self assert: aPlaygroundPageReference databaseId equals: self theDatabase primaryDB uuidString.
	self assert: aPlaygroundPageReference pageId equals: self theDatabase pages first uid asString36.
]

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

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> emptyCodeArgument [
	<gtExample>
	<return: #GtLFunctionToolCall>
	| tool call |
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: {
			'code' -> '   '.
			'bindings' -> #()
			} asDictionary
		inContext: (GtLToolExecutionContext new 
			lepiterDatabase: self theDatabase).
	self
		assertMissingArgument: call result targetObject
		withArgumentName: 'code'
		errorMessage: 'Missing argument called code'.
	^ call
]

{ #category : #private }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> ensureLepiterPageForObject: anObject withSnippetCode: aString [
	self lepiterPageReferenceForObject: anObject withSnippetCode: aString
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeReturningBlElement [
	<gtExample>
	<return: #GtLFunctionToolCall>
	"Test execution that returns a BlElement, which has image views."
	| objectStorage tool call targetObject objectValue |
	objectStorage := GtLObjectStorage new.
	self ensureLepiterPageForObject: BlElement new withSnippetCode: 'BlElement new'.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: {
			'code' -> 'BlElement new'.
			'bindings' -> #()
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage;
			lepiterDatabase: self theDatabase).
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: (targetObject object isKindOf: BlElement).
	self assert: targetObject code equals: 'BlElement new'.
	self assert: targetObject playgroundPageReference notNil.
	self assert: targetObject playgroundPageReference databaseId equals: self theDatabase primaryDB uuidString.
	self assert: targetObject playgroundPageReference pageId equals: self theDatabase pages first uid asString36.
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
	| objectStorage tool call targetObject objectValue storedResult |
	objectStorage := GtLObjectStorage new.
	self ensureLepiterPageForObject: GtLSerializedObjectValueTestObject exampleInstance withSnippetCode: 'GtLSerializedObjectValueTestObject exampleInstance'.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: {
			'code' -> 'GtLSerializedObjectValueTestObject exampleInstance'.
			'bindings' -> #()
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage;
			lepiterDatabase: self theDatabase).
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: (targetObject object isKindOf: GtLSerializedObjectValueTestObject).
	self assert: targetObject object name equals: 'TestObject'.
	self assert: targetObject object count equals: 42.
	self assert: targetObject object items equals: #('apple' 'banana' 'cherry').
	self assert: targetObject playgroundPageReference notNil.
	self assert: targetObject playgroundPageReference databaseId equals: self theDatabase primaryDB uuidString.
	self assert: targetObject playgroundPageReference pageId equals: self theDatabase pages first uid asString36.
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
	| call jsonObject objectValue slots pageReference |
	call := self executeReturningObjectWithSlots.
	jsonObject := GtMagritteJSONDataExporter exportObject: call result targetObject.
	self assert: (jsonObject at: 'code') equals: 'GtLSerializedObjectValueTestObject exampleInstance'.
	self assert: (jsonObject at: 'objectId') isNotEmpty.
	pageReference := jsonObject at: 'playgroundPageReference'.
	self assert: (pageReference at: 'databaseId') equals: self theDatabase primaryDB uuidString.
	self assert: (pageReference at: 'pageId') isNotEmpty.
	objectValue := jsonObject at: 'objectValue'.
	self assert: (objectValue at: 'objectClassName') equals: 'GtLSerializedObjectValueTestObject'.
	self assert: (objectValue at: 'superclassName') equals: 'Object'.
	self assert: (objectValue at: 'packageName') equals: 'Gt4LlmCore-Examples'.
	self assert: (objectValue at: 'phlowViews') isNotEmpty.
	self assert: ((objectValue at: 'phlowViews') anySatisfy: [ :v | 
		(v at: 'title') = 'Details' ]).
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
	| objectStorage tool call targetObject storedResult |
	objectStorage := GtLObjectStorage new.
	self ensureLepiterPageForObject: 3 withSnippetCode: '1 + 2'.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: {
			'code' -> '1 + 2'.
			'bindings' -> #()
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage;
			lepiterDatabase: self theDatabase).
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: targetObject object equals: 3.
	self assert: targetObject code equals: '1 + 2'.
	
	self assert: targetObject objectValue objectClassName equals: 'SmallInteger'.
	self assert: targetObject objectValue objectPrintString equals: '3'.
	self assertPlaygroundPageReference: targetObject playgroundPageReference.
	
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
	| objectStorage tool call targetObject storedResult |
	objectStorage := GtLObjectStorage new.
	self ensureLepiterPageForObject: 3 withSnippetCode: '1 + 2'.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: {
			'code' -> '1 + 2'.
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage;
			lepiterDatabase: self theDatabase).
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: targetObject object equals: 3.
	self assert: targetObject code equals: '1 + 2'.
	self assert: targetObject objectValue objectClassName equals: 'SmallInteger'.
	self assert: targetObject objectValue objectPrintString equals: '3'.
	self assert: targetObject objectId isNotEmpty.
	self assert: targetObject playgroundPageReference notNil.
	self assert: targetObject playgroundPageReference databaseId equals: self theDatabase primaryDB uuidString.
	self assert: targetObject playgroundPageReference pageId equals: self theDatabase pages first uid asString36.
	self assert: objectStorage objectCount equals: 1.
	self assert: (objectStorage objectAt: objectStorage objectIds first) equals: 3.
	storedResult := objectStorage storedObjectAt: targetObject objectId.
	self assert: storedResult reason class equals: GtLStoredObjectCodeExecutionReason.
	self assert: storedResult reason asReasonString equals: '1 + 2'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeSimpleDoItWithoutLepiterPage [
	<gtExample>
	| objectStorage tool call targetObject |
	objectStorage := GtLObjectStorage new.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: {
			'code' -> 'LePage new'.
			'bindings' -> #()
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage;
			lepiterDatabase: self theDatabase).
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: (targetObject object isKindOf: LePage).
	self assert: targetObject playgroundPageReference isNil.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeSimpleDoItWithoutObjectStorage [
	<gtExample>
	| tool call |
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	
	call := self
		executeTool: tool
		withArguments: {
			'code' -> '1 + 2'.
			'bindings' -> #()
			} asDictionary
		inContext: (GtLToolExecutionContext new 
			lepiterDatabase: self theDatabase).
			
	self assert: (call result targetObject isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: call result targetObject object equals: 3.
	self assert: call result targetObject code equals: '1 + 2'.
	self assert: call result targetObject objectId equals: ''.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindingEmptyName [
	<gtExample>
	<return: #GtLFunctionToolCall>
	"Test that a binding with empty name is handled."
	| objectStorage call bindingObjectId |
	objectStorage := GtLObjectStorage new.
	bindingObjectId := objectStorage addNewObject: 40.
	call := self
		executeTool: GtLMagritteToolForSmalltalkCodeEvaluation new
		withArguments: {
			'code' -> 'value + 2'.
			'bindings' -> {
				{ 'name' -> ''. 'objectId' -> bindingObjectId } asDictionary
			} asArray
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage;
			lepiterDatabase: self theDatabase).
	self
		assertSmalltalkCodeEvaluationException: call result targetObject
		withCode: 'value + 2'
		exceptionClass: RBParser gtParseErrorClass
		messageSubstring: 'Undeclared variable'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindingEmptyObjectId [
	<gtExample>
	<return: #GtLFunctionToolCall>
	"Test that a binding with empty objectId is handled."
	| objectStorage call |
	objectStorage := GtLObjectStorage new.
	call := self
		executeTool: GtLMagritteToolForSmalltalkCodeEvaluation new
		withArguments: {
			'code' -> 'value + 2'.
			'bindings' -> {
				{ 'name' -> 'value'. 'objectId' -> '' } asDictionary
			} asArray
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage;
			lepiterDatabase: self theDatabase).
	self
		assertMissingObject: call result targetObject
		withObjectName: ''
		errorMessage: ' is not found'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindingMissingName [
	<gtExample>
	<return: #GtLFunctionToolCall>
	"Test that a binding with missing name is handled - returns missing required properties error."
	| objectStorage call bindingObjectId |
	objectStorage := GtLObjectStorage new.
	bindingObjectId := objectStorage addNewObject: 40.
	call := self
		executeTool: GtLMagritteToolForSmalltalkCodeEvaluation new
		withArguments: {
			'code' -> 'value + 2'.
			'bindings' -> {
				{ 'objectId' -> bindingObjectId } asDictionary
			} asArray
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage;
			lepiterDatabase: self theDatabase).
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('name')
		path: #(#bindings 1)
		errorMessage: '@[bindings/1] required properties missing [name]'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindingMissingObjectId [
	<gtExample>
	<return: #GtLFunctionToolCall>
	"Test that a binding with missing objectId is handled - returns missing required properties error."
	| objectStorage call |
	objectStorage := GtLObjectStorage new.
	call := self
		executeTool: GtLMagritteToolForSmalltalkCodeEvaluation new
		withArguments: {
			'code' -> 'value + 2'.
			'bindings' -> {
				{ 'name' -> 'value' } asDictionary
			} asArray
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage;
			lepiterDatabase: self theDatabase).
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('objectId')
		path: #(#bindings 1)
		errorMessage: '@[bindings/1] required properties missing [objectId]'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindingNilName [
	<gtExample>
	<return: #GtLFunctionToolCall>
	"Test that a binding with nil name is handled - returns JSON schema validation error."
	| objectStorage call bindingObjectId |
	objectStorage := GtLObjectStorage new.
	bindingObjectId := objectStorage addNewObject: 40.
	call := self
		executeTool: GtLMagritteToolForSmalltalkCodeEvaluation new
		withArguments: {
			'code' -> 'value + 2'.
			'bindings' -> {
				{ 'name' -> nil. 'objectId' -> bindingObjectId } asDictionary
			} asArray
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage;
			lepiterDatabase: self theDatabase).
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #(#bindings 1 #name)
		errorMessage: '@[bindings/1/name] string expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindingNilObjectId [
	<gtExample>
	<return: #GtLFunctionToolCall>
	"Test that a binding with nil objectId is handled - returns JSON schema validation error."
	| objectStorage tool call |
	objectStorage := GtLObjectStorage new.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: {
			'code' -> 'value + 2'.
			'bindings' -> {
				{ 'name' -> 'value'. 'objectId' -> nil } asDictionary
			} asArray
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage;
			lepiterDatabase: self theDatabase).
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #(#bindings 1 #objectId)
		errorMessage: '@[bindings/1/objectId] string expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindings [
	<gtExample>
	| objectStorage tool call targetObject bindingObjectId resultObjectId storedResult |
	objectStorage := GtLObjectStorage new.
	bindingObjectId := objectStorage addNewObject: 40.
	self ensureLepiterPageForObject: 42 withSnippetCode: 'value + 2'.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: {
			'code' -> 'value + 2'.
			'bindings' -> {
				{ 'name' -> 'value'. 'objectId' -> bindingObjectId } asDictionary
			} asArray
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage;
			lepiterDatabase: self theDatabase).
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: targetObject object equals: 42.
	self assert: targetObject playgroundPageReference notNil.
	self assert: targetObject playgroundPageReference databaseId equals: self theDatabase primaryDB uuidString.
	self assert: targetObject playgroundPageReference pageId equals: self theDatabase pages first uid asString36.
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

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindingsMissingObjectStorage [
	<gtExample>
	<return: #GtLFunctionToolCall>
	| call |
	call := self
		executeTool: GtLMagritteToolForSmalltalkCodeEvaluation new
		withArguments: {
			'code' -> 'value + 2'.
			'bindings' -> {
				{ 'name' -> 'value'. 'objectId' -> 'missing' } asDictionary
			} asArray
			} asDictionary
		inContext: (GtLToolExecutionContext new 
			lepiterDatabase: self theDatabase).
	self
		assertMissingInformation: call result targetObject
		withModelName: 'objectStorage'
		errorMessage: 'Missing objectStorage'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithError [
	<gtExample>
	| objectStorage tool call targetObject storedResult |
	objectStorage := GtLObjectStorage new.
	self ensureLepiterPageForObject: ZeroDivide new withSnippetCode: '1 / 0'.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: {
			'code' -> '1 / 0'.
			'bindings' -> #()
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage;
			lepiterDatabase: self theDatabase).
	targetObject := call result targetObject.
	self
		assertSmalltalkCodeEvaluationException: targetObject
		withCode: '1 / 0'
		exceptionClass: ZeroDivide
		messageSubstring: 'ZeroDivide'.
		
	self assert: targetObject objectValue notNil.
	self assert: targetObject objectValue objectClassName equals: 'ZeroDivide'.
	self assert: targetObject objectValue objectPrintString equals: 'ZeroDivide'.
	self assertPlaygroundPageReference: targetObject playgroundPageReference.
	
	self assert: targetObject objectId isNotEmpty.
	self assert: objectStorage objectCount equals: 1.
	self assert: ((objectStorage objectAt: objectStorage objectIds first) isKindOf: ZeroDivide).
	
	storedResult := objectStorage storedObjectAt: targetObject objectId.
	self assert: storedResult reason class equals: GtLStoredObjectCodeExecutionReason.
	self assert: storedResult reason asReasonString equals: '1 / 0'.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithErrorWithoutLepiterPage [
	<gtExample>
	| objectStorage tool call targetObject |
	objectStorage := GtLObjectStorage new.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: {
			'code' -> 'LePage new error: ''boom'''.
			'bindings' -> #()
		} asDictionary
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage;
			lepiterDatabase: self theDatabase).
	targetObject := call result targetObject.
	self
		assertSmalltalkCodeEvaluationException: targetObject
		withCode: 'LePage new error: ''boom'''
		exceptionClass: Error
		messageSubstring: 'boom'.
	self assert: targetObject objectValue notNil.
	self assert: targetObject objectValue objectClassName equals: 'Error'.
	self assert: targetObject objectId isNotEmpty.
	self assert: targetObject playgroundPageReference isNil.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithErrorWithoutObjectStorage [
	<gtExample>
	| tool call targetObject |
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: {
					'code' -> '1 / 0'.
			'bindings' -> #()
			} asDictionary
		inContext: (GtLToolExecutionContext new 
			lepiterDatabase: self theDatabase).
	targetObject := call result targetObject.
	self
		assertSmalltalkCodeEvaluationException: targetObject
		withCode: '1 / 0'
		exceptionClass: ZeroDivide
		messageSubstring: 'ZeroDivide'.
		
	self assert: targetObject objectValue notNil.
	self assert: targetObject objectValue objectClassName equals: 'ZeroDivide'.
	self assert: targetObject objectValue objectPrintString equals: 'ZeroDivide'.
	self assert: targetObject objectId equals: ''.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> missingCodeArgument [
	<gtExample>
	<return: #GtLFunctionToolCall>
	| tool call |
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := self
		executeTool: tool
		withArguments: {
			'bindings' -> #()
			} asDictionary
		inContext: (GtLToolExecutionContext new 
			lepiterDatabase: self theDatabase).
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('code')
		path: #(nil)
		errorMessage: 'required properties missing [code]'.
	^ call
]
