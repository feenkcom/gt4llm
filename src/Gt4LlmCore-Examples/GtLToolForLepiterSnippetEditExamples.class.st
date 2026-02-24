Class {
	#name : #GtLToolForLepiterSnippetEditExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> missingPageUid [
	<gtExample>
	| tool call result |
	tool := GtLToolForLepiterSnippetEdit new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> { 'snippetUid' -> 'invalid'. 'updatedText' -> 'Updated text' } asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self assert: result missingArgument equals: 'pageUid'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> missingSnippetUid [
	<gtExample>
	| tool call result pageUid |
	tool := GtLToolForLepiterSnippetEdit new.
	pageUid := UUID new asString.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> { 'pageUid' -> pageUid. 'updatedText' -> 'Updated text' } asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self assert: result missingArgument equals: 'snippetUid'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> missingUpdatedText [
	<gtExample>
	| tool call result pageUid snippetUid |
	tool := GtLToolForLepiterSnippetEdit new.
	pageUid := UUID new asString.
	snippetUid := (LeUID new uidString: (UUID new asString); uidString).
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> { 'pageUid' -> pageUid. 'snippetUid' -> snippetUid } asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self assert: result missingArgument equals: 'updatedText'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> successfulSnippetEdit [
	<gtExample>
	| tool call result snippet page database updatedText |
	database := LeContentExamples new basicDatabase.
	page := database pageBuilder
		title: 'one';
		add.
	snippet := page snippetBuilder
		string: 'one > one';
		add.
	updatedText := 'Updated snippet text'.
	tool := GtLToolForLepiterSnippetEdit new.
	tool database: database.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'pageUid' -> page uid asString.
			'snippetUid' -> snippet uidString.
			'updatedText' -> updatedText } asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result value at: 'status') equals: 'updated'.
	self assert: snippet string equals: updatedText.
	^ call
]
