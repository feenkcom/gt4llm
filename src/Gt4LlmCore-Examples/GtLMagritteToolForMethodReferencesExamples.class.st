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
	| tool call result domainObject |
	#someUniqueSelector printString.
	tool := GtLMagritteToolForMethodReferences new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'methodName' -> 'someUniqueSelector' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLMethodsSearchResult).
	self assert: domainObject foundMethods isNotEmpty.
	self
		assert: (domainObject foundMethods anySatisfy: [ :each |
			each methodSignature includesSubstring: 'GtLMagritteToolForMethodReferencesExamples>>#methodReferencesForExistingSelector' ]).
	self assert: domainObject mayHaveMore not.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodReferencesExamples >> methodReferencesForUnknownSelector [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForMethodReferences new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'methodName' -> 'unknownSelector42' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLMethodsSearchResult).
	self assert: domainObject foundMethods equals: #().
	self assert: domainObject mayHaveMore not.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodReferencesExamples >> methodReferencesForValueOnlyReturns200 [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForMethodReferences new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'methodName' -> 'value' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLMethodsSearchResult).
	self assert: domainObject foundMethods size equals: 200.
	self assert: domainObject mayHaveMore.
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodReferencesExamples >> methodReferencesWithEmptyMethodName [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForMethodReferences new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'methodName' -> '' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingArgument: domainObject 
		withArgumentName: 'methodName' 
		errorMessage: 'Missing argument called methodName'.
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodReferencesExamples >> methodReferencesWithMissingMethodName [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForMethodReferences new.
	call := GtLFunctionToolCall new.
	call rawArguments: {} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 0.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('methodName') 
		path: #(nil) 
		errorMessage: 'required properties missing [methodName]'.
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodReferencesExamples >> methodReferencesWithNilMethodName [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForMethodReferences new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'methodName' -> nil } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertJSONSchemaValidationError: domainObject 
		withPath: #('methodName') 
		errorMessage: '@[methodName] string expected'.
	^ domainObject
]
