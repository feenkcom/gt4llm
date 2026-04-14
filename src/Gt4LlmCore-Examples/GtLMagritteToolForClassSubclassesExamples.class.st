"
Examples for GtLMagritteToolForClassSubclasses.
"
Class {
	#name : #GtLMagritteToolForClassSubclassesExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForClassSubclassesExamples >> classSubclassesDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| call domainObject compositeView dataBlock jsonData |
	call := self classSubclassesForExistingClass.
	domainObject := call result targetObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: #givenClassName) equals: 'GtLAbstractMagritteFunctionTool'.
	self assert: (jsonData at: #subclassNames) isNotEmpty.
	self assert: (jsonData at: #mayHaveMore) not.
	
	^ dataBlock
]

{ #category : #examples }
GtLMagritteToolForClassSubclassesExamples >> classSubclassesForBlElement [
	<gtExample>
	| call targetObject |
	
	call := self
		executeTool: GtLMagritteToolForClassSubclasses new
		withArguments: {
			'className' -> 'BlElement'
		} asDictionary.
	targetObject := call result targetObject.
	
	self assert: (targetObject isKindOf: GtLClassSubclasses).
	self assert: targetObject givenClassName equals: 'BlElement'.
	self assert: targetObject subclassNames size equals: 200.
	self assert: targetObject mayHaveMore.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassSubclassesExamples >> classSubclassesForClassWithNoSubclasses [
	<gtExample>
	| call targetObject |
	
	call := self
		executeTool: GtLMagritteToolForClassSubclasses new
		withArguments: {
			'className' -> 'GtLlmToolForClassSubclasses'
		} asDictionary.
	targetObject := call result targetObject.
	
	self assert: (targetObject isKindOf: GtLClassSubclasses).
	self assert: targetObject givenClassName equals: 'GtLlmToolForClassSubclasses'.
	self assert: targetObject subclassNames isEmpty.
	self assert: targetObject mayHaveMore not.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassSubclassesExamples >> classSubclassesForExistingClass [
	<gtExample>
	| call targetObject |
	
	call := self
		executeTool: GtLMagritteToolForClassSubclasses new
		withArguments: {
			'className' -> 'GtLAbstractMagritteFunctionTool'
		} asDictionary.
	targetObject := call result targetObject.
	
	self assert: (targetObject isKindOf: GtLClassSubclasses).
	self assert: targetObject givenClassName equals: 'GtLAbstractMagritteFunctionTool'.
	self assert: targetObject subclassNames isNotEmpty.
	self assert: (targetObject subclassNames anySatisfy: [ :each | each includesSubstring: 'GtLToolForClass' ]).
	self assert: targetObject mayHaveMore not.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassSubclassesExamples >> classSubclassesForUnknownClass [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassSubclasses new
		withArguments: {
			'className' -> 'NonExistingClassName'
		} asDictionary.
	
	self
		assertMissingObject: call result targetObject
		withObjectName: 'NonExistingClassName'
		errorMessage: 'NonExistingClassName is not found'.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassSubclassesExamples >> classSubclassesWithEmptyClassName [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassSubclasses new
		withArguments: {
			'className' -> ''
		} asDictionary.
	
	self
		assertMissingArgument: call result targetObject
		withArgumentName: 'className'
		errorMessage: 'Missing argument called className'.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassSubclassesExamples >> classSubclassesWithMissingClassName [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassSubclasses new
		withArguments: Dictionary new.
	
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('className')
		path: #(nil)
		errorMessage: 'required properties missing [className]'.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassSubclassesExamples >> classSubclassesWithNilClassName [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassSubclasses new
		withArguments: {
			'className' -> nil
		} asDictionary.
	
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('className')
		errorMessage: '@[className] string expected'.
	
	^ call
]
