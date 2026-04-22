"
Examples for GtLMagritteToolForSubstringLiteralSearch.
"
Class {
	#name : #GtLMagritteToolForSubstringLiteralSearchExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForSubstringLiteralSearchExamples >> searchWithEmptyQuery [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForSubstringLiteralSearch new
		withArguments: {
			'query' -> ''
		} asDictionary.
	self
		assertMissingArgument: call result targetObject
		withArgumentName: 'query'
		errorMessage: 'Missing argument called query'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSubstringLiteralSearchExamples >> searchWithMatches [
	<gtExample>
	| call query |
	query := 'substringLiteralSearchExampleUnique'.
	call := self
		executeTool: GtLMagritteToolForSubstringLiteralSearch new
		withArguments: {
			'query' -> query
		} asDictionary.
	self assert: (call result targetObject isKindOf: GtLMethodsSearchResult).
	self assert: (call result targetObject foundMethods anySatisfy: [ :each |
		each methodSignature = 'GtLMagritteToolForSubstringLiteralSearchExamples>>#searchWithMatches' ]).
	self assert: call result targetObject mayHaveMore not.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSubstringLiteralSearchExamples >> searchWithMissingQuery [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForSubstringLiteralSearch new
		withArguments: Dictionary new.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('query')
		path: #(nil)
		errorMessage: 'required properties missing [query]'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSubstringLiteralSearchExamples >> searchWithMoreThan200Matches [
	<gtExample>
	| call query |
	query := 'gt'.
	call := self
		executeTool: GtLMagritteToolForSubstringLiteralSearch new
		withArguments: {
			'query' -> query
		} asDictionary.
	self assert: (call result targetObject isKindOf: GtLMethodsSearchResult).
	self assert: call result targetObject foundMethods size equals: 200.
	self assert: call result targetObject mayHaveMore.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSubstringLiteralSearchExamples >> searchWithNilQuery [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForSubstringLiteralSearch new
		withArguments: {
			'query' -> nil
		} asDictionary.
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('query')
		errorMessage: '@[query] string expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSubstringLiteralSearchExamples >> searchWithNoMatches [
	<gtExample>
	| call query |
	query := 'noLiteralMatchString', 'ForSearch' , '42'.
	call := self
		executeTool: GtLMagritteToolForSubstringLiteralSearch new
		withArguments: {
			'query' -> query
		} asDictionary.
	self assert: (call result targetObject isKindOf: GtLMethodsSearchResult).
	self assert: call result targetObject foundMethods isEmpty.
	self assert: call result targetObject mayHaveMore not.
	^ call
]
