Class {
	#name : #GtLlmToolForMethodReferencesExamples,
	#superclass : #GtLlmToolExamples,
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
		'arguments' -> {'selector' -> 'gtReferences'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: result isEmpty not.
	self assert: (result includesSubstring: 'GtLlmToolForClassReferences>>#performToolCall:').
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
	self assert: result equals: 'No references found'.
	^ tool
]
