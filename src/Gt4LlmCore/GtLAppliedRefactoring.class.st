"
I am the result of applying a {{gtClass:GtLRefactoringPreview}} with the applyRefactoring tool ({{gtClass:GtLToolForApplyRefactoring}}).

Once RB changes are applied they compute their diffs against the already changed image, so they no longer show what changed. Therefore I keep:
- `codeChangeResults`: {{gtClass:GtLCodeChangeResult}} objects (method compilations and removals, class modifications, comment changes and removals) built by {{gtClass:GtLRefactoringCodeChangesBuilder}} from snapshots taken before and after applying the changes. The {{gtClass:GtLCodeChangesToolCallsSummarizer}} uses them to summarize refactorings like any other code change;
- `undoChange`: the RB change that reverts the applied changes, as answered by {{gtMethod:GtRefactoryChangeManager>>#performChangeReturningUndo:}}. It is also recorded in the global undo history;
- `exception`: when applying the changes raised an error, the frozen exception. My status is then 'failed', there is no undo change and the code change results describe the changes applied before the error.
"
Class {
	#name : #GtLAppliedRefactoring,
	#superclass : #Object,
	#instVars : [
		'preview',
		'undoChange',
		'codeChangeResults',
		'exception'
	],
	#category : #Gt4LlmCore
}

{ #category : #'instance creation' }
GtLAppliedRefactoring class >> preview: aRefactoringPreview [
	^self new initializePreview: aRefactoringPreview
]

{ #category : #'instance creation' }
GtLAppliedRefactoring class >> preview: aRefactoringPreview undoChange: anUndoChange codeChangeResults: aCollection exception: anExceptionDomainObject [
	"anUndoChange is the change that reverts the applied changes (nil if applying failed).
	aCollection holds the GtLCodeChangeResult objects describing what changed.
	anExceptionDomainObject is nil, or the frozen exception raised while applying the changes."

	^ self new
		initializePreview: aRefactoringPreview
		undoChange: anUndoChange
		codeChangeResults: aCollection
		exception: anExceptionDomainObject
]

{ #category : #accessing }
GtLAppliedRefactoring >> changesCount [
	^preview changesCount
]

{ #category : #descriptions }
GtLAppliedRefactoring >> changesCountDescription [
	<magritteDescription>
	^(MANumberDescription new)
		label: 'Changes count';
		accessor: #changesCount;
		beRequired
]

{ #category : #accessing }
GtLAppliedRefactoring >> codeChangeResults [
	"Return the GtLCodeChangeResult objects describing the methods and classes changed by the refactoring"

	^ codeChangeResults ifNil: [ #() ]
]

{ #category : #accessing }
GtLAppliedRefactoring >> codeChanges [
	"Return a short description (kind and target) of each code change"

	^ self codeChangeResults
		collect: [ :each | self descriptionOfCodeChange: each ]
]

{ #category : #descriptions }
GtLAppliedRefactoring >> codeChangesDescription [
	<magritteDescription>
	^ MAToManyScalarRelationDescription new
		label: 'Code changes';
		accessor: #codeChanges;
		classes: {String};
		yourself
]

{ #category : #accessing }
GtLAppliedRefactoring >> descriptionOfCodeChange: aCodeChangeResult [
	^ (self kindOfCodeChange: aCodeChangeResult) , ' '
		, (self targetOfCodeChange: aCodeChangeResult)
]

{ #category : #accessing }
GtLAppliedRefactoring >> errorMessage [
	"Return the message of the exception raised while applying the changes, or nil"

	^ exception ifNotNil: [ :anException | anException messageText ]
]

{ #category : #descriptions }
GtLAppliedRefactoring >> errorMessageDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Error message';
		accessor: #errorMessage;
		yourself
]

{ #category : #accessing }
GtLAppliedRefactoring >> exception [
	"Return the frozen exception (a GtLExceptionDomainObject) raised while applying the changes, or nil"

	^ exception
]

{ #category : #views }
GtLAppliedRefactoring >> gtChangesFor: aView [
	"The code changes (GtLCodeChangeResult) describe what the refactoring changed in the image. They are the main view; the refactoring changes (GtLRefactoringChange) that produced them are shown by #gtRefactoringChangesFor:"

	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'Code changes';
		priority: 1;
		items: [ self codeChangeResults ];
		column: ''
			stencil: [ :each | each gtViewChangeIcon asElement ]
			width: 26;
		column: 'Change'
			text: [ :each | self kindOfCodeChange: each ]
			width: 160;
		column: 'Target' text: [ :each | self targetOfCodeChange: each ];
		send: [ :each | each ];
		actionButtonIcon: BrGlamorousVectorIcons inspect
			tooltip: 'Inspect the preview'
			action: [ :aButton | aButton phlow spawnObject: preview ]
]

{ #category : #views }
GtLAppliedRefactoring >> gtErrorFor: aView [
	<gtView>
	self hasFailed ifFalse: [ ^ aView empty ].
	^ aView forward
		title: 'Error';
		priority: 0;
		object: [ exception ];
		view: #gtExceptionStackFor:
]

{ #category : #views }
GtLAppliedRefactoring >> gtRefactoringChangesFor: aView [
	"The refactoring changes (GtLRefactoringChange) of the preview that was applied"

	<gtView>
	<gtLlmView>
	preview ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Refactoring changes';
		priority: 2;
		object: [ preview ];
		view: #gtRefactoringChangesFor:
]

{ #category : #views }
GtLAppliedRefactoring >> gtStatusFor: aView [
	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'Status';
		priority: 3;
		items: [ | items |
			items := OrderedCollection new.
			items
				add: 'Status' -> self status;
				add: 'Changes count' -> self changesCount;
				add: 'Code changes' -> self codeChangeResults size.
			self hasFailed ifTrue: [ items add: 'Error' -> exception ].
			undoChange ifNotNil: [ items add: 'Undo change' -> undoChange ].
			items ];
		column: 'Property'
			text: [ :each | each key ]
			width: 150;
		column: 'Value' text: [ :each | each value ];
		send: [ :each | each value ]
]

{ #category : #testing }
GtLAppliedRefactoring >> hasFailed [
	^ exception notNil
]

{ #category : #initialization }
GtLAppliedRefactoring >> initializePreview: aRefactoringPreview [
	preview := aRefactoringPreview
]

{ #category : #initialization }
GtLAppliedRefactoring >> initializePreview: aRefactoringPreview undoChange: anUndoChange codeChangeResults: aCollection exception: anExceptionDomainObject [
	preview := aRefactoringPreview.
	undoChange := anUndoChange.
	codeChangeResults := aCollection asArray.
	exception := anExceptionDomainObject
]

{ #category : #private }
GtLAppliedRefactoring >> isClassRename: aCodeChangeResult [
	^ aCodeChangeResult isClassModificationResult
		and: [ aCodeChangeResult originalClass currentClassName asString
				~= aCodeChangeResult updatedClass currentClassName asString ]
]

{ #category : #testing }
GtLAppliedRefactoring >> isErrorDomainObject [
	"I am a result even when applying the changes failed: I then describe the changes applied before the error"

	^ false
]

{ #category : #accessing }
GtLAppliedRefactoring >> kindOfCodeChange: aCodeChangeResult [
	"Return a short label of the kind of aCodeChangeResult, such as 'added method' or 'removed class'"

	aCodeChangeResult isMethodChangeResult
		ifTrue: [ aCodeChangeResult isMethodRemovalResult ifTrue: [ ^ 'removed method' ].
			aCodeChangeResult isMethodAdditionResult ifTrue: [ ^ 'added method' ].
			^ 'modified method' ].
	aCodeChangeResult isClassChangeResult
		ifTrue: [ aCodeChangeResult isClassRemovalResult ifTrue: [ ^ 'removed class' ].
			aCodeChangeResult isClassAdditionResult ifTrue: [ ^ 'added class' ].
			aCodeChangeResult isClassCommentChangeResult
				ifTrue: [ ^ 'changed class comment' ].
			(self isClassRename: aCodeChangeResult) ifTrue: [ ^ 'renamed class' ].
			^ 'changed class' ].
	^ 'changed'
]

{ #category : #'llm views' }
GtLAppliedRefactoring >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	^aDataView magritteObject: [self]
]

{ #category : #accessing }
GtLAppliedRefactoring >> preview [
	^preview
]

{ #category : #printing }
GtLAppliedRefactoring >> printOn: aStream [
	super printOn: aStream.
	aStream
		parenthesize: [ aStream
				nextPutAll: self status;
				nextPutAll: ', ';
				print: self codeChangeResults size;
				nextPutAll: ' code changes' ]
]

{ #category : #accessing }
GtLAppliedRefactoring >> refactoringChanges [
	"Return the GtLRefactoringChange objects of the applied preview"

	^ preview
		ifNil: [ #() ]
		ifNotNil: [ :aPreview | aPreview changes ifNil: [ #() ] ]
]

{ #category : #accessing }
GtLAppliedRefactoring >> status [
	^ self hasFailed ifTrue: [ 'failed' ] ifFalse: [ 'applied' ]
]

{ #category : #descriptions }
GtLAppliedRefactoring >> statusDescription [
	<magritteDescription>
	^(MAStringDescription new)
		label: 'Status';
		accessor: #status;
		beRequired
]

{ #category : #accessing }
GtLAppliedRefactoring >> targetOfCodeChange: aCodeChangeResult [
	"Return the method signature or class name affected by aCodeChangeResult"

	aCodeChangeResult isMethodChangeResult
		ifTrue: [ ^ aCodeChangeResult targetMethodReference methodSignature ].
	(self isClassRename: aCodeChangeResult)
		ifTrue: [ ^ aCodeChangeResult originalClass currentClassName asString , ' to '
				, aCodeChangeResult updatedClass currentClassName asString ].
	^ aCodeChangeResult targetClassName asString
]

{ #category : #accessing }
GtLAppliedRefactoring >> undoChange [
	"Return the RB change that reverts the applied changes, or nil if applying them failed.
	It is the same change that was recorded in the undo history of GtRefactoryChangeManager."

	^ undoChange
]
