Class {
	#name : #GtLToolForLepiterPageCreate,
	#superclass : #GtLAbstractLepiterTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #private }
GtLToolForLepiterPageCreate >> createPageTitled: aTitle in: aDatabase [
	"Create the page, or refuse a title that a page of aDatabase already has"

	| page |
	page := [ aDatabase pageBuilder
			title: aTitle;
			add ]
			on: LeDuplicatePageIdError
			do: [ :anError | 
				^ GtLProblemDomainObject new
					errorMessage: 'A page titled ' , aTitle printString , ' is already in '
							, aDatabase databaseName asString , ': use it or choose another title';
					yourself ].
	^ GtLLepiterPageCreateDomainObject new
		status: 'created';
		databaseId: (GtLLepiterSnippetReference databaseIdOf: aDatabase);
		pageUid: page uidString;
		title: page title;
		page: page
]

{ #category : #magritte }
GtLToolForLepiterPageCreate >> databaseIdDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Database id';
		accessor: #databaseId;
		comment: 'The id of the database to add the page to, from lepiterKnowledgeBases.';
		beRequired
]

{ #category : #accessing }
GtLToolForLepiterPageCreate >> description [
	^ 'Creates an empty Lepiter page in the database databaseId; add snippets to it with createLepiterSnippets. The response gives its pageUid, the id that the other Lepiter tools take. A title that a page of the database already has is refused.

Example JSON arguments:
{"databaseId": "dklrfmltzaib6womkfkknkfap", "title": "New Page"}

Example JSON response:
{"status": "created", "databaseId": "dklrfmltzaib6womkfkknkfap", "pageUid": "4cz39477un3tnbzdfe3lwi475", "pageTitle": "New Page"}'
]

{ #category : #accessing }
GtLToolForLepiterPageCreate >> name [
	^ 'createLepiterPage'
]

{ #category : #private }
GtLToolForLepiterPageCreate >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments targetDatabase |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	(self missingArgumentAmong: #('title' 'databaseId') inArguments: arguments)
		ifNotNil: [ :aProblem | ^ aProblem ].
	targetDatabase := (self snippetLocator
			databasesWithId: (arguments at: 'databaseId')
			ifNone: [ :aProblem | ^ aProblem ]) first.
	^ self createPageTitled: (arguments at: 'title') in: targetDatabase
]

{ #category : #magritte }
GtLToolForLepiterPageCreate >> titleDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Title';
		accessor: #title;
		comment: 'The title of the new page.';
		beRequired
]
