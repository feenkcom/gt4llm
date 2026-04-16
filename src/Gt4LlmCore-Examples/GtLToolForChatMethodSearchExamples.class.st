Class {
	#name : #GtLToolForChatMethodSearchExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'examples - data views' }
GtLToolForChatMethodSearchExamples >> methodSearchDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| call compositeView dataBlock jsonData |
	call := self methodSearchReturnsMatches.
	compositeView := call result targetObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock llmJsonData.
	self assert: (jsonData at: #foundMethods) isNotEmpty.
	self assert: (jsonData includesKey: #mayHaveMore).
	
	^ dataBlock
]

{ #category : #examples }
GtLToolForChatMethodSearchExamples >> methodSearchHandlesError [
	<gtExample>
	| call providerWithStubData |
	providerWithStubData := self providerWithStubDataForQuery: '1/0'.
	call := self
		executeTool: (GtLToolForChatMethodSearch new provider: providerWithStubData)
		withArguments: {
			'searchPrompt' -> 'methods that trigger failures'
		} asDictionary.
	self assert: call result targetObject isErrorDomainObject.
	^ call
]

{ #category : #examples }
GtLToolForChatMethodSearchExamples >> methodSearchReturnsMatches [
	<gtExample>
	| call providerWithStubData targetObject |
	providerWithStubData := self
		providerWithStubDataForQuery: 'GtLToolForChatMethodSearch gtReferences'.
	call := self
		executeTool: (GtLToolForChatMethodSearch new provider: providerWithStubData)
		withArguments: {
			'searchPrompt' -> 'methods referencing BlElement'
		} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLMethodsSearchResult).
	self assert: (targetObject foundMethods anySatisfy: [ :each |
		each methodClassName = #GtLToolForChatMethodSearchExamples ]).
	^ call
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
