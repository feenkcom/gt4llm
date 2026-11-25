"
I report the changed snippets of one Lepiter database, grouped by page (see {{gtClass:GtLRefactoringLepiterChangesReport}}).
"
Class {
	#name : #GtLRefactoringLepiterDatabaseReport,
	#superclass : #Object,
	#instVars : [
		'report',
		'database',
		'pageReports'
	],
	#category : #'Gt4LlmCore-Refactorings'
}

{ #category : #'instance creation' }
GtLRefactoringLepiterDatabaseReport class >> report: aLepiterChangesReport database: aDatabaseOrNil entries: aCollectionOfSnippetEntries [
	^ self new
		initializeReport: aLepiterChangesReport
		database: aDatabaseOrNil
		entries: aCollectionOfSnippetEntries
]

{ #category : #accessing }
GtLRefactoringLepiterDatabaseReport >> database [
	^ database
]

{ #category : #accessing }
GtLRefactoringLepiterDatabaseReport >> databaseId [
	"The form getLepiterPageContents expects. An in-memory database has no id"

	database ifNil: [ ^ nil ].
	database uuid = UUID nilUUID ifTrue: [ ^ nil ].
	^ database uuidString
]

{ #category : #accessing }
GtLRefactoringLepiterDatabaseReport >> databaseName [
	^ database ifNotNil: [ :aDatabase | aDatabase databaseName ]
]

{ #category : #accessing }
GtLRefactoringLepiterDatabaseReport >> displayedPageReports [
	^ pageReports select: [ :each | each displayedSnippetsCount > 0 ]
]

{ #category : #accessing }
GtLRefactoringLepiterDatabaseReport >> displayedPagesCount [
	^ self displayedPageReports size
]

{ #category : #accessing }
GtLRefactoringLepiterDatabaseReport >> displayedSnippetsCount [
	^ pageReports
		inject: 0
		into: [ :aSum :each | aSum + each displayedSnippetsCount ]
]

{ #category : #accessing }
GtLRefactoringLepiterDatabaseReport >> entries [
	"Return all my snippet entries, in the order of my pages"

	^ pageReports flatCollect: [ :each | each entries ]
]

{ #category : #initialization }
GtLRefactoringLepiterDatabaseReport >> initializeReport: aLepiterChangesReport database: aDatabaseOrNil entries: aCollectionOfSnippetEntries [
	report := aLepiterChangesReport.
	database := aDatabaseOrNil.
	pageReports := GtLRefactoringLepiterChangesReport
			sortedReports: ((GtLRefactoringLepiterChangesReport
					groupsOf: aCollectionOfSnippetEntries
					by: [ :each | each page ])
					collect: [ :each | 
						GtLRefactoringLepiterPageReport
							report: aLepiterChangesReport
							page: each key
							entries: each value ])
]

{ #category : #converting }
GtLRefactoringLepiterDatabaseReport >> llmJsonObjectIncludingSources: aBoolean [
	| json |
	json := NeoJSONObject new.
	self databaseId ifNotNil: [ :anId | json at: 'databaseId' put: anId ].
	self databaseName ifNotNil: [ :aName | json at: 'databaseName' put: aName ].
	^ json
		at: 'totalSnippetsCount' put: self totalSnippetsCount;
		at: 'displayedSnippetsCount' put: self displayedSnippetsCount;
		at: 'totalPagesCount' put: self totalPagesCount;
		at: 'displayedPagesCount' put: self displayedPagesCount;
		at: 'pages'
			put: (self displayedPageReports
					collect: [ :each | each llmJsonObjectIncludingSources: aBoolean ]
					as: Array);
		yourself
]

{ #category : #accessing }
GtLRefactoringLepiterDatabaseReport >> pageReports [
	"Return the reports of all pages, also the ones without listed snippets"

	^ pageReports
]

{ #category : #printing }
GtLRefactoringLepiterDatabaseReport >> printOn: aStream [
	super printOn: aStream.
	aStream
		parenthesize: [ aStream
				nextPutAll: (self databaseName ifNil: [ 'no database' ]);
				nextPutAll: ': ';
				print: self displayedSnippetsCount;
				nextPutAll: ' of ';
				print: self totalSnippetsCount;
				nextPutAll: ' snippets' ]
]

{ #category : #accessing }
GtLRefactoringLepiterDatabaseReport >> sortKeys [
	^ {self databaseName ifNil: [ '' ].
		self databaseId ifNil: [ '' ]}
]

{ #category : #accessing }
GtLRefactoringLepiterDatabaseReport >> totalPagesCount [
	^ pageReports size
]

{ #category : #accessing }
GtLRefactoringLepiterDatabaseReport >> totalSnippetsCount [
	^ pageReports inject: 0 into: [ :aSum :each | aSum + each totalSnippetsCount ]
]
