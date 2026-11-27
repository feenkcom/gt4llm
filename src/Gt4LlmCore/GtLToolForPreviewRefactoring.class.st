"
I am the previewRefactoring tool: I preview code transformations ({{gtClass:GtLCodeTransformations}}) without applying them, store the preview ({{gtClass:GtLRefactoringPreview}}) in the object storage, so that applyRefactoring can apply it by its object id, and answer a report of it ({{gtClass:GtLRefactoringPreviewReport}}) built for the displayOptions of the call. The transformations decide whether the preview groups its changes.
"
Class {
	#name : #GtLToolForPreviewRefactoring,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForPreviewRefactoring >> description [
	^ 'Previews refactoring transformations without applying them and stores the preview: pass its objectId to applyRefactoring to apply all its changes. The transformations run in the given order.

The response has refactoringName, refactoringDescription, changesCount, objectId and status (not applied), and lists the changes:
- usually in changes, each with a changeDescription, a kind, a target and, with includeSources, its newSource;
- when a transformation says that it lists its changes in groups (as RenameClass and RenameMethod do), in groups: the groups of all the transformations, also when empty, and otherChanges when there are changes outside them. With a RenameClass, the renamed class is listed under its new name, with its changed methods only; its direct subclasses and trait users are changed classes, as their definitions name it. The snippets are listed by database and page, with the databaseId, pageUid and snippetUid that the snippet tools take.
Each group has a totalCount, a displayedCount, kindCounts and, when its limit cut it, a nextOffset: getRefactoringChanges lists the rest. lepiterChanges has these counts for snippets, pages and databases.

Invalid transformations answer an errorMessage; an error of the refactoring engine answers an errorReason.

Example JSON arguments:
{"transformations": [{"PushUpMethod": {"methodClassName": "MySubclass", "classSide": false, "methodNameToPushUp": "foo", "targetClassName": "MySuperclass"}}], "displayOptions": {"includeSources": true}}

Example JSON response:
{"refactoringName": "Push up method", "refactoringDescription": "Push up method foo from MySubclass to MySuperclass", "changesCount": 2, "objectId": "abc123", "status": "not applied", "changes": [{"changeDescription": "Add MySuperclass>>#foo", "kind": "added method", "target": "MySuperclass>>#foo", "newSource": "foo ^ 42"}, {"changeDescription": "Remove MySubclass>>#foo", "kind": "removed method", "target": "MySubclass>>#foo"}]}

Example JSON arguments of a rename:
{"transformations": [{"RenameClass": {"className": "MyClass", "newClassName": "MyRenamedClass"}}], "displayOptions": {"snippetsLimit": 1}}

Example JSON response:
{"refactoringName": "Rename class", "refactoringDescription": "Rename class MyClass to MyRenamedClass", "changesCount": 5, "objectId": "abc124", "status": "not applied", "classChanges": {"totalCount": 2, "displayedCount": 2, "kindCounts": {"changed class": 1, "renamed class": 1}, "classes": [{"kind": "renamed class", "className": "MyClass", "newClassName": "MyRenamedClass"}, {"kind": "changed class", "className": "MySubclass"}]}, "methodChanges": {"totalCount": 1, "displayedCount": 1, "kindCounts": {"modified method": 1}, "methods": [{"kind": "modified method", "methodClassName": "MyUser", "methodName": "create", "classSide": false}]}, "lepiterChanges": {"totalSnippetsCount": 2, "displayedSnippetsCount": 1, "nextOffset": 1, "totalPagesCount": 2, "displayedPagesCount": 1, "totalDatabasesCount": 1, "displayedDatabasesCount": 1, "kindCounts": {"modified snippet": 2}, "databases": [{"databaseId": "dklrfmltzaib6womkfkknkfap", "databaseName": "My notes", "totalSnippetsCount": 2, "displayedSnippetsCount": 1, "totalPagesCount": 2, "displayedPagesCount": 1, "pages": [{"pageUid": "86t968o90hlfreacjec76wapk", "pageTitle": "Using MyClass", "totalSnippetsCount": 1, "displayedSnippetsCount": 1, "snippets": [{"kind": "modified snippet", "snippetUid": "SgJekENeTPytZjVknCfulw=="}]}]}]}}'
]

{ #category : #descriptions }
GtLToolForPreviewRefactoring >> displayOptionsDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		label: 'Display options';
		accessor: #displayOptions;
		classes: {GtLRefactoringDisplayOptions};
		beOptional
]

{ #category : #accessing }
GtLToolForPreviewRefactoring >> name [
	^'previewRefactoring'
]

{ #category : #private }
GtLToolForPreviewRefactoring >> previewTransformations: aTransformations displayOptions: aDisplayOptions inContext: anExecutionContext [
	"Store the preview, which keeps all its changes, and answer a report of it built for the display options of the call.
	The transformations decide in which groups the changes are listed: in none, one by one, unless one of them can change many methods and snippets"

	| preview |
	preview := [ GtLRefactoringPreview
			namespace: aTransformations applyRefactoring
			refactoringName: aTransformations refactoringName
			refactoringDescription: aTransformations refactoringDescription
			changeGroupNames: aTransformations changeGroupNames ]
			on: Error
			do: [ :anError | 
				^ (GtLExceptionDomainObject freeze: anError)
					errorReason: 'Error while previewing the refactoring';
					yourself ].
	preview
		objectId: (anExecutionContext objectStorage
				addNewObject: preview
				reason: (GtLStoredObjectStringReason text: 'Refactoring preview')).
	^ preview reportFor: aDisplayOptions
]

{ #category : #execution }
GtLToolForPreviewRefactoring >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| transformations problems |
	anExecutionContext objectStorage
		ifNil: [ ^ GtLMissingInformationDomainObject new missingModelName: 'objectStorage' ].
	transformations := self transformationsClass new
			transformations: (aToolCall arguments at: 'transformations').
	transformations transformations
		ifEmpty: [ ^ GtLMissingArgumentDomainObject new
				arguments: aToolCall arguments;
				missingArgument: 'transformations' ].
	problems := transformations gtProblems.
	problems
		ifNotEmpty: [ ^ GtLProblemDomainObject new
				errorMessage: 'Invalid transformations: '
						, ('; ' join: (problems collect: [ :each | each description ])) ].
	^ self
		previewTransformations: transformations
		displayOptions: (GtLRefactoringDisplayOptions
				fromArguments: aToolCall arguments)
		inContext: anExecutionContext
]

{ #category : #accessing }
GtLToolForPreviewRefactoring >> transformationsClass [
	^GtLCodeTransformations
]

{ #category : #descriptions }
GtLToolForPreviewRefactoring >> transformationsDescription [
	<magritteDescription>
	^(MAToManyRelationDescription new)
		label: 'Transformations';
		accessor: #transformations;
		classes: self transformationsClass new allowedTransformationClasses;
		useExplicitContainerForChildren;
		beRequired
]
