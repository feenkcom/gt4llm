Class {
	#name : #GtLlmToolForClassSubclassesExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-Examples'
}

{ #category : #'llm-generated' }
GtLlmToolForClassSubclassesExamples >> classSubclassesForClassWithNoSubclasses [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForClassSubclasses new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'className' -> 'GtLlmToolForClassSubclasses'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'No subclasses found'.
	^ tool
]

{ #category : #'llm-generated' }
GtLlmToolForClassSubclassesExamples >> classSubclassesForExistingClass [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForClassSubclasses new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'className' -> 'GtLlmAbstractFunctionTool'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isEmpty not.
	self assert: (result includesSubstring: 'GtLlmToolForClassReferences').
	^ tool
]

{ #category : #'llm-generated' }
GtLlmToolForClassSubclassesExamples >> classSubclassesForUnknownClass [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForClassSubclasses new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'className' -> 'NonExistingClassName'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'Class not found'.
	^ tool
]
