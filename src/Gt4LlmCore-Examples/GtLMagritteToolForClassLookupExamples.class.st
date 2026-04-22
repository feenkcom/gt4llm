"
Examples for GtLMagritteToolForClassLookup.
"
Class {
	#name : #GtLMagritteToolForClassLookupExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForClassLookupExamples >> lookupClassEmptyClassName [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassLookup new
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
GtLMagritteToolForClassLookupExamples >> lookupClassMissingArgument [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassLookup new
		withArguments: Dictionary new.
	
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('className')
		path: #(nil)
		errorMessage: 'required properties missing [className]'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassLookupExamples >> lookupClassNilClassName [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassLookup new
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
GtLMagritteToolForClassLookupExamples >> lookupClassSuccessful [
	<gtExample>
	| call targetObject |
	
	call := self
		executeTool: GtLMagritteToolForClassLookup new
		withArguments: {
			'className' -> GtLMagritteToolForClassLookup name
		} asDictionary.
	targetObject := call result targetObject.
	
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
	| call targetObject |
	
	call := self
		executeTool: GtLMagritteToolForClassLookup new
		withArguments: {
			'className' -> 'TGtLInvalidInputDataAssertions'
		} asDictionary.
	targetObject := call result targetObject.
	
	self assert: (targetObject isKindOf: GtLClassDescription).
	self assert: targetObject currentClassName equals: #TGtLInvalidInputDataAssertions.
	self assert: targetObject superclassName isNil.
	self assert: targetObject allInstanceMethodNames notEmpty.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassLookupExamples >> lookupClassUnknown [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassLookup new
		withArguments: {
			'className' -> 'NonExistingClassName42'
		} asDictionary.
	
	self
		assertMissingObject: call result targetObject
		withObjectName: 'NonExistingClassName42'
		errorMessage: 'NonExistingClassName42 is not found'.
		
	^ call
]
