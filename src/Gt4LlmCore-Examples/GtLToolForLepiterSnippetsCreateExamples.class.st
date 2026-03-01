Class {
	#name : #GtLToolForLepiterSnippetsCreateExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> missingSnippetPageUid [
	<gtExample>
	| tool call result model |
	tool := GtLToolForLepiterSnippetsCreate new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'snippetText' put: 'Updated text';
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	model := result model.
	self assert: model snippets first missingArgument equals: 'pageUid'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> missingSnippetText [
	<gtExample>
	| tool call result model |
	tool := GtLToolForLepiterSnippetsCreate new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'pageUid' put: UUID new asString;
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	model := result model.
	self assert: model snippets first missingArgument equals: 'snippetText'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> missingSnippets [
	<gtExample>
	| tool call result |
	tool := GtLToolForLepiterSnippetsCreate new.
	call := GtLFunctionToolCall new.
	call rawArguments: {} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	self assert: result model missingArgument equals: 'snippets'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> successfulPharoSnippetCreate [
	<gtExample>
	| tool call result snippet page database snippetText model |
	database := LeContentExamples new basicDatabase.
	page := database pageBuilder
		title: 'one';
		add.
	snippetText := 'Transcript show: 1'.
	tool := GtLToolForLepiterSnippetsCreate new.
	tool database: database.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'pageUid' put: page uidString;
				at: 'snippetText' put: snippetText;
				at: 'snippetType' put: 'pharo';
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	model := result model.
	self assert: model snippets size equals: 1.
	snippet := page children last.
	self assert: (snippet isKindOf: LePharoSnippet).
	self assert: snippet contentAsString equals: snippetText.
	self assert: model snippets first status equals: 'created'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> successfulPythonSnippetCreate [
	<gtExample>
	| tool call result snippet page database snippetText model |
	database := LeContentExamples new basicDatabase.
	page := database pageBuilder
		title: 'one';
		add.
	snippetText := 'print(1)'.
	tool := GtLToolForLepiterSnippetsCreate new.
	tool database: database.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'pageUid' put: page uidString;
				at: 'snippetText' put: snippetText;
				at: 'snippetType' put: 'python';
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	model := result model.
	self assert: model snippets size equals: 1.
	snippet := page children last.
	self assert: (snippet isKindOf: LePythonSnippet).
	self assert: snippet contentAsString equals: snippetText.
	self assert: model snippets first status equals: 'created'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> successfulShellSnippetCreate [
	<gtExample>
	| tool call result snippet page database snippetText model |
	database := LeContentExamples new basicDatabase.
	page := database pageBuilder
		title: 'one';
		add.
	snippetText := 'echo "Hello"'.
	tool := GtLToolForLepiterSnippetsCreate new.
	tool database: database.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'pageUid' put: page uidString;
				at: 'snippetText' put: snippetText;
				at: 'snippetType' put: 'shell';
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	model := result model.
	self assert: model snippets size equals: 1.
	snippet := page children last.
	self assert: (snippet isKindOf: LeShellScriptSnippet).
	self assert: snippet contentAsString equals: snippetText.
	self assert: model snippets first status equals: 'created'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> successfulSnippetCreate [
	<gtExample>
	| tool call result snippet page database snippetText model |
	database := LeContentExamples new basicDatabase.
	page := database pageBuilder
		title: 'one';
		add.
	snippetText := 'New snippet text'.
	tool := GtLToolForLepiterSnippetsCreate new.
	tool database: database.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'pageUid' put: page uidString;
				at: 'snippetText' put: snippetText;
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	model := result model.
	self assert: model snippets size equals: 1.
	snippet := page children last.
	self assert: snippet contentAsString equals: snippetText.
	self assert: model snippets first status equals: 'created'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> successfulSnippetsCreateMultiple [
	<gtExample>
	| tool call result pageOne pageTwo database snippetOne snippetTwo model snippets |
	database := LeContentExamples new basicDatabase.
	pageOne := database pageBuilder
		title: 'one';
		add.
	pageTwo := database pageBuilder
		title: 'two';
		add.
	snippetOne := 'Notes'.
	snippetTwo := 'print(2)'.
	tool := GtLToolForLepiterSnippetsCreate new.
	tool database: database.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'pageUid' put: pageOne uidString;
				at: 'snippetText' put: snippetOne;
				at: 'snippetType' put: 'text';
				yourself.
			Dictionary new
				at: 'pageUid' put: pageTwo uidString;
				at: 'snippetText' put: snippetTwo;
				at: 'snippetType' put: 'python';
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	model := result model.
	self assert: model snippets size equals: 2.
	snippets := { pageOne children last. pageTwo children last }.
	self assert: (snippets first isKindOf: LeTextSnippet).
	self assert: (snippets second isKindOf: LePythonSnippet).
	self assert: snippets first contentAsString equals: snippetOne.
	self assert: snippets second contentAsString equals: snippetTwo.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsCreateExamples >> successfulTextSnippetCreate [
	<gtExample>
	| tool call result snippet page database snippetText model |
	database := LeContentExamples new basicDatabase.
	page := database pageBuilder
		title: 'one';
		add.
	snippetText := 'New snippet text'.
	tool := GtLToolForLepiterSnippetsCreate new.
	tool database: database.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'snippets' -> {
			Dictionary new
				at: 'pageUid' put: page uidString;
				at: 'snippetText' put: snippetText;
				at: 'snippetType' put: 'text';
				yourself } } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	model := result model.
	self assert: model snippets size equals: 1.
	snippet := page children last.
	self assert: (snippet isKindOf: LeTextSnippet).
	self assert: snippet contentAsString equals: snippetText.
	self assert: model snippets first status equals: 'created'.
	^ call
]
