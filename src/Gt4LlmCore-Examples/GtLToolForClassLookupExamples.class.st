Class {
	#name : #GtLToolForClassLookupExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #'llm-generated' }
GtLToolForClassLookupExamples >> lookupClassForExistingClass [
	<gtExample>
	| tool call result |
	tool := GtLToolForClassLookup new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'className' -> GtLToolForClassLookup name} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: (result serializeToLlmJsonString includesSubstring: '"class":"GtLToolForClassLookup"').
	self assert: (result serializeToLlmJsonString includesSubstring: '"package":"Gt4LlmCore"').
	self assert: (result serializeToLlmJsonString includesSubstring: '"classSlots":[]').
	self assert: (result serializeToLlmJsonString includesSubstring: '"instanceSlots":[]').
	self assert: (result serializeToLlmJsonString includesSubstring: '"allInstanceMethods"').
	self assert: (result serializeToLlmJsonString includesSubstring: '"allClassMethods"').

	^ call
]

{ #category : #'llm-generated' }
GtLToolForClassLookupExamples >> lookupClassForUnknownClass [
	<gtExample>
	| tool call result |
	tool := GtLToolForClassLookup new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments' -> {'className' -> 'NonExistingClassName42'} asDictionary}
				asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self assert: result objectName equals: 'NonExistingClassName42'.
	^ call
]
