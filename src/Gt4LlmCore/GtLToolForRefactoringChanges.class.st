"
I am the getRefactoringChanges tool: I list the changes of a stored preview ({{gtClass:GtLRefactoringPreview}}) or result ({{gtClass:GtLRefactoringResult}}) page by page, group by group, so that an agent can go through all the changes of a large refactoring. I answer a report ({{gtClass:GtLRefactoringReport}}) with the same groups as the responses of the other refactoring tools, built for my options ({{gtClass:GtLRefactoringChangesOptions}}).
"
Class {
	#name : #GtLToolForRefactoringChanges,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLToolForRefactoringChanges >> description [
	^ 'Lists the changes of a stored preview (from previewRefactoring or previewRewrite) or result (from applyRefactoring or renameClass) page by page, to go through a large refactoring without getting all its changes at once.

Each group in groups is listed from its offset, in the order of the other responses. While a group has a nextOffset in the response, pass it as the offset to continue. lepiterChanges pages by snippet, so a page can be split between calls.

The response has the status, refactoringName, refactoringDescription, changesCount and objectId, and the groups asked for, with the fields they have in the other responses plus their offset. A preview or result whose changes are not grouped lists them all, whatever the groups.

A refused call (unknown objectId, an object that is not a preview or result, no group, a group the refactoring does not have) answers an errorMessage. After a failed apply, the Lepiter changes are not known.

Example JSON arguments:
{"objectId": "abc123", "groups": {"methodChanges": {"offset": 200, "limit": 100}, "lepiterChanges": {"offset": 50}}}

Example JSON response:
{"status": "applied", "refactoringName": "Rename class", "refactoringDescription": "Rename class MyClass to MyRenamedClass", "changesCount": 377, "objectId": "abc123", "methodChanges": {"totalCount": 320, "displayedCount": 100, "offset": 200, "nextOffset": 300, "kindCounts": {"modified method": 320}, "methods": [{"kind": "modified method", "methodClassName": "MyUser", "methodName": "create", "classSide": false}]}, "lepiterChanges": {"totalSnippetsCount": 55, "displayedSnippetsCount": 5, "offset": 50, "totalPagesCount": 20, "displayedPagesCount": 2, "totalDatabasesCount": 1, "displayedDatabasesCount": 1, "kindCounts": {"modified snippet": 55}, "databases": [{"databaseId": "dklrfmltzaib6womkfkknkfap", "databaseName": "My notes", "totalSnippetsCount": 55, "displayedSnippetsCount": 5, "totalPagesCount": 20, "displayedPagesCount": 2, "pages": [{"pageUid": "86t968o90hlfreacjec76wapk", "pageTitle": "Using MyClass", "totalSnippetsCount": 3, "displayedSnippetsCount": 2, "snippets": [{"kind": "modified snippet", "snippetUid": "SgJekENeTPytZjVknCfulw=="}]}]}]}}'
]

{ #category : #magritte }
GtLToolForRefactoringChanges >> groupsDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		label: 'Groups';
		accessor: #groups;
		classes: {GtLRefactoringChangesGroups};
		beOptional
]

{ #category : #magritte }
GtLToolForRefactoringChanges >> includeSourcesDescription [
	<magritteDescription>
	^ MABooleanDescription new
		label: 'Include sources';
		accessor: #includeSources;
		comment: 'Whether the listed changes have their newSource: the method source, class definition, class comment or snippet text. Defaults to false; with sources, use small limits, such as 20 to 50.';
		beOptional
]

{ #category : #private }
GtLToolForRefactoringChanges >> isRefactoring: anObject [
	^ (anObject isKindOf: GtLRefactoringPreview)
		or: [ anObject isKindOf: GtLRefactoringResult ]
]

{ #category : #accessing }
GtLToolForRefactoringChanges >> name [
	^ 'getRefactoringChanges'
]

{ #category : #magritte }
GtLToolForRefactoringChanges >> objectIdDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Object id';
		accessor: #objectId;
		comment: 'The id of a stored refactoring preview or result.';
		beRequired
]

{ #category : #private }
GtLToolForRefactoringChanges >> pagesIn: anArguments of: aRefactoring id: anObjectId ifInvalid: aBlock [
	"Return the pages of the groups asked for, by group name, or the value of aBlock with the problem.
	The groups are optional in the schema, as the changes of a refactoring that does not group them are listed whole"

	| pages |
	pages := (anArguments at: 'groups' ifAbsent: [ nil ])
			ifNil: [ Dictionary new ]
			ifNotNil: [ :someGroups | someGroups pagesByGroupName ].
	pages
		ifEmpty: [ ^ aBlock
				value: (self problem: 'groups must name at least one group, such as methodChanges') ].
	pages
		keysDo: [ :aGroupName | 
			(self
				problemWithGroup: aGroupName
				of: aRefactoring
				id: anObjectId)
				ifNotNil: [ :aMessage | ^ aBlock value: (self problem: aMessage) ] ].
	^ pages
]

{ #category : #private }
GtLToolForRefactoringChanges >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	"The JSON schema has already checked the types and values of the arguments"

	| arguments objectId refactoring options |
	arguments := aToolCall arguments.
	objectId := arguments at: 'objectId'.
	refactoring := self
			refactoringWithId: objectId
			inContext: anExecutionContext
			ifNone: [ :aProblem | ^ aProblem ].
	options := GtLRefactoringChangesOptions new
			includeSources: (arguments at: 'includeSources' ifAbsent: [ nil ]).
	refactoring groupsChanges
		ifTrue: [ options
				pages: (self
						pagesIn: arguments
						of: refactoring
						id: objectId
						ifInvalid: [ :aProblem | ^ aProblem ]) ].
	^ refactoring reportFor: options
]

{ #category : #private }
GtLToolForRefactoringChanges >> problem: aString [
	^ GtLProblemDomainObject new errorMessage: aString
]

{ #category : #private }
GtLToolForRefactoringChanges >> problemWithGroup: aGroupName of: aRefactoring id: anObjectId [
	"Return why the group cannot be listed, or nil. Other changes can always be asked for"

	(aRefactoring changeGroupNames includes: aGroupName) ifTrue: [ ^ nil ].
	aGroupName = 'otherChanges' ifTrue: [ ^ nil ].
	(aGroupName = 'lepiterChanges' and: [ aRefactoring hasUnknownLepiterChanges ])
		ifTrue: [ ^ 'the Lepiter changes are not known after a failed apply' ].
	^ anObjectId , ' has no ' , aGroupName , '; its groups are '
		, (', ' join: aRefactoring changeGroupNames)
]

{ #category : #private }
GtLToolForRefactoringChanges >> refactoringWithId: anObjectId inContext: anExecutionContext ifNone: aBlock [
	"Return the stored preview or result with the id, or the value of aBlock with the problem"

	| storage object |
	storage := anExecutionContext objectStorage
			ifNil: [ ^ aBlock
					value: (GtLMissingInformationDomainObject new missingModelName: 'objectStorage') ].
	object := storage
			objectAt: anObjectId
			ifPresent: [ :each | each ]
			ifAbsent: [ ^ aBlock
					value: (GtLMissingDomainObject new objectName: anObjectId) ].
	(self isRefactoring: object)
		ifFalse: [ ^ aBlock
				value: (self problem: anObjectId , ' is not a refactoring preview or result') ].
	^ object
]
