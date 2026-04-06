"
Examples for GtLMagritteToolForClassSearch.
"
Class {
	#name : #GtLMagritteToolForClassSearchExamples,
	#superclass : #Object,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForClassSearchExamples >> searchClassesDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData |
	domainObject := self searchClassesWithMatches.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: #foundClassNames) isNotEmpty.
	self assert: (jsonData at: #mayHaveMore) not.
	
	^ dataBlock
]

{ #category : #examples }
GtLMagritteToolForClassSearchExamples >> searchClassesWithEmptyQuery [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForClassSearch new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'query' -> '' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLClassesSearchResult).
	self assert: domainObject foundClassNames isEmpty.
	self assert: domainObject mayHaveMore not.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForClassSearchExamples >> searchClassesWithMatches [
	<gtExample>
	| tool call result domainObject queryLower |
	tool := GtLMagritteToolForClassSearch new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'query' -> 'GtLToolForClass' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLClassesSearchResult).
	self assert: domainObject foundClassNames isNotEmpty.
	queryLower := 'GtLToolForClass' asLowercase.
	self assert: (domainObject foundClassNames anySatisfy: [ :each | each asLowercase includesSubstring: queryLower ]).
	self assert: domainObject mayHaveMore not.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForClassSearchExamples >> searchClassesWithMissingQuery [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForClassSearch new.
	call := GtLFunctionToolCall new.
	call rawArguments: {} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('query') 
		path: #(nil) 
		errorMessage: 'required properties missing [query]'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForClassSearchExamples >> searchClassesWithMoreThan200Matches [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForClassSearch new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'query' -> 'Object' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLClassesSearchResult).
	self assert: domainObject foundClassNames size equals: 200.
	self assert: (domainObject foundClassNames allSatisfy: [ :each | each includesSubstring: 'Object' ]).
	self assert: domainObject mayHaveMore.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForClassSearchExamples >> searchClassesWithNilQuery [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForClassSearch new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'query' -> nil } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertJSONSchemaValidationError: domainObject 
		withPath: #('query') 
		errorMessage: '@[query] string expected'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForClassSearchExamples >> searchClassesWithNoMatches [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForClassSearch new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'query' -> 'ClassNameThatDoesNotExist42' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLClassesSearchResult).
	self assert: domainObject foundClassNames isEmpty.
	self assert: domainObject mayHaveMore not.
	^ domainObject
]
