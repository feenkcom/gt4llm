"
Examples for GtLMagritteToolForClassLookup.
"
Class {
	#name : #GtLMagritteToolForClassLookupExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForClassLookupExamples >> lookupClassEmptyClassName [
	<gtExample>
	| tool call result targetObject |
	tool := GtLMagritteToolForClassLookup new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> '' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertMissingObject: targetObject
		withObjectName: ''
		errorMessage: ' is not found'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassLookupExamples >> lookupClassMissingArgument [
	<gtExample>
	| tool call result targetObject |
	tool := GtLMagritteToolForClassLookup new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('className')
		path: #(nil)
		errorMessage: 'required properties missing [className]'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassLookupExamples >> lookupClassNilClassName [
	<gtExample>
	| tool call result targetObject |
	tool := GtLMagritteToolForClassLookup new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> nil } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertJSONSchemaValidationError: targetObject
		withPath: #('className')
		errorMessage: '@[className] string expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassLookupExamples >> lookupClassSuccessful [
	<gtExample>
	| tool call result targetObject |
	tool := GtLMagritteToolForClassLookup new.
	call := GtLFunctionToolCall new.
	call rawArguments: {'className' -> GtLMagritteToolForClassLookup name} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self assert: (targetObject isKindOf: GtLClassDescription).
	self assert: targetObject currentClassName equals: GtLMagritteToolForClassLookup name.
	self assert: targetObject packageName equals: 'Gt4LlmCore'.
	self assert: targetObject instanceSlotNames isEmpty.
	self assert: targetObject classSlotNames isEmpty.
	self assert: targetObject allInstanceMethodNames notEmpty.
	self assert: (targetObject allClassMethodNames isKindOf: Collection).
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassLookupExamples >> lookupClassSuccessfulWithTrait [
	<gtExample>
	| tool call result targetObject |
	tool := GtLMagritteToolForClassLookup new.
	call := GtLFunctionToolCall new.
	call rawArguments: {'className' -> 'TGtLInvalidInputDataAssertions'} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self assert: (targetObject isKindOf: GtLClassDescription).
	self assert: targetObject currentClassName equals: #TGtLInvalidInputDataAssertions.
	self assert: targetObject superclassName isNil.
	self assert: targetObject allInstanceMethodNames notEmpty.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassLookupExamples >> lookupClassUnknown [
	<gtExample>
	| tool call result targetObject |
	tool := GtLMagritteToolForClassLookup new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> 'NonExistingClassName42' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertMissingObject: targetObject
		withObjectName: 'NonExistingClassName42'
		errorMessage: 'NonExistingClassName42 is not found'.
	^ call
]
