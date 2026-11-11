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
		'appliedRefactoring',
		'refactoringName',
		'refactoringDescription'
	],
	#category : #Gt4LlmCore
}

{ #category : #'instance creation' }
GtLRefactoringPreview class >> namespace: aNamespace [
	^self new initializeNamespace: aNamespace
]

{ #category : #'instance creation' }
GtLRefactoringPreview class >> namespace: aNamespace refactoringName: aNameString refactoringDescription: aDescriptionString [
	^ self new
		initializeNamespace: aNamespace
		refactoringName: aNameString
		refactoringDescription: aDescriptionString
]

{ #category : #accessing }
GtLRefactoringPreview >> applicationStatus [
	"Return 'not applied', 'applied' or 'failed' (when applying raised an error after applying some of the changes)"

	^ appliedRefactoring
		ifNil: [ 'not applied' ]
		ifNotNil: [ :anAppliedRefactoring | anAppliedRefactoring status ]
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

{ #category : #initialization }
GtLRefactoringPreview >> initializeNamespace: aNamespace refactoringName: aNameString refactoringDescription: aDescriptionString [
	self initializeNamespace: aNamespace.
	refactoringName := aNameString.
	refactoringDescription := aDescriptionString
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

{ #category : #printing }
GtLRefactoringPreview >> printOn: aStream [
	super printOn: aStream.
	aStream
		parenthesize: [ refactoringName
				ifNotNil: [ :aName | 
					aStream
						nextPutAll: aName;
						nextPutAll: ': ' ].
			aStream
				print: self changesCount;
				nextPutAll: (self changesCount = 1 ifTrue: [ ' change' ] ifFalse: [ ' changes' ]);
				nextPutAll: ', ';
				nextPutAll: self applicationStatus ]
]

{ #category : #accessing }
GtLRefactoringPreview >> refactoringDescription [
	"Return a description of the previewed refactoring with its parameters, such as 'Push up method foo from MySubclass to MySuperclass', or nil if unknown"

	^ refactoringDescription
]

{ #category : #descriptions }
GtLRefactoringPreview >> refactoringDescriptionDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Refactoring description';
		accessor: #refactoringDescription;
		yourself
]

{ #category : #accessing }
GtLRefactoringPreview >> refactoringName [
	"Return a short name of the previewed refactoring, such as 'Push up method' or 'Rewrite', or nil if unknown"

	^ refactoringName
]

{ #category : #descriptions }
GtLRefactoringPreview >> refactoringNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Refactoring name';
		accessor: #refactoringName;
		yourself
]
