"
Examples for GtLMagritteToolForClassRemoval.
"
Class {
	#name : #GtLMagritteToolForClassRemovalExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
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
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassRemoval new
		withArguments: {
			'className' -> ''
		} asDictionary.
	
	self
		assertMissingObject: call result targetObject
		withObjectName: ''
		errorMessage: ' is not found'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> removeClassMissingArgument [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassRemoval new
		withArguments: Dictionary new.
	
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('className')
		path: #(nil)
		errorMessage: 'required properties missing [className]'.
		
	^ call
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
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassRemoval new
		withArguments: {
			'className' -> nil
		} asDictionary.
	
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('className')
		errorMessage: '@[className] string expected'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> removeClassWhitespaceOnlyClassName [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassRemoval new
		withArguments: {
			'className' -> '   '
		} asDictionary.
	
	self
		assertMissingObject: call result targetObject
		withObjectName: '   '
		errorMessage: '    is not found'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> removeExistingClass [
	<gtExample>
	| className call |
	
	className := #GtLMagritteToolForClassRemovalExamplesTemporary.
	[
		| targetObject |
		self ensureClassNamed: className.
		call := self
			executeTool: GtLMagritteToolForClassRemoval new
			withArguments: {
				'className' -> className asString
			} asDictionary.
		targetObject := call result targetObject.
		
		self assert: (targetObject isKindOf: GtLClassRemovalResult).
		self assert: targetObject removedClassName equals: className asString.
		self assert: targetObject status equals: 'removed'.
		self assert: (Smalltalk globals includesKey: className) not
	] ensure: [ self removeClassNamedIfPresent: className ].
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassRemovalExamples >> removeExistingClassDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| call domainObject compositeView dataBlock jsonData expectedJson |
	call := self removeExistingClass.
	domainObject := call result targetObject.
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
	| call className |
	
	className := 'GtLMagritteToolForClassRemovalExamplesDoesNotExist'.
	call := self
		executeTool: GtLMagritteToolForClassRemoval new
		withArguments: {
			'className' -> className
		} asDictionary.
	
	self
		assertMissingObject: call result targetObject
		withObjectName: className
		errorMessage: className, ' is not found'.
		
	^ call
]
