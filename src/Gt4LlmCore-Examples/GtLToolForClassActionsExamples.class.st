Class {
	#name : #GtLToolForClassActionsExamples,
	#superclass : #Object,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForClassActionsExamples >> classActionsDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData |
	domainObject := self classActionsForExistingClass.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: 'className') equals: 'GtLudoRecordingGame'.
	self assert: (jsonData at: 'methods') isNotEmpty.
	self assert: ((jsonData at: 'methods') anySatisfy: [ :m | m includesSubstring: 'gtAutoplayAction:' ]).
	
	^ dataBlock
]

{ #category : #examples }
GtLToolForClassActionsExamples >> classActionsForClassWithNoActions [
	<gtExample>
	| tool call result domainObject |
	tool := GtLToolForClassActions new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> 'GtLToolForClassActionsExamples' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLClassMethodsDomainObject).
	self assert: domainObject targetClass equals: GtLToolForClassActionsExamples.
	self assert: domainObject methods equals: #().
	^ domainObject
]

{ #category : #examples }
GtLToolForClassActionsExamples >> classActionsForExistingClass [
	<gtExample>
	| tool call result domainObject |
	tool := GtLToolForClassActions new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> 'GtLudoRecordingGame' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLClassMethodsDomainObject).
	self assert: domainObject methods isNotEmpty.
	self assert: (domainObject methods anySatisfy: [ :eachMethod | eachMethod selector = #gtAutoplayAction: ]).
	^ domainObject
]

{ #category : #examples }
GtLToolForClassActionsExamples >> classActionsForUnknownClass [
	<gtExample>
	| tool call result domainObject |
	tool := GtLToolForClassActions new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> 'NonExistingClassName' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingObject: domainObject 
		withObjectName: 'NonExistingClassName' 
		errorMessage: 'NonExistingClassName is not found'.
	^ domainObject
]
