Class {
	#name : #GtLToolForSearchFilterExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
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
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForSearchFilter new
		withArguments: {
			'query' -> 'GtLToolForSearchFilterExamples gtMethodsInClass & #gtExample gtPragmas'
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLSearchFilterDomainObject).
	self assert: targetObject isErrorDomainObject not.
	self assert: targetObject items isNotEmpty.
	self assert: (targetObject items anySatisfy: [ :eachMethod |
		eachMethod methodClass = GtLToolForSearchFilterExamples
			and: [ eachMethod selector = #searchFilterForExampleMethods ] ]).
	
	^ targetObject
]

{ #category : #examples }
GtLToolForSearchFilterExamples >> searchFilterWithError [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForSearchFilter new
		withArguments: {
			'query' -> 'self error: ''boom'''
		} asDictionary.
	
	self assert: targetObject isErrorDomainObject.
	self assert: (targetObject description beginsWith: 'There was an error when evaluating the query: ').
	self assert: (targetObject description includesSubstring: 'boom').
	
	^ targetObject
]

{ #category : #examples }
GtLToolForSearchFilterExamples >> searchFilterWithMissingQuery [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForSearchFilter new
		withArguments: Dictionary new.
	
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('query')
		path: #(nil)
		errorMessage: 'required properties missing [query]'.
	
	^ targetObject
]
