Class {
	#name : #GtLToolForLepiterPageRemove,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#instVars : [
		'logicalDatabase'
	],
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForLepiterPageRemove >> database [
	^ logicalDatabase
]

{ #category : #accessing }
GtLToolForLepiterPageRemove >> database: aDatabase [
	logicalDatabase := aDatabase
]

{ #category : #magritte }
GtLToolForLepiterPageRemove >> databaseIdDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Database id';
		accessor: #databaseId;
		beRequired
]

{ #category : #accessing }
GtLToolForLepiterPageRemove >> description [
	^ 'Remove a Lepiter page using the database and page identifiers.

Example JSON arguments:
{
  "databaseId": "UUID",
  "pageUid": "UUID"
}

Example JSON response:
{
  "status": "removed",
  "databaseId": "UUID",
  "pageUid": "UUID",
  "title": "Page Title"
}'
]

{ #category : #initialization }
GtLToolForLepiterPageRemove >> initialize [
	super initialize.
	logicalDatabase := LeDatabasesRegistry defaultLogicalDatabase
]

{ #category : #accessing }
GtLToolForLepiterPageRemove >> name [
	^ 'removeLepiterPage'
]

{ #category : #magritte }
GtLToolForLepiterPageRemove >> pageUidDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Page uid';
		accessor: #pageUid;
		beRequired
]

{ #category : #private }
GtLToolForLepiterPageRemove >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments pageUidString databaseId baseDatabase targetDatabase pageUid page |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	pageUidString := arguments	at: 'pageUid'.
	(pageUidString trimBoth isEmpty)
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
			arguments: arguments;
			missingArgument: 'pageUid' ].
	databaseId := arguments at: 'databaseId'.
	(databaseId trimBoth isEmpty)
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
			arguments: arguments;
			missingArgument: 'databaseId' ].
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
	pageUidString := pageUidString asString trimBoth.
	pageUid := [ UUID fromString36: pageUidString ]
		on: Error
		do: [ :error |
			^ GtLExceptionDomainObject new
				freeze: error;
				errorReason: 'Invalid page uid' ].
	page := nil.
	targetDatabase
		pageWithID: pageUid
		ifPresent: [ :aPage |
			page := aPage.
			[ aPage removeSelf ]
				on: Error
				do: [ :error |
					^ GtLExceptionDomainObject new
						freeze: error;
						errorReason: 'Error while removing page' ] ]
		ifAbsent: [ ^ GtLProblemDomainObject new
			description: 'Could not locate page with id ' , pageUid asString ].
	^ GtLLepiterPageRemoveDomainObject new
		status: 'removed';
		databaseId: databaseId;
		pageUid: pageUidString;
		title: page title;
		page: page
]
