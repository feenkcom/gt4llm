Class {
	#name : #GtLToolForLepiterSnippetEditExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> missingPageUid [
	<gtExample>
	| tool call result model |
	tool := GtLToolForLepiterSnippetEdit new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippetUid' -> 'invalid'.
		'updatedText' -> 'Updated text' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	
	model := result model.
	self assert: (model isKindOf: GtLMissingRequiredPropertiesDomainObject).
	self assert: model missingPropertyNames equals: #('pageUid').
	self assert: model path equals: #(nil).
	
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> missingSnippetUid [
	<gtExample>
	| tool call result pageUid model|
	tool := GtLToolForLepiterSnippetEdit new.
	pageUid := UUID new asString.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'pageUid' -> pageUid.
		'updatedText' -> 'Updated text' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	
	model := result model.
	self assert: (model isKindOf: GtLMissingRequiredPropertiesDomainObject).
	self assert: model missingPropertyNames equals: #('snippetUid').
	self assert: model path equals: #(nil).
	
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> missingUpdatedText [
	<gtExample>
	| tool call result pageUid snippetUid model |
	tool := GtLToolForLepiterSnippetEdit new.
	pageUid := UUID new asString.
	snippetUid := (LeUID new uidString: (UUID new asString); uidString).
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'pageUid' -> pageUid.
		'snippetUid' -> snippetUid } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).

	model := result model.
	self assert: (model isKindOf: GtLMissingRequiredPropertiesDomainObject).
	self assert: model missingPropertyNames equals: #('updatedText').
	self assert: model path equals: #(nil).
	
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetEditExamples >> successfulSnippetEdit [
	<gtExample>
	| tool call result snippet page database updatedText model |
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
	call rawArguments: {
		'pageUid' -> page uidString.
		'snippetUid' -> snippet uidString.
		'updatedText' -> updatedText } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model status equals: 'updated'.
	self assert: model oldText equals: 'one > one'.
	self assert: snippet string equals: updatedText.
	^ call
]
