Class {
	#name : #GtLToolForLepiterPageCreate,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#instVars : [
		'logicalDatabase'
	],
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForLepiterPageCreate >> database [
	^ logicalDatabase
]

{ #category : #accessing }
GtLToolForLepiterPageCreate >> database: aDatabase [
	logicalDatabase := aDatabase
]

{ #category : #magritte }
GtLToolForLepiterPageCreate >> databaseIdDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Database id';
		accessor: #databaseId;
		beRequired
]

{ #category : #accessing }
GtLToolForLepiterPageCreate >> description [
	^ 'Create a new Lepiter page in a database with the provided title, target database id, and optional initial text.

Example JSON arguments:
{
  "title": "New Page",
  "databaseId": "UUID",
  "initialText": "First snippet"
}

Example JSON response:
{
  "status": "created",
  "pageUid": "UUID",
  "title": "New Page"
}'
]

{ #category : #magritte }
GtLToolForLepiterPageCreate >> initialTextDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Initial text';
		accessor: #initialText;
		beRequired
]

{ #category : #initialization }
GtLToolForLepiterPageCreate >> initialize [
	super initialize.
	logicalDatabase := LeDatabasesRegistry defaultLogicalDatabase
]

{ #category : #accessing }
GtLToolForLepiterPageCreate >> name [
	^ 'createLepiterPage'
]

{ #category : #private }
GtLToolForLepiterPageCreate >> privatePerformToolCall: aToolCall [
	| arguments title targetDatabase page databaseId baseDatabase initialText |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	title := arguments
		at: 'title'
		ifAbsent: [ ^ GtLMissingArgumentDomainObject new
			arguments: arguments;
			missingArgument: 'title' ].
	databaseId := arguments
		at: 'databaseId'
		ifAbsent: [ ^ GtLMissingArgumentDomainObject new
			arguments: arguments;
			missingArgument: 'databaseId' ].
	initialText := arguments
		at: 'initialText'
		ifAbsent: [ ^ GtLMissingArgumentDomainObject new
			arguments: arguments;
			missingArgument: 'initialText' ].
	baseDatabase := self database.
	targetDatabase := (baseDatabase respondsTo: #databaseWithID:ifNone:)
		ifTrue: [ baseDatabase databaseWithID: databaseId ifNone: [ nil ] ]
		ifFalse: [ (baseDatabase respondsTo: #uuid)
				ifTrue: [ baseDatabase uuid asString = databaseId
						ifTrue: [ baseDatabase ]
						ifFalse: [ nil ] ]
				ifFalse: [ nil ] ].
	targetDatabase ifNil: [ ^ GtLProblemDomainObject new
			description: 'Database with ' , databaseId asString , ' not found' ].
	page := targetDatabase pageBuilder title: title; add.
	page addSnippet: (LeTextSnippet string: initialText).
	^ GtLLepiterPageCreateDomainObject new
		status: 'created';
		databaseId: databaseId;
		pageUid: page uidString;
		title: page title;
		page: page
]

{ #category : #magritte }
GtLToolForLepiterPageCreate >> titleDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Title';
		accessor: #title;
		beRequired
]
