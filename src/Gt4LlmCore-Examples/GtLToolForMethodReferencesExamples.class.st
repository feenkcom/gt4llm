Class {
	#name : #GtLToolForMethodReferencesExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'llm-generated' }
GtLToolForMethodReferencesExamples >> methodReferencesForExistingSelector [
	<gtExample>
	| tool call result |
	#someUniqueSelector printString.
	tool := GtLToolForMethodReferences new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments' -> {'selector' -> 'someUniqueSelector'} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self
		assert: (result serializeToOpenAIResponseJsonString
				includesSubstring: 'GtLToolForMethodReferencesExamples>>#methodReferencesForExistingSelector').
	^ call
]

{ #category : #'llm-generated' }
GtLToolForMethodReferencesExamples >> methodReferencesForUnknownSelector [
	<gtExample>
	| tool call result |
	tool := GtLToolForMethodReferences new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'selector' -> 'unknownSelector42'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result methods equals: #().
	^ call
]

{ #category : #'llm-generated' }
GtLToolForMethodReferencesExamples >> methodReferencesForValueOnlyReturns100 [
	<gtExample>
	| tool call result |
	tool := GtLToolForMethodReferences new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'selector' -> 'value'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result methods size equals: 100.
	self assert: result mayHaveMore.
	^ call
]
