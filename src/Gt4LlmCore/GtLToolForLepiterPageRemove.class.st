Class {
	#name : #GtLToolForLepiterPageRemove,
	#superclass : #GtLAbstractLepiterTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #magritte }
GtLToolForLepiterPageRemove >> databaseIdDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Database id';
		accessor: #databaseId;
		comment: 'The id of the database of the page, from lepiterKnowledgeBases or searchForLepiterPages.';
		beRequired
]

{ #category : #accessing }
GtLToolForLepiterPageRemove >> description [
	^ 'Removes a Lepiter page and all its snippets.

Example JSON arguments:
{"databaseId": "dklrfmltzaib6womkfkknkfap", "pageUid": "4cz39477un3tnbzdfe3lwi475"}

Example JSON response:
{"status": "removed", "databaseId": "dklrfmltzaib6womkfkknkfap", "pageUid": "4cz39477un3tnbzdfe3lwi475", "pageTitle": "New Page"}'
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
		comment: 'The id of the page (base 36), from searchForLepiterPages or createLepiterPage.';
		beRequired
]

{ #category : #private }
GtLToolForLepiterPageRemove >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	(self missingArgumentAmong: #('pageUid' 'databaseId') inArguments: arguments)
		ifNotNil: [ :aProblem | ^ aProblem ].
	^ self snippetLocator
		pageWithUid: (arguments at: 'pageUid')
		databaseId: (arguments at: 'databaseId')
		ifFound: [ :aPage | self removePage: aPage ]
		ifNone: [ :aProblem | aProblem ]
]

{ #category : #private }
GtLToolForLepiterPageRemove >> removePage: aPage [
	"Remove aPage and answer what was removed; the database is taken before, as a removed page has none"

	| databaseId |
	databaseId := GtLLepiterSnippetReference databaseIdOf: aPage database.
	[ aPage removeSelf ]
		on: Error
		do: [ :error | 
			^ GtLExceptionDomainObject new
				freeze: error;
				errorReason: 'Error while removing page' ].
	^ GtLLepiterPageRemoveDomainObject new
		status: 'removed';
		databaseId: databaseId;
		pageUid: aPage uidString;
		title: aPage title;
		page: aPage
]
