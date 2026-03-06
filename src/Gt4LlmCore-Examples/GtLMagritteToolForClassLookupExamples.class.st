"
Examples for GtLMagritteToolForClassLookup.
"
Class {
	#name : #GtLMagritteToolForClassLookupExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLMagritteToolForClassLookupExamples >> lookupClassMissingArgument [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForClassLookup new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLMissingArgumentDomainObject).
	self assert: model missingArgument equals: 'className'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassLookupExamples >> lookupClassSuccessful [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForClassLookup new.
	call := GtLFunctionToolCall new.
	call rawArguments: {'className' -> GtLMagritteToolForClassLookup name} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model currentClassName equals: GtLMagritteToolForClassLookup name.
	self assert: model packageName equals: 'Gt4LlmCore'.
	self assert: model instanceSlotNames isEmpty.
	self assert: model classSlotNames isEmpty.
	self assert: model allInstanceMethodNames notEmpty.
	self assert: (model allClassMethodNames isKindOf: Collection).
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassLookupExamples >> lookupClassUnknown [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForClassLookup new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> 'NonExistingClassName42' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLMissingDomainObject).
	self assert: model objectName equals: 'NonExistingClassName42'.
	^ call
]
