"
Examples for GtLMagritteToolForMethodReferences.
"
Class {
	#name : #GtLMagritteToolForMethodReferencesExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForMethodReferencesExamples >> methodReferencesForExistingSelector [
	<gtExample>
	| targetObject |
	#someUniqueSelector printString.
	
	targetObject := self
		executeTool: GtLMagritteToolForMethodReferences new
		withArguments: {
			'methodName' -> 'someUniqueSelector'
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLMethodsSearchResult).
	self assert: targetObject foundMethods isNotEmpty.
	self assert: (targetObject foundMethods anySatisfy: [ :each |
		each methodSignature includesSubstring: 'GtLMagritteToolForMethodReferencesExamples>>#methodReferencesForExistingSelector' ]).
	self assert: targetObject mayHaveMore not.
	
	^ targetObject
]

{ #category : #examples }
GtLMagritteToolForMethodReferencesExamples >> methodReferencesForUnknownSelector [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLMagritteToolForMethodReferences new
		withArguments: {
			'methodName' -> 'unknownSelector42'
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLMethodsSearchResult).
	self assert: targetObject foundMethods equals: #().
	self assert: targetObject mayHaveMore not.
	
	^ targetObject
]

{ #category : #examples }
GtLMagritteToolForMethodReferencesExamples >> methodReferencesForValueOnlyReturns200 [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLMagritteToolForMethodReferences new
		withArguments: {
			'methodName' -> 'value'
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLMethodsSearchResult).
	self assert: targetObject foundMethods size equals: 200.
	self assert: targetObject mayHaveMore.
	
	^ targetObject
]

{ #category : #examples }
GtLMagritteToolForMethodReferencesExamples >> methodReferencesWithEmptyMethodName [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLMagritteToolForMethodReferences new
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
GtLMagritteToolForMethodReferencesExamples >> methodReferencesWithMissingMethodName [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLMagritteToolForMethodReferences new
		withArguments: Dictionary new.
	
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('methodName')
		path: #(nil)
		errorMessage: 'required properties missing [methodName]'.
	
	^ targetObject
]

{ #category : #examples }
GtLMagritteToolForMethodReferencesExamples >> methodReferencesWithNilMethodName [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLMagritteToolForMethodReferences new
		withArguments: {
			'methodName' -> nil
		} asDictionary.
	
	self
		assertJSONSchemaValidationError: targetObject
		withPath: #('methodName')
		errorMessage: '@[methodName] string expected'.
	
	^ targetObject
]
