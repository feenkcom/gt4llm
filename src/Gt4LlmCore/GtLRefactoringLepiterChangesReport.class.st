"
I report the changed Lepiter snippets. I order them by database, page and position in the page, and list the first `limit` of them in that order, so the listed snippets can all be in the first database. In the JSON they are grouped by database, then by page ({{gtClass:GtLRefactoringLepiterDatabaseReport}}, {{gtClass:GtLRefactoringLepiterPageReport}}), with the total and displayed counts of snippets, pages and databases. Databases are sorted by name, then id, and pages by title, then uid; equal ones keep their order.
"
Class {
	#name : #GtLRefactoringLepiterChangesReport,
	#superclass : #GtLRefactoringChangesReport,
	#instVars : [
		'databaseReports',
		'displayedSnippets'
	],
	#category : #'Gt4LlmCore-Refactorings'
}

{ #category : #private }
GtLRefactoringLepiterChangesReport class >> groupsOf: aCollection by: aBlock [
	"Return the elements grouped by the value of aBlock, compared by identity, as associations in the order in which the groups first appear"

	| groups |
	groups := OrderedCollection new.
	aCollection
		do: [ :each | 
			| aKey |
			aKey := aBlock value: each.
			(groups
				detect: [ :aGroup | aGroup key == aKey ]
				ifNone: [ groups add: aKey -> OrderedCollection new ]) value add: each ].
	^ groups
]

{ #category : #private }
GtLRefactoringLepiterChangesReport class >> keys: aCollection precede: anotherCollection [
	aCollection with: anotherCollection do: [ :a :b | a = b ifFalse: [ ^ a < b ] ].
	^ true
]

{ #category : #private }
GtLRefactoringLepiterChangesReport class >> sortedReports: aCollection [
	"Sort database or page reports by their sort keys, compared one after the other; reports with the same keys keep their order"

	| indexed |
	indexed := aCollection asArray
			withIndexCollect: [ :each :anIndex | each -> anIndex ].
	^ ((indexed
		asSortedCollection: [ :a :b | 
			self
				keys: (a key sortKeys copyWith: a value)
				precede: (b key sortKeys copyWith: b value) ]) collect: [ :each | each key ])
		asArray
]

{ #category : #accessing }
GtLRefactoringLepiterChangesReport >> databaseReports [
	"Return the reports of all databases, also the ones without listed snippets"

	^ databaseReports
]

{ #category : #accessing }
GtLRefactoringLepiterChangesReport >> displayedDatabaseReports [
	^ databaseReports select: [ :each | each displayedSnippetsCount > 0 ]
]

{ #category : #accessing }
GtLRefactoringLepiterChangesReport >> displayedDatabasesCount [
	^ self displayedDatabaseReports size
]

{ #category : #accessing }
GtLRefactoringLepiterChangesReport >> displayedPagesCount [
	^ databaseReports
		inject: 0
		into: [ :aSum :each | aSum + each displayedPagesCount ]
]

{ #category : #accessing }
GtLRefactoringLepiterChangesReport >> displayedSnippetsCount [
	^ self displayedCount
]

{ #category : #views }
GtLRefactoringLepiterChangesReport >> gtEntriesFor: aView [
	"All changed snippets, also the ones that are not listed in the JSON"

	<gtView>
	^ aView columnedList
		title: 'Snippets';
		priority: 1;
		items: [ databaseReports
				flatCollect: [ :eachDatabase | eachDatabase pageReports flatCollect: [ :eachPage | eachPage entries ] ] ];
		column: 'Kind'
			text: [ :each | each kind ]
			width: 120;
		column: 'Database'
			text: [ :each | each database ifNil: [ '' ] ifNotNil: [ :aDatabase | aDatabase databaseName ] ]
			width: 200;
		column: 'Page title'
			text: [ :each | each page ifNil: [ '' ] ifNotNil: [ :aPage | aPage title ] ];
		column: 'Snippet' text: [ :each | each snippetUid ]
]

{ #category : #initialization }
GtLRefactoringLepiterChangesReport >> initializeEntries: aCollectionOfSnippetEntries limit: anInteger includeSources: aBoolean [
	"Order the snippets by database, page and position in the page. The first anInteger snippets in that order are listed"

	limit := anInteger.
	includeSources := aBoolean.
	databaseReports := self class
			sortedReports: ((self class groupsOf: aCollectionOfSnippetEntries by: [ :each | each database ])
					collect: [ :each | 
						GtLRefactoringLepiterDatabaseReport
							report: self
							database: each key
							entries: each value ]).
	entries := (databaseReports flatCollect: [ :each | each entries ]) asArray
]

{ #category : #testing }
GtLRefactoringLepiterChangesReport >> isDisplayed: aSnippetEntry [
	^ (displayedSnippets
		ifNil: [ displayedSnippets := self displayedEntries asIdentitySet ])
		includes: aSnippetEntry
]

{ #category : #private }
GtLRefactoringLepiterChangesReport >> listKey [
	^ 'databases'
]

{ #category : #converting }
GtLRefactoringLepiterChangesReport >> llmJsonObject [
	| json |
	json := NeoJSONObject new.
	json
		at: 'totalSnippetsCount' put: self totalSnippetsCount;
		at: 'displayedSnippetsCount' put: self displayedSnippetsCount.
	self addPagePropertiesTo: json.
	json
		at: 'totalPagesCount' put: self totalPagesCount;
		at: 'displayedPagesCount' put: self displayedPagesCount;
		at: 'totalDatabasesCount' put: self totalDatabasesCount;
		at: 'displayedDatabasesCount' put: self displayedDatabasesCount;
		at: 'kindCounts' put: self kindCounts;
		at: self listKey
			put: (self displayedDatabaseReports
					collect: [ :each | each llmJsonObjectIncludingSources: includeSources ]
					as: Array).
	^ json
]

{ #category : #printing }
GtLRefactoringLepiterChangesReport >> printOn: aStream [
	super printOn: aStream.
	aStream
		parenthesize: [ aStream
				print: self displayedSnippetsCount;
				nextPutAll: ' of ';
				print: self totalSnippetsCount;
				nextPutAll: ' snippets' ]
]

{ #category : #accessing }
GtLRefactoringLepiterChangesReport >> totalDatabasesCount [
	^ databaseReports size
]

{ #category : #accessing }
GtLRefactoringLepiterChangesReport >> totalPagesCount [
	^ databaseReports inject: 0 into: [ :aSum :each | aSum + each totalPagesCount ]
]

{ #category : #accessing }
GtLRefactoringLepiterChangesReport >> totalSnippetsCount [
	^ self totalCount
]
