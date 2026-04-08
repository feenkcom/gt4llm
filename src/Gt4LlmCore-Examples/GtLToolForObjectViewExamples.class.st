"
Examples for GtLToolForObjectView demonstrating data views serialization and error handling.
"
Class {
	#name : #GtLToolForObjectViewExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForObjectViewExamples >> viewContentForExistingObjectAndView [
	<gtExample>
	| objectStorage objectId tool domainObject compositeView dataBlock jsonData imageBlock |
	objectStorage := GtLObjectStorage new.
	objectId := objectStorage addNewObject: 'Hello'.
	tool := GtLToolForObjectView new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'objectId' -> objectId.
			'viewSelector' -> 'gtStringFor:'
		} asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self assert: (domainObject isKindOf: GtLPhlowViewDomainObject).
	self assert: domainObject phlowView notNil.
	self assert: domainObject phlowView title equals: 'String'.
	self assert: domainObject viewMethodClassName equals: String name.
	self assert: domainObject viewMethodSourceCode equals: (String >> #gtStringFor:) sourceCode.
	
	"Test data view serialization"
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 2.
	dataBlock := compositeView serializeToLlmPrimiteData.
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: #viewMethodClass) equals: String name.
	self assert: (jsonData at: #viewMethodSourceCode) equals: (String >> #gtStringFor:) sourceCode.
	self assert: (jsonData at: #viewTitle) equals: 'String'.
	
	imageBlock := dataBlock imageDataBlocks first.
	self assert: imageBlock imageType equals: 'png'.
	self assert: imageBlock imageBytes isNotEmpty.
	^ domainObject
]

{ #category : #examples }
GtLToolForObjectViewExamples >> viewContentForMissingObjectId [
	<gtExample>
	| tool domainObject |
	tool := GtLToolForObjectView new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'viewSelector' -> 'gtStringFor:'
		} asDictionary.
	self
		assertMissingRequiredProperties: domainObject
		withPropertyNames: #('objectId')
		path: #(nil)
		errorMessage: 'required properties missing [objectId]'.
	^ domainObject
]

{ #category : #examples }
GtLToolForObjectViewExamples >> viewContentForMissingObjectStorage [
	<gtExample>
	| tool domainObject |
	tool := GtLToolForObjectView new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'objectId' -> 'missing'.
			'viewSelector' -> 'gtStringFor:'
		} asDictionary.
	self
		assertMissingInformation: domainObject
		withModelName: 'objectStorage'
		errorMessage: 'Missing objectStorage'.
	^ domainObject
]

{ #category : #examples }
GtLToolForObjectViewExamples >> viewContentForMissingViewSelector [
	<gtExample>
	| tool domainObject |
	tool := GtLToolForObjectView new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'objectId' -> 'missing'
		} asDictionary.
	self
		assertMissingRequiredProperties: domainObject
		withPropertyNames: #('viewSelector')
		path: #(nil)
		errorMessage: 'required properties missing [viewSelector]'.
	^ domainObject
]

{ #category : #examples }
GtLToolForObjectViewExamples >> viewContentForNonExistentViewSelector [
	<gtExample>
	| objectStorage objectId tool domainObject viewSelector |
	objectStorage := GtLObjectStorage new.
	objectId := objectStorage addNewObject: 'Hello'.
	viewSelector := 'nonExistentViewFor:'.
	tool := GtLToolForObjectView new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'objectId' -> objectId.
			'viewSelector' -> viewSelector
		} asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self
		assertMissingObject: domainObject
		withObjectName: viewSelector
		errorMessage: viewSelector, ' is not found'.
	^ domainObject
]

{ #category : #examples }
GtLToolForObjectViewExamples >> viewContentForUnknownObjectId [
	<gtExample>
	| objectStorage objectId tool domainObject |
	objectStorage := GtLObjectStorage new.
	objectId := objectStorage addNewObject: 1.
	objectStorage clearCache.
	tool := GtLToolForObjectView new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'objectId' -> objectId.
			'viewSelector' -> 'gtStringFor:'
		} asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self
		assertMissingObject: domainObject
		withObjectName: objectId
		errorMessage: objectId, ' is not found'.
	^ domainObject
]

{ #category : #examples }
GtLToolForObjectViewExamples >> viewContentForViewWithExceptionAtCreation [
	<gtExample>
	| objectStorage objectId tool domainObject compositeView dataBlock jsonData |
	objectStorage := GtLObjectStorage new.
	objectId := objectStorage addNewObject: GtInspectorSampleWithExceptionsInExtensions new.
	tool := GtLToolForObjectView new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'objectId' -> objectId.
			'viewSelector' -> 'gtViewWithExceptionAtCreationFor:'
		} asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self assert: (domainObject isKindOf: GtLPhlowViewDomainObject).
	self assert: domainObject phlowView notNil.
	self assert: domainObject phlowView title equals: 'Error'.
	self assert: domainObject viewMethodClassName equals: GtInspectorSampleWithExceptionsInExtensions name.
	self assert: domainObject viewMethodSourceCode equals: (GtInspectorSampleWithExceptionsInExtensions >> #gtViewWithExceptionAtCreationFor:) sourceCode.
	
	"Test data view serialization"
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	dataBlock := compositeView serializeToLlmPrimiteData.
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: #viewMethodClass) equals: GtInspectorSampleWithExceptionsInExtensions name.
	self assert: (jsonData at: #viewMethodSourceCode) equals: (GtInspectorSampleWithExceptionsInExtensions >> #gtViewWithExceptionAtCreationFor:) sourceCode.
	^ domainObject
]

{ #category : #examples }
GtLToolForObjectViewExamples >> viewContentForViewWithExceptionInStencil [
	<gtExample>
	| objectStorage objectId tool domainObject compositeView dataBlock jsonData |
	objectStorage := GtLObjectStorage new.
	objectId := objectStorage addNewObject: GtInspectorSampleWithExceptionsInExtensions new.
	tool := GtLToolForObjectView new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'objectId' -> objectId.
			'viewSelector' -> 'gtViewWithExceptionInStencilFor:'
		} asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self assert: (domainObject isKindOf: GtLPhlowViewDomainObject).
	self assert: domainObject phlowView notNil.
	self assert: domainObject phlowView title equals: 'With error in stencil'.
	self assert: domainObject viewMethodClassName equals: GtInspectorSampleWithExceptionsInExtensions name.
	self assert: domainObject viewMethodSourceCode equals: (GtInspectorSampleWithExceptionsInExtensions >> #gtViewWithExceptionInStencilFor:) sourceCode.
	
	"Test data view serialization"
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	dataBlock := compositeView serializeToLlmPrimiteData.
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: #viewMethodClass) equals: GtInspectorSampleWithExceptionsInExtensions name.
	self assert: (jsonData at: #viewMethodSourceCode) equals: (GtInspectorSampleWithExceptionsInExtensions >> #gtViewWithExceptionInStencilFor:) sourceCode.
	^ domainObject
]
