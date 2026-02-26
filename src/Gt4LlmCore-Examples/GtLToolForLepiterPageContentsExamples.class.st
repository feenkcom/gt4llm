Class {
	#name : #GtLToolForLepiterPageContentsExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForLepiterPageContentsExamples >> pageSerializationForExistingPage [
	<gtExample>
	| tool call result database page expected |
	tool := GtLToolForLepiterPageContents new.
	database := LeDatabase gtBook.
	page := database pageNamed: 'Warmup: understanding the Money classes'.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'uid' -> page uidString.
			'knowledgeBase' -> database uuidString
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	expected := LeJsonV4 uniqueInstance serializePretty: page.
	self assert: call tool == tool.
	self assert: result serializeToOpenAIResponseJsonObject equals: expected.
	^ tool
]

{ #category : #examples }
GtLToolForLepiterPageContentsExamples >> pageSerializationForMissingKnowledgeBase [
	<gtExample>
	| tool call result |
	tool := GtLToolForLepiterPageContents new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments' -> {
					'uid' -> UUID new asString36.
					'knowledgeBase' -> 'missing-uuid-42'
				} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self assert: (result isKindOf: GtLMissingDomainObject).
	self assert: result objectName isNotNil.
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageContentsExamples >> pageSerializationForUnknownPage [
	<gtExample>
	| tool call result unknownUid database |
	tool := GtLToolForLepiterPageContents new.
	database := LeDatabase gtBook.
	unknownUid := UUID new asString36.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments' -> {
					'uid' -> unknownUid.
					'knowledgeBase' -> database uuidString
				} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self assert: result objectName equals: unknownUid.
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageContentsExamples >> pageSerializationWithoutKnowledgeBase [
	<gtExample>
	| tool call result |
	tool := GtLToolForLepiterPageContents new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments' -> {
					'uid' -> UUID new asString36
				} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self assert: result missingArgument equals: 'knowledgeBase'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageContentsExamples >> pageSerializationWithoutUid [
	<gtExample>
	| tool call result |
	tool := GtLToolForLepiterPageContents new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments' -> Dictionary new} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self assert: result missingArgument equals: 'uid'.
	^ call
]
