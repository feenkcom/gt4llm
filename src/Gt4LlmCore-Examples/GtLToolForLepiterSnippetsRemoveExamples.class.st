Class {
	#name : #GtLToolForLepiterSnippetsRemoveExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> copiesInTwoDatabasesAreRemovedInOneCall [
	"The same page and snippet ids in two databases are two snippets: with their databaseIds, both are removed in one call. A request without databaseId after them is answered as already removed"

	<gtExample>
	^ GtLToolForLepiterSnippetsEditExamples new
		withCopiedPageInTwoDatabasesDo: [ :aLogicalDatabase :theDatabases :theSnippets | 
			| theArguments call results |
			theArguments := (1 to: 2)
					collect: [ :anIndex | 
						Dictionary new
							at: 'databaseId' put: (theDatabases at: anIndex) uuidString;
							at: 'pageUid' put: (theSnippets at: anIndex) page uidString;
							at: 'snippetUid' put: (theSnippets at: anIndex) uidString;
							yourself ].
			call := self
					executeTool: (GtLToolForLepiterSnippetsRemove new
							database: aLogicalDatabase;
							yourself)
					withArguments: {'snippets'
								-> (theArguments asArray
										, {theArguments first copy
													removeKey: 'databaseId';
													yourself})} asDictionary.
			results := call result targetObject snippets.
			self
				assert: ((results first: 2) collect: [ :each | each status ]) asArray
				equals: #('removed' 'removed').
			self
				assert: ((results first: 2) collect: [ :each | each targetSnippetReference databaseId ])
						asArray
				equals: (theDatabases collect: [ :each | each uuidString ]) asArray.
			self
				assert: (results third errorMessage
						includesSubstring: 'was already removed earlier in this call').
			self assert: (theSnippets allSatisfy: [ :each | each page isNil ]).
			call ]
]

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> emptyPageUid [
	"Test behavior when pageUid is an empty string.
	The schema accepts empty strings, but the tool logic validates it."

	<gtExample>
	| call targetObject |
	call := self
			executeTool: GtLToolForLepiterSnippetsRemove new
			withArguments: {'snippets'
						-> {Dictionary new
									at: 'pageUid' put: '';
									at: 'snippetUid' put: UUID new asString;
									yourself}} asDictionary.
	targetObject := call result targetObject.	"Empty string passes schema validation, tool proceeds to handle it"
	self assert: (targetObject isKindOf: GtLLepiterSnippetsChangeResult).
	self assert: targetObject snippets size equals: 1.	"The snippet removal should return a missing argument error"
	self
		assertMissingArgument: targetObject snippets first
		withArgumentName: 'pageUid'
		errorMessage: 'Missing argument called pageUid'.

	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> emptySnippetUid [
	"Test behavior when snippetUid is an empty string.
	The schema accepts empty strings, but the tool logic validates it."

	<gtExample>
	| call targetObject |
	call := self
			executeTool: GtLToolForLepiterSnippetsRemove new
			withArguments: {'snippets'
						-> {Dictionary new
									at: 'pageUid' put: UUID new asString;
									at: 'snippetUid' put: '';
									yourself}} asDictionary.
	targetObject := call result targetObject.	"Empty string passes schema validation, tool proceeds to handle it"
	self assert: (targetObject isKindOf: GtLLepiterSnippetsChangeResult).
	self assert: targetObject snippets size equals: 1.	"The snippet removal should return a missing argument error"
	self
		assertMissingArgument: targetObject snippets first
		withArgumentName: 'snippetUid'
		errorMessage: 'Missing argument called snippetUid'.

	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> missingSnippetPageUid [
	<gtExample>
	| call targetObject |
	call := self
			executeTool: GtLToolForLepiterSnippetsRemove new
			withArguments: {'snippets'
						-> {Dictionary new
									at: 'snippetUid' put: 'invalid';
									yourself}} asDictionary.
	targetObject := call result targetObject.

	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('pageUid')
		path: #('snippets' 1)
		errorMessage: '@[snippets/1] required properties missing [pageUid]'.

	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> missingSnippetUid [
	<gtExample>
	| call targetObject |
	call := self
			executeTool: GtLToolForLepiterSnippetsRemove new
			withArguments: {'snippets'
						-> {Dictionary new
									at: 'pageUid' put: UUID new asString;
									yourself}} asDictionary.
	targetObject := call result targetObject.

	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('snippetUid')
		path: #('snippets' 1)
		errorMessage: '@[snippets/1] required properties missing [snippetUid]'.

	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> missingSnippets [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForLepiterSnippetsRemove new
		withArguments: Dictionary new.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('snippets')
		path: #(nil)
		errorMessage: 'required properties missing [snippets]'.
	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> multipleSnippetRemoval [
	<gtExample>
	| contentExamples database |
	contentExamples := LeContentExamples new.
	database := contentExamples basicDatabaseWithMonitor.
	[ | call targetObject tool pageOne pageTwo snippetOne snippetTwo |
	pageOne := database pageBuilder
			title: 'one';
			add.
	pageTwo := database pageBuilder
			title: 'two';
			add.
	snippetOne := pageOne snippetBuilder
			string: 'First';
			add.
	snippetTwo := pageTwo snippetBuilder
			string: 'Second';
			add.
	tool := GtLToolForLepiterSnippetsRemove new.
	tool database: database.
	call := self
			executeTool: tool
			withArguments: {'snippets'
						-> {Dictionary new
									at: 'databaseId' put: database uuidString;
									at: 'pageUid' put: pageOne uidString;
									at: 'snippetUid' put: snippetOne uidString;
									yourself.
								Dictionary new
									at: 'databaseId' put: database uuidString;
									at: 'pageUid' put: pageTwo uidString;
									at: 'snippetUid' put: snippetTwo uidString;
									yourself}} asDictionary.
	targetObject := call result targetObject.
	self assert: targetObject snippets size equals: 2.
	self assert: targetObject snippets first status equals: 'removed'.
	self assert: targetObject snippets second status equals: 'removed'.
	self assert: pageOne children isEmpty.
	self assert: pageTwo children isEmpty.
	^ call ] ensure: [ contentExamples stopDatabaseMonitor ]
]

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> nilPageUid [
	"Test that a null pageUid is caught by JSON schema validation."

	<gtExample>
	| call targetObject |
	call := self
			executeTool: GtLToolForLepiterSnippetsRemove new
			withArguments: {'snippets'
						-> {Dictionary new
									at: 'pageUid' put: nil;
									at: 'snippetUid' put: UUID new asString;
									yourself}} asDictionary.
	targetObject := call result targetObject.	"JSON schema validation returns an error for null in required string slot"
	self assert: (targetObject isKindOf: GtLJSONSchemaValidationErrorDomainObject).

	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> nilSnippetUid [
	"Test that a null snippetUid is caught by JSON schema validation."

	<gtExample>
	| call targetObject |
	call := self
			executeTool: GtLToolForLepiterSnippetsRemove new
			withArguments: {'snippets'
						-> {Dictionary new
									at: 'pageUid' put: UUID new asString;
									at: 'snippetUid' put: nil;
									yourself}} asDictionary.
	targetObject := call result targetObject.	"JSON schema validation returns an error for null in required string slot"
	self assert: (targetObject isKindOf: GtLJSONSchemaValidationErrorDomainObject).

	^ call
]

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> removalOfAChildAfterItsParentInOneCall [
	"A snippet listed after its ancestor in the same call was already removed with it: its entry says so, instead of not finding it"

	<gtExample>
	| contentExamples database |
	contentExamples := LeContentExamples new.
	database := contentExamples basicDatabaseWithMonitor.
	[ | page parent child tool call results |
	page := database pageBuilder
			title: 'one';
			add.
	parent := page snippetBuilder
			string: 'Parent';
			add.
	child := LeTextSnippet string: 'Child'.
	parent addSnippet: child.
	tool := GtLToolForLepiterSnippetsRemove new.
	tool database: database.
	call := self
			executeTool: tool
			withArguments: {'snippets'
						-> {Dictionary new
									at: 'pageUid' put: page uidString;
									at: 'snippetUid' put: parent uidString;
									yourself.
								Dictionary new
									at: 'pageUid' put: page uidString;
									at: 'snippetUid' put: child uidString;
									yourself}} asDictionary.
	results := call result targetObject snippets.
	self assert: (results first isKindOf: GtLLepiterSnippetRemovalResult).
	self assert: (results second isKindOf: GtLProblemDomainObject).
	self
		assert: (results second errorMessage
				includesSubstring: 'already removed earlier in this call, with its ancestor ' , parent uidString).
	self assert: page children isEmpty.
	^ call ] ensure: [ contentExamples stopDatabaseMonitor ]
]

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> removalWithChildSnippets [
	"Removing a snippet removes its descendants. Each has a result, depth first, linked to the snippet that was asked for, and the response lists their uids"

	<gtExample>
	| contentExamples database |
	contentExamples := LeContentExamples new.
	database := contentExamples basicDatabaseWithMonitor.
	[ | call tool page parent childOne grandChild childTwo other result |
	page := database pageBuilder
			title: 'one';
			add.
	parent := page snippetBuilder
			string: 'Parent';
			add.
	childOne := LeTextSnippet string: 'Child one'.
	parent addSnippet: childOne.
	grandChild := LePharoSnippet code: '1 + 2'.
	childOne addSnippet: grandChild.
	childTwo := LeTextSnippet string: 'Child two'.
	parent addSnippet: childTwo.
	other := page snippetBuilder
			string: 'Other';
			add.
	tool := GtLToolForLepiterSnippetsRemove new.
	tool database: database.
	call := self
			executeTool: tool
			withArguments: {'snippets'
						-> {Dictionary new
									at: 'pageUid' put: page uidString;
									at: 'snippetUid' put: parent uidString;
									yourself}} asDictionary.
	result := call result targetObject snippets first.
	self assert: (result isKindOf: GtLLepiterSnippetRemovalResult).
	self assert: result removedSnippet contentString equals: 'Parent'.
	self
		assert: (result removedChildResults
				collect: [ :each | each targetSnippetReference snippetUid ])
		equals: {childOne uidString.
				grandChild uidString.
				childTwo uidString}.
	self
		assert: (result removedChildResults
				allSatisfy: [ :each | each removedWithSnippet = result targetSnippetReference ]).
	self
		assert: result removedChildResults second removedSnippet parentSnippetUid
		equals: childOne uidString.
	self
		assert: result removedChildResults second removedSnippet contentString
		equals: '1 + 2'.
	self assert: call result targetObject allChangeResults size equals: 4.
	self assert: page children asArray equals: {other}.
	self
		assert: (self jsonOf: call)
		equals: (Dictionary new
				at: 'snippets'
					put: {Dictionary new
								at: 'status' put: 'removed';
								at: 'targetSnippetReference'
									put: (Dictionary new
											at: 'databaseId' put: database uuidString;
											at: 'pageUid' put: page uidString;
											at: 'snippetUid' put: parent uidString;
											yourself);
								at: 'removedChildSnippetUids'
									put: {childOne uidString.
											grandChild uidString.
											childTwo uidString};
								yourself};
				yourself).
	^ call ] ensure: [ contentExamples stopDatabaseMonitor ]
]

{ #category : #examples }
GtLToolForLepiterSnippetsRemoveExamples >> successfulSnippetRemoval [
	<gtExample>
	| contentExamples database |
	contentExamples := LeContentExamples new.
	database := contentExamples basicDatabaseWithMonitor.
	[ | call targetObject tool page snippet |
	page := database pageBuilder
			title: 'one';
			add.
	snippet := page snippetBuilder
			string: 'Remove me';
			add.
	tool := GtLToolForLepiterSnippetsRemove new.
	tool database: database.
	call := self
			executeTool: tool
			withArguments: {'snippets'
						-> {Dictionary new
									at: 'databaseId' put: database uuidString;
									at: 'pageUid' put: page uidString;
									at: 'snippetUid' put: snippet uidString;
									yourself}} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLLepiterSnippetsChangeResult).
	self assert: targetObject snippets size equals: 1.
	self assert: targetObject snippets first status equals: 'removed'.
	self assert: page children isEmpty.
	^ call ] ensure: [ contentExamples stopDatabaseMonitor ]
]
