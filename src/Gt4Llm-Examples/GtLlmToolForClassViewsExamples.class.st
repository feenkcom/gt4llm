Class {
	#name : #GtLlmToolForClassViewsExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-Examples'
}

{ #category : #'llm-generated' }
GtLlmToolForClassViewsExamples >> classViewsForClassWithNoViews [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForClassViews new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'className' -> 'GtLlmToolForClassViewsExamples'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'No views found'.
	^ call
]

{ #category : #'llm-generated' }
GtLlmToolForClassViewsExamples >> classViewsForExistingClass [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForClassViews new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'className' -> 'GtABAddressBook'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isEmpty not.
	self assert: (result includesSubstring: 'gtViewContactsListOn:').
	^ call
]

{ #category : #'llm-generated' }
GtLlmToolForClassViewsExamples >> classViewsForUnknownClass [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForClassViews new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'className' -> 'NonExistingClassName'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'Class not found'.
	^ call
]
