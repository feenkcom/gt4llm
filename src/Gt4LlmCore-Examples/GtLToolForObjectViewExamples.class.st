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
	| objectStorage objectId call targetObject compositeView dataBlock jsonData imageBlock |
	objectStorage := GtLObjectStorage new.
	objectId := objectStorage addNewObject: 'Hello'.
	call := self
		executeTool: GtLToolForObjectView new
		withArguments: {
			'objectId' -> objectId.
			'viewSelector' -> 'gtStringFor:'
		} asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLPhlowViewDomainObject).
	self assert: targetObject phlowView notNil.
	self assert: targetObject phlowView title equals: 'String'.
	self assert: targetObject viewMethodClassName equals: String name.
	self assert: targetObject viewMethodSourceCode equals: (String >> #gtStringFor:) sourceCode.
	compositeView := targetObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 2.
	dataBlock := compositeView serializeToLlmPrimiteData.
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: #viewMethodClass) equals: String name.
	self assert: (jsonData at: #viewMethodSourceCode) equals: (String >> #gtStringFor:) sourceCode.
	self assert: (jsonData at: #viewTitle) equals: 'String'.
	imageBlock := dataBlock imageDataBlocks first.
	self assert: imageBlock imageType equals: 'png'.
	self assert: imageBlock imageBytes isNotEmpty.
	^ call
]

{ #category : #examples }
GtLToolForObjectViewExamples >> viewContentForMissingObjectId [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForObjectView new
		withArguments: {
			'viewSelector' -> 'gtStringFor:'
		} asDictionary.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('objectId')
		path: #(nil)
		errorMessage: 'required properties missing [objectId]'.
	^ call
]

{ #category : #examples }
GtLToolForObjectViewExamples >> viewContentForMissingObjectStorage [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForObjectView new
		withArguments: {
			'objectId' -> 'missing'.
			'viewSelector' -> 'gtStringFor:'
		} asDictionary.
	self
		assertMissingInformation: call result targetObject
		withModelName: 'objectStorage'
		errorMessage: 'Missing objectStorage'.
	^ call
]

{ #category : #examples }
GtLToolForObjectViewExamples >> viewContentForMissingViewSelector [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForObjectView new
		withArguments: {
			'objectId' -> 'missing'
		} asDictionary.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('viewSelector')
		path: #(nil)
		errorMessage: 'required properties missing [viewSelector]'.
	^ call
]

{ #category : #examples }
GtLToolForObjectViewExamples >> viewContentForNonExistentViewSelector [
	<gtExample>
	| objectStorage objectId call viewSelector |
	objectStorage := GtLObjectStorage new.
	objectId := objectStorage addNewObject: 'Hello'.
	viewSelector := 'nonExistentViewFor:'.
	call := self
		executeTool: GtLToolForObjectView new
		withArguments: {
			'objectId' -> objectId.
			'viewSelector' -> viewSelector
		} asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self
		assertMissingObject: call result targetObject
		withObjectName: viewSelector
		errorMessage: viewSelector, ' is not found'.
	^ call
]

{ #category : #examples }
GtLToolForObjectViewExamples >> viewContentForUnknownObjectId [
	<gtExample>
	| objectStorage objectId call |
	objectStorage := GtLObjectStorage new.
	objectId := objectStorage addNewObject: 1.
	objectStorage clearCache.
	call := self
		executeTool: GtLToolForObjectView new
		withArguments: {
			'objectId' -> objectId.
			'viewSelector' -> 'gtStringFor:'
		} asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self
		assertMissingObject: call result targetObject
		withObjectName: objectId
		errorMessage: objectId, ' is not found'.
	^ call
]

{ #category : #examples }
GtLToolForObjectViewExamples >> viewContentForViewWithExceptionAtCreation [
	<gtExample>
	| objectStorage objectId tool call targetObject compositeView dataBlock jsonData |
	objectStorage := GtLObjectStorage new.
	objectId := objectStorage addNewObject: GtInspectorSampleWithExceptionsInExtensions new.
	tool := GtLToolForObjectView new.
	call := self
		executeTool: tool
		withArguments: {
			'objectId' -> objectId.
			'viewSelector' -> 'gtViewWithExceptionAtCreationFor:'
		} asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLPhlowViewDomainObject).
	self assert: targetObject phlowView notNil.
	self assert: targetObject phlowView title equals: 'Error'.
	self assert: targetObject viewMethodClassName equals: GtInspectorSampleWithExceptionsInExtensions name.
	self assert: targetObject viewMethodSourceCode equals: (GtInspectorSampleWithExceptionsInExtensions >> #gtViewWithExceptionAtCreationFor:) sourceCode.
	
	"Test data view serialization"
	compositeView := targetObject llmDataViewsFor: GtLDataView new.
	dataBlock := compositeView serializeToLlmPrimiteData.
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: #viewMethodClass) equals: GtInspectorSampleWithExceptionsInExtensions name.
	self assert: (jsonData at: #viewMethodSourceCode) equals: (GtInspectorSampleWithExceptionsInExtensions >> #gtViewWithExceptionAtCreationFor:) sourceCode.
	^ call
]

{ #category : #examples }
GtLToolForObjectViewExamples >> viewContentForViewWithExceptionInStencil [
	<gtExample>
	| objectStorage objectId tool call targetObject compositeView dataBlock jsonData |
	objectStorage := GtLObjectStorage new.
	objectId := objectStorage addNewObject: GtInspectorSampleWithExceptionsInExtensions new.
	tool := GtLToolForObjectView new.
	call := self
		executeTool: tool
		withArguments: {
			'objectId' -> objectId.
			'viewSelector' -> 'gtViewWithExceptionInStencilFor:'
		} asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLPhlowViewDomainObject).
	self assert: targetObject phlowView notNil.
	self assert: targetObject phlowView title equals: 'With error in stencil'.
	self assert: targetObject viewMethodClassName equals: GtInspectorSampleWithExceptionsInExtensions name.
	self assert: targetObject viewMethodSourceCode equals: (GtInspectorSampleWithExceptionsInExtensions >> #gtViewWithExceptionInStencilFor:) sourceCode.
	
	"Test data view serialization"
	compositeView := targetObject llmDataViewsFor: GtLDataView new.
	dataBlock := compositeView serializeToLlmPrimiteData.
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: #viewMethodClass) equals: GtInspectorSampleWithExceptionsInExtensions name.
	self assert: (jsonData at: #viewMethodSourceCode) equals: (GtInspectorSampleWithExceptionsInExtensions >> #gtViewWithExceptionInStencilFor:) sourceCode.
	^ call
]
