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
	^ 'Creates a new Lepiter text snippet for a page identified by its page id.'
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
	| arguments pageUidString snippetText pageUid snippet |
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
	self database
		pageWithID: pageUid
		ifPresent: [ :page |
			[ snippet := LeTextSnippet string: snippetText.
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

{ #category : #magritte }
GtLToolForLepiterSnippetCreate >> snippetTextDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Snippet text';
		accessor: #snippetText;
		beRequired
]
