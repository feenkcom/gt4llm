"
Examples for GtLMagritteToolForClassRemoval.
"
Class {
	#name : #GtLMagritteToolForClassRemovalExamples,
	#superclass : #Object,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #private }
GtLMagritteToolForClassRemovalExamples >> ensureClassNamed: aSymbol [
	self removeClassNamedIfPresent: aSymbol.
	^ Object
		subclass: aSymbol
		instanceVariableNames: ''
		classVariableNames: ''
		package: 'Gt4LlmCore-Examples'
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> removeClassEmptyClassName [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForClassRemoval new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> '' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingObject: domainObject 
		withObjectName: '' 
		errorMessage: ' is not found'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> removeClassMissingArgument [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForClassRemoval new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('className') 
		path: #(nil) 
		errorMessage: 'required properties missing [className]'.
	^ domainObject
]

{ #category : #private }
GtLMagritteToolForClassRemovalExamples >> removeClassNamedIfPresent: aSymbol [
	Smalltalk globals
		at: aSymbol asSymbol
		ifPresent: [ :cls | cls removeFromSystem ]
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> removeClassNilClassName [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForClassRemoval new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> nil } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertJSONSchemaValidationError: domainObject 
		withPath: #('className') 
		errorMessage: '@[className] string expected'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> removeClassWhitespaceOnlyClassName [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForClassRemoval new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> '   ' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingObject: domainObject 
		withObjectName: '   ' 
		errorMessage: '    is not found'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> removeExistingClass [
	<gtExample>
	| className domainObject |
	className := #GtLMagritteToolForClassRemovalExamplesTemporary.
	[
		| tool call result |
		self ensureClassNamed: className.
		tool := GtLMagritteToolForClassRemoval new.
		call := GtLFunctionToolCall new.
		call rawArguments: { 'className' -> className asString } asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		domainObject := result targetObject.
		self assert: (domainObject isKindOf: GtLClassRemovalResult).
		self assert: domainObject removedClassName equals: className asString.
		self assert: domainObject status equals: 'removed'.
		self assert: (Smalltalk globals includesKey: className) not
	] ensure: [ self removeClassNamedIfPresent: className ].
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> removeExistingClassDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData expectedJson |
	domainObject := self removeExistingClass.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#removedClassName -> 'GtLMagritteToolForClassRemovalExamplesTemporary'.
		#status -> 'removed'
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ dataBlock
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> removeUnknownClass [
	<gtExample>
	| tool call result domainObject className |
	className := 'GtLMagritteToolForClassRemovalExamplesDoesNotExist'.
	tool := GtLMagritteToolForClassRemoval new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> className } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingObject: domainObject 
		withObjectName: className 
		errorMessage: className, ' is not found'.
	^ domainObject
]
