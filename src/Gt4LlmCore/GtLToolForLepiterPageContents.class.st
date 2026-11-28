Class {
	#name : #GtLToolForLepiterPageContents,
	#superclass : #GtLAbstractLepiterTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForLepiterPageContents >> databaseIdDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Database id';
		accessor: #databaseId;
		comment: 'Optional id of the database of the page, from lepiterKnowledgeBases or searchForLepiterPages. Needed only when the page id is in several databases: the errorMessage then lists them.';
		yourself
]

{ #category : #accessing }
GtLToolForLepiterPageContents >> description [
	^ 'Gets the contents of a Lepiter page in one format. Get only one format per page:
- markdown: the page as markdown, without snippet ids. The smallest format: use it to read a page that you will not edit.
- structure: the tree of the snippets, each with its snippetUid, its type and its own attributes (the text of a text snippet in string, the code of a code snippet in code), without the metadata that every snippet carries and without attributes that have their default value. Use it when you might edit the page: it has all the text, and the ids that createLepiterSnippets, editLepiterSnippets and removeLepiterSnippets take.
- storage: the page as Lepiter stores it on disk, with all attributes, timestamps and authors. Its ids are in the storage form and it has no databaseId. Use it only for the on-disk format or the metadata.

Example JSON arguments:
{"databaseId": "dklrfmltzaib6womkfkknkfap", "pageUid": "86t968o90hlfreacjec76wapk", "format": "structure"}

Example JSON response for structure:
{"pageTitle": "Notes", "pageUid": "86t968o90hlfreacjec76wapk", "databaseId": "dklrfmltzaib6womkfkknkfap", "snippets": [{"snippetUid": "SgJekENeTPytZjVknCfulw==", "type": "textSnippet", "string": "Some text", "children": [{"snippetUid": "bb49pqTrTh+k1tAEnG4H4Q==", "type": "pharoSnippet", "code": "1 + 2"}]}]}

Example JSON response for markdown:
{"pageTitle": "Notes", "pageUid": "86t968o90hlfreacjec76wapk", "databaseId": "dklrfmltzaib6womkfkknkfap", "markdown": "Some text\n\n```pharo\n1 + 2\n```"}'
]

{ #category : #'accessing - descriptions' }
GtLToolForLepiterPageContents >> formatDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Format';
		accessor: #format;
		comment: 'markdown to only read the page, structure when you might edit it, storage for the LeJsonV4 stored on disk with its metadata.';
		propertyAt: 'enum' put: GtLLepiterPageContent formatNames;
		beRequired
]

{ #category : #accessing }
GtLToolForLepiterPageContents >> name [
	^ 'getLepiterPageContents'
]

{ #category : #accessing }
GtLToolForLepiterPageContents >> pageUidDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Page uid';
		accessor: #pageUid;
		comment: 'The id of the page (base 36), from searchForLepiterPages or createLepiterPage.';
		beRequired
]

{ #category : #private }
GtLToolForLepiterPageContents >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments contentClass |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	(self missingArgumentAmong: #('pageUid') inArguments: arguments)
		ifNotNil: [ :aProblem | ^ aProblem ].
	contentClass := GtLLepiterPageContent
			forFormat: (arguments at: 'format' ifAbsent: [ nil ])
			ifUnknown: [ :aProblem | ^ aProblem ].
	^ self snippetLocator
		pageWithUid: (arguments at: 'pageUid')
		databaseId: (arguments at: 'databaseId' ifAbsent: [ nil ])
		ifFound: [ :aPage | contentClass page: aPage ]
		ifNone: [ :aProblem | aProblem ]
]
