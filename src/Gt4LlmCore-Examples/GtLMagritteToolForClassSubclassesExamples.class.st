"
Examples for GtLMagritteToolForClassSubclasses.
"
Class {
	#name : #GtLMagritteToolForClassSubclassesExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForClassSubclassesExamples >> classSubclassesForBlElement [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForClassSubclasses new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> 'BlElement' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model givenClassName equals: 'BlElement'.
	self assert: model subclassNames size equals: 200.
	self assert: model mayHaveMore.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassSubclassesExamples >> classSubclassesForClassWithNoSubclasses [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForClassSubclasses new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> 'GtLlmToolForClassSubclasses' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model givenClassName equals: 'GtLlmToolForClassSubclasses'.
	self assert: model subclassNames equals: #().
	self assert: model mayHaveMore not.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassSubclassesExamples >> classSubclassesForExistingClass [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForClassSubclasses new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> 'GtLAbstractPlainSchemaFunctionTool' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model givenClassName equals: 'GtLAbstractPlainSchemaFunctionTool'.
	self assert: model subclassNames isNotEmpty.
	self assert: (model subclassNames anySatisfy: [ :each | each includesSubstring: 'GtLToolForClass' ]).
	self assert: model mayHaveMore not.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassSubclassesExamples >> classSubclassesForUnknownClass [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForClassSubclasses new.
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
GtLMagritteToolForClassSubclassesExamples >> classSubclassesWithEmptyClassName [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForClassSubclasses new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> '' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model class equals: GtLMissingArgumentDomainObject.
	self assert: model missingArgument equals: 'className'.
	self assert: model errorMessage equals: 'Missing argument called className'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassSubclassesExamples >> classSubclassesWithMissingClassName [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForClassSubclasses new.
	call := GtLFunctionToolCall new.
	call rawArguments: {} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model class equals: GtLMissingRequiredPropertiesDomainObject.
	self assert: model missingPropertyNames asArray equals: #('className').
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassSubclassesExamples >> classSubclassesWithNilClassName [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForClassSubclasses new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> nil } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model class equals: GtLJSONSchemaValidationErrorDomainObject.
	self assert: model path asArray equals: #('className').
	self assert: model errorMessage equals: '@[className] string expected'.
	^ call
]
