"
I name a Lepiter snippet by its database, page and snippet ids, in the forms the Lepiter tools take:
- `databaseId`: `database uuidString` (base 36), or nil for an in-memory database, which has no id;
- `pageUid`: `page uidString` (base 36);
- `snippetUid`: `snippet uid uidString`.

I never hold the snippet. {{gtMethod:GtLLepiterSnippetReference>>#snippetIfPresent:ifMissing:}} resolves me in the logical database, and {{gtMethod:GtLLepiterSnippetReference>>#snippetIn:ifPresent:ifMissing:}} in a given database, through {{gtClass:GtLLepiterSnippetLocator}}, which refuses ambiguous ids.

Build me from a live snippet with {{gtMethod:GtLLepiterSnippetReference class>>#fromSnippet:}}.
"
Class {
	#name : #GtLLepiterSnippetReference,
	#superclass : #Object,
	#instVars : [
		'databaseId',
		'pageUid',
		'snippetUid'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLLepiterSnippetReference class >> databaseIdOf: aDatabaseOrNil [
	"Return the id of a database in the form the tools take, or nil for an in-memory database, which has no id (uuidString fails without a monitor)"

	aDatabaseOrNil ifNil: [ ^ nil ].
	(aDatabaseOrNil isKindOf: LeDatabase) ifFalse: [ ^ nil ].
	aDatabaseOrNil uuid = UUID nilUUID ifTrue: [ ^ nil ].
	^ aDatabaseOrNil uuidString
]

{ #category : #accessing }
GtLLepiterSnippetReference class >> databaseNameOf: aDatabaseOrNil [
	aDatabaseOrNil ifNil: [ ^ nil ].
	(aDatabaseOrNil isKindOf: LeDatabase) ifFalse: [ ^ nil ].
	^ aDatabaseOrNil databaseName
]

{ #category : #'instance creation' }
GtLLepiterSnippetReference class >> fromSnippet: aSnippet [
	"Name aSnippet, which must be in a page"

	| aPage |
	aPage := aSnippet page.
	^ self new
		databaseId: (aPage ifNotNil: [ self databaseIdOf: aPage database ]);
		pageUid: (aPage ifNotNil: [ aPage uidString ]);
		snippetUid: aSnippet uid uidString;
		yourself
]

{ #category : #comparing }
GtLLepiterSnippetReference >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ self databaseId = anObject databaseId
		and: [ self pageUid = anObject pageUid and: [ self snippetUid = anObject snippetUid ] ]
]

{ #category : #accessing }
GtLLepiterSnippetReference >> databaseId [
	^ databaseId
]

{ #category : #accessing }
GtLLepiterSnippetReference >> databaseId: aStringOrNil [
	databaseId := aStringOrNil
]

{ #category : #magritte }
GtLLepiterSnippetReference >> databaseIdDescription [
	"An in-memory database has no id: the key is then left out"

	<magritteDescription>
	self databaseId ifNil: [ ^ nil ].
	^ MAStringDescription new
		label: 'Database id';
		accessor: #databaseId;
		comment: 'The id of the Lepiter database (base 36), as lepiterKnowledgeBases lists it.';
		yourself
]

{ #category : #resolving }
GtLLepiterSnippetReference >> existsInLepiter [
	^ self snippetIfPresent: [ :aSnippet | true ] ifMissing: [ :anError | false ]
]

{ #category : #views }
GtLLepiterSnippetReference >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 10;
		items: [ {'Database id' -> self databaseId.
				'Page uid' -> self pageUid.
				'Snippet uid' -> self snippetUid.
				'Current snippet'
					-> (self
							snippetIfPresent: [ :aSnippet | aSnippet ]
							ifMissing: [ :anError | anError ])} ];
		column: 'Property'
			text: [ :each | each key ]
			width: 150;
		column: 'Value' text: [ :each | each value ifNil: [ '' ] ];
		send: [ :each | each value ]
]

{ #category : #views }
GtLLepiterSnippetReference >> gtLiveSnippetFor: aView [
	"The snippet as it is now, editable. Empty when I do not resolve: the snippet was removed, or its ids became ambiguous"

	<gtView>
	self existsInLepiter ifFalse: [ ^ aView empty ].
	^ aView forward
		title: 'Live snippet';
		priority: 15;
		object: [ self
				snippetIfPresent: [ :aSnippet | aSnippet ]
				ifMissing: [ :aProblem | aProblem ] ];
		view: #gtLiveFor:
]

{ #category : #comparing }
GtLLepiterSnippetReference >> hash [
	^ (self databaseId hash bitXor: self pageUid hash) bitXor: self snippetUid hash
]

{ #category : #'llm views' }
GtLLepiterSnippetReference >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	^ aDataView magritteObject: [ self ]
]

{ #category : #accessing }
GtLLepiterSnippetReference >> pageUid [
	^ pageUid
]

{ #category : #accessing }
GtLLepiterSnippetReference >> pageUid: aString [
	pageUid := aString
]

{ #category : #magritte }
GtLLepiterSnippetReference >> pageUidDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Page uid';
		accessor: #pageUid;
		comment: 'The id of the page (base 36), as getLepiterPageContents takes it.';
		beRequired
]

{ #category : #printing }
GtLLepiterSnippetReference >> printOn: aStream [
	super printOn: aStream.
	aStream
		parenthesize: [ aStream
				nextPutAll: (self databaseId ifNil: [ 'no database id' ]);
				nextPutAll: ' / ';
				nextPutAll: (self pageUid ifNil: [ '' ]);
				nextPutAll: ' / ';
				nextPutAll: (self snippetUid ifNil: [ '' ]) ]
]

{ #category : #resolving }
GtLLepiterSnippetReference >> snippetIfPresent: aPresentBlock ifMissing: aMissingBlock [
	"Resolve me in the logical database. aMissingBlock gets an error domain object saying why I am not resolved"

	^ self
		snippetIn: LeDatabasesRegistry defaultLogicalDatabase
		ifPresent: aPresentBlock
		ifMissing: aMissingBlock
]

{ #category : #resolving }
GtLLepiterSnippetReference >> snippetIn: aDatabase ifPresent: aPresentBlock ifMissing: aMissingBlock [
	"Resolve me in aDatabase, a logical database or a single database. aMissingBlock gets an error domain object saying why I am not resolved (not found, or ambiguous)"

	^ (GtLLepiterSnippetLocator database: aDatabase)
		snippetWithUid: self snippetUid
		pageUid: self pageUid
		databaseId: self databaseId
		ifFound: aPresentBlock
		ifNone: aMissingBlock
]

{ #category : #accessing }
GtLLepiterSnippetReference >> snippetUid [
	^ snippetUid
]

{ #category : #accessing }
GtLLepiterSnippetReference >> snippetUid: aString [
	snippetUid := aString
]

{ #category : #magritte }
GtLLepiterSnippetReference >> snippetUidDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Snippet uid';
		accessor: #snippetUid;
		comment: 'The uid of the snippet, as editLepiterSnippets takes it.';
		beRequired
]
