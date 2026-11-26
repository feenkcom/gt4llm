"
Examples of the Lepiter snippet change results and their parts: references, contents, snapshots ({{gtClass:GtLLepiterSnippetWithContent}}) and results ({{gtClass:GtLLepiterSnippetChangeResult}}). They use in-memory databases (`LeDatabase new`), which are never added to the logical database.
"
Class {
	#name : #GtLLepiterSnippetChangeResultExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLLepiterSnippetChangeResultExamples >> codeSnippetContentsAreDiffedByLanguage [
	"Pharo code is diffed and styled as Pharo, other code by lines, and text by words"

	<gtExample>
	| theContents |
	theContents := {LePharoSnippet code: '3 + 4'.
			LePythonSnippet code: 'print(2)'.
			LeTextSnippet string: 'Some text'}
			collect: [ :each | GtLLepiterSnippetContent fromSnippet: each ].
	self
		assert: (theContents collect: [ :each | each diffKind ]) asArray
		equals: #(#code #lines #text).
	self
		assert: (theContents collect: [ :each | each contentString ]) asArray
		equals: #('3 + 4' 'print(2)' 'Some text').
	^ theContents
]

{ #category : #examples }
GtLLepiterSnippetChangeResultExamples >> exampleSnippetContentIsItsAnnotation [
	"An example snippet is recorded as its annotation, which names the attributes that are not at their default. It is the text that an LeExampleSnippetChange gives in a preview, so the preview and the applied result agree. The content is a copy: a later change of the snippet does not change it"

	<gtExample>
	| aSnippet aChange anOldContent aNewContent |
	aSnippet := self pageWithSnippets children second.
	aSnippet previewHeight: 300.
	anOldContent := GtLLepiterSnippetContent fromSnippet: aSnippet.
	self assert: (anOldContent isKindOf: GtLLepiterSnippetStringContent).
	self assert: anOldContent diffKind equals: #text.
	self
		assert: anOldContent contentString
		equals: '{{gtExample:' , self class name
				, ' >> #unknownSnippetContent | previewHeight=300}}'.
	aChange := LeExampleSnippetChange new
			snippet: aSnippet;
			change: #exampleSelector to: #modificationResult;
			yourself.
	aSnippet exampleSelector: #modificationResult.
	aNewContent := GtLLepiterSnippetContent fromSnippet: aSnippet.
	self assert: aNewContent contentString equals: aChange gtLlmNewSource.
	self
		assert: (anOldContent contentString includesSubstring: '#unknownSnippetContent').
	^ aNewContent
]

{ #category : #examples }
GtLLepiterSnippetChangeResultExamples >> locatorRefusesASnippetIdHeldTwiceInAPage [
	"A page that holds the same snippet id twice (snippets copied by hand) cannot tell them apart: the locator refuses it"

	<gtExample>
	| aPage aFirst aSecond aProblem |
	aPage := LePage named: 'Twice'.
	LeDatabase new addPage: aPage.
	aFirst := LeTextSnippet string: 'First'.
	aSecond := LeTextSnippet string: 'Second'.
	aPage
		addSnippet: aFirst;
		addSnippet: aSecond.
	aSecond uid: aFirst uid.
	aProblem := (GtLLepiterSnippetLocator database: aPage database)
			snippetWithUid: aFirst uid uidString
			pageUid: aPage uidString
			databaseId: nil
			ifFound: [ :aSnippet | aSnippet ]
			ifNone: [ :each | each ].
	self assert: (aProblem isKindOf: GtLProblemDomainObject).
	self assert: (aProblem errorMessage includesSubstring: 'more than once').
	^ aProblem
]

{ #category : #examples }
GtLLepiterSnippetChangeResultExamples >> locatorRefusesUnknownAndInvalidIds [
	"An unknown databaseId, an invalid page uid and a page that is not in the given database are refused with an errorMessage that says why"

	<gtExample>
	| aPage aLocator theMessages |
	aPage := self pageWithSnippets.
	aLocator := GtLLepiterSnippetLocator database: aPage database.
	theMessages := {aLocator
				pageWithUid: aPage uidString
				databaseId: 'unknownid'
				ifFound: [ :each | nil ]
				ifNone: [ :aProblem | aProblem errorMessage ].
			aLocator
				pageWithUid: '!!!'
				databaseId: nil
				ifFound: [ :each | nil ]
				ifNone: [ :aProblem | aProblem errorMessage ].
			aLocator
				pageWithUid: UUID new asString36
				databaseId: nil
				ifFound: [ :each | nil ]
				ifNone: [ :aProblem | aProblem errorMessage ]}.
	self
		assert: (theMessages first
				includesSubstring: 'Could not locate the database with id unknownid').
	self assert: (theMessages second includesSubstring: 'Invalid page uid').
	self
		assert: (theMessages third includesSubstring: 'Could not locate page with id').
	^ theMessages
]

{ #category : #examples }
GtLLepiterSnippetChangeResultExamples >> locatorTakesTheDashedFormOfAPageUid [
	"A page id is base 36, as the Lepiter tools give it, or the dashed form of its UUID, as the page JSON shows it. Other text is refused as invalid, also when it has the size of a UUID"

	<gtExample>
	| aPage aLocator resolve |
	aPage := self pageWithSnippets.
	aLocator := GtLLepiterSnippetLocator database: aPage database.
	resolve := [ :aString | 
		aLocator
			pageWithUid: aString
			databaseId: nil
			ifFound: [ :each | each ]
			ifNone: [ :aProblem | aProblem errorMessage ] ].
	self assert: (resolve value: aPage uidString) == aPage.
	self assert: (resolve value: aPage uid asString) == aPage.
	self assert: (resolve value: '  ' , aPage uid asString , ' ') == aPage.
	self
		assert: ((resolve value: 'zzzzzzzz-zzzz-zzzz-zzzz-zzzzzzzzzzzz')
				includesSubstring: 'Invalid page uid').
	self
		assert: ((resolve value: 'not-base-36') includesSubstring: 'Invalid page uid').
	^ aPage
]

{ #category : #examples }
GtLLepiterSnippetChangeResultExamples >> modificationResult [
	"A modification result holds the snapshots before and after; its diff is split as code for a code snippet"

	<gtExample>
	| aSnippet anOld aResult |
	aSnippet := self pageWithSnippets children first children first.
	anOld := GtLLepiterSnippetWithContent fromSnippet: aSnippet.
	aSnippet updateString: '3 + 5'.
	aResult := GtLLepiterSnippetModificationResult new
			oldSnippet: anOld;
			newSnippet: (GtLLepiterSnippetWithContent fromSnippet: aSnippet);
			yourself.
	self assert: aResult status equals: 'updated'.
	self assert: aResult llmChangeKind equals: 'modified snippet'.
	self assert: aResult isLepiterChangeResult.
	self assert: aResult isContentChanged.
	self assert: aResult oldContentString equals: '3 + 4'.
	self assert: aResult newContentString equals: '3 + 5'.
	self assert: aResult asDiffElement notNil.
	self assert: aResult gtViewChangeIcon notNil.
	self assert: aResult llmChangeEntry snippetUid equals: aSnippet uid uidString.
	self assert: aResult llmChangeEntry position equals: 2.
	self assert: aResult llmChangeEntry newSource equals: '3 + 5'.
	^ aResult
]

{ #category : #examples }
GtLLepiterSnippetChangeResultExamples >> pageWithSnippets [
	"An in-memory database with a page: a text snippet with a nested Pharo snippet, then an example snippet"

	<gtExample>
	| aPage aText |
	aPage := LePage named: 'Snapshot page'.
	LeDatabase new addPage: aPage.
	aText := LeTextSnippet string: 'Some text'.
	aPage addSnippet: aText.
	aText addSnippet: (LePharoSnippet code: '3 + 4').
	aPage
		addSnippet: (LeExampleSnippet new
				exampleBehaviorName: #GtLLepiterSnippetChangeResultExamples;
				exampleSelector: #unknownSnippetContent;
				yourself).
	self assert: aPage children size equals: 2.
	^ aPage
]

{ #category : #examples }
GtLLepiterSnippetChangeResultExamples >> propertiesContentOfPictureSnippet [
	"A non-textual snippet other than an example keeps the JSON Lepiter writes for each of its specific attributes, sorted by name, one per line. The metadata, uid and children are not part of it"

	<gtExample>
	| aSnippet aContent aNames |
	aSnippet := LePictureSnippet new
			urlString: 'https://example.com/picture.png';
			caption: 'A caption';
			previewHeight: 150;
			yourself.
	aContent := GtLLepiterSnippetContent fromSnippet: aSnippet.
	self assert: (aContent isKindOf: GtLLepiterSnippetPropertiesContent).
	self assert: (aContent valueOf: 'caption') equals: '"A caption"'.
	self assert: (aContent valueOf: 'previewHeight') equals: '150'.
	self assert: (aContent valueOf: 'uid') isNil.
	self assert: (aContent valueOf: 'editTime') isNil.
	aNames := (aContent properties collect: [ :each | each key ]) asArray.
	self assert: aNames equals: (aNames copy sort: [ :a :b | a <= b ]).
	self assert: (aContent contentString lines includes: 'caption: "A caption"').
	aSnippet caption: 'Another caption'.
	self assert: (aContent valueOf: 'caption') equals: '"A caption"'.
	^ aContent
]

{ #category : #examples }
GtLLepiterSnippetChangeResultExamples >> referenceResolvesInItsDatabase [
	"A reference resolves in a given database, and no longer once the snippet is removed"

	<gtExample>
	| aPage aDatabase aSnippet aReference |
	aPage := self pageWithSnippets.
	aDatabase := aPage database.
	aSnippet := aPage children first children first.
	aReference := GtLLepiterSnippetReference fromSnippet: aSnippet.
	self
		assert: (aReference
				snippetIn: aDatabase
				ifPresent: [ :each | each ]
				ifMissing: [ :aProblem | aProblem ]) == aSnippet.
	self
		assert: aReference
		equals: (GtLLepiterSnippetReference fromSnippet: aSnippet).
	aSnippet removeSelf.
	self
		assert: ((aReference
				snippetIn: aDatabase
				ifPresent: [ :each | each ]
				ifMissing: [ :aProblem | aProblem ]) isKindOf: GtLProblemDomainObject).
	^ aReference
]

{ #category : #examples }
GtLLepiterSnippetChangeResultExamples >> resultsDataViewSerialization [
	"The LLM JSON of a tool call: status and reference, no contents. An in-memory database has no id, so databaseId is left out; the removal of a snippet with children lists their uids"

	<gtExample>
	| aPage aParent aChild aParentSnapshot aResults dataBlock |
	aPage := self pageWithSnippets.
	aParent := aPage children first.
	aChild := aParent children first.
	aParentSnapshot := GtLLepiterSnippetWithContent fromSnippet: aParent.
	aResults := GtLLepiterSnippetsChangeResult new
			snippetResults: {GtLLepiterSnippetRemovalResult new
						removedSnippet: aParentSnapshot;
						removedChildResults: {GtLLepiterSnippetRemovalResult new
									removedSnippet: (GtLLepiterSnippetWithContent fromSnippet: aChild);
									removedWithSnippet: aParentSnapshot reference;
									yourself};
						yourself.
					GtLProblemDomainObject new
						errorMessage: 'Could not locate page with id 0';
						yourself};
			yourself.
	self assert: aResults allChangeResults size equals: 2.
	dataBlock := (aResults llmDataViewsFor: GtLDataView new)
			serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.	"The data mixes NeoJSONObject and Dictionary: compare it as the agent reads it"
	self
		assert: (NeoJSONReader fromString: (NeoJSONWriter toString: dataBlock llmJsonData))
		equals: (Dictionary new
				at: 'snippets'
					put: {Dictionary new
								at: 'status' put: 'removed';
								at: 'targetSnippetReference'
									put: (Dictionary new
											at: 'pageUid' put: aPage uidString;
											at: 'snippetUid' put: aParent uid uidString;
											yourself);
								at: 'removedChildSnippetUids' put: {aChild uid uidString};
								yourself.
							Dictionary new
								at: 'errorMessage' put: 'Could not locate page with id 0';
								yourself};
				yourself).
	^ dataBlock
]

{ #category : #examples }
GtLLepiterSnippetChangeResultExamples >> resultsOfEachKindShowTheirChange [
	"Each kind of result names its snippet for the views and builds its diff from its snapshots. A removal holds the results of the descendants. An addition has no position before the change in its report entry. A result without snapshots can still be printed"

	<gtExample>
	| aPage aParent aChild aParentSnapshot aRemoval anAddition |
	aPage := self pageWithSnippets.
	aParent := aPage children first.
	aChild := aParent children first.
	aParentSnapshot := GtLLepiterSnippetWithContent fromSnippet: aParent.
	aRemoval := GtLLepiterSnippetRemovalResult new
			removedSnippet: aParentSnapshot;
			removedChildResults: {GtLLepiterSnippetRemovalResult new
						removedSnippet: (GtLLepiterSnippetWithContent fromSnippet: aChild);
						removedWithSnippet: aParentSnapshot reference;
						yourself};
			yourself.
	anAddition := GtLLepiterSnippetAdditionResult new
			newSnippet: (GtLLepiterSnippetWithContent fromSnippet: aChild);
			yourself.
	self
		assert: aRemoval gtViewChangeTarget
		equals: 'text: Some text (page Snapshot page)'.
	self
		assert: anAddition gtViewChangeTarget
		equals: 'pharo: 3 + 4 (page Snapshot page)'.
	self assert: aRemoval oldContentString equals: 'Some text'.
	self assert: aRemoval newContentString equals: ''.
	self assert: anAddition oldContentString equals: ''.
	self assert: aRemoval asDiffElement notNil.
	self assert: anAddition asDiffElement notNil.
	self
		assert: (aRemoval allResults collect: [ :each | each removedSnippet contentString ])
				asArray
		equals: #('Some text' '3 + 4').
	self assert: aRemoval llmChangeEntry position equals: 1.
	self assert: anAddition llmChangeEntry position isNil.
	self
		assert: GtLLepiterSnippetAdditionResult new printString
		equals: 'a GtLLepiterSnippetAdditionResult'.
	self
		assert: GtLLepiterSnippetRemovalResult new gtViewChangeTarget
		equals: 'snippet'.
	^ aRemoval
]

{ #category : #examples }
GtLLepiterSnippetChangeResultExamples >> snapshotOfNestedCodeSnippet [
	"A snapshot records the reference, type, content, page, parent and depth-first position of a snippet. An in-memory database has no id and no name"

	<gtExample>
	| aPage aSnippet aSnapshot |
	aPage := self pageWithSnippets.
	aSnippet := aPage children first children first.
	aSnapshot := GtLLepiterSnippetWithContent fromSnippet: aSnippet.
	self assert: aSnapshot snippetType equals: 'pharo'.
	self assert: aSnapshot snippetUid equals: aSnippet uid uidString.
	self assert: aSnapshot pageUid equals: aPage uidString.
	self assert: aSnapshot databaseId isNil.
	self assert: aSnapshot databaseName isNil.
	self assert: aSnapshot pageTitle equals: 'Snapshot page'.
	self
		assert: aSnapshot parentSnippetUid
		equals: aPage children first uid uidString.
	self assert: aSnapshot position equals: 2.
	self assert: (aSnapshot content isKindOf: GtLLepiterSnippetStringContent).
	self assert: aSnapshot content diffKind equals: #code.
	self assert: aSnapshot contentString equals: '3 + 4'.	"The content is a copy: a later edit does not change the snapshot"
	aSnippet updateString: '5 + 6'.
	self assert: aSnapshot contentString equals: '3 + 4'.
	^ aSnapshot
]

{ #category : #examples }
GtLLepiterSnippetChangeResultExamples >> stringContentCopiesASharedString [
	"A string snippet answers its own string as contentAsString: the content keeps a copy"

	<gtExample>
	| aString aSnippet aContent |
	aString := 'abc' copy.
	aSnippet := LeStringSnippet new
			contentString: aString;
			yourself.
	aContent := GtLLepiterSnippetContent fromSnippet: aSnippet.
	self assert: aSnippet contentAsString == aString.
	aString at: 1 put: $X.
	self assert: aContent contentString equals: 'abc'.
	^ aContent
]

{ #category : #examples }
GtLLepiterSnippetChangeResultExamples >> unknownSnippetContent [
	"An unknown snippet is textual, but has no specific attributes and no contentAsString: its content falls back to its JSON, diffed by lines"

	<gtExample>
	| aSnippet aContent |
	aSnippet := LeUnknownSnippet new.
	self assert: aSnippet contentAsString isNil.
	self assert: aSnippet extractSpecificState attributes isEmpty.
	aContent := GtLLepiterSnippetContent fromSnippet: aSnippet.
	self assert: (aContent isKindOf: GtLLepiterSnippetStringContent).
	self assert: aContent diffKind equals: #lines.
	self assert: aContent contentString equals: (aSnippet jsonString ifNil: [ '' ]).
	^ aContent
]

{ #category : #examples }
GtLLepiterSnippetChangeResultExamples >> viewChangeTargetNamesTypeContentAndPage [
	"The views name a changed snippet by its type, the start of its content on one line and its page, while the LLM JSON keeps its uid. A preview names it in the same way, from the Le change"

	<gtExample>
	| aText aResult aChange |
	aText := self pageWithSnippets children first.
	aResult := GtLLepiterSnippetModificationResult new
			oldSnippet: (GtLLepiterSnippetWithContent fromSnippet: aText);
			newSnippet: (GtLLepiterSnippetWithContent fromSnippet: aText);
			yourself.
	self
		assert: aResult gtViewChangeTarget
		equals: 'text: Some text (page Snapshot page)'.
	self assert: (aResult llmChangeTarget includesSubstring: aText uid uidString).
	aChange := GtLRefactoringChange
			fromChange: (LeSnippetChange new
					snippet: aText;
					newSource: 'A much longer text
that goes on over two lines and more than forty characters';
					yourself).
	self
		assert: aChange gtViewChangeTarget
		equals: 'text: A much longer text that goes on over two... (page Snapshot page)'.
	self assert: (aChange target includesSubstring: aText uid uidString).
	^ aChange
]
