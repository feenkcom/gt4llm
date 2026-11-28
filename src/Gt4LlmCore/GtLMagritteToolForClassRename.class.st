"
I am the renameClass tool: I rename a class or trait at once, with its references in code and in Lepiter snippets, through the RenameClass transformation ({{gtClass:GtLRenameClassSpecification}}). I store the result ({{gtClass:GtLRefactoringResult}}) and answer a report of it ({{gtClass:GtLRefactoringResultReport}}) built for the displayOptions of the call.
"
Class {
	#name : #GtLMagritteToolForClassRename,
	#superclass : #GtLAbstractMagritteToolForTransformation,
	#category : #'Gt4LlmCore-Tools'
}

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

The response is the one of applyRefactoring for a grouped preview: the status, refactoringName, refactoringDescription, changesCount, objectId of the stored result and, unless includeChanges is false, classChanges, methodChanges and lepiterChanges. When the rename fails partway, errorMessage says why, and the changes made before the error, to code and to Lepiter snippets, stay in the image and are listed.

A refused rename (unknown class, a class side, an invalid or used new name) answers an errorMessage; a refusal of the refactoring engine answers an errorReason.

Example JSON arguments:
{"className": "MyClass", "newClassName": "MyRenamedClass"}

Example JSON response:
{"status": "applied", "refactoringName": "Rename class", "refactoringDescription": "Rename class MyClass to MyRenamedClass", "changesCount": 3, "objectId": "abc123", "classChanges": {"totalCount": 2, "displayedCount": 2, "kindCounts": {"changed class": 1, "renamed class": 1}, "classes": [{"kind": "renamed class", "className": "MyClass", "newClassName": "MyRenamedClass"}, {"kind": "changed class", "className": "MySubclass"}]}, "methodChanges": {"totalCount": 1, "displayedCount": 1, "kindCounts": {"modified method": 1}, "methods": [{"kind": "modified method", "methodClassName": "MyUser", "methodName": "create", "classSide": false}]}, "lepiterChanges": {"totalSnippetsCount": 0, "displayedSnippetsCount": 0, "totalPagesCount": 0, "displayedPagesCount": 0, "totalDatabasesCount": 0, "displayedDatabasesCount": 0, "kindCounts": {}, "databases": []}}

Example JSON response when the rename is refused:
{"errorMessage": "MyOtherClass is already the name of a class or global variable"}'
]

{ #category : #private }
GtLMagritteToolForClassRename >> errorReason [
	^ 'Error while renaming class'
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

{ #category : #private }
GtLMagritteToolForClassRename >> resultDescription [
	^ 'Class rename result'
]

{ #category : #private }
GtLMagritteToolForClassRename >> specificationFromArguments: aDictionary [
	^ GtLRenameClassSpecification new
		className: (aDictionary at: 'className');
		newClassName: (aDictionary at: 'newClassName');
		yourself
]
