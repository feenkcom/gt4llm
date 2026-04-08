Class {
	#name : #GtLToolForClassActionsExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
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
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForClassActions new
		withArguments: {
			'className' -> 'GtLToolForClassActionsExamples'
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLClassMethodsDomainObject).
	self assert: targetObject targetClass equals: GtLToolForClassActionsExamples.
	self assert: targetObject methods equals: #().
	
	^ targetObject
]

{ #category : #examples }
GtLToolForClassActionsExamples >> classActionsForExistingClass [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForClassActions new
		withArguments: {
			'className' -> 'GtLudoRecordingGame'
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLClassMethodsDomainObject).
	self assert: targetObject methods isNotEmpty.
	self assert: (targetObject methods anySatisfy: [ :eachMethod | eachMethod selector = #gtAutoplayAction: ]).
	
	^ targetObject
]

{ #category : #examples }
GtLToolForClassActionsExamples >> classActionsForUnknownClass [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForClassActions new
		withArguments: {
			'className' -> 'NonExistingClassName'
		} asDictionary.
	
	self
		assertMissingObject: targetObject
		withObjectName: 'NonExistingClassName'
		errorMessage: 'NonExistingClassName is not found'.
	
	^ targetObject
]
