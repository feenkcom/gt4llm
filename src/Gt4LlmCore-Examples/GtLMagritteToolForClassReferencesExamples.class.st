"
Examples for GtLMagritteToolForClassReferences.
"
Class {
	#name : #GtLMagritteToolForClassReferencesExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForClassReferencesExamples >> classReferencesDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| call domainObject compositeView dataBlock jsonData |
	call := self classReferencesForExistingClass.
	domainObject := call result targetObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: #givenClassName) equals: 'GtLMagritteToolForClassReferences'.
	self assert: (jsonData at: #mayHaveMore) not.
	self assert: (jsonData at: #references) isNotEmpty.
	self 
		assert: ((jsonData at: #references) anySatisfy: [ :each |
			(each at: #methodClassName) = 'GtLMagritteToolForClassReferencesExamples' ]).
	
	^ dataBlock
]

{ #category : #examples }
GtLMagritteToolForClassReferencesExamples >> classReferencesForClassWithNoReferences [
	<gtExample>
	| call targetObject |
	
	call := self
		executeTool: GtLMagritteToolForClassReferences new
		withArguments: {
			'className' -> 'GtLClassReferencesExamples'
		} asDictionary.
	targetObject := call result targetObject.
	
	self assert: (targetObject isKindOf: GtLClassReferences).
	self assert: targetObject givenClassName equals: 'GtLClassReferencesExamples'.
	self assert: targetObject references isEmpty.
	self assert: targetObject mayHaveMore not.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassReferencesExamples >> classReferencesForExistingClass [
	<gtExample>
	| call targetObject |
	
	call := self
		executeTool: GtLMagritteToolForClassReferences new
		withArguments: {
			'className' -> 'GtLMagritteToolForClassReferences'
		} asDictionary.
	targetObject := call result targetObject.
	
	self assert: (targetObject isKindOf: GtLClassReferences).
	self assert: targetObject givenClassName equals: 'GtLMagritteToolForClassReferences'.
	self assert: targetObject references isNotEmpty.
	self assert: (targetObject references anySatisfy: [ :each |
		each methodClassName = 'GtLMagritteToolForClassReferencesExamples' ]).
	self assert: targetObject mayHaveMore not.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassReferencesExamples >> classReferencesForTrait [
	<gtExample>
	| call targetObject |
	
	call := self
		executeTool: GtLMagritteToolForClassReferences new
		withArguments: {
			'className' -> 'TGtLInvalidInputDataAssertions'
		} asDictionary.
	targetObject := call result targetObject.
	
	self assert: (targetObject isKindOf: GtLClassReferences).
	self assert: targetObject givenClassName equals: 'TGtLInvalidInputDataAssertions'.
	self assert: targetObject references isNotEmpty.
	self assert: targetObject mayHaveMore not.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassReferencesExamples >> classReferencesForUnknownClass [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassReferences new
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
GtLMagritteToolForClassReferencesExamples >> classReferencesWithEmptyClassName [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassReferences new
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
GtLMagritteToolForClassReferencesExamples >> classReferencesWithMissingClassName [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassReferences new
		withArguments: {} asDictionary.
	
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('className')
		path: #(nil)
		errorMessage: 'required properties missing [className]'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassReferencesExamples >> classReferencesWithMoreThan200Results [
	<gtExample>
	| call targetObject |
	
	call := self
		executeTool: GtLMagritteToolForClassReferences new
		withArguments: {
			'className' -> 'Object'
		} asDictionary.
	targetObject := call result targetObject.
	
	self assert: (targetObject isKindOf: GtLClassReferences).
	self assert: targetObject givenClassName equals: 'Object'.
	self assert: targetObject references size equals: 200.
	self assert: targetObject mayHaveMore.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassReferencesExamples >> classReferencesWithNilClassName [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassReferences new
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
GtLMagritteToolForClassReferencesExamples >> classReferencesWithWhitespaceOnlyClassName [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassReferences new
		withArguments: {
			'className' -> '   '
		} asDictionary.
	
	self
		assertMissingArgument: call result targetObject
		withArgumentName: 'className'
		errorMessage: 'Missing argument called className'.
		
	^ call
]
