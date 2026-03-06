"
Examples for GtLMagritteToolForClassSearch.
"
Class {
	#name : #GtLMagritteToolForClassSearchExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLMagritteToolForClassSearchExamples >> searchClassesWithMatches [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForClassSearch new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'query' -> 'GtLToolForClass' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model foundClassNames isNotEmpty.
	self assert: (model foundClassNames anySatisfy: [ :each | each includesSubstring: 'GtLToolForClassSearch' ]).
	self assert: model mayHaveMore not.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassSearchExamples >> searchClassesWithMissingQuery [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForClassSearch new.
	call := GtLFunctionToolCall new.
	call rawArguments: {} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 0.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLMissingArgumentDomainObject).
	self assert: model missingArgument equals: 'query'.
	self assert: model errorMessage equals: 'Missing argument called query'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassSearchExamples >> searchClassesWithMoreThan200Matches [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForClassSearch new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'query' -> 'Object' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model foundClassNames size equals: 200.
	self assert: model mayHaveMore.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassSearchExamples >> searchClassesWithNoMatches [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForClassSearch new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'query' -> 'ClassNameThatDoesNotExist42' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model foundClassNames equals: #().
	^ call
]
