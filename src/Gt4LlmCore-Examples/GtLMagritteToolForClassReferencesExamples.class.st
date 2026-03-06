"
Examples for GtLMagritteToolForClassReferences.
"
Class {
	#name : #GtLMagritteToolForClassReferencesExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLMagritteToolForClassReferencesExamples >> classReferencesForExistingClass [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForClassReferences new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> 'GtLToolForClassReferences' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLClassReferences).
	self assert: model givenClassName equals: 'GtLToolForClassReferences'.
	self assert: model references isNotEmpty.
	self
		assert: (model references anySatisfy: [ :each |
			each methodClassName = 'GtLToolForClassReferencesExamples' ]).
	self assert: model mayHaveMore not.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassReferencesExamples >> classReferencesForUnknownClass [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForClassReferences new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> 'NonExistingClassName' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLMissingDomainObject).
	self assert: model objectName equals: 'NonExistingClassName'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassReferencesExamples >> classReferencesWithMissingClassName [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForClassReferences new.
	call := GtLFunctionToolCall new.
	call rawArguments: {} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 0.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLMissingArgumentDomainObject).
	self assert: model missingArgument equals: 'className'.
	self assert: model errorMessage equals: 'Missing argument called className'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassReferencesExamples >> classReferencesWithMoreThan200Results [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForClassReferences new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> 'Object' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLClassReferences).
	self assert: model givenClassName equals: 'Object'.
	self assert: model references size equals: 200.
	self assert: model mayHaveMore.
	^ call
]
