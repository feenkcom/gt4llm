"
Examples for GtLMagritteToolForClassSubclasses.
"
Class {
	#name : #GtLMagritteToolForClassSubclassesExamples,
	#superclass : #Object,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForClassSubclassesExamples >> classSubclassesDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData |
	domainObject := self classSubclassesForExistingClass.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: #givenClassName) equals: 'GtLAbstractMagritteFunctionTool'.
	self assert: (jsonData at: #subclassNames) isNotEmpty.
	self assert: (jsonData at: #mayHaveMore) not.
	
	^ dataBlock
]

{ #category : #examples }
GtLMagritteToolForClassSubclassesExamples >> classSubclassesForBlElement [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForClassSubclasses new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> 'BlElement' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLClassSubclasses).
	self assert: domainObject givenClassName equals: 'BlElement'.
	self assert: domainObject subclassNames size equals: 200.
	self assert: domainObject mayHaveMore.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForClassSubclassesExamples >> classSubclassesForClassWithNoSubclasses [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForClassSubclasses new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> 'GtLlmToolForClassSubclasses' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLClassSubclasses).
	self assert: domainObject givenClassName equals: 'GtLlmToolForClassSubclasses'.
	self assert: domainObject subclassNames isEmpty.
	self assert: domainObject mayHaveMore not.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForClassSubclassesExamples >> classSubclassesForExistingClass [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForClassSubclasses new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> 'GtLAbstractMagritteFunctionTool' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLClassSubclasses).
	self assert: domainObject givenClassName equals: 'GtLAbstractMagritteFunctionTool'.
	self assert: domainObject subclassNames isNotEmpty.
	self assert: (domainObject subclassNames anySatisfy: [ :each | each includesSubstring: 'GtLToolForClass' ]).
	self assert: domainObject mayHaveMore not.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForClassSubclassesExamples >> classSubclassesForUnknownClass [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForClassSubclasses new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> 'NonExistingClassName' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingObject: domainObject 
		withObjectName: 'NonExistingClassName' 
		errorMessage: 'NonExistingClassName is not found'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForClassSubclassesExamples >> classSubclassesWithEmptyClassName [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForClassSubclasses new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> '' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingArgument: domainObject 
		withArgumentName: 'className' 
		errorMessage: 'Missing argument called className'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForClassSubclassesExamples >> classSubclassesWithMissingClassName [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForClassSubclasses new.
	call := GtLFunctionToolCall new.
	call rawArguments: {} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('className') 
		path: #(nil) 
		errorMessage: 'required properties missing [className]'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForClassSubclassesExamples >> classSubclassesWithNilClassName [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForClassSubclasses new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> nil } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertJSONSchemaValidationError: domainObject 
		withPath: #('className') 
		errorMessage: '@[className] string expected'.
	^ domainObject
]
