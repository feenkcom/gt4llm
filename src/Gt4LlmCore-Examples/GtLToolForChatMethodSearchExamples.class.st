Class {
	#name : #GtLToolForChatMethodSearchExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
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
	| targetObject providerWithStubData |
	providerWithStubData := self providerWithStubDataForQuery: '1/0'.
	
	targetObject := self
		executeTool: (GtLToolForChatMethodSearch new provider: providerWithStubData)
		withArguments: {
			'searchPrompt' -> 'methods that trigger failures'
		} asDictionary.
	
	self assert: targetObject isErrorDomainObject.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForChatMethodSearchExamples >> methodSearchReturnsMatches [
	<gtExample>
	| targetObject providerWithStubData |
	providerWithStubData := self
		providerWithStubDataForQuery: 'GtLToolForChatMethodSearch gtReferences'.
	
	targetObject := self
		executeTool: (GtLToolForChatMethodSearch new provider: providerWithStubData)
		withArguments: {
			'searchPrompt' -> 'methods referencing BlElement'
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLMethodsSearchResult).
	self assert: (targetObject foundMethods anySatisfy: [ :each |
		each methodClassName = #GtLToolForChatMethodSearchExamples ]).
	
	^ targetObject
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
