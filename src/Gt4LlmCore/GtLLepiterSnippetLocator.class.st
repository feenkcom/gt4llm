"
I resolve the pages and snippets named by the Lepiter snippet tools, in a logical database (all its databases) or in a single database.

I never act on a guess. I refuse, with an error domain object whose errorMessage says what to do:
- an invalid id, or a database, page or snippet that is not found;
- a page id (or a page and snippet id pair) that matches in more than one database: the optional `databaseId` tells them apart;
- a snippet id present twice in one page.

When a `databaseId` is given I look only in that database.
"
Class {
	#name : #GtLLepiterSnippetLocator,
	#superclass : #Object,
	#instVars : [
		'database'
	],
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #'instance creation' }
GtLLepiterSnippetLocator class >> database: aDatabase [
	"aDatabase is a logical database (all its databases are searched) or a single database"

	^ self new
		database: aDatabase;
		yourself
]

{ #category : #accessing }
GtLLepiterSnippetLocator >> database [
	^ database
]

{ #category : #accessing }
GtLLepiterSnippetLocator >> database: aDatabase [
	database := aDatabase
]

{ #category : #accessing }
GtLLepiterSnippetLocator >> databases [
	"Return the databases I search: those of a logical database, or the single database I was given"

	database ifNil: [ ^ #() ].
	^ (database respondsTo: #databases)
		ifTrue: [ database databases ]
		ifFalse: [ {database} ]
]

{ #category : #resolving }
GtLLepiterSnippetLocator >> databasesWithId: aDatabaseIdOrNil ifNone: aNoneBlock [
	"Return the databases to search: all of them without an id, else the one with that id"

	| anId found |
	anId := aDatabaseIdOrNil ifNotNil: [ :aString | aString asString trimBoth ].
	(anId isNil or: [ anId isEmpty ]) ifTrue: [ ^ self databases ].
	found := self databases
			select: [ :each | (GtLLepiterSnippetReference databaseIdOf: each) = anId ].
	found
		ifEmpty: [ ^ aNoneBlock
				value: (self
						problem: 'Could not locate the database with id ' , anId
								, '. The lepiterKnowledgeBases tool lists the databases and their ids.') ].
	^ found
]

{ #category : #private }
GtLLepiterSnippetLocator >> nameOfDatabase: aDatabase [
	"Name a database in an error message: its name and id"

	| aName anId |
	aName := (GtLLepiterSnippetReference databaseNameOf: aDatabase)
			ifNil: [ 'an in-memory database' ].
	anId := GtLLepiterSnippetReference databaseIdOf: aDatabase.
	^ anId
		ifNil: [ aName , ' (no databaseId)' ]
		ifNotNil: [ aName , ' (databaseId ' , anId , ')' ]
]

{ #category : #private }
GtLLepiterSnippetLocator >> namesOfDatabasesOf: aCollectionOfSnippetsOrPages [
	^ ', '
		join: (aCollectionOfSnippetsOrPages
				collect: [ :each | self nameOfDatabase: each database ])
]

{ #category : #resolving }
GtLLepiterSnippetLocator >> pageUuidFrom: aPageUidString ifInvalid: anInvalidBlock [
	"Return the uuid of a page id: base 36, as the Lepiter tools give it, or the dashed form of a UUID, as the page JSON shows it.
	UUID class>>#fromString36: does not refuse other characters (it answers an unrelated uuid), so they are checked first"

	| aString |
	aString := aPageUidString
			ifNil: [ '' ]
			ifNotNil: [ aPageUidString asString trimBoth ].
	aString isEmpty
		ifTrue: [ ^ anInvalidBlock value: (self problem: 'Missing page uid') ].
	(aString size = 36 and: [ (aString occurrencesOf: $-) = 4 ])
		ifTrue: [ ^ [ UUID fromString: aString ]
				on: Error
				do: [ :anError | anInvalidBlock value: (self problemOfInvalidPageUid: aString) ] ].
	(aString
		allSatisfy: [ :each | each isDigit or: [ each asLowercase between: $a and: $z ] ])
		ifFalse: [ ^ anInvalidBlock value: (self problemOfInvalidPageUid: aString) ].
	^ [ UUID fromString36: aString ]
		on: Error
		do: [ :anError | anInvalidBlock value: (self problemOfInvalidPageUid: aString) ]
]

{ #category : #resolving }
GtLLepiterSnippetLocator >> pageWithUid: aPageUidString databaseId: aDatabaseIdOrNil ifFound: aFoundBlock ifNone: aNoneBlock [
	"Resolve a page. A page id that is in several databases is refused: the databaseId tells them apart"

	| pages |
	pages := self
			pagesWithUid: aPageUidString
			databaseId: aDatabaseIdOrNil
			ifNone: [ :aProblem | ^ aNoneBlock value: aProblem ].
	pages size > 1
		ifTrue: [ ^ aNoneBlock
				value: (self
						problem: 'The page id ' , aPageUidString asString trimBoth , ' is in several databases: '
								, (self namesOfDatabasesOf: pages)
								, '. Give the databaseId of the one to change.') ].
	^ aFoundBlock value: pages first
]

{ #category : #resolving }
GtLLepiterSnippetLocator >> pagesWithUid: aPageUidString databaseId: aDatabaseIdOrNil ifNone: aNoneBlock [
	"Return the pages with that id, at most one per database, in the databases to search. aNoneBlock gets an error domain object when the id is invalid or no page is found"

	| aUuid candidates pages |
	aUuid := self
			pageUuidFrom: aPageUidString
			ifInvalid: [ :aProblem | ^ aNoneBlock value: aProblem ].
	candidates := self
			databasesWithId: aDatabaseIdOrNil
			ifNone: [ :aProblem | ^ aNoneBlock value: aProblem ].
	pages := OrderedCollection new.
	candidates
		do: [ :eachDatabase | 
			eachDatabase
				pageWithID: aUuid
				ifPresent: [ :aPage | pages add: aPage ]
				ifAbsent: [  ] ].
	pages
		ifEmpty: [ ^ aNoneBlock
				value: (self
						problem: 'Could not locate page with id ' , aPageUidString asString trimBoth
								, ((aDatabaseIdOrNil notNil and: [ aDatabaseIdOrNil asString trimBoth notEmpty ])
										ifTrue: [ ' in ' , (self nameOfDatabase: candidates first) ]
										ifFalse: [ '' ])) ].
	^ pages asArray
]

{ #category : #private }
GtLLepiterSnippetLocator >> problem: aString [
	^ GtLProblemDomainObject new
		errorMessage: aString;
		yourself
]

{ #category : #private }
GtLLepiterSnippetLocator >> problemOfInvalidPageUid: aString [
	^ self
		problem: 'Invalid page uid ' , aString
				, ': a page id is base 36, as getLepiterPageContents and searchForLepiterPages give it, or the dashed form of the page UUID'
]

{ #category : #private }
GtLLepiterSnippetLocator >> problemOfSnippetUid: aLeUid twiceIn: aPage [
	^ self
		problem: 'The page ' , aPage uidString , ' of ' , (self nameOfDatabase: aPage database)
				, ' holds the snippet id ' , aLeUid uidString
				, ' more than once, so it cannot tell the snippets apart. Change this page in the Glamorous Toolkit instead.'
]

{ #category : #resolving }
GtLLepiterSnippetLocator >> snippetUidFrom: aSnippetUidString ifInvalid: anInvalidBlock [
	| aString anUid |
	aString := aSnippetUidString
			ifNil: [ '' ]
			ifNotNil: [ aSnippetUidString asString trimBoth ].
	aString isEmpty
		ifTrue: [ ^ anInvalidBlock value: (self problem: 'Missing snippet uid') ].
	anUid := LeUID new.
	[ anUid uidString: aString ]
		on: Error
		do: [ :anError | ^ anInvalidBlock value: (self problem: 'Invalid snippet uid ' , aString) ].
	^ anUid
]

{ #category : #resolving }
GtLLepiterSnippetLocator >> snippetWithUid: aSnippetUidString pageUid: aPageUidString databaseId: aDatabaseIdOrNil ifFound: aFoundBlock ifNone: aNoneBlock [
	"Resolve a snippet by its page and snippet ids. A page and snippet id pair found in several databases is refused, and so is a snippet id that one page holds twice"

	| anUid pages matches |
	anUid := self
			snippetUidFrom: aSnippetUidString
			ifInvalid: [ :aProblem | ^ aNoneBlock value: aProblem ].
	pages := self
			pagesWithUid: aPageUidString
			databaseId: aDatabaseIdOrNil
			ifNone: [ :aProblem | ^ aNoneBlock value: aProblem ].
	matches := OrderedCollection new.
	pages
		do: [ :eachPage | 
			| found |
			found := self snippetsWithUid: anUid inPage: eachPage.
			found size > 1
				ifTrue: [ ^ aNoneBlock value: (self problemOfSnippetUid: anUid twiceIn: eachPage) ].
			found ifNotEmpty: [ matches add: found first ] ].
	matches
		ifEmpty: [ ^ aNoneBlock
				value: (self
						problem: 'Could not locate snippet with id ' , anUid uidString , ' in page '
								, aPageUidString asString trimBoth) ].
	matches size > 1
		ifTrue: [ ^ aNoneBlock
				value: (self
						problem: 'The page id ' , aPageUidString asString trimBoth , ' and snippet id '
								, anUid uidString , ' are in several databases: '
								, (self namesOfDatabasesOf: matches)
								, '. Give the databaseId of the one to change.') ].
	^ aFoundBlock value: matches first
]

{ #category : #private }
GtLLepiterSnippetLocator >> snippetsWithUid: aLeUid inPage: aPage [
	^ (aPage allChildrenSnippetsMatching: [ :each | each uid = aLeUid ]) asArray
]
