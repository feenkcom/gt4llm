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
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForClassViews new
		withArguments: {
			'className' -> 'GtLToolForClassViewsExamples'
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLClassMethodsDomainObject).
	self assert: targetObject targetClass equals: GtLToolForClassViewsExamples.
	self assert: targetObject methods equals: #().
	
	^ targetObject
]

{ #category : #examples }
GtLToolForClassViewsExamples >> classViewsForExistingClass [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForClassViews new
		withArguments: {
			'className' -> 'GtABAddressBook'
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLClassMethodsDomainObject).
	self assert: targetObject methods isNotEmpty.
	self assert: (targetObject methods anySatisfy: [ :m | m selector = #gtViewContactsListOn: ]).
	
	^ targetObject
]

{ #category : #examples }
GtLToolForClassViewsExamples >> classViewsForUnknownClass [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForClassViews new
		withArguments: {
			'className' -> 'NonExistingClassName'
		} asDictionary.
	
	self
		assertMissingObject: targetObject
		withObjectName: 'NonExistingClassName'
		errorMessage: 'NonExistingClassName is not found'.
	
	^ targetObject
]
