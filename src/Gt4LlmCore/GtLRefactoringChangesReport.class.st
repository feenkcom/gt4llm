"
I report a group of changes of the same sort: I list at most `limit` of my entries, in order, and always give the total count, the displayed count and the number of changes of each kind, so that a reader knows how much is not listed. My subclasses report classes, methods, Lepiter snippets and other changes; they choose the order of the entries and the JSON key of the list.
"
Class {
	#name : #GtLRefactoringChangesReport,
	#superclass : #Object,
	#instVars : [
		'entries',
		'limit',
		'includeSources',
		'offset'
	],
	#category : #'Gt4LlmCore-Refactorings'
}

{ #category : #'instance creation' }
GtLRefactoringChangesReport class >> entries: aCollectionOfChangeEntries limit: anInteger includeSources: aBoolean [
	^ self new
		initializeEntries: aCollectionOfChangeEntries
		limit: anInteger
		includeSources: aBoolean
]

{ #category : #'instance creation' }
GtLRefactoringChangesReport class >> entries: aCollectionOfChangeEntries offset: anOffset limit: anInteger includeSources: aBoolean [
	"List at most anInteger entries, from the one after the first anOffset ones"

	^ (self
		entries: aCollectionOfChangeEntries
		limit: anInteger
		includeSources: aBoolean)
		offset: anOffset;
		yourself
]

{ #category : #accessing }
GtLRefactoringChangesReport class >> kindCountsOf: aCollectionOfChangeEntries [
	"Return the number of entries of each kind, sorted by kind, as a JSON object"

	| counts |
	counts := NeoJSONObject new.
	(aCollectionOfChangeEntries collect: [ :each | each kind ]) asSet
		asSortedCollection
		do: [ :eachKind | 
			counts
				at: eachKind
				put: (aCollectionOfChangeEntries count: [ :each | each kind = eachKind ]) ].
	^ counts
]

{ #category : #converting }
GtLRefactoringChangesReport >> addPagePropertiesTo: aJsonObject [
	"The offset when the list does not start at the first entry, and the next offset when entries are left"

	self offset > 0 ifTrue: [ aJsonObject at: 'offset' put: self offset ].
	self nextOffset
		ifNotNil: [ :aNumber | aJsonObject at: 'nextOffset' put: aNumber ]
]

{ #category : #accessing }
GtLRefactoringChangesReport >> displayedCount [
	^ self displayedEntries size
]

{ #category : #accessing }
GtLRefactoringChangesReport >> displayedEntries [
	| start |
	start := self offset min: entries size.
	^ entries copyFrom: start + 1 to: (start + limit min: entries size)
]

{ #category : #accessing }
GtLRefactoringChangesReport >> entries [
	"Return all my entries, also the ones that are not listed"

	^ entries
]

{ #category : #views }
GtLRefactoringChangesReport >> gtEntriesFor: aView [
	"All my entries, also the ones that are not listed in the JSON"

	<gtView>
	| listed |
	listed := self displayedEntries asIdentitySet.
	^ aView columnedList
		title: 'Changes';
		priority: 1;
		items: [ entries ];
		column: 'Kind'
			text: [ :each | each kind ]
			width: 160;
		column: 'Target' text: [ :each | each target ];
		column: 'Listed'
			text: [ :each | (listed includes: each) ifTrue: [ 'yes' ] ifFalse: [ 'no' ] ]
			width: 60
]

{ #category : #accessing }
GtLRefactoringChangesReport >> includeSources [
	^ includeSources
]

{ #category : #initialization }
GtLRefactoringChangesReport >> initializeEntries: aCollectionOfChangeEntries limit: anInteger includeSources: aBoolean [
	entries := (aCollectionOfChangeEntries asSortedCollection: self sortBlock)
			asArray.
	limit := anInteger.
	includeSources := aBoolean
]

{ #category : #testing }
GtLRefactoringChangesReport >> isEmpty [
	^ entries isEmpty
]

{ #category : #accessing }
GtLRefactoringChangesReport >> kindCounts [
	"Count all my entries, also the ones that are not listed"

	^ self class kindCountsOf: entries
]

{ #category : #accessing }
GtLRefactoringChangesReport >> limit [
	^ limit
]

{ #category : #private }
GtLRefactoringChangesReport >> listKey [
	"Return the JSON key of my listed entries"

	^ self subclassResponsibility
]

{ #category : #converting }
GtLRefactoringChangesReport >> llmJsonObject [
	| json |
	json := NeoJSONObject new.
	json
		at: 'totalCount' put: self totalCount;
		at: 'displayedCount' put: self displayedCount.
	self addPagePropertiesTo: json.
	json
		at: 'kindCounts' put: self kindCounts;
		at: self listKey
			put: (self displayedEntries
					collect: [ :each | each llmJsonObjectIncludingSources: includeSources ]
					as: Array).
	^ json
]

{ #category : #accessing }
GtLRefactoringChangesReport >> nextOffset [
	"The offset of the first entry after the listed ones, or nil when none is left"

	| next |
	next := (self offset min: entries size) + self displayedCount.
	^ next < entries size ifTrue: [ next ] ifFalse: [ nil ]
]

{ #category : #accessing }
GtLRefactoringChangesReport >> offset [
	"The number of entries before the first listed one"

	^ offset ifNil: [ 0 ]
]

{ #category : #accessing }
GtLRefactoringChangesReport >> offset: anInteger [
	offset := anInteger
]

{ #category : #printing }
GtLRefactoringChangesReport >> printOn: aStream [
	super printOn: aStream.
	aStream
		parenthesize: [ aStream
				print: self displayedCount;
				nextPutAll: ' of ';
				print: self totalCount ]
]

{ #category : #private }
GtLRefactoringChangesReport >> sortBlock [
	^ [ :a :b | a target <= b target ]
]

{ #category : #accessing }
GtLRefactoringChangesReport >> totalCount [
	^ entries size
]
