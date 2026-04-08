"
Examples for GtLMagritteToolForMethodImplementors.
"
Class {
	#name : #GtLMagritteToolForMethodImplementorsExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForMethodImplementorsExamples >> implementorsForExistingMethodName [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForMethodImplementors new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'methodName' -> 'performToolCall:' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLMethodsSearchResult).
	self assert: domainObject foundMethods isNotEmpty.
	self
		assert: (domainObject foundMethods anySatisfy: [ :each |
			each methodSignature = 'GtLAbstractFunctionTool>>#performToolCall:' ]).
	self assert: domainObject mayHaveMore not.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodImplementorsExamples >> implementorsForGtDisplayOnReturns200 [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForMethodImplementors new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'methodName' -> 'gtDisplayOn:' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLMethodsSearchResult).
	self assert: domainObject foundMethods size equals: 200.
	self assert: domainObject mayHaveMore.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodImplementorsExamples >> implementorsForUnknownMethodName [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForMethodImplementors new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'methodName' -> 'unknownMethodName42' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLMethodsSearchResult).
	self assert: domainObject foundMethods equals: #().
	self assert: domainObject mayHaveMore not.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodImplementorsExamples >> implementorsForUnknownMethodNameDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData expected |
	domainObject := self implementorsForUnknownMethodName.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expected := Dictionary new
		at: #foundMethods put: NeoJSONArray new;
		at: #mayHaveMore put: false;
		yourself.
	self assert: jsonData equals: expected.
	
	^ dataBlock
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodImplementorsExamples >> implementorsWithEmptyMethodName [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForMethodImplementors new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'methodName' -> '' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingArgument: domainObject 
		withArgumentName: 'methodName' 
		errorMessage: 'Missing argument called methodName'.
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodImplementorsExamples >> implementorsWithMissingMethodName [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForMethodImplementors new.
	call := GtLFunctionToolCall new.
	call rawArguments: {} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 0.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('methodName') 
		path: #(nil) 
		errorMessage: 'required properties missing [methodName]'.
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodImplementorsExamples >> implementorsWithNilMethodName [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForMethodImplementors new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'methodName' -> nil } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertJSONSchemaValidationError: domainObject 
		withPath: #('methodName') 
		errorMessage: '@[methodName] string expected'.
	^ domainObject
]
