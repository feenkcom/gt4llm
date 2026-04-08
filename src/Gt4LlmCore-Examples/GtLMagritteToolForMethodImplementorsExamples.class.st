"
Examples for GtLMagritteToolForMethodImplementors.
"
Class {
	#name : #GtLMagritteToolForMethodImplementorsExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForMethodImplementorsExamples >> implementorsForExistingMethodName [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLMagritteToolForMethodImplementors new
		withArguments: {
			'methodName' -> 'performToolCall:'
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLMethodsSearchResult).
	self assert: targetObject foundMethods isNotEmpty.
	self assert: (targetObject foundMethods anySatisfy: [ :each |
		each methodSignature = 'GtLAbstractFunctionTool>>#performToolCall:' ]).
	self assert: targetObject mayHaveMore not.
	
	^ targetObject
]

{ #category : #examples }
GtLMagritteToolForMethodImplementorsExamples >> implementorsForGtDisplayOnReturns200 [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLMagritteToolForMethodImplementors new
		withArguments: {
			'methodName' -> 'gtDisplayOn:'
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLMethodsSearchResult).
	self assert: targetObject foundMethods size equals: 200.
	self assert: targetObject mayHaveMore.
	
	^ targetObject
]

{ #category : #examples }
GtLMagritteToolForMethodImplementorsExamples >> implementorsForUnknownMethodName [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLMagritteToolForMethodImplementors new
		withArguments: {
			'methodName' -> 'unknownMethodName42'
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLMethodsSearchResult).
	self assert: targetObject foundMethods equals: #().
	self assert: targetObject mayHaveMore not.
	
	^ targetObject
]

{ #category : #examples }
GtLMagritteToolForMethodImplementorsExamples >> implementorsForUnknownMethodNameDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData expected |
	domainObject := self implementorsForUnknownMethodName.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expected := Dictionary new
		at: #foundMethods put: NeoJSONArray new;
		at: #mayHaveMore put: false;
		yourself.
	self assert: jsonData equals: expected.
	
	^ dataBlock
]

{ #category : #examples }
GtLMagritteToolForMethodImplementorsExamples >> implementorsWithEmptyMethodName [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLMagritteToolForMethodImplementors new
		withArguments: {
			'methodName' -> ''
		} asDictionary.
	
	self
		assertMissingArgument: targetObject
		withArgumentName: 'methodName'
		errorMessage: 'Missing argument called methodName'.
	
	^ targetObject
]

{ #category : #examples }
GtLMagritteToolForMethodImplementorsExamples >> implementorsWithMissingMethodName [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLMagritteToolForMethodImplementors new
		withArguments: Dictionary new.
	
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('methodName')
		path: #(nil)
		errorMessage: 'required properties missing [methodName]'.
	
	^ targetObject
]

{ #category : #examples }
GtLMagritteToolForMethodImplementorsExamples >> implementorsWithNilMethodName [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLMagritteToolForMethodImplementors new
		withArguments: {
			'methodName' -> nil
		} asDictionary.
	
	self
		assertJSONSchemaValidationError: targetObject
		withPath: #('methodName')
		errorMessage: '@[methodName] string expected'.
	
	^ targetObject
]
