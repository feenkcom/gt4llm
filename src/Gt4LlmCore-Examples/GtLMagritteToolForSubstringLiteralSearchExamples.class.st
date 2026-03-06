"
Examples for GtLMagritteToolForSubstringLiteralSearch.
"
Class {
	#name : #GtLMagritteToolForSubstringLiteralSearchExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForSubstringLiteralSearchExamples >> searchWithEmptyQuery [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForSubstringLiteralSearch new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'query' -> '' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: (model isKindOf: GtLMissingArgumentDomainObject).
	self assert: model missingArgument equals: 'query'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSubstringLiteralSearchExamples >> searchWithMatches [
	<gtExample>
	| tool call result model query |
	query := 'substringLiteralSearchExampleUnique'.
	tool := GtLMagritteToolForSubstringLiteralSearch new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'query' -> query } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLMethodsSearchResult).
	self
		assert: (model foundMethods anySatisfy: [ :each |
			each methodSignature = 'GtLToolForSubstringLiteralSearchExamples>>#searchWithMatches' ]).
	self assert: model mayHaveMore not.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSubstringLiteralSearchExamples >> searchWithMissingQuery [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForSubstringLiteralSearch new.
	call := GtLFunctionToolCall new.
	call rawArguments: {} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 0.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: (model isKindOf: GtLMissingRequiredPropertiesDomainObject).
	self assert: model missingPropertyNames asArray equals: #('query').
	^ call
]

{ #category : #examples }
GtLMagritteToolForSubstringLiteralSearchExamples >> searchWithMoreThan200Matches [
	<gtExample>
	| tool call result model query |
	query := 'gt'.
	tool := GtLMagritteToolForSubstringLiteralSearch new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'query' -> query } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLMethodsSearchResult).
	self assert: model foundMethods size equals: 200.
	self assert: model mayHaveMore.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSubstringLiteralSearchExamples >> searchWithNilQuery [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForSubstringLiteralSearch new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'query' -> nil } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: (model isKindOf: GtLJSONSchemaValidationErrorDomainObject).
	self assert: model path asArray equals: #('query').
	self assert: model errorMessage equals: '@[query] string expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForSubstringLiteralSearchExamples >> searchWithNoMatches [
	<gtExample>
	| tool call result model query |
	query := 'noLiteralMatchString', 'ForSearch' , '42'.
	tool := GtLMagritteToolForSubstringLiteralSearch new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'query' -> query } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLMethodsSearchResult).
	self assert: model foundMethods isEmpty.
	self assert: model mayHaveMore not.
	^ call
]
