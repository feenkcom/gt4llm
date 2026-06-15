"
Shared helper behavior for examples that create Lepiter page references backed by a logical database.
"
Trait {
	#name : #TGtLWithLepiterPageReferenceForDomainObjectExamples,
	#instVars : [
		'theDatabase'
	],
	#category : #'Gt4LlmCore-Examples-Support'
}

{ #category : #private }
TGtLWithLepiterPageReferenceForDomainObjectExamples >> expectedPlaygroundPageReferenceForObjectClassName: aClassName [
	| page expectedTitle |
	expectedTitle := aClassName , ' Page'.
	page := self theDatabase pages detect: [ :each | each title = expectedTitle ].
	^ NeoJSONObject new
		at: 'databaseId' put: self theDatabase primaryDB uuidString;
		at: 'pageId' put: page uid asString36;
		yourself
]

{ #category : #private }
TGtLWithLepiterPageReferenceForDomainObjectExamples >> lepiterPageReferenceForObject: anObject withSnippetCode: aString [
	| page snippet |
	page := LePage pharoClassName: anObject class name.
	snippet := LePharoSnippet new.
	snippet code: aString.
	page addSnippet: snippet.
	self theDatabase addPage: page.
	self assert: page children size equals: 1.
	^ GtLLepiterPageReference new
		page: page;
		yourself
]

{ #category : #accessing }
TGtLWithLepiterPageReferenceForDomainObjectExamples >> theDatabase [
	| newDatabase |
	^ theDatabase
		ifNil: [ newDatabase := LeExplicitlyAttachedLinksExamples new emptyDatabase.
			theDatabase := LeLogicalDatabase new primaryDB: newDatabase ]
		ifNotNil: [ theDatabase ]
]
