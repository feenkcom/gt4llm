Class {
	#name : #GtLlmToolForLepiterPageContentsExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-Examples'
}

{ #category : #'llm-generated' }
GtLlmToolForLepiterPageContentsExamples >> pageSerializationForExistingPage [
	<gtExample>
	| tool call result database page expected |
	tool := GtLlmToolForLepiterPageContents new.
	database := LeDatabase gtBook.
	page := database pageNamed: 'Warmup: understanding the Money classes'.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> { 'uid' -> page uidString } asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	expected := LeJsonV4 uniqueInstance serializePretty: page.
	self assert: call tool == tool.
	self assert: result equals: expected.
	^ tool
]

{ #category : #'llm-generated' }
GtLlmToolForLepiterPageContentsExamples >> pageSerializationForUnknownPage [
	<gtExample>
	| tool call result unknownUid |
	tool := GtLlmToolForLepiterPageContents new.
	unknownUid := UUID new asString36.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> { 'uid' -> unknownUid } asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'Page not found'.
	^ tool
]

{ #category : #'llm-generated' }
GtLlmToolForLepiterPageContentsExamples >> pageSerializationWithoutUid [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForLepiterPageContents new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {}} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'UID not provided'.
	^ tool
]
