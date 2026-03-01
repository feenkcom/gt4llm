Class {
	#name : #GtLToolForLepiterSnippetCreate,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#instVars : [
		'database'
	],
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLToolForLepiterSnippetCreate >> database [
	^ database
]

{ #category : #accessing }
GtLToolForLepiterSnippetCreate >> database: aDatabase [
	database := aDatabase
]

{ #category : #accessing }
GtLToolForLepiterSnippetCreate >> description [
	^ 'Creates a new Lepiter snippet for a page identified by its page id.

Example JSON arguments:
{
  "pageUid": "UUID",
  "snippetText": "Transcript show: 1",
  "snippetType": "pharo"
}

Supported snippet types are: text, pharo, python, shell.

Example JSON response:
{
  "status": "created",
  "pageUid": "UUID",
  "snippetUid": "UUID"
}'
]

{ #category : #initialization }
GtLToolForLepiterSnippetCreate >> initialize [
	super initialize.
	database := LeDatabasesRegistry defaultLogicalDatabase
]

{ #category : #accessing }
GtLToolForLepiterSnippetCreate >> name [
	^ 'createLepiterSnippet'
]

{ #category : #magritte }
GtLToolForLepiterSnippetCreate >> pageUidDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Page uid';
		accessor: #pageUid;
		beRequired
]

{ #category : #private }
GtLToolForLepiterSnippetCreate >> privatePerformToolCall: aToolCall [
	| arguments pageUidString snippetText pageUid snippet snippetType snippetClass |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	pageUidString := arguments
		at: 'pageUid'
		ifAbsent: [ ^ GtLMissingArgumentDomainObject new
			receiverName: self name;
			arguments: arguments;
			missingArgument: 'pageUid' ].
	pageUidString := pageUidString trimBoth.
	pageUidString isEmpty
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
			receiverName: self name;
			arguments: arguments;
			missingArgument: 'pageUid' ].
	pageUid := [ UUID fromString36: pageUidString ]
		on: Error
		do: [ :error |
			^ GtLExceptionDomainObject new
				freeze: error;
				description: 'Invalid page uid' ].
	snippetText := arguments
		at: 'snippetText'
		ifAbsent: [ ^ GtLMissingArgumentDomainObject new
			receiverName: self name;
			arguments: arguments;
			missingArgument: 'snippetText' ].
	snippetText := snippetText asString.
	snippetText isEmpty
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
			receiverName: self name;
			arguments: arguments;
			missingArgument: 'snippetText' ].
	snippetType := arguments at: 'snippetType' ifAbsent: [ 'text' ].
	snippetType := snippetType asString trimBoth.
	snippetType isEmpty ifTrue: [ snippetType := 'text' ].
	snippetClass := {
		'text' -> LeTextSnippet.
		'pharo' -> LePharoSnippet.
		'python' -> LePythonSnippet.
		'shell' -> LeShellScriptSnippet } asDictionary
			at: snippetType
			ifAbsent: [ nil ].
	snippetClass ifNil: [ ^ GtLProblemDomainObject new
			description: 'Unknown snippet type ' , snippetType ].
	self database
		pageWithID: pageUid
		ifPresent: [ :page |
			[ snippet := snippetClass = LeTextSnippet
				ifTrue: [ LeTextSnippet string: snippetText ]
				ifFalse: [ snippetClass code: snippetText ].
			page addSnippet: snippet ]
				on: Error
				do: [ :error |
					^ GtLExceptionDomainObject new
						freeze: error;
						description: 'Error while creating snippet' ] ]
		ifAbsent: [ ^ GtLProblemDomainObject new
			description: 'Could not locate page with id ' , pageUid asString ].
	^ GtLLepiterSnippetDomainObject new
		status: 'created';
		pageUid: pageUid asString;
		snippetUid: snippet uidString;
		snippet: snippet
]

{ #category : #accessing }
GtLToolForLepiterSnippetCreate >> snippetTextDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Snippet text';
		comment: 'Textual content of the snippet.';
		accessor: #snippetText;
		beRequired
]

{ #category : #accessing }
GtLToolForLepiterSnippetCreate >> snippetTypeDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Snippet type';
		comment: 'One of text, pharo, python, shell. Defaults to text.';
		accessor: #snippetType
]
