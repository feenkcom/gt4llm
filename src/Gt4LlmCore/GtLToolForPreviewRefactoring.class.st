Class {
	#name : #GtLToolForPreviewRefactoring,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForPreviewRefactoring >> description [
	^'Dry-runs one or more refactoring transformations and returns a preview of the resulting changes without applying them. Pass the objectId from the result to applyRefactoring to execute the changes.

Arguments:
- transformations: a JSON array of transformation specs. Each element is an object with a single key naming the transformation (e.g. PushUpMethod) whose value holds the parameters of that transformation. Call listTransformations to get the JSON schema of the available transformations.

Example JSON arguments:
{"transformations": [{"PushUpMethod": {"methodClassName": "MySubclass", "methodNameToPushUp": "foo", "targetClassName": "MySuperclass"}}]}

Example JSON response:
{"changes": [{"changeDescription": "MySuperclass>>foo", "newSource": "foo\r\t^ 42"}, {"changeDescription": "Remove MySubclass>>#foo", "newSource": "Remove MySubclass>>#foo"}], "objectId": "abc123"}'
]

{ #category : #accessing }
GtLToolForPreviewRefactoring >> name [
	^'previewRefactoring'
]

{ #category : #private }
GtLToolForPreviewRefactoring >> previewTransformations: aTransformations inContext: anExecutionContext [
	| preview |
	preview := 
			[GtLRefactoringPreview namespace: aTransformations applyRefactoring]
					on: Error
					do: [:anError | ^GtLExceptionDomainObject freeze: anError].
	preview objectId: (anExecutionContext objectStorage addNewObject: preview
				reason: (GtLStoredObjectStringReason text: 'Refactoring preview')).
	^preview
]

{ #category : #execution }
GtLToolForPreviewRefactoring >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| transformations problems |
	anExecutionContext objectStorage
		ifNil: 
			[^GtLMissingInformationDomainObject new missingModelName: 'objectStorage'].
	transformations := self transformationsClass new
				transformations: (aToolCall arguments at: 'transformations').
	transformations transformations ifEmpty: 
			[^(GtLMissingArgumentDomainObject new)
				arguments: aToolCall arguments;
				missingArgument: 'transformations'].
	problems := transformations gtProblems.
	problems ifNotEmpty: 
			[^GtLProblemDomainObject new errorMessage: 'Invalid transformations: '
						, ('; ' join: (problems collect: [:each | each description]))].
	^self previewTransformations: transformations inContext: anExecutionContext
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
