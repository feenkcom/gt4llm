Class {
	#name : #GtLToolForLepiterSnippetCreateExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLToolForLepiterSnippetCreateExamples >> missingPageUid [
	<gtExample>
	| tool call result |
	tool := GtLToolForLepiterSnippetCreate new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'snippetText' -> 'Updated text' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	self assert: result model missingArgument equals: 'pageUid'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetCreateExamples >> missingSnippetText [
	<gtExample>
	| tool call result pageUid |
	tool := GtLToolForLepiterSnippetCreate new.
	pageUid := UUID new asString.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'pageUid' -> pageUid } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	self assert: result model missingArgument equals: 'snippetText'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetCreateExamples >> successfulSnippetCreate [
	<gtExample>
	| tool call result snippet page database snippetText model |
	database := LeContentExamples new basicDatabase.
	page := database pageBuilder
		title: 'one';
		add.
	snippetText := 'New snippet text'.
	tool := GtLToolForLepiterSnippetCreate new.
	tool database: database.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'pageUid' -> page uidString.
		'snippetText' -> snippetText } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	model := result model.
	self assert: model status equals: 'created'.
	snippet := page children last.
	self assert: snippet contentAsString equals: snippetText.
	^ call
]
