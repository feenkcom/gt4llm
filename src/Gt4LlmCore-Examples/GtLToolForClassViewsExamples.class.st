Class {
	#name : #GtLToolForClassViewsExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForClassViewsExamples >> classViewsDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData |
	domainObject := self classViewsForExistingClass.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: 'className') equals: 'GtABAddressBook'.
	self assert: (jsonData at: 'methods') isNotEmpty.
	self assert: ((jsonData at: 'methods') anySatisfy: [ :m | m includesSubstring: 'gtViewContactsListOn:' ]).
	
	^ dataBlock
]

{ #category : #examples }
GtLToolForClassViewsExamples >> classViewsForClassWithNoViews [
	<gtExample>
	| tool call result domainObject |
	tool := GtLToolForClassViews new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> 'GtLToolForClassViewsExamples' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLClassMethodsDomainObject).
	self assert: domainObject targetClass equals: GtLToolForClassViewsExamples.
	self assert: domainObject methods equals: #().
	^ domainObject
]

{ #category : #examples }
GtLToolForClassViewsExamples >> classViewsForExistingClass [
	<gtExample>
	| tool call result domainObject |
	tool := GtLToolForClassViews new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> 'GtABAddressBook' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLClassMethodsDomainObject).
	self assert: domainObject methods isNotEmpty.
	self assert: (domainObject methods anySatisfy: [ :m | m selector = #gtViewContactsListOn: ]).
	^ domainObject
]

{ #category : #examples }
GtLToolForClassViewsExamples >> classViewsForUnknownClass [
	<gtExample>
	| tool call result domainObject |
	tool := GtLToolForClassViews new.
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
