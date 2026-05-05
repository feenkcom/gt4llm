"
Examples for GtLMagritteToolForMethodReferences.
"
Class {
	#name : #GtLMagritteToolForMethodReferencesExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForMethodReferencesExamples >> methodReferencesForExistingSelector [
	<gtExample>
	| call targetObject |
	#someUniqueSelector printString.
	call := self
		executeTool: GtLMagritteToolForMethodReferences new
		withArguments: {
			'methodName' -> 'someUniqueSelector'
		} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLMethodsSearchResult).
	self assert: targetObject foundMethods isNotEmpty.
	self assert: (targetObject foundMethods anySatisfy: [ :each |
		each methodSignature includesSubstring: 'GtLMagritteToolForMethodReferencesExamples>>#methodReferencesForExistingSelector' ]).
	self assert: targetObject mayHaveMore not.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodReferencesExamples >> methodReferencesForUnknownSelector [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodReferences new
		withArguments: {
			'methodName' -> 'unknownSelector42'
		} asDictionary.
	self assert: (call result targetObject isKindOf: GtLMethodsSearchResult).
	self assert: call result targetObject foundMethods equals: #().
	self assert: call result targetObject mayHaveMore not.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodReferencesExamples >> methodReferencesForValueOnlyReturns200 [
	<gtExample>
	| call targetObject |
	call := self
		executeTool: GtLMagritteToolForMethodReferences new
		withArguments: {
			'methodName' -> 'value'
		} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLMethodsSearchResult).
	self assert: targetObject foundMethods size equals: 200.
	self assert: targetObject mayHaveMore.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodReferencesExamples >> methodReferencesWithEmptyMethodName [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodReferences new
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
GtLMagritteToolForMethodReferencesExamples >> methodReferencesWithMissingMethodName [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodReferences new
		withArguments: Dictionary new.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('methodName')
		path: #(nil)
		errorMessage: 'required properties missing [methodName]'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodReferencesExamples >> methodReferencesWithNilMethodName [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodReferences new
		withArguments: {
			'methodName' -> nil
		} asDictionary.
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('methodName')
		errorMessage: '@[methodName] string expected'.
	^ call
]
