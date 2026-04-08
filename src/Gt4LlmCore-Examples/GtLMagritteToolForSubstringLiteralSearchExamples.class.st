"
Examples for GtLMagritteToolForSubstringLiteralSearch.
"
Class {
	#name : #GtLMagritteToolForSubstringLiteralSearchExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForSubstringLiteralSearchExamples >> searchWithEmptyQuery [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLMagritteToolForSubstringLiteralSearch new
		withArguments: {
			'query' -> ''
		} asDictionary.
	
	self
		assertMissingArgument: targetObject
		withArgumentName: 'query'
		errorMessage: 'Missing argument called query'.
	
	^ targetObject
]

{ #category : #examples }
GtLMagritteToolForSubstringLiteralSearchExamples >> searchWithMatches [
	<gtExample>
	| targetObject query |
	query := 'substringLiteralSearchExampleUnique'.
	
	targetObject := self
		executeTool: GtLMagritteToolForSubstringLiteralSearch new
		withArguments: {
			'query' -> query
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLMethodsSearchResult).
	self assert: (targetObject foundMethods anySatisfy: [ :each |
		each methodSignature = 'GtLMagritteToolForSubstringLiteralSearchExamples>>#searchWithMatches' ]).
	self assert: targetObject mayHaveMore not.
	
	^ targetObject
]

{ #category : #examples }
GtLMagritteToolForSubstringLiteralSearchExamples >> searchWithMissingQuery [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLMagritteToolForSubstringLiteralSearch new
		withArguments: Dictionary new.
	
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('query')
		path: #(nil)
		errorMessage: 'required properties missing [query]'.
	
	^ targetObject
]

{ #category : #examples }
GtLMagritteToolForSubstringLiteralSearchExamples >> searchWithMoreThan200Matches [
	<gtExample>
	| targetObject query |
	query := 'gt'.
	
	targetObject := self
		executeTool: GtLMagritteToolForSubstringLiteralSearch new
		withArguments: {
			'query' -> query
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLMethodsSearchResult).
	self assert: targetObject foundMethods size equals: 200.
	self assert: targetObject mayHaveMore.
	
	^ targetObject
]

{ #category : #examples }
GtLMagritteToolForSubstringLiteralSearchExamples >> searchWithNilQuery [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLMagritteToolForSubstringLiteralSearch new
		withArguments: {
			'query' -> nil
		} asDictionary.
	
	self
		assertJSONSchemaValidationError: targetObject
		withPath: #('query')
		errorMessage: '@[query] string expected'.
	
	^ targetObject
]

{ #category : #examples }
GtLMagritteToolForSubstringLiteralSearchExamples >> searchWithNoMatches [
	<gtExample>
	| targetObject query |
	query := 'noLiteralMatchString', 'ForSearch' , '42'.
	
	targetObject := self
		executeTool: GtLMagritteToolForSubstringLiteralSearch new
		withArguments: {
			'query' -> query
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLMethodsSearchResult).
	self assert: targetObject foundMethods isEmpty.
	self assert: targetObject mayHaveMore not.
	
	^ targetObject
]
