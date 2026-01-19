Class {
	#name : #GtLToolForLepiterPageContentsExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'llm-generated' }
GtLToolForLepiterPageContentsExamples >> pageSerializationForExistingPage [
	<gtExample>
	| tool call result database page expected |
	tool := GtLToolForLepiterPageContents new.
	database := LeDatabase gtBook.
	page := database pageNamed: 'Warmup: understanding the Money classes'.
	call := GtLFunctionToolCall new.
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
GtLToolForLepiterPageContentsExamples >> pageSerializationForUnknownPage [
	<gtExample>
	| tool call result unknownUid |
	tool := GtLToolForLepiterPageContents new.
	unknownUid := UUID new asString36.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments' -> {'uid' -> unknownUid} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self assert: result objectName equals: unknownUid.
	^ call
]

{ #category : #'llm-generated' }
GtLToolForLepiterPageContentsExamples >> pageSerializationWithoutUid [
	<gtExample>
	| tool call result |
	tool := GtLToolForLepiterPageContents new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {}} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'UID not provided'.
	^ tool
]
