"
Examples for GtLMagritteToolForSubstringLiteralSearch.
"
Class {
	#name : #GtLMagritteToolForSubstringLiteralSearchExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #'examples - error conditions' }
GtLMagritteToolForSubstringLiteralSearchExamples >> searchWithEmptyQuery [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForSubstringLiteralSearch new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'query' -> '' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingArgument: domainObject 
		withArgumentName: 'query' 
		errorMessage: 'Missing argument called query'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForSubstringLiteralSearchExamples >> searchWithMatches [
	<gtExample>
	| tool call result domainObject query |
	query := 'substringLiteralSearchExampleUnique'.
	tool := GtLMagritteToolForSubstringLiteralSearch new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'query' -> query } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLMethodsSearchResult).
	self
		assert: (domainObject foundMethods anySatisfy: [ :each |
			each methodSignature = 'GtLMagritteToolForSubstringLiteralSearchExamples>>#searchWithMatches' ]).
	self assert: domainObject mayHaveMore not.
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForSubstringLiteralSearchExamples >> searchWithMissingQuery [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForSubstringLiteralSearch new.
	call := GtLFunctionToolCall new.
	call rawArguments: {} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 0.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('query') 
		path: #(nil) 
		errorMessage: 'required properties missing [query]'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForSubstringLiteralSearchExamples >> searchWithMoreThan200Matches [
	<gtExample>
	| tool call result domainObject query |
	query := 'gt'.
	tool := GtLMagritteToolForSubstringLiteralSearch new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'query' -> query } asDictionary.
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
GtLMagritteToolForSubstringLiteralSearchExamples >> searchWithNilQuery [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForSubstringLiteralSearch new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'query' -> nil } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertJSONSchemaValidationError: domainObject 
		withPath: #('query') 
		errorMessage: '@[query] string expected'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForSubstringLiteralSearchExamples >> searchWithNoMatches [
	<gtExample>
	| tool call result domainObject query |
	query := 'noLiteralMatchString', 'ForSearch' , '42'.
	tool := GtLMagritteToolForSubstringLiteralSearch new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'query' -> query } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLMethodsSearchResult).
	self assert: domainObject foundMethods isEmpty.
	self assert: domainObject mayHaveMore not.
	^ domainObject
]
