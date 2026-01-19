Class {
	#name : #GtLToolForClassSearchExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'llm-generated' }
GtLToolForClassSearchExamples >> searchClassesWithMatches [
	<gtExample>
	| tool call result |
	tool := GtLToolForClassSearch new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'query' -> 'GtLToolForClass'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result includesSubstring: 'GtLToolForClassReferences').
	self assert: (result includesSubstring: 'GtLToolForClassSearch').
	^ tool
]

{ #category : #'llm-generated' }
GtLToolForClassSearchExamples >> searchClassesWithNoMatches [
	<gtExample>
	| tool call result |
	tool := GtLToolForClassSearch new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments' -> {'query' -> 'ClassNameThatDoesNotExist42'} asDictionary}
				asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result foundClasses equals: #().
	^ call
]
