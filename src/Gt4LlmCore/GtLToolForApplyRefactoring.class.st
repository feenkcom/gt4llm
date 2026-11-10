Class {
	#name : #GtLToolForApplyRefactoring,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #Gt4LlmCore
}

{ #category : #private }
GtLToolForApplyRefactoring >> applyPreview: aPreview [
	"Errors raised while executing the changes are reported by the applied refactoring itself;
	this handler only covers errors raised while collecting or snapshotting the affected code"

	^ [ aPreview apply ]
		on: Error
		do: [ :anError | GtLExceptionDomainObject freeze: anError ]
]

{ #category : #accessing }
GtLToolForApplyRefactoring >> description [
	^'Applies a refactoring previewed with previewRefactoring or previewRewrite. Takes the objectId returned by the preview and executes the previewed changes on the live system. A preview can be applied only once.

Example JSON arguments:
{"objectId": "abc123"}

Example JSON response:
{"status": "applied", "changesCount": 1}'
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

{ #category : #execution }
GtLToolForApplyRefactoring >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| objectId preview |
	objectId := aToolCall arguments at: 'objectId'.
	objectId trimBoth isEmpty
		ifTrue: 
			[^(GtLMissingArgumentDomainObject new)
				arguments: aToolCall arguments;
				missingArgument: 'objectId'].
	anExecutionContext objectStorage
		ifNil: 
			[^GtLMissingInformationDomainObject new missingModelName: 'objectStorage'].
	preview := anExecutionContext objectStorage
				objectAt: objectId
				ifPresent: [:each | each]
				ifAbsent: [^GtLMissingDomainObject new objectName: objectId].
	(preview isKindOf: GtLRefactoringPreview)
		ifFalse: 
			[^GtLProblemDomainObject new
				errorMessage: objectId , ' is not a refactoring preview'].
	preview isApplied
		ifTrue: 
			[^GtLProblemDomainObject new
				errorMessage: objectId , ' was already applied'].
	^self applyPreview: preview
]
