Class {
	#name : #GtLToolForLepiterSnippetEdit,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#instVars : [
		'database'
	],
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForLepiterSnippetEdit >> database [
	^ database
]

{ #category : #accessing }
GtLToolForLepiterSnippetEdit >> database: aDatabase [
	database := aDatabase
]

{ #category : #accessing }
GtLToolForLepiterSnippetEdit >> description [
	^ 'Edits a Lepiter snippet identified by page and snippet ids, updating the snippet text.'
]

{ #category : #initialization }
GtLToolForLepiterSnippetEdit >> initialize [
	super initialize.
	database := LeDatabasesRegistry defaultLogicalDatabase
]

{ #category : #accessing }
GtLToolForLepiterSnippetEdit >> name [
	^ 'editLepiterSnippet'
]

{ #category : #accessing }
GtLToolForLepiterSnippetEdit >> parametersDescription [
	^ #('pageUid' 'snippetUid' 'updatedText')
]

{ #category : #actions }
GtLToolForLepiterSnippetEdit >> privatePerformToolCall: aToolCall [
	| arguments pageUidString snippetUidString updatedText snippetUid pageUid snippets |
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
	pageUid := [ UUID fromString: pageUidString ]
			on: Error
			do: [ :error | 
				^ GtLExceptionDomainObject new
					freeze: error;
					description: 'Invalid page uid' ].
	snippetUidString := arguments
			at: 'snippetUid'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: arguments;
					missingArgument: 'snippetUid' ].
	snippetUidString := snippetUidString trimBoth.
	snippetUidString isEmpty
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
				receiverName: self name;
				arguments: arguments;
				missingArgument: 'snippetUid' ].
	snippetUid := LeUID new.
	[ snippetUid uidString: snippetUidString ]
		on: Error
		do: [ :error | 
			^ GtLExceptionDomainObject new
				freeze: error;
				description: 'Invalid snippet uid' ].
	updatedText := arguments
			at: 'updatedText'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: arguments;
					missingArgument: 'updatedText' ].
	updatedText := updatedText asString.
	updatedText isEmpty
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
				receiverName: self name;
				arguments: arguments;
				missingArgument: 'updatedText' ].
	self database
		pageWithID: pageUid
		ifPresent: [ :aPage | 
			snippets := aPage
					allChildrenSnippetsMatching: [ :aSnippet | aSnippet uid = snippetUid ].
			snippets ifEmpty: [ ^ GtLProblemDomainObject new
						description: 'Could not locate snippet with id ' , snippetUid uidString ] ]
		ifAbsent: [ ^ GtLProblemDomainObject new
				description: 'Could not locate page with id ' , pageUid asString ].
	[ snippets anyOne updateString: updatedText ]
		on: Error
		do: [ :error | 
			^ GtLExceptionDomainObject new
				freeze: error;
				description: 'Error while applying snippet change' ].
	^ GtLValueDomainObject new
		value: {'status' -> 'updated'.
				'snippetUid' -> snippetUid uidString.
				'pageUid' -> pageUid asString} asDictionary
]
