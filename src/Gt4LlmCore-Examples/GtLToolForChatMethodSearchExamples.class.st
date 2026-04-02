Class {
	#name : #GtLToolForChatMethodSearchExamples,
	#superclass : #Object,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForChatMethodSearchExamples >> methodSearchDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData |
	domainObject := self methodSearchReturnsMatches.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: #foundMethods) isNotEmpty.
	self assert: (jsonData includesKey: #mayHaveMore).
	
	^ dataBlock
]

{ #category : #examples }
GtLToolForChatMethodSearchExamples >> methodSearchHandlesError [
	<gtExample>
	| tool call result domainObject providerWithStubData |
	providerWithStubData := self providerWithStubDataForQuery: '1/0'.
	tool := GtLToolForChatMethodSearch new provider: providerWithStubData.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'searchPrompt' -> 'methods that trigger failures' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: domainObject isErrorDomainObject.
	^ domainObject
]

{ #category : #examples }
GtLToolForChatMethodSearchExamples >> methodSearchReturnsMatches [
	<gtExample>
	| tool call result domainObject providerWithStubData |
	providerWithStubData := self
			providerWithStubDataForQuery: 'GtLToolForChatMethodSearch gtReferences'.
	tool := GtLToolForChatMethodSearch new provider: providerWithStubData.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'searchPrompt' -> 'methods referencing BlElement' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLMethodsSearchResult).
	self assert: (domainObject foundMethods anySatisfy: [ :each | 
		each methodClassName = #GtLToolForChatMethodSearchExamples ]).
	^ domainObject
]

{ #category : #examples }
GtLToolForChatMethodSearchExamples >> providerWithStubDataForQuery: string [
	| textJsonString exporter obj |
	obj := GtLPharoScript new content: string.
	exporter := GtMagritteJSONDataExporter forObject: obj.
	textJsonString := '{ "PharoScript": ' , exporter exportObjectAsJsonString , '}'.
	^ GtLOpenAIProviderWithChatMethodSearchStub new
		responseData: {'content' -> {{'text' -> textJsonString} asDictionary}} asDictionary
]
