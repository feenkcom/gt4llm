"
Examples for GtLMagritteToolForMethodImplementors.
"
Class {
	#name : #GtLMagritteToolForMethodImplementorsExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForMethodImplementorsExamples >> implementorsForExistingMethodName [
	<gtExample>
	| call targetObject |
	call := self
		executeTool: GtLMagritteToolForMethodImplementors new
		withArguments: {
			'methodName' -> 'performToolCall:'
		} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLMethodsSearchResult).
	self assert: targetObject foundMethods isNotEmpty.
	self assert: (targetObject foundMethods anySatisfy: [ :each |
		each methodSignature = 'GtLAbstractFunctionTool>>#performToolCall:' ]).
	self assert: targetObject mayHaveMore not.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodImplementorsExamples >> implementorsForGtDisplayOnReturns200 [
	<gtExample>
	| call targetObject |
	call := self
		executeTool: GtLMagritteToolForMethodImplementors new
		withArguments: {
			'methodName' -> 'gtDisplayOn:'
		} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLMethodsSearchResult).
	self assert: targetObject foundMethods size equals: 200.
	self assert: targetObject mayHaveMore.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodImplementorsExamples >> implementorsForUnknownMethodName [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodImplementors new
		withArguments: {
			'methodName' -> 'unknownMethodName42'
		} asDictionary.
	self assert: (call result targetObject isKindOf: GtLMethodsSearchResult).
	self assert: call result targetObject foundMethods equals: #().
	self assert: call result targetObject mayHaveMore not.
	^ call
]

{ #category : #'examples - data views' }
GtLMagritteToolForMethodImplementorsExamples >> implementorsForUnknownMethodNameDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| call compositeView dataBlock expectedJson |
	call := self implementorsForUnknownMethodName.
	compositeView := call result targetObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	expectedJson := Dictionary new
		at: #foundMethods put: NeoJSONArray new;
		at: #mayHaveMore put: false;
		yourself.
	self assertDataBlock: dataBlock hasLlmJsonData: expectedJson.
	
	^ dataBlock
]

{ #category : #examples }
GtLMagritteToolForMethodImplementorsExamples >> implementorsWithEmptyMethodName [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodImplementors new
		withArguments: {
			'methodName' -> ''
		} asDictionary.
	self
		assertMissingArgument: call result targetObject
		withArgumentName: 'methodName'
		errorMessage: 'Missing argument called methodName'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodImplementorsExamples >> implementorsWithMissingMethodName [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodImplementors new
		withArguments: Dictionary new.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('methodName')
		path: #(nil)
		errorMessage: 'required properties missing [methodName]'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodImplementorsExamples >> implementorsWithNilMethodName [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodImplementors new
		withArguments: {
			'methodName' -> nil
		} asDictionary.
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('methodName')
		errorMessage: '@[methodName] string expected'.
	^ call
]
