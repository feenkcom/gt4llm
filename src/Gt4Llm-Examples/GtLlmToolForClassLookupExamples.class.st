Class {
	#name : #GtLlmToolForClassLookupExamples,
	#superclass : #GtLlmToolExamples,
	#category : #'Gt4Llm-Examples'
}

{ #category : #'llm-generated' }
GtLlmToolForClassLookupExamples >> lookupClassForExistingClass [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForClassLookup new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'className' -> 'GtLlmToolForClassLookup'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: (result = '{"class":"GtLlmToolForClassLookup","package":"Gt4Llm-GToolkit","comment":"","superclass":"GtLlmAbstractFunctionTool","instanceSlots":[],"allInstanceMethods":["parameters","name","performToolCall:","acceptVisitor:","description"]}').
	^ tool
]

{ #category : #'llm-generated' }
GtLlmToolForClassLookupExamples >> lookupClassForUnknownClass [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForClassLookup new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'className' -> 'NonExistingClassName42'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: result equals: 'Class not found'.
	^ tool
]
