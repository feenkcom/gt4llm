"
I show how the reports of refactoring previews and applied refactorings ({{gtClass:GtLRefactoringChangeGroupsReport}} and its groups) list, limit and write the changes.
"
Class {
	#name : #GtLRefactoringReportExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLRefactoringReportExamples >> changeGroupsListTheCoveredGroups [
	"The groups are split by the sort of their changes and limited by the display options. The groups the refactoring covers are in the JSON also when they are empty; the other groups only when they have changes"

	<gtExample>
	<return: #GtLRefactoringChangeGroupsReport>
	| groups json |
	groups := GtLRefactoringChangeGroupsReport
			entries: {self classEntryNamed: 'MySubclass' kind: 'changed class'.
					self
						methodEntryNamed: 'create'
						in: 'MyUser'
						classSide: false}
			displayOptions: (GtLRefactoringDisplayOptions new
					methodsLimit: 0;
					includeSources: false;
					yourself)
			groupNames: #('classChanges' 'methodChanges' 'lepiterChanges').
	self assert: groups classChanges totalCount equals: 1.
	self assert: groups methodChanges totalCount equals: 1.
	self assert: groups methodChanges displayedCount equals: 0.
	self assert: groups lepiterChanges isEmpty.
	self assert: groups otherChanges isEmpty.
	json := NeoJSONObject new.
	groups addJsonPropertiesTo: json.
	self
		assert: json keys asArray
		equals: #('classChanges' 'methodChanges' 'lepiterChanges').
	self assert: ((json at: 'methodChanges') at: 'methods') isEmpty.
	self
		assert: ((json at: 'methodChanges') at: 'kindCounts')
		equals: (NeoJSONObject new
				at: 'modified method' put: 1;
				yourself).
	self assert: ((json at: 'lepiterChanges') at: 'totalSnippetsCount') equals: 0.
	self assert: ((json at: 'lepiterChanges') at: 'databases') isEmpty.
	^ groups
]

{ #category : #examples }
GtLRefactoringReportExamples >> changesOfRenamedClassUseItsNewName [
	"A method removed from a class that the same refactoring renames, before the rename, is listed under the new name, as the other changes of the renamed class"

	<gtExample>
	<return: #GtLRefactoringChangeGroupsReport>
	| groups json |
	groups := GtLRefactoringChangeGroupsReport
			entries: {GtLRefactoringClassChangeEntry new
						kind: 'renamed class';
						className: 'MyClass';
						newClassName: 'MyRenamedClass';
						yourself.
					(self
						methodEntryNamed: 'old'
						in: 'MyClass'
						classSide: false)
						kind: 'removed method';
						yourself.
					self
						methodEntryNamed: 'create'
						in: 'MyUser'
						classSide: false}
			displayOptions: GtLRefactoringDisplayOptions new
			groupNames: #('classChanges' 'methodChanges' 'lepiterChanges').
	json := NeoJSONObject new.
	groups addJsonPropertiesTo: json.
	self
		assert: (((json at: 'classChanges') at: 'classes') first at: 'className')
		equals: 'MyClass'.
	self
		assert: (((json at: 'methodChanges') at: 'methods')
				collect: [ :each | each at: 'methodClassName' ]) asSet
		equals: #('MyRenamedClass' 'MyUser') asSet.
	^ groups
]

{ #category : #examples }
GtLRefactoringReportExamples >> classChangesListRenamesFirst [
	"The renamed class comes first, then the changed classes by name. As the list is cut, nextOffset tells where the next classes start"

	<gtExample>
	<return: #GtLRefactoringClassChangesReport>
	| report |
	report := GtLRefactoringClassChangesReport
			entries: {self classEntryNamed: 'MySubclassB' kind: 'changed class'.
					(self classEntryNamed: 'MyClass' kind: 'renamed class')
						newClassName: 'MyRenamedClass';
						yourself.
					self classEntryNamed: 'MySubclassA' kind: 'changed class'}
			limit: 2
			includeSources: true.
	self assert: report totalCount equals: 3.
	self assert: report displayedCount equals: 2.
	self
		assert: (report displayedEntries collect: [ :each | each className ]) asArray
		equals: #('MyClass' 'MySubclassA').
	self
		assert: report llmJsonObject
		equals: (NeoJSONObject new
				at: 'totalCount' put: 3;
				at: 'displayedCount' put: 2;
				at: 'nextOffset' put: 2;
				at: 'kindCounts'
					put: (NeoJSONObject new
							at: 'changed class' put: 2;
							at: 'renamed class' put: 1;
							yourself);
				at: 'classes'
					put: {NeoJSONObject new
								at: 'kind' put: 'renamed class';
								at: 'className' put: 'MyClass';
								at: 'newClassName' put: 'MyRenamedClass';
								yourself.
							NeoJSONObject new
								at: 'kind' put: 'changed class';
								at: 'className' put: 'MySubclassA';
								yourself};
				yourself).
	^ report
]

{ #category : #private }
GtLRefactoringReportExamples >> classEntryNamed: aClassName kind: aKind [
	^ GtLRefactoringClassChangeEntry new
		className: aClassName;
		kind: aKind;
		yourself
]

{ #category : #examples }
GtLRefactoringReportExamples >> classLevelChangeNamesWhatChanges [
	"A slot change is listed with the class and the change description, which names the slot"

	<gtExample>
	<return: #NeoJSONObject>
	| anEntry json |
	anEntry := (GtLRefactoringChange
			fromChange: (RBRemoveInstanceVariableChange
					remove: 'changeDescription'
					from: GtLRefactoringChange)) asChangeEntry.
	json := anEntry llmJsonObjectIncludingSources: true.
	self
		assert: json
		equals: (NeoJSONObject new
				at: 'kind' put: 'removed slot';
				at: 'className' put: 'GtLRefactoringChange';
				at: 'changeDescription'
					put: 'Remove instance variable changeDescription from GtLRefactoringChange';
				yourself).
	^ json
]

{ #category : #examples }
GtLRefactoringReportExamples >> exampleSnippetChangeNewSource [
	"The new text of an example snippet is computed from the change without changing the snippet"

	<gtExample>
	<return: #LeExampleSnippetChange>
	| aSnippet aChange |
	aSnippet := LeExampleSnippet new
			exampleBehaviorName: #GtLRefactoringReportExamples;
			exampleSelector: #exampleSnippetChangeNewSource;
			yourself.
	aChange := aSnippet
			changeToRenameClass: 'GtLRefactoringReportExamples'
			to: 'MyRenamedExamples'.
	self
		assert: aChange gtLlmNewSource
		equals: '{{gtExample:MyRenamedExamples >> #exampleSnippetChangeNewSource}}'.
	self
		assert: aSnippet contentAsString
		equals: '{{gtExample:GtLRefactoringReportExamples >> #exampleSnippetChangeNewSource}}'.
	^ aChange
]

{ #category : #examples }
GtLRefactoringReportExamples >> failedGroupedApplyListsAppliedChanges [
	"After a failure, the response has the error and lists the changes made before it, also when the changes were not wanted. The Lepiter changes are known too, from the snapshot taken after the failure: their group is listed, empty here"

	<gtExample>
	<return: #NeoJSONObject>
	| applied json |
	applied := GtLRefactoringCodeChangesExamples new
			failedRefactoringReportsAppliedChanges.
	applied preview
		changeGroupNames: #('classChanges' 'methodChanges' 'lepiterChanges').
	json := (GtLRefactoringResultReport
			refactoring: applied
			displayOptions: (GtLRefactoringResultDisplayOptions new includeChanges: false))
			llmJsonObject.
	self assert: (json at: 'status') equals: 'failed'.
	self assert: (json at: 'errorMessage') notEmpty.
	self assert: ((json at: 'methodChanges') at: 'totalCount') equals: 1.
	self assert: ((json at: 'classChanges') at: 'totalCount') equals: 0.
	self assert: ((json at: 'lepiterChanges') at: 'totalSnippetsCount') equals: 0.
	self assert: (json includesKey: 'codeChanges') not.
	^ json
]

{ #category : #examples }
GtLRefactoringReportExamples >> lepiterChangesLimitedToTheFirstSnippets [
	"20 snippets in 4 databases, 5 in each. With a limit of 4, the first 4 snippets are listed: they are all in the first database"

	<gtExample>
	<return: #GtLRefactoringLepiterChangesReport>
	| report aDatabaseReport |
	report := GtLRefactoringLepiterChangesReport
			entries: (self snippetEntriesInDatabases: 4)
			limit: 4
			includeSources: true.
	self assert: report totalSnippetsCount equals: 20.
	self assert: report displayedSnippetsCount equals: 4.
	self assert: report totalPagesCount equals: 8.
	self assert: report displayedPagesCount equals: 2.
	self assert: report totalDatabasesCount equals: 4.
	self assert: report displayedDatabasesCount equals: 1.
	aDatabaseReport := report displayedDatabaseReports first.
	self assert: aDatabaseReport totalSnippetsCount equals: 5.
	self assert: aDatabaseReport displayedSnippetsCount equals: 4.
	self assert: aDatabaseReport totalPagesCount equals: 2.
	self assert: aDatabaseReport displayedPagesCount equals: 2.
	self
		assert: (aDatabaseReport displayedPageReports collect: [ :each | each pageTitle ])
				asArray
		equals: #('Page 1-1' 'Page 1-2').
	self
		assert: (aDatabaseReport displayedPageReports
				collect: [ :each | each displayedSnippetsCount ]) asArray
		equals: #(3 1).
	self
		assert: (aDatabaseReport displayedPageReports
				collect: [ :each | each totalSnippetsCount ]) asArray
		equals: #(3 2).
	self
		assert: report kindCounts
		equals: (NeoJSONObject new
				at: 'modified snippet' put: 20;
				yourself).
	^ report
]

{ #category : #examples }
GtLRefactoringReportExamples >> lepiterChangesSerialization [
	"Without sources, a snippet has only its kind and uid; its database and page are given by the groups. As the list is cut, nextOffset tells where the next snippets start"

	<gtExample>
	<return: #NeoJSONObject>
	| report json |
	report := GtLRefactoringLepiterChangesReport
			entries: (self snippetEntriesInDatabases: 2)
			limit: 1
			includeSources: false.
	json := report llmJsonObject.
	self
		assert: json
		equals: (NeoJSONObject new
				at: 'totalSnippetsCount' put: 10;
				at: 'displayedSnippetsCount' put: 1;
				at: 'nextOffset' put: 1;
				at: 'totalPagesCount' put: 4;
				at: 'displayedPagesCount' put: 1;
				at: 'totalDatabasesCount' put: 2;
				at: 'displayedDatabasesCount' put: 1;
				at: 'kindCounts'
					put: (NeoJSONObject new
							at: 'modified snippet' put: 10;
							yourself);
				at: 'databases'
					put: {NeoJSONObject new
								at: 'databaseId' put: 'database-1';
								at: 'databaseName' put: 'Database 1';
								at: 'totalSnippetsCount' put: 5;
								at: 'displayedSnippetsCount' put: 1;
								at: 'totalPagesCount' put: 2;
								at: 'displayedPagesCount' put: 1;
								at: 'pages'
									put: {NeoJSONObject new
												at: 'pageUid' put: 'page-1-1';
												at: 'pageTitle' put: 'Page 1-1';
												at: 'totalSnippetsCount' put: 3;
												at: 'displayedSnippetsCount' put: 1;
												at: 'snippets'
													put: {NeoJSONObject new
																at: 'kind' put: 'modified snippet';
																at: 'snippetUid' put: 'snippet-1-1-1';
																yourself};
												yourself};
								yourself};
				yourself).
	^ json
]

{ #category : #examples }
GtLRefactoringReportExamples >> lepiterChangesWithSources [
	"With sources, a snippet has its new text, in the form editLepiterSnippet accepts"

	<gtExample>
	<return: #GtLRefactoringLepiterChangesReport>
	| report aSnippetJson |
	report := GtLRefactoringLepiterChangesReport
			entries: (self snippetEntriesInDatabases: 1)
			limit: 1
			includeSources: true.
	aSnippetJson := (((report llmJsonObject at: 'databases') first at: 'pages')
			first at: 'snippets') first.
	self
		assert: (aSnippetJson at: 'newSource')
		equals: 'Uses {{gtClass:MyRenamedClass}}'.
	^ report
]

{ #category : #examples }
GtLRefactoringReportExamples >> lepiterChangesWithZeroLimit [
	"Only the counts are given"

	<gtExample>
	<return: #GtLRefactoringLepiterChangesReport>
	| report |
	report := GtLRefactoringLepiterChangesReport
			entries: (self snippetEntriesInDatabases: 2)
			limit: 0
			includeSources: true.
	self assert: report totalSnippetsCount equals: 10.
	self assert: report displayedSnippetsCount equals: 0.
	self assert: report displayedPagesCount equals: 0.
	self assert: report displayedDatabasesCount equals: 0.
	self assert: (report llmJsonObject at: 'databases') isEmpty.
	self assert: report totalDatabasesCount equals: 2.
	^ report
]

{ #category : #examples }
GtLRefactoringReportExamples >> lepiterChangesWithoutLimit [
	<gtExample>
	<return: #GtLRefactoringLepiterChangesReport>
	| report |
	report := GtLRefactoringLepiterChangesReport
			entries: (self snippetEntriesInDatabases: 4)
			limit: GtLRefactoringDisplayOptions defaultLimit
			includeSources: true.
	self assert: report displayedSnippetsCount equals: 20.
	self assert: report displayedPagesCount equals: 8.
	self assert: report displayedDatabasesCount equals: 4.
	self
		assert: (report displayedDatabaseReports
				collect: [ :each | each displayedPageReports first pageTitle ]) asArray
		equals: #('Page 1-1' 'Page 2-1' 'Page 3-1' 'Page 4-1').
	^ report
]

{ #category : #examples }
GtLRefactoringReportExamples >> lepiterPagesSortedByTitleThenUid [
	"Pages are sorted by title, then by uid: a title that is a prefix of another comes first"

	<gtExample>
	<return: #GtLRefactoringLepiterChangesReport>
	| entries report |
	entries := #('Page 2' 'Page')
			withIndexCollect: [ :aTitle :anIndex | 
				GtLRefactoringSnippetChangeEntry new
					databaseId: 'database';
					databaseName: 'Database';
					pageUid: 'page-' , anIndex printString;
					pageTitle: aTitle;
					position: 1;
					snippetUid: 'snippet-' , anIndex printString;
					kind: 'modified snippet';
					yourself ].
	report := GtLRefactoringLepiterChangesReport
			entries: entries
			limit: 1
			includeSources: false.
	self
		assert: (report databaseReports first pageReports collect: [ :each | each pageTitle ])
		equals: #('Page' 'Page 2').
	self assert: report displayedEntries first == entries last.
	^ report
]

{ #category : #examples }
GtLRefactoringReportExamples >> lepiterSnippetsOrderedByRecordedPosition [
	"In a page, the snippets are listed in the depth-first order recorded in their entries, and databases without id (in memory) are grouped together"

	<gtExample>
	<return: #GtLRefactoringLepiterChangesReport>
	| entries report |
	entries := #(3 1 2)
			collect: [ :aPosition | 
				GtLRefactoringSnippetChangeEntry new
					pageUid: 'page';
					pageTitle: 'Page';
					position: aPosition;
					snippetUid: 'snippet-' , aPosition printString;
					kind: 'modified snippet';
					yourself ].
	report := GtLRefactoringLepiterChangesReport
			entries: entries
			limit: 10
			includeSources: false.
	self assert: report totalDatabasesCount equals: 1.
	self assert: report databaseReports first databaseId isNil.
	self
		assert: (report displayedEntries collect: [ :each | each snippetUid ]) asArray
		equals: #('snippet-1' 'snippet-2' 'snippet-3').
	self
		assert: ((report llmJsonObject at: 'databases') first includesKey: 'databaseId') not.
	^ report
]

{ #category : #examples }
GtLRefactoringReportExamples >> methodChangesAreSortedAndLimited [
	"By class, instance side first, then by selector. The source is listed only when it is wanted"

	<gtExample>
	<return: #GtLRefactoringMethodChangesReport>
	| report entries |
	entries := {self
				methodEntryNamed: 'b'
				in: 'MyUser'
				classSide: false.
			self
				methodEntryNamed: 'a'
				in: 'MyUser'
				classSide: true.
			self
				methodEntryNamed: 'a'
				in: 'MyUser'
				classSide: false.
			self
				methodEntryNamed: 'c'
				in: 'AnotherUser'
				classSide: false}.
	report := GtLRefactoringMethodChangesReport
			entries: entries
			limit: 3
			includeSources: true.
	self assert: report totalCount equals: 4.
	self assert: report displayedCount equals: 3.
	self
		assert: (report displayedEntries collect: [ :each | each target ]) asArray
		equals: #('AnotherUser>>#c' 'MyUser>>#a' 'MyUser>>#b').
	self
		assert: (report entries collect: [ :each | each target ]) last
		equals: 'MyUser class>>#a'.
	self
		assert: ((report llmJsonObject at: 'methods') first at: 'newSource')
		equals: 'c ^ MyRenamedClass'.
	self
		assert: (((GtLRefactoringMethodChangesReport
				entries: entries
				limit: 3
				includeSources: false) llmJsonObject at: 'methods')
				noneSatisfy: [ :each | each includesKey: 'newSource' ]).
	^ report
]

{ #category : #examples }
GtLRefactoringReportExamples >> methodChangesCanBeListedFromAnOffset [
	"From an offset, the entries after the first ones are listed; nextOffset tells where the next ones start, and is left out once the last entry is listed"

	<gtExample>
	<return: #GtLRefactoringMethodChangesReport>
	| entries page lastPage json |
	entries := (1 to: 5)
			collect: [ :index | 
				self
					methodEntryNamed: 'method' , index printString
					in: 'MyClass'
					classSide: false ].
	page := GtLRefactoringMethodChangesReport
			entries: entries
			offset: 2
			limit: 2
			includeSources: false.
	self
		assert: (page displayedEntries collect: [ :each | each methodName ]) asArray
		equals: #('method3' 'method4').
	json := page llmJsonObject.
	self assert: (json at: 'offset') equals: 2.
	self assert: (json at: 'displayedCount') equals: 2.
	self assert: (json at: 'nextOffset') equals: 4.
	lastPage := GtLRefactoringMethodChangesReport
			entries: entries
			offset: 4
			limit: 2
			includeSources: false.
	self assert: lastPage displayedCount equals: 1.
	self assert: (lastPage llmJsonObject includesKey: 'nextOffset') not.
	self
		assert: (GtLRefactoringMethodChangesReport
				entries: entries
				offset: 7
				limit: 2
				includeSources: false) displayedCount
		equals: 0.
	^ page
]

{ #category : #private }
GtLRefactoringReportExamples >> methodEntryNamed: aSelector in: aClassName classSide: aBoolean [
	^ GtLRefactoringMethodChangeEntry new
		methodClassName: aClassName;
		methodName: aSelector;
		classSide: aBoolean;
		kind: 'modified method';
		newSource: aSelector , ' ^ MyRenamedClass';
		yourself
]

{ #category : #examples }
GtLRefactoringReportExamples >> otherChangesAreListedWhenPresent [
	"Changes that are neither class, method nor Lepiter changes, such as a package change, are listed in otherChanges, all of them, with their kind and target"

	<gtExample>
	<return: #NeoJSONObject>
	| groups json others |
	groups := GtLRefactoringChangeGroupsReport
			entries: {GtLRefactoringOtherChangeEntry new
						kind: 'changed package';
						target: 'MyPackage';
						yourself}
			displayOptions: (GtLRefactoringDisplayOptions new
					classesLimit: 0;
					methodsLimit: 0;
					snippetsLimit: 0;
					yourself)
			groupNames: #('classChanges' 'methodChanges' 'lepiterChanges').
	json := NeoJSONObject new.
	groups addJsonPropertiesTo: json.
	self
		assert: json keys asArray
		equals: #('classChanges' 'methodChanges' 'lepiterChanges' 'otherChanges').
	others := json at: 'otherChanges'.
	self assert: (others at: 'totalCount') equals: 1.
	self assert: (others at: 'displayedCount') equals: 1.
	self
		assert: (others at: 'changes') first
		equals: (NeoJSONObject new
				at: 'kind' put: 'changed package';
				at: 'target' put: 'MyPackage';
				yourself).
	^ json
]

{ #category : #examples }
GtLRefactoringReportExamples >> reportViewsShownForAToolCall [
	"A tool call shows the views of its answer that are marked with gtLlmView. A report first links the views of its preview or result, only the ones that apply, then shows its own: the JSON the agent got, its groups when grouped, and the display options of the call"

	<gtExample>
	<return: #GtLRefactoringPreviewReport>
	| report titles |
	report := GtLRefactoringPreviewReport
			refactoring: GtLRefactoringPreviewExamples new refactoringPreview
			displayOptions: GtLRefactoringDisplayOptions new.
	titles := ((GtPhlowViewsCollector new
			pragmaName: #gtLlmView;
			fromObject: report;
			collect) reject: [ :each | each isKindOf: GtPhlowEmptyView ])
			collect: [ :each | each title asString ].
	self
		assert: titles asArray
		equals: #('Diff' 'Refactoring changes' 'New sources' 'Report JSON' 'Display options').
	^ report
]

{ #category : #private }
GtLRefactoringReportExamples >> snippetEntriesInDatabases: aNumberOfDatabases [
	"Return the entries of changed snippets in aNumberOfDatabases databases, each with a page of three snippets and a page of two. Entries hold the values recorded from snapshots, not snippets, so no Lepiter database is needed"

	| entries |
	entries := OrderedCollection new.
	1
		to: aNumberOfDatabases
		do: [ :eachDatabaseIndex | 
			#(3 2)
				withIndexDo: [ :aSnippetsCount :aPageIndex | 
					1
						to: aSnippetsCount
						do: [ :eachSnippetIndex | 
							entries
								add: (GtLRefactoringSnippetChangeEntry new
										databaseId: 'database-' , eachDatabaseIndex printString;
										databaseName: 'Database ' , eachDatabaseIndex printString;
										pageUid: 'page-' , eachDatabaseIndex printString , '-' , aPageIndex printString;
										pageTitle: 'Page ' , eachDatabaseIndex printString , '-' , aPageIndex printString;
										position: eachSnippetIndex;
										snippetUid: 'snippet-' , eachDatabaseIndex printString , '-' , aPageIndex printString , '-'
												, eachSnippetIndex printString;
										kind: 'modified snippet';
										newSource: 'Uses {{gtClass:MyRenamedClass}}';
										yourself) ] ] ].
	^ entries asArray
]
