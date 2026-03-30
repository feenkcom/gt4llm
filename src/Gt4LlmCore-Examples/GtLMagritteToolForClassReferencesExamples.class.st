"
Examples for GtLMagritteToolForClassReferences.
"
Class {
	#name : #GtLMagritteToolForClassReferencesExamples,
	#superclass : #Object,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForClassReferencesExamples >> classReferencesDataViewSerialization [
	<gtExample>
	<return: #GtLCompositeDataBlock>
	| domainObject compositeView dataBlock jsonData expectedJson |
	domainObject := self classReferencesForExistingClass.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: #givenClassName) equals: 'GtLMagritteToolForClassReferences'.
	self assert: (jsonData at: #mayHaveMore) not.
	self assert: (jsonData at: #references) isNotEmpty.
	self 
		assert: ((jsonData at: #references) anySatisfy: [ :each |
			(each at: #methodClassName) = 'GtLMagritteToolForClassReferencesExamples' ]).
	
	^ dataBlock
]

{ #category : #examples }
GtLMagritteToolForClassReferencesExamples >> classReferencesForClassWithNoReferences [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForClassReferences new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> 'GtLClassReferencesExamples' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLClassReferences).
	self assert: domainObject givenClassName equals: 'GtLClassReferencesExamples'.
	self assert: domainObject references isEmpty.
	self assert: domainObject mayHaveMore not.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForClassReferencesExamples >> classReferencesForExistingClass [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForClassReferences new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> 'GtLMagritteToolForClassReferences' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLClassReferences).
	self assert: domainObject givenClassName equals: 'GtLMagritteToolForClassReferences'.
	self assert: domainObject references isNotEmpty.
	self
		assert: (domainObject references anySatisfy: [ :each |
			each methodClassName = 'GtLMagritteToolForClassReferencesExamples' ]).
	self assert: domainObject mayHaveMore not.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForClassReferencesExamples >> classReferencesForTrait [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForClassReferences new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> 'TGtLInvalidInputDataAssertions' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLClassReferences).
	self assert: domainObject givenClassName equals: 'TGtLInvalidInputDataAssertions'.
	self assert: domainObject references isNotEmpty.
	self assert: domainObject mayHaveMore not.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForClassReferencesExamples >> classReferencesForUnknownClass [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForClassReferences new.
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
GtLMagritteToolForClassReferencesExamples >> classReferencesWithEmptyClassName [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForClassReferences new.
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
GtLMagritteToolForClassReferencesExamples >> classReferencesWithMissingClassName [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForClassReferences new.
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
GtLMagritteToolForClassReferencesExamples >> classReferencesWithMoreThan200Results [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForClassReferences new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> 'Object' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLClassReferences).
	self assert: domainObject givenClassName equals: 'Object'.
	self assert: domainObject references size equals: 200.
	self assert: domainObject mayHaveMore.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForClassReferencesExamples >> classReferencesWithNilClassName [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForClassReferences new.
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

{ #category : #examples }
GtLMagritteToolForClassReferencesExamples >> classReferencesWithWhitespaceOnlyClassName [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForClassReferences new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> '   ' } asDictionary.
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
