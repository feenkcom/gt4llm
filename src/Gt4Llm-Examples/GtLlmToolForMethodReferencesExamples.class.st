Class {
	#name : #GtLlmToolForMethodReferencesExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-Examples'
}

{ #category : #'llm-generated' }
GtLlmToolForMethodReferencesExamples >> methodReferencesForExistingSelector [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForMethodReferences new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'selector' -> 'methodReferencesForExistingSelector'} asDictionary
	} asDictionary.
	#methodReferencesForExistingSelector printString.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isEmpty not.
	self assert: (result includesSubstring: 'GtLlmToolForMethodReferencesExamples>>#methodReferencesForExistingSelector').
	^ tool
]

{ #category : #'llm-generated' }
GtLlmToolForMethodReferencesExamples >> methodReferencesForUnknownSelector [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForMethodReferences new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'selector' -> 'unknownSelector42'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'No references found'.
	^ tool
]

{ #category : #'llm-generated' }
GtLlmToolForMethodReferencesExamples >> methodReferencesForValueOnlyReturns100 [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForMethodReferences new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'selector' -> 'value'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isEmpty not.
	self assert: result lines size equals: 100.
	^ call
]
