Class {
	#name : #GtLToolForMethodReferencesExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'llm-generated' }
GtLToolForMethodReferencesExamples >> methodReferencesForExistingSelector [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForMethodReferences new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'selector' -> 'performToolCall:'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isEmpty not.
	self assert: (result includesSubstring: 'GtLToolForMethodReferencesExamples>>#methodReferencesForExistingSelector').
	^ tool
]

{ #category : #'llm-generated' }
GtLToolForMethodReferencesExamples >> methodReferencesForUnknownSelector [
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
GtLToolForMethodReferencesExamples >> methodReferencesForValueOnlyReturns100 [
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
