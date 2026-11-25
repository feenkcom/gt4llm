"
I am the applyRefactoring tool: I apply a stored preview ({{gtClass:GtLRefactoringPreview}}) once, store its result ({{gtClass:GtLRefactoringResult}}) and answer a report of the result ({{gtClass:GtLRefactoringResultReport}}) built for the displayOptions of the call.
"
Class {
	#name : #GtLToolForApplyRefactoring,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #Gt4LlmCore
}

{ #category : #private }
GtLToolForApplyRefactoring >> alreadyAppliedMessageFor: aPreview id: anObjectId [
	"An applied preview is not applied again: its changes are in the image. After a failure, a new preview starts from the code as it is now"

	| resultPart |
	resultPart := (aPreview result ifNotNil: [ :aResult | aResult objectId ])
			ifNil: [ '' ]
			ifNotNil: [ :aResultId | ' (result ' , aResultId , ')' ].
	^ aPreview applicationStatus = 'applied'
		ifTrue: [ anObjectId , ' was already applied' , resultPart
				, ': its changes are in the image' ]
		ifFalse: [ anObjectId , ' was already applied and failed' , resultPart
				, ': the changes made before the error stay in the image. To retry, preview the refactoring again; the new preview starts from the code as it is now' ]
]

{ #category : #private }
GtLToolForApplyRefactoring >> applyPreview: aPreview displayOptions: aDisplayOptions inContext: anExecutionContext [
	"Store the result, which keeps all the applied changes, and answer a report of it built for the display options of the call.
	Errors raised while applying are reported by the result itself; this handler only covers unexpected errors"

	| result |
	result := [ aPreview apply ]
			on: Error
			do: [ :anError | ^ GtLExceptionDomainObject freeze: anError ].
	result
		objectId: (anExecutionContext objectStorage
				addNewObject: result
				reason: (GtLStoredObjectStringReason text: 'Refactoring result')).
	^ result reportFor: aDisplayOptions
]

{ #category : #accessing }
GtLToolForApplyRefactoring >> description [
	^ 'Applies all the changes of a preview made by previewRefactoring or previewRewrite, also the ones the preview did not list, and stores the result. A preview is applied only once, also when applying it fails.

The response has the status (applied or failed), refactoringName, refactoringDescription, changesCount and objectId, the id of the stored result. Unless includeChanges is false, it lists what changed in the image: for a preview with a changes list, codeChanges, each with a kind and a target; for a grouped preview, the groups of previewRefactoring except otherChanges, built from what changed in the image, so their counts can differ from the preview. getRefactoringChanges lists the changes the response does not.

When applying fails, errorMessage says why, and the changes made before the error, which stay in the image, are listed, except the Lepiter changes. To retry, preview again.

A refused call (unknown objectId, an object that is not a preview, a preview already applied) answers an errorMessage.

Example JSON arguments:
{"objectId": "abc123"}

Example JSON response:
{"status": "applied", "refactoringName": "Push up method", "refactoringDescription": "Push up method foo from MySubclass to MySuperclass", "changesCount": 2, "objectId": "def456", "codeChanges": [{"kind": "added method", "target": "MySuperclass>>#foo"}, {"kind": "removed method", "target": "MySubclass>>#foo"}]}

Example JSON arguments, without the applied changes:
{"objectId": "abc124", "displayOptions": {"includeChanges": false}}

Example JSON response:
{"status": "applied", "refactoringName": "Rename class", "refactoringDescription": "Rename class MyClass to MyRenamedClass", "changesCount": 5, "objectId": "def457"}'
]

{ #category : #descriptions }
GtLToolForApplyRefactoring >> displayOptionsDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		label: 'Display options';
		accessor: #displayOptions;
		classes: {GtLRefactoringResultDisplayOptions};
		beOptional
]

{ #category : #accessing }
GtLToolForApplyRefactoring >> name [
	^'applyRefactoring'
]

{ #category : #descriptions }
GtLToolForApplyRefactoring >> objectIdDescription [
	<magritteDescription>
	^(MAStringDescription new)
		label: 'Object id';
		accessor: #objectId;
		beRequired
]

{ #category : #private }
GtLToolForApplyRefactoring >> previewWithId: anObjectId inContext: anExecutionContext ifNone: aBlock [
	"Return the stored preview with the id, if it can be applied, or the value of aBlock with the problem"

	| storage object |
	storage := anExecutionContext objectStorage
			ifNil: [ ^ aBlock
					value: (GtLMissingInformationDomainObject new missingModelName: 'objectStorage') ].
	object := storage
			objectAt: anObjectId
			ifPresent: [ :each | each ]
			ifAbsent: [ ^ aBlock
					value: (GtLMissingDomainObject new objectName: anObjectId) ].
	(object isKindOf: GtLRefactoringResult)
		ifTrue: [ ^ aBlock
				value: (self
						problem: anObjectId
								, ' is the result of an applied refactoring, not a preview: its changes are already in the image') ].
	(object isKindOf: GtLRefactoringPreview)
		ifFalse: [ ^ aBlock value: (self problem: anObjectId , ' is not a refactoring preview') ].
	object isApplied
		ifTrue: [ ^ aBlock
				value: (self problem: (self alreadyAppliedMessageFor: object id: anObjectId)) ].
	^ object
]

{ #category : #execution }
GtLToolForApplyRefactoring >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	"The JSON schema has already checked the types of the arguments"

	| objectId preview |
	objectId := aToolCall arguments at: 'objectId'.
	objectId trimBoth isEmpty
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
				arguments: aToolCall arguments;
				missingArgument: 'objectId' ].
	preview := self
			previewWithId: objectId
			inContext: anExecutionContext
			ifNone: [ :aProblem | ^ aProblem ].
	^ self
		applyPreview: preview
		displayOptions: (GtLRefactoringResultDisplayOptions
				fromArguments: aToolCall arguments)
		inContext: anExecutionContext
]

{ #category : #private }
GtLToolForApplyRefactoring >> problem: aString [
	^ GtLProblemDomainObject new errorMessage: aString
]
