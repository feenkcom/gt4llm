"
Examples for GtLMagritteToolForMethodReferences.
"
Class {
	#name : #GtLMagritteToolForMethodReferencesExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForMethodReferencesExamples >> methodReferencesForExistingSelector [
	<gtExample>
	| tool call result model |
	#someUniqueSelector printString.
	tool := GtLMagritteToolForMethodReferences new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'methodName' -> 'someUniqueSelector' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLMethodsSearchResult).
	self assert: model foundMethods isNotEmpty.
	self
		assert: (model foundMethods anySatisfy: [ :each |
			each methodSignature includesSubstring: 'GtLToolForMethodReferencesExamples>>#methodReferencesForExistingSelector' ]).
	self assert: model mayHaveMore not.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodReferencesExamples >> methodReferencesForUnknownSelector [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodReferences new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'methodName' -> 'unknownSelector42' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLMethodsSearchResult).
	self assert: model foundMethods equals: #().
	self assert: model mayHaveMore not.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodReferencesExamples >> methodReferencesForValueOnlyReturns200 [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodReferences new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'methodName' -> 'value' } asDictionary.
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
GtLMagritteToolForMethodReferencesExamples >> methodReferencesWithMissingMethodName [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForMethodReferences new.
	call := GtLFunctionToolCall new.
	call rawArguments: {} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 0.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLMissingArgumentDomainObject).
	self assert: model missingArgument equals: 'methodName'.
	self assert: model errorMessage equals: 'Missing argument called methodName'.
	^ call
]
