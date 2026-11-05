Class {
	#name : #GtLToolForApplyRefactoring,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #Gt4LlmCore
}

{ #category : #private }
GtLToolForApplyRefactoring >> applyPreview: aPreview [
	[aPreview apply] on: Error
		do: [:anError | ^GtLExceptionDomainObject freeze: anError].
	^aPreview
]

{ #category : #accessing }
GtLToolForApplyRefactoring >> description [
	^'Applies a refactoring previewed with previewRefactoring. Takes the objectId returned by previewRefactoring and executes the previewed changes on the live system. A preview can be applied only once.

Example JSON arguments:
{"objectId": "abc123"}

Example JSON response:
{"changes": [{"changeDescription": "MySuperclass>>foo", "newSource": "foo\r\t^ 42"}], "objectId": "abc123", "applied": true}'
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
