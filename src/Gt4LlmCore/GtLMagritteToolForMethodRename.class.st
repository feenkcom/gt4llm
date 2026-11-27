"
I am the renameMethod tool: I rename a method at once through the RenameMethod transformation ({{gtClass:GtLRenameMethodSpecification}}). The rename is global: every implementor of the selector in the image, all its senders and the Lepiter snippets that mention it. I store the result ({{gtClass:GtLRefactoringResult}}) and answer a report of it ({{gtClass:GtLRefactoringResultReport}}) built for the displayOptions of the call.
"
Class {
	#name : #GtLMagritteToolForMethodRename,
	#superclass : #GtLAbstractMagritteToolForTransformation,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #magritte }
GtLMagritteToolForMethodRename >> classSideDescription [
	<magritteDescription>
	^ MABooleanDescription new
		label: 'Class side';
		accessor: #classSide;
		comment: 'True for a method of the class side.';
		beRequired
]

{ #category : #accessing }
GtLMagritteToolForMethodRename >> description [
	^ 'Renames a method at once, everywhere. The rename is global: it renames every implementor of the selector in all classes and traits, not only in methodClassName and its hierarchy, and rewrites all the methods that send it or name it as a symbol, such as #foo, and all the Lepiter snippets that mention it, in all databases. A common selector can change many unrelated classes. Strings and comments are not changed, so code that builds a selector from a string still uses the old one. The new selector must take the same number of arguments. To see the changes first, use previewRefactoring with a RenameMethod, then applyRefactoring.

The response is the one of applyRefactoring for a grouped preview: the status, refactoringName, refactoringDescription, changesCount, objectId of the stored result and, unless includeChanges is false, methodChanges and lepiterChanges. Each implementor is listed as removed under the old selector and added under the new one, each sender as modified. When the rename fails partway, errorMessage says why, and the changes made before the error, to code and to Lepiter snippets, stay in the image and are listed.

A refused rename (an unknown, inherited or trait-provided method, an invalid new selector, a different number of arguments, a new selector already defined in the hierarchy of an implementor, a trait composition that aliases or excludes the selector) answers an errorMessage; a refusal of the refactoring engine answers an errorReason.

Example JSON arguments:
{"methodClassName": "MyClass", "classSide": false, "methodNameToRename": "total", "newMethodName": "sum"}

Example JSON response:
{"status": "applied", "refactoringName": "Rename method", "refactoringDescription": "Rename method MyClass>>#total to sum", "changesCount": 3, "objectId": "abc123", "methodChanges": {"totalCount": 3, "displayedCount": 3, "kindCounts": {"added method": 1, "modified method": 1, "removed method": 1}, "methods": [{"kind": "added method", "methodClassName": "MyClass", "methodName": "sum", "classSide": false}, {"kind": "removed method", "methodClassName": "MyClass", "methodName": "total", "classSide": false}, {"kind": "modified method", "methodClassName": "MyReport", "methodName": "printOn:", "classSide": false}]}, "lepiterChanges": {"totalSnippetsCount": 0, "displayedSnippetsCount": 0, "totalPagesCount": 0, "displayedPagesCount": 0, "totalDatabasesCount": 0, "displayedDatabasesCount": 0, "kindCounts": {}, "databases": []}}

Example JSON response when the rename is refused:
{"errorMessage": "sum is already defined in the hierarchy of an implementor of total, which the rename renames: MyClass (sum in MySuperclass). The renamed methods would override these methods or be overridden by them"}'
]

{ #category : #private }
GtLMagritteToolForMethodRename >> errorReason [
	^ 'Error while renaming method'
]

{ #category : #magritte }
GtLMagritteToolForMethodRename >> methodClassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Class name';
		accessor: #methodClassName;
		comment: 'The name of a class or trait that defines the method, without " class": classSide tells the side.';
		beRequired
]

{ #category : #magritte }
GtLMagritteToolForMethodRename >> methodNameToRenameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Method name to rename';
		accessor: #methodNameToRename;
		comment: 'The current selector of the method, such as foo or at:put:.';
		beRequired
]

{ #category : #accessing }
GtLMagritteToolForMethodRename >> name [
	^ 'renameMethod'
]

{ #category : #magritte }
GtLMagritteToolForMethodRename >> newMethodNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'New method name';
		accessor: #newMethodName;
		comment: 'The new selector. It must take the same number of arguments as the current one.';
		beRequired
]

{ #category : #private }
GtLMagritteToolForMethodRename >> resultDescription [
	^ 'Method rename result'
]

{ #category : #private }
GtLMagritteToolForMethodRename >> specificationFromArguments: aDictionary [
	^ GtLRenameMethodSpecification new
		methodClassName: (aDictionary at: 'methodClassName');
		classSide: (aDictionary at: 'classSide');
		methodNameToRename: (aDictionary at: 'methodNameToRename');
		newMethodName: (aDictionary at: 'newMethodName');
		yourself
]
