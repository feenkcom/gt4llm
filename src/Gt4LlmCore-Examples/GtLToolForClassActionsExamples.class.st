Class {
	#name : #GtLToolForClassActionsExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'examples - data views' }
GtLToolForClassActionsExamples >> classActionsDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| call compositeView dataBlock jsonData |
	call := self classActionsForExistingClass.
	compositeView := call result targetObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock llmJsonData.
	self assert: (jsonData at: 'className') equals: 'GtLudoRecordingGame'.
	self assert: (jsonData at: 'methods') isNotEmpty.
	self assert: ((jsonData at: 'methods') anySatisfy: [ :m | m includesSubstring: 'gtAutoplayAction:' ]).
	
	^ dataBlock
]

{ #category : #examples }
GtLToolForClassActionsExamples >> classActionsForClassWithNoActions [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForClassActions new
		withArguments: {
			'className' -> 'GtLToolForClassActionsExamples'
		} asDictionary.
	self assert: (call result targetObject isKindOf: GtLClassMethodsDomainObject).
	self assert: call result targetObject targetClass equals: GtLToolForClassActionsExamples.
	self assert: call result targetObject methods equals: #().
	^ call
]

{ #category : #examples }
GtLToolForClassActionsExamples >> classActionsForExistingClass [
	<gtExample>
	| call targetObject |
	call := self
		executeTool: GtLToolForClassActions new
		withArguments: {
			'className' -> 'GtLudoRecordingGame'
		} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLClassMethodsDomainObject).
	self assert: targetObject methods isNotEmpty.
	self assert: (targetObject methods anySatisfy: [ :eachMethod | eachMethod selector = #gtAutoplayAction: ]).
	^ call
]

{ #category : #examples }
GtLToolForClassActionsExamples >> classActionsForUnknownClass [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForClassActions new
		withArguments: {
			'className' -> 'NonExistingClassName'
		} asDictionary.
	self
		assertMissingObject: call result targetObject
		withObjectName: 'NonExistingClassName'
		errorMessage: 'NonExistingClassName is not found'.
	^ call
]
