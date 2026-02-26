Class {
	#name : #GtLToolForSearchForLepiterPagesExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForSearchForLepiterPagesExamples >> documentationLookupForExistingPage [
	<gtExample>
	| tool call result |
	tool := GtLToolForSearchForLepiterPages new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'query' -> 'Warmup: understanding the Money classes'.
			'knowledgeBases' -> { LeDatabase gtBook uuidString }
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result pages size equals: 1.
	self assert: (result serializeToOpenAIResponseJsonString includesSubstring: 'Warmup: understanding the Money classes').
	self assert: (result serializeToOpenAIResponseJsonString includesSubstring: 'uuid').
	^ call
]

{ #category : #examples }
GtLToolForSearchForLepiterPagesExamples >> documentationLookupForMissingPage [
	<gtExample>
	| tool call result |
	tool := GtLToolForSearchForLepiterPages new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments' -> {
					'query' -> 'NonExistingDocumentationPage42'.
					'knowledgeBases' -> { LeDatabase gtBook uuidString }
				} asDictionary}
				asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result pages equals: #().

	^ call
]

{ #category : #examples }
GtLToolForSearchForLepiterPagesExamples >> documentationLookupForMultipleKnowledgeBases [
	<gtExample>
	| tool call result logicalDatabase defaultDatabase |
	tool := GtLToolForSearchForLepiterPages new.
	logicalDatabase := LeDatabasesRegistry defaultLogicalDatabase.
	defaultDatabase := logicalDatabase databases
		detect: [ :each | each databaseName = 'default' ]
		ifNone: [ LeDatabase gtBook ].
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'query' -> 'Warmup: understanding the Money classes'.
			'knowledgeBases' -> {
				defaultDatabase uuidString.
				LeDatabase gtBook uuidString
			}
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result pages isNotEmpty.
	self assert: (result serializeToOpenAIResponseJsonString includesSubstring: 'Warmup: understanding the Money classes').
	^ call
]

{ #category : #examples }
GtLToolForSearchForLepiterPagesExamples >> documentationLookupForWrongKnowledgeBaseId [
	<gtExample>
	| tool call result |
	tool := GtLToolForSearchForLepiterPages new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'query' -> 'Warmup: understanding the Money classes'.
			'knowledgeBases' -> { 'missing-uuid-42' }
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self assert: (result isKindOf: GtLMissingDomainObject).
	self assert: result objectName equals: 'missing-uuid-42'.
	^ call
]
