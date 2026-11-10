"
I am the result of the previewRefactoring and previewRewrite tools. I hold a namespace with the RB changes of the previewed refactoring and a JSON friendly description of these changes. I am stored in the object storage, so that the applyRefactoring tool can apply me through my object id.

{{gtMethod:GtLRefactoringPreview>>#apply}} applies the changes and answers a {{gtClass:GtLAppliedRefactoring}} describing what changed; I keep it as `appliedRefactoring`, and my views show its changes once I am applied (the RB changes no longer show a diff after being applied).
"
Class {
	#name : #GtLRefactoringPreview,
	#superclass : #Object,
	#instVars : [
		'namespace',
		'objectId',
		'changes',
		'applied',
		'appliedRefactoring'
	],
	#category : #Gt4LlmCore
}

{ #category : #'instance creation' }
GtLRefactoringPreview class >> namespace: aNamespace [
	^self new initializeNamespace: aNamespace
]

{ #category : #accessing }
GtLRefactoringPreview >> applied [
	^applied
]

{ #category : #descriptions }
GtLRefactoringPreview >> appliedDescription [
	<magritteDescription>
	^(MABooleanDescription new)
		label: 'Applied';
		accessor: #applied;
		beRequired
]

{ #category : #accessing }
GtLRefactoringPreview >> appliedRefactoring [
	"Return the GtLAppliedRefactoring produced by the last attempt to apply me, or nil"

	^ appliedRefactoring
]

{ #category : #applying }
GtLRefactoringPreview >> apply [
	"Apply the previewed changes and answer a GtLAppliedRefactoring.
	The methods and classes affected by the changes are snapshotted 
	before and after applying them,so that the applied refactoring 
	describes what changed with GtLCodeChangeResult objects. Each of 
	my changes (GtLRefactoringChange) is then linked to the code change 
	result it led to, since the RB changes can no longer compute their 
	diffs once the image contains them. If applying the changes raises 
	an error, the applied refactoring is marked as failed, holds the 
	frozen exception and describes the changes that were applied before 
	the error."

	| targets before undo after exception results |
	targets := GtLRefactoringChangeTargets forChange: namespace changes.
	before := targets snapshotBeforeChanges.
	[ undo := GtRefactoryChangeManager instance
			performChangeReturningUndo: namespace changes ]
		on: Error
		do: [ :anError | 
			exception := GtLExceptionDomainObject freeze: anError.
			anError return: nil ].
	after := targets snapshotAfterChanges.
	results := (GtLRefactoringCodeChangesBuilder
			targets: targets
			before: before
			after: after) build.
	changes do: [ :each | each markAppliedWithCodeChangeResults: results ].
	exception ifNil: [ applied := true ].
	^ appliedRefactoring := GtLAppliedRefactoring
			preview: self
			undoChange: undo
			codeChangeResults: results
			exception: exception
]

{ #category : #accessing }
GtLRefactoringPreview >> changes [
	^changes
]

{ #category : #accessing }
GtLRefactoringPreview >> changesCount [
	^changes size
]

{ #category : #descriptions }
GtLRefactoringPreview >> changesCountDescription [
	<magritteDescription>
	^(MANumberDescription new)
		label: 'Changes count';
		accessor: #changesCount;
		beRequired
]

{ #category : #descriptions }
GtLRefactoringPreview >> changesDescription [
	<magritteDescription>
	^(MAToManyRelationDescription new)
		label: 'Changes';
		accessor: #changes;
		classes: (Array with: GtLRefactoringChange);
		beRequired
]

{ #category : #views }
GtLRefactoringPreview >> gtChangesFor: aView [
	"Before applying, the RB changes of the namespace show their diffs against the image.
	Once applied, they would compute their diffs against the already changed image and show nothing,
	so the view is then replaced by #gtCodeChangesFor:"

	<gtView>
	<gtLlmView>
	
	appliedRefactoring ifNotNil: [ ^ aView empty ].
	^ aView forward
		title: 'Diff';
		priority: 3;
		object: [ self namespace ];
		view: #gtApplyingChangesFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			tooltip: 'Inspect preview object'
			action: [ :aButton | aButton phlow spawnObject: self ]
]

{ #category : #views }
GtLRefactoringPreview >> gtCodeChangesFor: aView [
	"Once the preview is applied, the code changes (GtLCodeChangeResult) describe what changed in the image"

	<gtView>
	<gtLlmView>
	appliedRefactoring ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Code changes';
		priority: 1;
		object: [ appliedRefactoring ];
		view: #gtChangesFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			tooltip: 'Inspect the applied refactoring'
			action: [ :aButton | aButton phlow spawnObject: appliedRefactoring ]
]

{ #category : #views }
GtLRefactoringPreview >> gtRefactoringChangesFor: aView [
	"The refactoring changes (GtLRefactoringChange), one per basic RB change of the namespace"

	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'Refactoring changes';
		priority: 2;
		items: [ self changes ifNil: [ #() ] ];
		column: 'Kind'
			text: [ :each | each kind ifNil: [ '' ] ]
			width: 160;
		column: 'Target' text: [ :each | each target ifNil: [ '' ] ];
		column: 'Description' text: [ :each | each changeDescription ifNil: [ '' ] ];
		send: [ :each | each ];
		actionButtonIcon: BrGlamorousVectorIcons inspect
			tooltip: 'Inspect preview object'
			action: [ :aButton | aButton phlow spawnObject: self ]
]

{ #category : #initialization }
GtLRefactoringPreview >> initializeNamespace: aNamespace [
	namespace := aNamespace.
	applied := false.
	changes := (aNamespace changes gtBasicChanges
				collect: [:each | GtLRefactoringChange fromChange: each]) asArray
]

{ #category : #testing }
GtLRefactoringPreview >> isApplied [
	^applied
]

{ #category : #'llm views' }
GtLRefactoringPreview >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	^aDataView magritteObject: [self]
]

{ #category : #accessing }
GtLRefactoringPreview >> namespace [
	^namespace
]

{ #category : #accessing }
GtLRefactoringPreview >> objectId [
	^objectId
]

{ #category : #accessing }
GtLRefactoringPreview >> objectId: aString [
	objectId := aString
]

{ #category : #descriptions }
GtLRefactoringPreview >> objectIdDescription [
	<magritteDescription>
	^(MAStringDescription new)
		label: 'Object id';
		accessor: #objectId;
		beRequired
]
