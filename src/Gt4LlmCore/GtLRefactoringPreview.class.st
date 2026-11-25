"
I am the plan of a refactoring: what the previewRefactoring and previewRewrite tools compute without applying it. I hold a namespace with the RB changes of the refactoring and all their descriptions ({{gtClass:GtLRefactoringChange}}). These tools store me in the object storage and give my objectId in their response, so that the applyRefactoring tool can apply me.

I can be large, so the tools do not answer me: they answer a {{gtClass:GtLRefactoringPreviewReport}} of me ({{gtMethod:GtLRefactoringPreview>>#reportFor:}}), built for the display options of the call. When my refactoring names groups ({{gtMethod:GtLRefactoringPreview>>#changeGroupNames}}), as a class rename or a rewrite does, the reports list my changes in these groups, each limited and present also when empty; otherwise they list them one by one. My own views show all my changes; {{gtMethod:GtLRefactoringPreview>>#gtReportFor:}} shows a report with the default display options.

{{gtMethod:GtLRefactoringPreview>>#apply}} applies the changes and answers a {{gtClass:GtLRefactoringResult}} describing what changed; I keep it as my `result`, and my views show its changes once I am applied (the RB changes no longer show a diff after being applied).
"
Class {
	#name : #GtLRefactoringPreview,
	#superclass : #Object,
	#instVars : [
		'namespace',
		'objectId',
		'changes',
		'applied',
		'result',
		'refactoringName',
		'refactoringDescription',
		'changeGroupNames'
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

{ #category : #'instance creation' }
GtLRefactoringPreview class >> namespace: aNamespace refactoringName: aNameString refactoringDescription: aDescriptionString changeGroupNames: anArray [
	"Return a preview that lists its changes in the groups named in anArray, or one by one when anArray is empty"

	^ (self
		namespace: aNamespace
		refactoringName: aNameString
		refactoringDescription: aDescriptionString)
		changeGroupNames: anArray;
		yourself
]

{ #category : #accessing }
GtLRefactoringPreview >> applicationStatus [
	"Return 'not applied', 'applied' or 'failed' (when applying raised an error after applying some of the changes, or failed before its result could be built)"

	applied ifFalse: [ ^ 'not applied' ].
	^ result ifNil: [ 'failed' ] ifNotNil: [ :aResult | aResult status ]
]

{ #category : #applying }
GtLRefactoringPreview >> apply [
	"Apply the previewed changes and answer a GtLRefactoringResult.
	The methods and classes affected by the changes are snapshotted before and after applying them, so that the result describes what changed with GtLCodeChangeResult objects. Each of my changes (GtLRefactoringChange) is then linked to the code change result it led to, since the RB changes can no longer compute their diffs once the image contains them.
	If applying the changes or describing them raises an error, the result is marked as failed, holds the frozen exception and describes the changes that could be described.
	I count as applied from the moment the changes start to be performed, also if something fails afterwards: applying me again would apply again the changes already made"

	| targets before undo after exception results |
	targets := GtLRefactoringChangeTargets forChange: namespace changes.
	before := targets snapshotBeforeChanges.
	applied := true.
	[ undo := GtRefactoryChangeManager instance
			performChangeReturningUndo: namespace changes ]
		on: Error
		do: [ :anError | 
			exception := GtLExceptionDomainObject freeze: anError.
			anError return: nil ].
	[ after := targets snapshotAfterChanges.
	results := (GtLRefactoringCodeChangesBuilder
			targets: targets
			before: before
			after: after) build.
	changes do: [ :each | each markAppliedWithCodeChangeResults: results ] ]
		on: Error
		do: [ :anError | 
			exception ifNil: [ exception := GtLExceptionDomainObject freeze: anError ].
			anError return: nil ].
	^ result := GtLRefactoringResult
			preview: self
			undoChange: undo
			codeChangeResults: (results ifNil: [ #() ])
			exception: exception
]

{ #category : #accessing }
GtLRefactoringPreview >> changeEntries [
	"Return the entries that list my changes in the groups of a report"

	^ changes collect: [ :each | each asChangeEntry ]
]

{ #category : #accessing }
GtLRefactoringPreview >> changeGroupNames [
	"Return the names of the groups in which my report lists my changes, each also when it is empty: the kinds of changes my refactoring covers. Without names, my changes are listed one by one"

	^ changeGroupNames ifNil: [ #() ]
]

{ #category : #accessing }
GtLRefactoringPreview >> changeGroupNames: anArray [
	changeGroupNames := anArray
]

{ #category : #accessing }
GtLRefactoringPreview >> changes [
	^changes
]

{ #category : #accessing }
GtLRefactoringPreview >> changesCount [
	^changes size
]

{ #category : #accessing }
GtLRefactoringPreview >> groupsChanges [
	"Return whether my changes are listed in groups, each limited, instead of one by one"

	^ self changeGroupNames notEmpty
]

{ #category : #views }
GtLRefactoringPreview >> gtChangesFor: aView [
	"Before applying, the RB changes of the namespace show their diffs against the image.
	Once applied, they would compute their diffs against the already changed image and show nothing,
	so the view is then replaced by #gtCodeChangesFor:"

	<gtView>
	<gtLlmView>
	result ifNotNil: [ ^ aView empty ].
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
	"Once the preview is applied, the code changes (GtLCodeChangeResult) of its result describe what changed in the image"

	<gtView>
	<gtLlmView>
	result ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Code changes';
		priority: 1;
		object: [ result ];
		view: #gtChangesFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			tooltip: 'Inspect the result'
			action: [ :aButton | aButton phlow spawnObject: result ]
]

{ #category : #views }
GtLRefactoringPreview >> gtNewSourcesFor: aView [
	"The code or text that each change introduces, also when the response does not list it"

	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'New sources';
		priority: 4;
		items: [ changes select: [ :each | each hasNewSource ] ];
		column: 'Kind'
			text: [ :each | each kind ifNil: [ '' ] ]
			width: 160;
		column: 'Target'
			text: [ :each | each target ifNil: [ '' ] ]
			width: 300;
		column: 'New source' text: [ :each | each newSource ];
		send: [ :each | each ]
]

{ #category : #views }
GtLRefactoringPreview >> gtRefactoringChangesFor: aView [
	"The refactoring changes (GtLRefactoringChange), one per basic RB change of the namespace"

	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'Refactoring changes';
		priority: 2;
		items: [ changes ];
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

{ #category : #views }
GtLRefactoringPreview >> gtReportFor: aView [
	"What a report with the default display options lists of me"

	<gtView>
	^ aView forward
		title: 'Report';
		priority: 5;
		object: [ self report ];
		view: #gtJsonFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			tooltip: 'Inspect the report'
			action: [ :aButton | aButton phlow spawnObject: self report ]
]

{ #category : #testing }
GtLRefactoringPreview >> hasUnknownLepiterChanges [
	"A preview knows all its changes"

	^ false
]

{ #category : #initialization }
GtLRefactoringPreview >> initializeNamespace: aNamespace [
	"Describe each basic change, and the changes nested in a class rename.
	A class whose definition changes because it names a renamed class is left out when it is renamed itself: its own rename describes it"

	| allChanges renamedNames |
	namespace := aNamespace.
	applied := false.
	allChanges := aNamespace changes gtBasicChanges
			flatCollect: [ :each | each gtLlmPreviewChanges ].
	renamedNames := (aNamespace changes gtBasicChanges
			select: [ :each | each isKindOf: RBRenameClassChange ])
			collect: [ :each | each oldName asString ].
	changes := (allChanges
			reject: [ :each | 
				(each change isKindOf: GtLRefactoringDefinitionChange)
					and: [ renamedNames includes: each change gtLlmChangeTarget asString ] ])
			asArray
]

{ #category : #initialization }
GtLRefactoringPreview >> initializeNamespace: aNamespace refactoringName: aNameString refactoringDescription: aDescriptionString [
	self initializeNamespace: aNamespace.
	refactoringName := aNameString.
	refactoringDescription := aDescriptionString
]

{ #category : #testing }
GtLRefactoringPreview >> isApplied [
	"Return whether I was applied, also when applying me failed"

	^ applied
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

{ #category : #accessing }
GtLRefactoringPreview >> refactoringName [
	"Return a short name of the previewed refactoring, such as 'Push up method' or 'Rewrite', or nil if unknown"

	^ refactoringName
]

{ #category : #accessing }
GtLRefactoringPreview >> report [
	"Return a report of my changes with the default display options, as my view shows it"

	^ self reportFor: GtLRefactoringDisplayOptions new
]

{ #category : #accessing }
GtLRefactoringPreview >> reportFor: aDisplayOptions [
	"Return a report of my changes built for the display options of a tool call"

	^ GtLRefactoringPreviewReport refactoring: self displayOptions: aDisplayOptions
]

{ #category : #accessing }
GtLRefactoringPreview >> result [
	"Return the GtLRefactoringResult of applying me, or nil while I am not applied"

	^ result
]
