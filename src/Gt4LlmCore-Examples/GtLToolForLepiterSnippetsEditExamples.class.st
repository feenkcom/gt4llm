"
Examples of the editLepiterSnippets tool ({{gtClass:GtLToolForLepiterSnippetsEdit}}): several edits in one call, refusals and errors answered per entry, a snippet listed twice, and snippets whose page and snippet ids are in two databases. They use detached databases: an in-memory one, or two monitored in-memory databases that are stopped afterwards ({{gtMethod:GtLToolForLepiterSnippetsEditExamples>>#withCopiedPageInTwoDatabasesDo:}}).
"
Class {
	#name : #GtLToolForLepiterSnippetsEditExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForLepiterSnippetsEditExamples >> copiesInTwoDatabasesAreToldApartByDatabaseId [
	"The same page and snippet ids in two databases are two snippets: with their databaseIds, both are edited in one call. Without a databaseId, the pair is refused as ambiguous, or, after an edit of it, as already edited"

	<gtExample>
	^ self
		withCopiedPageInTwoDatabasesDo: [ :aLogicalDatabase :theDatabases :theSnippets | 
			| tool call results ambiguous |
			tool := GtLToolForLepiterSnippetsEdit new
					database: aLogicalDatabase;
					yourself.
			ambiguous := (self
					executeTool: tool
					withArguments: {'snippets' -> {self edit: theSnippets first to: 'Ambiguous'}} asDictionary)
					result targetObject snippets first.
			self
				assert: (ambiguous errorMessage includesSubstring: 'are in several databases').
			call := self
					executeTool: tool
					withArguments: {'snippets'
								-> (((1 to: 2)
										collect: [ :anIndex | 
											(self edit: (theSnippets at: anIndex) to: 'Edited in ' , anIndex printString)
												at: 'databaseId' put: (theDatabases at: anIndex) uuidString;
												yourself ]) asArray
										, {self edit: theSnippets first to: 'Edited again'})} asDictionary.
			results := call result targetObject snippets.
			self
				assert: ((results first: 2) collect: [ :each | each status ]) asArray
				equals: #('updated' 'updated').
			self
				assert: ((results first: 2) collect: [ :each | each targetSnippetReference databaseId ])
						asArray
				equals: (theDatabases collect: [ :each | each uuidString ]) asArray.
			self
				assert: (results third errorMessage
						includesSubstring: 'was already edited earlier in this call').
			self
				assert: (theSnippets collect: [ :each | each string ]) asArray
				equals: #('Edited in 1' 'Edited in 2').
			call ]
]

{ #category : #private }
GtLToolForLepiterSnippetsEditExamples >> edit: aSnippet to: aString [
	"Return the arguments of one edit of aSnippet"

	^ Dictionary new
		at: 'pageUid' put: aSnippet page uidString;
		at: 'snippetUid' put: aSnippet uidString;
		at: 'updatedText' put: aString;
		yourself
]

{ #category : #examples }
GtLToolForLepiterSnippetsEditExamples >> emptySnippetsList [
	"An empty list edits nothing and answers an empty list of results"

	<gtExample>
	| page call |
	page := self pageWithSnippets.
	call := self
			executeTool: (self toolOn: page)
			withArguments: {'snippets' -> #()} asDictionary.
	self
		assert: (call result targetObject isKindOf: GtLLepiterSnippetsChangeResult).
	self assert: call result targetObject snippets isEmpty.
	self assert: page children first string equals: 'First text'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsEditExamples >> isOfferedInsteadOfTheSingleEdit [
	"The Lepiter change tools offer editLepiterSnippets; editLepiterSnippet, which it uses for each request, is still available but not offered"

	<gtExample>
	| names |
	names := (GtLTools leChange collect: [ :each | each name ]) asArray.
	self assert: (names includes: 'editLepiterSnippets').
	self assert: (names includes: 'editLepiterSnippet') not.
	self assert: (names includes: 'createLepiterSnippets').
	self assert: (names includes: 'removeLepiterSnippets').
	self assert: GtLAbstractLepiterSnippetTool isAbstract.
	self assert: GtLToolForLepiterSnippetsEdit isAbstract not.
	^ names
]

{ #category : #examples }
GtLToolForLepiterSnippetsEditExamples >> mixedEditsAnswerInOrder [
	"Refusals and errors are answered per entry, in order, and do not stop the other edits: a non-textual snippet, a blank snippet uid and a snippet that is not in the page"

	<gtExample>
	| page call results |
	page := self pageWithSnippets.
	call := self
			executeTool: (self toolOn: page)
			withArguments: {'snippets'
						-> {self edit: page children third to: 'An example has no text'.
								(self edit: page children first to: 'Blank uid')
									at: 'snippetUid' put: '  ';
									yourself.
								(self edit: page children first to: 'Unknown snippet')
									at: 'snippetUid' put: self pageWithSnippets children first uidString;
									yourself.
								self edit: page children first to: 'Edited text'}} asDictionary.
	results := call result targetObject snippets.
	self assert: (results first isKindOf: GtLProblemDomainObject).
	self
		assert: (results first errorMessage includesSubstring: 'is a snippet of type example').
	self
		assertMissingArgument: results second
		withArgumentName: 'snippetUid'
		errorMessage: 'Missing argument called snippetUid'.
	self
		assert: (results third errorMessage
				includesSubstring: 'Could not locate snippet with id').
	self assert: (results fourth isKindOf: GtLLepiterSnippetModificationResult).
	self assert: page children first string equals: 'Edited text'.
	self assert: page children third exampleSelector equals: #emptySnippetsList.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsEditExamples >> pageWithSnippets [
	"A page with a text, a Pharo and an example snippet, in an in-memory database"

	<gtExample>
	| page |
	page := LeContentExamples new basicDatabase pageBuilder
			title: 'Bulk edit';
			add.
	page snippetBuilder
		string: 'First text';
		add.
	page addSnippet: (LePharoSnippet code: '1 + 2').
	page
		addSnippet: (LeExampleSnippet new
				exampleBehaviorName: self class name;
				exampleSelector: #emptySnippetsList;
				yourself).
	self assert: page children size equals: 3.
	^ page
]

{ #category : #examples }
GtLToolForLepiterSnippetsEditExamples >> sameSnippetTwiceInBothPageIdFormsIsRefused [
	"A snippet named once with its base 36 page id and once with the dashed form of the page UUID is the same snippet: the second entry is refused"

	<gtExample>
	| page call results second |
	page := self pageWithSnippets.
	second := (self edit: page children first to: 'Second edit')
			at: 'pageUid' put: page uid asString;
			yourself.
	call := self
			executeTool: (self toolOn: page)
			withArguments: {'snippets'
						-> {self edit: page children first to: 'First edit'.
								second}} asDictionary.
	results := call result targetObject snippets.
	self assert: results first status equals: 'updated'.
	self
		assert: (results second errorMessage
				includesSubstring: 'was already edited earlier in this call').
	self assert: page children first string equals: 'First edit'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsEditExamples >> sameSnippetTwiceIsRefused [
	"A snippet listed twice is edited once: the second entry is refused, so that the result of the first one describes the edit from the original text"

	<gtExample>
	| page call results |
	page := self pageWithSnippets.
	call := self
			executeTool: (self toolOn: page)
			withArguments: {'snippets'
						-> {self edit: page children first to: 'First edit'.
								self edit: page children first to: 'Second edit'}} asDictionary.
	results := call result targetObject snippets.
	self assert: results first status equals: 'updated'.
	self assert: results first oldSnippet contentString equals: 'First text'.
	self assert: (results second isKindOf: GtLProblemDomainObject).
	self
		assert: (results second errorMessage
				includesSubstring: 'was already edited earlier in this call: give all its new text in one entry').
	self assert: page children first string equals: 'First edit'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsEditExamples >> schemaOfTheEditRequests [
	"Each entry of snippets is an edit request: page and snippet ids and the new text are required, the databaseId is optional. editLepiterSnippet takes the same request, as snippetEdit"

	<gtExample>
	| schema items |
	schema := GtLToolForLepiterSnippetsEdit new parametersJsonSchemaDictionary.
	self assert: (schema at: 'required') asArray equals: #('snippets').
	items := ((schema at: 'properties') at: 'snippets') at: 'items'.
	self
		assert: (items at: 'required') asSortedCollection asArray
		equals: #('pageUid' 'snippetUid' 'updatedText').
	self
		assert: (items at: 'properties') keys asSortedCollection asArray
		equals: #('databaseId' 'pageUid' 'snippetUid' 'updatedText').
	self
		assert: ((GtLToolForLepiterSnippetEdit new parametersJsonSchemaDictionary
				at: 'properties') at: 'snippetEdit')
		equals: items.
	^ schema
]

{ #category : #examples }
GtLToolForLepiterSnippetsEditExamples >> snippetToolsUseTheLogicalDatabaseByDefault [
	"A snippet tool that was given no database, or whose database slot was reset (as when the slot moves between classes), looks pages up in the current logical database"

	<gtExample>
	| theTools |
	theTools := {GtLToolForLepiterSnippetsCreate new.
			GtLToolForLepiterSnippetEdit new.
			GtLToolForLepiterSnippetsEdit new.
			GtLToolForLepiterSnippetsRemove new
				database: nil;
				yourself}.
	self
		assert: (theTools
				allSatisfy: [ :each | each database == LeDatabasesRegistry defaultLogicalDatabase ]).
	self
		assert: (theTools
				allSatisfy: [ :each | each snippetLocator database == LeDatabasesRegistry defaultLogicalDatabase ]).
	^ theTools
]

{ #category : #examples }
GtLToolForLepiterSnippetsEditExamples >> successfulSnippetsEdit [
	"Each snippet gets its own modification result, in order, and the response names each by its reference only"

	<gtExample>
	| page call results expected |
	page := self pageWithSnippets.
	call := self
			executeTool: (self toolOn: page)
			withArguments: {'snippets'
						-> {self edit: page children first to: 'Edited text'.
								self edit: page children second to: '3 + 4'}} asDictionary.
	results := call result targetObject snippets.
	self
		assert: (results collect: [ :each | each class ]) asArray
		equals: {GtLLepiterSnippetModificationResult.
				GtLLepiterSnippetModificationResult}.
	self
		assert: (results collect: [ :each | each oldSnippet contentString ]) asArray
		equals: #('First text' '1 + 2').
	self
		assert: (results collect: [ :each | each newSnippet contentString ]) asArray
		equals: #('Edited text' '3 + 4').
	self assert: page children first string equals: 'Edited text'.
	self assert: page children second code equals: '3 + 4'.
	expected := (page children asArray first: 2)
			collect: [ :each | 
				Dictionary new
					at: 'status' put: 'updated';
					at: 'targetSnippetReference'
						put: (Dictionary new
								at: 'pageUid' put: page uidString;
								at: 'snippetUid' put: each uidString;
								yourself);
					yourself ].
	self
		assert: (self jsonOf: call)
		equals: (Dictionary new
				at: 'snippets' put: expected;
				yourself).
	^ call
]

{ #category : #private }
GtLToolForLepiterSnippetsEditExamples >> toolOn: aPage [
	^ GtLToolForLepiterSnippetsEdit new
		database: aPage database;
		yourself
]

{ #category : #private }
GtLToolForLepiterSnippetsEditExamples >> withCopiedPageInTwoDatabasesDo: aBlock [
	"Evaluate aBlock with a logical database of two monitored in-memory databases, the two databases, and two text snippets: each database holds a page with the same uid (a page copied by hand) with one of the snippets, and the snippets have the same uid, given before they are added, as a copied page has it. The monitors are stopped afterwards"

	| databases |
	databases := #('one' 'two')
			collect: [ :aName | 
				| aFolder aStore |
				aFolder := FileSystem memory / aName.
				aFolder ensureCreateDirectory.
				aStore := LeLocalStoreLoad current.
				aStore localRoot: aFolder.
				aStore loadAndMonitorFrom: aFolder ].
	^ [ | pageUid snippets logicalDatabase |
	pageUid := UUID new.
	snippets := OrderedCollection new.
	databases
		do: [ :aDatabase | 
			| aPage aSnippet |
			aPage := (LePage named: 'Copied page')
					basicUid: pageUid;
					yourself.
			aDatabase addPage: aPage.
			aSnippet := LeTextSnippet string: 'Copied text'.
			snippets ifNotEmpty: [ aSnippet uid: snippets first uid ].
			aPage addSnippet: aSnippet.
			snippets add: aSnippet ].
	logicalDatabase := LeLogicalDatabase new
			primaryDB: databases first;
			addDB: databases second;
			yourself.
	aBlock
		value: logicalDatabase
		value: databases
		value: snippets asArray ]
		ensure: [ databases do: [ :each | each stopMonitoring ] ]
]
