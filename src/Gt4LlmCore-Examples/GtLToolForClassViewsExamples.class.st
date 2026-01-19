Class {
	#name : #GtLToolForClassViewsExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'llm-generated' }
GtLToolForClassViewsExamples >> classViewsForClassWithNoViews [
	<gtExample>
	| tool call result |
	tool := GtLToolForClassViews new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'className' -> 'GtLToolForClassViewsExamples'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result targetClass equals: GtLToolForClassViewsExamples.
	self assert: result methods equals: #().
	^ call
]

{ #category : #'llm-generated' }
GtLToolForClassViewsExamples >> classViewsForExistingClass [
	<gtExample>
	| tool call result |
	tool := GtLToolForClassViews new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'className' -> 'GtABAddressBook'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: (result serializeToOpenAIResponseJsonString includesSubstring: 'gtViewContactsListOn:').
	^ call
]

{ #category : #'llm-generated' }
GtLToolForClassViewsExamples >> classViewsForUnknownClass [
	<gtExample>
	| tool call result |
	tool := GtLToolForClassViews new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'className' -> 'NonExistingClassName'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self assert: result objectName equals: 'NonExistingClassName'.
	^ call
]
