Class {
	#name : #GtLToolForSearchFilterExamples,
	#superclass : #Object,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForSearchFilterExamples >> searchFilterDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData |
	domainObject := self searchFilterForExampleMethods.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: #query) equals: 'GtLToolForSearchFilterExamples gtMethodsInClass & #gtExample gtPragmas'.
	self assert: (jsonData at: #itemsAsPrintStrings) isNotEmpty.
	self assert: ((jsonData at: #itemsAsPrintStrings) anySatisfy: [ :item | 
		item includesSubstring: 'searchFilterForExampleMethods' ]).
	
	^ dataBlock
]

{ #category : #examples }
GtLToolForSearchFilterExamples >> searchFilterForExampleMethods [
	<gtExample>
	| tool call result domainObject |
	tool := GtLToolForSearchFilter new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'query' -> 'GtLToolForSearchFilterExamples gtMethodsInClass & #gtExample gtPragmas'
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLSearchFilterDomainObject).
	self assert: domainObject isErrorDomainObject not.
	self assert: domainObject items isNotEmpty.
	self assert: (domainObject items anySatisfy: [ :eachMethod | 
		eachMethod methodClass = GtLToolForSearchFilterExamples
			and: [ eachMethod selector = #searchFilterForExampleMethods ] ]).
	^ domainObject
]

{ #category : #examples }
GtLToolForSearchFilterExamples >> searchFilterWithError [
	<gtExample>
	| tool call result domainObject |
	tool := GtLToolForSearchFilter new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'query' -> 'self error: ''boom''' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: domainObject isErrorDomainObject.
	self assert: (domainObject description beginsWith: 'There was an error when evaluating the query: ').
	self assert: (domainObject description includesSubstring: 'boom').
	^ domainObject
]

{ #category : #examples }
GtLToolForSearchFilterExamples >> searchFilterWithMissingQuery [
	<gtExample>
	| tool call result domainObject |
	tool := GtLToolForSearchFilter new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
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
