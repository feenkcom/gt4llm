"
Examples for GtLToolForLepiterPageContents demonstrating data views serialization and error handling.
"
Class {
	#name : #GtLToolForLepiterPageContentsExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #private }
GtLToolForLepiterPageContentsExamples >> contentOfPage: aPage inFormat: aFormatName with: aTool [
	"Return the call of aTool that gets aPage in the given format"

	^ self
		executeTool: aTool
		withArguments: {'databaseId' -> aPage database uuidString.
				'pageUid' -> aPage uidString.
				'format' -> aFormatName} asDictionary
]

{ #category : #examples }
GtLToolForLepiterPageContentsExamples >> formatSchema [
	"format is required and is one of the three format names"

	<gtExample>
	| schema format |
	schema := GtLToolForLepiterPageContents new parametersJsonSchemaDictionary.
	self
		assert: (schema at: 'required') asSortedCollection asArray
		equals: #('format' 'pageUid').
	format := (schema at: 'properties') at: 'format'.
	self
		assert: (format at: 'enum') asArray
		equals: #('markdown' 'structure' 'storage').
	self assert: (format includesKey: 'description').
	^ schema
]

{ #category : #examples }
GtLToolForLepiterPageContentsExamples >> formatsInTheToolResponse [
	"Each format answers one JSON data view, sent as JSON and not as a string holding JSON"

	<gtExample>
	^ self
		withFormatsPageDo: [ :tool :page :database | 
			GtLLepiterPageContent formatNames
				collect: [ :aFormatName | 
					| call content dataBlock |
					call := self
							contentOfPage: page
							inFormat: aFormatName
							with: tool.
					content := call result targetObject.
					self assert: content formatName equals: aFormatName.
					self
						assert: (content llmDataViewsFor: GtLDataView new) dataViews size
						equals: 1.
					dataBlock := (content llmDataViewsFor: GtLDataView new)
							serializeToLlmPrimiteData.
					self assertDataBlockHasOnlyJsonData: dataBlock.
					self
						assert: (self jsonOf: call)
						equals: (NeoJSONReader fromString: (NeoJSONWriter toString: content llmJsonObject)).
					call ] ]
]

{ #category : #examples }
GtLToolForLepiterPageContentsExamples >> markdownFormat [
	"The markdown format has the title, the page and database ids and the page as markdown, as chats get it, with line feeds as line endings"

	<gtExample>
	^ self
		withFormatsPageDo: [ :tool :page :database | 
			| call content json |
			call := self
					contentOfPage: page
					inFormat: 'markdown'
					with: tool.
			content := call result targetObject.
			self assert: (content isKindOf: GtLLepiterPageMarkdownContent).
			self assert: content page == page.
			json := content llmJsonObject.
			self
				assert: json keys asArray
				equals: #('pageTitle' 'pageUid' 'databaseId' 'markdown').
			self assert: (json at: 'pageTitle') equals: 'Page in three formats'.
			self assert: (json at: 'pageUid') equals: page uid asString36.
			self assert: (json at: 'databaseId') equals: database uuidString.
			self assert: ((json at: 'markdown') includesSubstring: 'Some **bold** text').
			self assert: ((json at: 'markdown') includesSubstring: '```pharo').
			self
				assert: ((json at: 'markdown') includesSubstring: 'https://example.com/picture.png').
			self assert: ((json at: 'markdown') includes: Character cr) not.
			self
				assert: (json at: 'markdown')
				equals: (GtLLepiterContentExporter new
						strictMode: false;
						page: page;
						export) withUnixLineEndings.
			content ]
]

{ #category : #'examples - data views' }
GtLToolForLepiterPageContentsExamples >> pageSerializationForExistingPage [
	<gtExample>
	| call database page compositeView dataBlock |
	database := LeDatabase gtBook.
	page := database pageNamed: 'Warmup: understanding the Money classes'.
	call := self
			executeTool: GtLToolForLepiterPageContents new
			withArguments: {'pageUid' -> page uidString.
					'databaseId' -> database uuidString.
					'format' -> 'storage'} asDictionary.
	self assert: (call result targetObject isKindOf: GtLLepiterPageStorageContent).
	self assert: call result targetObject page equals: page.
	compositeView := call result targetObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.

	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	self
		assert: (NeoJSONReader fromString: (NeoJSONWriter toString: dataBlock llmJsonData))
		equals: (NeoJSONReader fromString: (LeJsonV4 uniqueInstance serialize: page)).

	^ call
]

{ #category : #examples }
GtLToolForLepiterPageContentsExamples >> pageSerializationForMissingKnowledgeBase [
	<gtExample>
	| call unknownDbId |
	unknownDbId := 'missing-uuid-42'.
	call := self
			executeTool: GtLToolForLepiterPageContents new
			withArguments: {'pageUid' -> UUID new asString36.
					'databaseId' -> unknownDbId.
					'format' -> 'markdown'} asDictionary.
	self assert: call result targetObject isErrorDomainObject.
	self assert: (call result targetObject isKindOf: GtLProblemDomainObject).
	self
		assert: (call result targetObject description includesSubstring: unknownDbId).
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageContentsExamples >> pageSerializationForTheDashedPageUid [
	"The page id can also be given in the dashed form of its UUID, which the stored page JSON shows; an invalid id is refused as such, not reported as a missing page"

	<gtExample>
	| db logicalDB page tool call invalid |
	db := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	logicalDB := LeLogicalDatabase new primaryDB: db.
	page := db pageBuilder
			title: 'Page to read';
			add.
	tool := GtLToolForLepiterPageContents new.
	tool database: logicalDB.
	call := self
			executeTool: tool
			withArguments: {'databaseId' -> db uuidString.
					'pageUid' -> page uid asString.
					'format' -> 'structure'} asDictionary.
	self
		assert: (call result targetObject isKindOf: GtLLepiterPageStructureContent).
	self assert: call result targetObject page == page.
	self
		assert: (call result targetObject llmJsonObject at: 'pageUid')
		equals: page uid asString36.
	invalid := (self
			executeTool: tool
			withArguments: {'databaseId' -> db uuidString.
					'pageUid' -> 'not base 36!'.
					'format' -> 'structure'} asDictionary) result targetObject.
	self assert: (invalid errorMessage includesSubstring: 'Invalid page uid').
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageContentsExamples >> pageSerializationForUnknownPage [
	<gtExample>
	| call database unknownUid |
	database := LeDatabase gtBook.
	unknownUid := UUID new asString36.
	call := self
			executeTool: GtLToolForLepiterPageContents new
			withArguments: {'pageUid' -> unknownUid.
					'databaseId' -> database uuidString.
					'format' -> 'markdown'} asDictionary.
	self assert: call result targetObject isErrorDomainObject.
	self
		assert: (call result targetObject errorMessage
				beginsWith: 'Could not locate page with id ' , unknownUid , ' in ' , database databaseName).
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageContentsExamples >> pageSerializationWithMissingDatabaseId [
	"databaseId is optional: without it, the page is found in any database. A page id that is in several databases is refused until the databaseId tells them apart"

	<gtExample>
	^ GtLToolForLepiterSnippetsEditExamples new
		withCopiedPageInTwoDatabasesDo: [ :logicalDatabase :databases :snippets | 
			| tool pageUid single ambiguous chosen |
			tool := GtLToolForLepiterPageContents new
					database: logicalDatabase;
					yourself.
			pageUid := snippets first page uidString.
			single := self
					executeTool: (GtLToolForLepiterPageContents new
							database: (LeLogicalDatabase new primaryDB: databases first);
							yourself)
					withArguments: {'pageUid' -> pageUid.
							'format' -> 'markdown'} asDictionary.
			self assert: single result targetObject page == snippets first page.
			ambiguous := (self
					executeTool: tool
					withArguments: {'pageUid' -> pageUid.
							'format' -> 'markdown'} asDictionary) result targetObject.
			self assert: ambiguous isErrorDomainObject.
			self
				assert: (ambiguous errorMessage includesSubstring: 'is in several databases').
			self
				assert: (ambiguous errorMessage endsWith: 'Give the databaseId of the one you mean.').
			chosen := self
					executeTool: tool
					withArguments: {'pageUid' -> pageUid.
							'databaseId' -> databases second uuidString.
							'format' -> 'markdown'} asDictionary.
			self assert: chosen result targetObject page == snippets second page.
			chosen ]
]

{ #category : #examples }
GtLToolForLepiterPageContentsExamples >> pageSerializationWithMissingFormat [
	<gtExample>
	| call database |
	database := LeDatabase gtBook.
	call := self
			executeTool: GtLToolForLepiterPageContents new
			withArguments: {'databaseId' -> database uuidString.
					'pageUid' -> UUID new asString36} asDictionary.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('format')
		path: #(nil)
		errorMessage: 'required properties missing [format]'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageContentsExamples >> pageSerializationWithMissingPageUid [
	<gtExample>
	| call database |
	database := LeDatabase gtBook.
	call := self
			executeTool: GtLToolForLepiterPageContents new
			withArguments: {'databaseId' -> database uuidString.
					'format' -> 'markdown'} asDictionary.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('pageUid')
		path: #(nil)
		errorMessage: 'required properties missing [pageUid]'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterPageContentsExamples >> storageFormat [
	"The storage format is the LeJsonV4 of the page as a JSON object, not as a string, with the keys in the stored order, and it reads back as the same page"

	<gtExample>
	^ self
		withFormatsPageDo: [ :tool :page :database | 
			| content json readPage |
			content := (self
					contentOfPage: page
					inFormat: 'storage'
					with: tool) result targetObject.
			self assert: (content isKindOf: GtLLepiterPageStorageContent).
			json := content llmJsonObject.
			self assert: json isDictionary.
			self assert: (json at: '__type') equals: 'page'.
			self
				assert: (NeoJSONWriter toString: json)
				equals: (LeJsonV4 uniqueInstance serialize: page).
			readPage := LeJsonV4 uniqueInstance
					deserialize: (NeoJSONWriter toString: json) readStream.
			self assert: readPage uid equals: page uid.
			self
				assert: (readPage allChildrenDepthFirst collect: [ :each | each uidString ]) asArray
				equals: (page allChildrenDepthFirst collect: [ :each | each uidString ]) asArray.
			content ]
]

{ #category : #examples }
GtLToolForLepiterPageContentsExamples >> structureFormat [
	"The structure format has the snippet tree with the ids the snippet tools take and the own attributes of each snippet: no metadata, no default values"

	<gtExample>
	^ self
		withFormatsPageDo: [ :tool :page :database | 
			| content json snippets text child example picture |
			content := (self
					contentOfPage: page
					inFormat: 'structure'
					with: tool) result targetObject.
			self assert: (content isKindOf: GtLLepiterPageStructureContent).
			json := content llmJsonObject.
			self
				assert: json keys asArray
				equals: #('pageTitle' 'pageUid' 'databaseId' 'snippets').
			self assert: (json at: 'pageUid') equals: page uid asString36.
			self assert: (json at: 'databaseId') equals: database uuidString.
			snippets := json at: 'snippets'.
			self assert: snippets size equals: 3.
			text := snippets first.
			self
				assert: text keys asArray
				equals: #('snippetUid' 'type' 'string' 'children').
			self assert: (text at: 'snippetUid') equals: page children first uidString.
			self assert: (text at: 'type') equals: 'textSnippet'.
			self assert: (text at: 'string') equals: 'Some **bold** text'.
			child := (text at: 'children') first.
			self assert: child keys asArray equals: #('snippetUid' 'type' 'code').
			self
				assert: (child at: 'snippetUid')
				equals: page children first children first uidString.
			self assert: (child at: 'type') equals: 'pharoSnippet'.
			self assert: (child at: 'code') equals: '1 + 2'.
			example := snippets second.
			self
				assert: example keys asArray
				equals: #('snippetUid' 'type' 'exampleBehaviorName' 'exampleSelector').
			self assert: (example at: 'exampleBehaviorName') equals: self class name.
			picture := snippets third.
			self assert: picture keys asArray equals: #('snippetUid' 'type' 'url').
			self assert: (picture at: 'url') equals: 'https://example.com/picture.png'.
			content ]
]

{ #category : #examples }
GtLToolForLepiterPageContentsExamples >> structureMetadataComesFromLepiter [
	"The metadata that the structure format leaves out is what Lepiter maps for every snippet, plus the keys of the format itself"

	<gtExample>
	| keys |
	keys := GtLLepiterPageStructureContent metadataKeys.
	self
		assert: keys asSortedCollection asArray
		equals: #('children' 'createEmail' 'createTime' 'editEmail' 'editTime' 'uid').
	self assert: (GtLLepiterPageStructureContent isMetadataKey: '__type').
	self assert: (GtLLepiterPageStructureContent isMetadataKey: '__schema').
	self assert: (GtLLepiterPageStructureContent isMetadataKey: 'string') not.
	self
		assert: (GtLLepiterPageStructureContent isMetadataKey: 'paragraphStyle') not.
	^ keys
]

{ #category : #examples }
GtLToolForLepiterPageContentsExamples >> unknownFormatIsRefused [
	"The schema refuses a format that is not one of the three, naming the value and the formats in JSON; called without the schema, the tool refuses it too"

	<gtExample>
	^ self
		withFormatsPageDo: [ :tool :page :database | 
			| call problem |
			call := self
					contentOfPage: page
					inFormat: 'html'
					with: tool.
			self assert: call result targetObject isErrorDomainObject.
			self
				assert: call result targetObject errorMessage
				equals: '@[format] "html" not part of enum ["markdown","structure","storage"]'.
			problem := GtLLepiterPageContent
					forFormat: 'html'
					ifUnknown: [ :aProblem | aProblem ].
			self assert: problem isErrorDomainObject.
			self
				assert: problem errorMessage
				equals: 'Unknown format html: the format is one of markdown, structure, storage'.
			call ]
]

{ #category : #private }
GtLToolForLepiterPageContentsExamples >> withFormatsPageDo: aBlock [
	"Evaluate aBlock with a tool reading an in-memory database, a page of that database and the database. The page has a text snippet with a Pharo child, an example snippet and a picture snippet"

	| database page tool |
	database := LeExplicitlyAttachedLinksExamples new primaryDatabase.
	page := database pageBuilder
			title: 'Page in three formats';
			add.
	page addSnippet: (LeTextSnippet string: 'Some **bold** text').
	page children first addSnippet: (LePharoSnippet code: '1 + 2').
	page
		addSnippet: (LeExampleSnippet new
				exampleBehaviorName: self class name;
				exampleSelector: #pageSerializationWithMissingDatabaseId;
				yourself).
	page
		addSnippet: (LePictureSnippet new
				urlString: 'https://example.com/picture.png';
				yourself).
	tool := GtLToolForLepiterPageContents new.
	tool database: (LeLogicalDatabase new primaryDB: database).
	^ aBlock
		value: tool
		value: page
		value: database
]
