"
I am the renameClass tool: I rename a class or trait at once, with its references in code and in Lepiter snippets, through the RenameClass transformation ({{gtClass:GtLRenameClassSpecification}}). I store the result ({{gtClass:GtLRefactoringResult}}) and answer a report of it ({{gtClass:GtLRefactoringResultReport}}) built for the displayOptions of the call.
"
Class {
	#name : #GtLMagritteToolForClassRename,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #private }
GtLMagritteToolForClassRename >> applySpecification: aSpecification inContext: anExecutionContext [
	"Go through the transformations, as previewRefactoring does, so that the changes are linked to the refactoring. Name the changes: the undo history shows the name.
	Store the result, as applyRefactoring does: the response gives its objectId, and the result keeps all the changes, also when the response does not list them"

	| transformations namespace result |
	transformations := GtLCodeTransformations new transformations: {aSpecification}.
	namespace := transformations applyRefactoring.
	namespace name: aSpecification gtDisplayString.
	result := (GtLRefactoringPreview
			namespace: namespace
			refactoringName: transformations refactoringName
			refactoringDescription: transformations refactoringDescription
			changeGroupNames: transformations changeGroupNames) apply.
	anExecutionContext objectStorage
		ifNotNil: [ :aStorage | 
			result
				objectId: (aStorage
						addNewObject: result
						reason: (GtLStoredObjectStringReason text: 'Class rename result')) ].
	^ result
]

{ #category : #magritte }
GtLMagritteToolForClassRename >> classNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Class name';
		accessor: #className;
		comment: 'The current name of the class or trait to rename.';
		beRequired
]

{ #category : #accessing }
GtLMagritteToolForClassRename >> description [
	^ 'Renames a class or trait at once. It rewrites the references in all methods, including symbols such as #MyClass, and in all Lepiter snippets: code snippets, example snippets, and class, method and example annotations in text snippets. Comments, strings and plain text are not changed. To see the changes first, use previewRefactoring with a RenameClass, then applyRefactoring.

The response is the one of applyRefactoring for a grouped preview: the status, refactoringName, refactoringDescription, changesCount, objectId of the stored result and, unless includeChanges is false, classChanges, methodChanges and lepiterChanges. When the rename fails partway, errorMessage says why, and the changes made before the error, which stay in the image, are listed, except the Lepiter changes.

A refused rename (unknown class, a class side, an invalid or used new name) answers an errorMessage; a refusal of the refactoring engine answers an errorReason.

Example JSON arguments:
{"className": "MyClass", "newClassName": "MyRenamedClass"}

Example JSON response:
{"status": "applied", "refactoringName": "Rename class", "refactoringDescription": "Rename class MyClass to MyRenamedClass", "changesCount": 3, "objectId": "abc123", "classChanges": {"totalCount": 2, "displayedCount": 2, "kindCounts": {"changed class": 1, "renamed class": 1}, "classes": [{"kind": "renamed class", "className": "MyClass", "newClassName": "MyRenamedClass"}, {"kind": "changed class", "className": "MySubclass"}]}, "methodChanges": {"totalCount": 1, "displayedCount": 1, "kindCounts": {"modified method": 1}, "methods": [{"kind": "modified method", "methodClassName": "MyUser", "methodName": "create", "classSide": false}]}, "lepiterChanges": {"totalSnippetsCount": 0, "displayedSnippetsCount": 0, "totalPagesCount": 0, "displayedPagesCount": 0, "totalDatabasesCount": 0, "displayedDatabasesCount": 0, "kindCounts": {}, "databases": []}}

Example JSON response when the rename is refused:
{"errorMessage": "MyOtherClass is already the name of a class or global variable"}'
]

{ #category : #magritte }
GtLMagritteToolForClassRename >> displayOptionsDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		label: 'Display options';
		accessor: #displayOptions;
		classes: {GtLRefactoringResultDisplayOptions};
		beOptional
]

{ #category : #accessing }
GtLMagritteToolForClassRename >> name [
	^ 'renameClass'
]

{ #category : #magritte }
GtLMagritteToolForClassRename >> newClassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'New class name';
		accessor: #newClassName;
		comment: 'The new name of the class or trait.';
		beRequired
]

{ #category : #'tool api' }
GtLMagritteToolForClassRename >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	"The JSON schema has already checked that both names are given"

	| specification problems |
	specification := GtLRenameClassSpecification new
			className: (aToolCall arguments at: 'className');
			newClassName: (aToolCall arguments at: 'newClassName');
			yourself.
	problems := specification gtProblems.
	problems
		ifNotEmpty: [ ^ GtLProblemDomainObject new
				errorMessage: ('; ' join: (problems collect: [ :each | each description ])) ].
	^ self
		renameClassWith: specification
		displayOptions: (GtLRefactoringResultDisplayOptions
				fromArguments: aToolCall arguments)
		inContext: anExecutionContext
]

{ #category : #private }
GtLMagritteToolForClassRename >> renameClassWith: aSpecification displayOptions: aDisplayOptions inContext: anExecutionContext [
	"Answer a report of the result, built for the display options of the call. A failure while executing the changes is reported by the result itself"

	| result |
	result := [ self
			applySpecification: aSpecification
			inContext: anExecutionContext ]
			on: Error
			do: [ :anError | 
				^ (GtLExceptionDomainObject freeze: anError)
					errorReason: 'Error while renaming class';
					yourself ].
	^ result reportFor: aDisplayOptions
]
