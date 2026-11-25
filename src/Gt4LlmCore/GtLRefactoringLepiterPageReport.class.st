"
I report the changed snippets of one Lepiter page, in their order in the page (see {{gtClass:GtLRefactoringLepiterChangesReport}}).
"
Class {
	#name : #GtLRefactoringLepiterPageReport,
	#superclass : #Object,
	#instVars : [
		'report',
		'page',
		'entries'
	],
	#category : #'Gt4LlmCore-Refactorings'
}

{ #category : #'instance creation' }
GtLRefactoringLepiterPageReport class >> report: aLepiterChangesReport page: aPageOrNil entries: aCollectionOfSnippetEntries [
	^ self new
		initializeReport: aLepiterChangesReport
		page: aPageOrNil
		entries: aCollectionOfSnippetEntries
]

{ #category : #accessing }
GtLRefactoringLepiterPageReport >> displayedEntries [
	^ entries select: [ :each | report isDisplayed: each ]
]

{ #category : #accessing }
GtLRefactoringLepiterPageReport >> displayedSnippetsCount [
	^ self displayedEntries size
]

{ #category : #accessing }
GtLRefactoringLepiterPageReport >> entries [
	"Return all my snippet entries, also the ones that are not listed"

	^ entries
]

{ #category : #initialization }
GtLRefactoringLepiterPageReport >> initializeReport: aLepiterChangesReport page: aPageOrNil entries: aCollectionOfSnippetEntries [
	"Keep the snippets in the order they have in the page"

	| positions |
	report := aLepiterChangesReport.
	page := aPageOrNil.
	positions := IdentityDictionary new.
	page
		ifNotNil: [ :aPage | 
			aPage
				allChildrenDepthFirstDo: [ :each | positions at: each put: positions size + 1 ] ].
	entries := (aCollectionOfSnippetEntries
			asSortedCollection: [ :a :b | 
				(positions at: a snippet ifAbsent: [ 0 ])
					<= (positions at: b snippet ifAbsent: [ 0 ]) ]) asArray
]

{ #category : #converting }
GtLRefactoringLepiterPageReport >> llmJsonObjectIncludingSources: aBoolean [
	| json |
	json := NeoJSONObject new.
	self pageUid ifNotNil: [ :anUid | json at: 'pageUid' put: anUid ].
	self pageTitle ifNotNil: [ :aTitle | json at: 'pageTitle' put: aTitle ].
	^ json
		at: 'totalSnippetsCount' put: self totalSnippetsCount;
		at: 'displayedSnippetsCount' put: self displayedSnippetsCount;
		at: 'snippets'
			put: (self displayedEntries
					collect: [ :each | each llmJsonObjectIncludingSources: aBoolean ]
					as: Array);
		yourself
]

{ #category : #accessing }
GtLRefactoringLepiterPageReport >> page [
	^ page
]

{ #category : #accessing }
GtLRefactoringLepiterPageReport >> pageTitle [
	^ page ifNotNil: [ :aPage | aPage title ]
]

{ #category : #accessing }
GtLRefactoringLepiterPageReport >> pageUid [
	"The form getLepiterPageContents and editLepiterSnippet expect"

	^ page ifNotNil: [ :aPage | aPage uidString ]
]

{ #category : #printing }
GtLRefactoringLepiterPageReport >> printOn: aStream [
	super printOn: aStream.
	aStream
		parenthesize: [ aStream
				nextPutAll: (self pageTitle ifNil: [ 'no page' ]);
				nextPutAll: ': ';
				print: self displayedSnippetsCount;
				nextPutAll: ' of ';
				print: self totalSnippetsCount;
				nextPutAll: ' snippets' ]
]

{ #category : #accessing }
GtLRefactoringLepiterPageReport >> sortKeys [
	^ {self pageTitle ifNil: [ '' ].
		self pageUid ifNil: [ '' ]}
]

{ #category : #accessing }
GtLRefactoringLepiterPageReport >> totalSnippetsCount [
	^ entries size
]
