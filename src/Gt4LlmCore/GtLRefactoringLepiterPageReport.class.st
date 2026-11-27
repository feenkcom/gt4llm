"
I report the changed snippets of one Lepiter page, in their order in the page (see {{gtClass:GtLRefactoringLepiterChangesReport}}).
"
Class {
	#name : #GtLRefactoringLepiterPageReport,
	#superclass : #Object,
	#instVars : [
		'report',
		'pageUid',
		'pageTitle',
		'entries'
	],
	#category : #'Gt4LlmCore-Refactorings'
}

{ #category : #'instance creation' }
GtLRefactoringLepiterPageReport class >> report: aLepiterChangesReport pageUid: aPageUidOrNil pageTitle: aPageTitleOrNil entries: aCollectionOfSnippetEntries [
	^ self new
		initializeReport: aLepiterChangesReport
		pageUid: aPageUidOrNil
		pageTitle: aPageTitleOrNil
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
GtLRefactoringLepiterPageReport >> initializeReport: aLepiterChangesReport pageUid: aPageUidOrNil pageTitle: aPageTitleOrNil entries: aCollectionOfSnippetEntries [
	"Keep the snippets in the order they had in the page before the changes, as the entries recorded it, and the added snippets, which have no such position, after them. Entries with the same position keep their order"

	| indexed |
	report := aLepiterChangesReport.
	pageUid := aPageUidOrNil.
	pageTitle := aPageTitleOrNil.
	indexed := aCollectionOfSnippetEntries asArray
			withIndexCollect: [ :each :anIndex | each -> anIndex ].
	entries := ((indexed
			asSortedCollection: [ :a :b | 
				| aPosition bPosition |
				aPosition := a key position ifNil: [ SmallInteger maxVal ].
				bPosition := b key position ifNil: [ SmallInteger maxVal ].
				aPosition < bPosition
					or: [ aPosition = bPosition and: [ a value <= b value ] ] ])
			collect: [ :each | each key ]) asArray
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
GtLRefactoringLepiterPageReport >> pageTitle [
	^ pageTitle
]

{ #category : #accessing }
GtLRefactoringLepiterPageReport >> pageUid [
	"The form getLepiterPageContents and editLepiterSnippets expect, as recorded by the entries"

	^ pageUid
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
