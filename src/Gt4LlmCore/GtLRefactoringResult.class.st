"
I am the result of applying a {{gtClass:GtLRefactoringPreview}}, with the applyRefactoring tool ({{gtClass:GtLToolForApplyRefactoring}}) or a tool that applies one transformation at once, such as renameClass and renameMethod ({{gtClass:GtLAbstractMagritteToolForTransformation}}). As {{gtClass:GtLMethodsCompilationResult}} for compiled methods, I am the complete record of what happened. These tools store me in the object storage and give my objectId in their response, so that an agent can come back to me.

Once RB changes are applied they compute their diffs against the already changed image, so they no longer show what changed. Therefore I keep:
- `codeChangeResults`: {{gtClass:GtLCodeChangeResult}} objects (method compilations and removals, class modifications, comment changes and removals) built by {{gtClass:GtLRefactoringCodeChangesBuilder}} from snapshots taken before and after applying the changes. The {{gtClass:GtLCodeChangesToolCallsSummarizer}} uses them to summarize refactorings like any other code change;
- `lepiterChangeResults`: {{gtClass:GtLLepiterSnippetChangeResult}} objects (snippet additions, modifications and removals, removed descendants included) built by the same builder from snapshots of the snippets of the Le changes. They are kept apart from the code change results, which the summarizer and the histories take as class and method changes; my change entries and my Code changes view list both;
- `undoChange`: the RB change that reverts the applied changes, as answered by {{gtMethod:GtRefactoryChangeManager>>#performChangeReturningUndo:}}. It is also recorded in the global undo history;
- `exception`: when applying the changes raised an error, the first frozen exception. My status is then 'failed', there is no undo change, and the code and Lepiter change results describe the changes applied before the error;
- `preview`: the preview I was applied from.

I can be large, so the tools do not answer me: they answer a {{gtClass:GtLRefactoringResultReport}} of me, built for the display options of the call. My own views show all my changes; {{gtMethod:GtLRefactoringResult>>#gtReportFor:}} shows a report with the default display options.
"
Class {
	#name : #GtLRefactoringResult,
	#superclass : #Object,
	#instVars : [
		'preview',
		'undoChange',
		'codeChangeResults',
		'lepiterChangeResults',
		'exception',
		'objectId'
	],
	#category : #Gt4LlmCore
}

{ #category : #'instance creation' }
GtLRefactoringResult class >> preview: aRefactoringPreview undoChange: anUndoChange codeChangeResults: aCollection lepiterChangeResults: aCollectionOfSnippetResults exception: anExceptionDomainObject [
	"anUndoChange is the change that reverts the applied changes (nil if applying failed).
	aCollection holds the GtLCodeChangeResult objects describing what changed in the code, aCollectionOfSnippetResults the GtLLepiterSnippetChangeResult objects describing what changed in Lepiter.
	anExceptionDomainObject is nil, or the frozen exception raised while applying the changes."

	^ self new
		initializePreview: aRefactoringPreview
		undoChange: anUndoChange
		codeChangeResults: aCollection
		lepiterChangeResults: aCollectionOfSnippetResults
		exception: anExceptionDomainObject
]

{ #category : #accessing }
GtLRefactoringResult >> allChangeResults [
	"Return the code change results, then the Lepiter snippet change results"

	^ self codeChangeResults , self lepiterChangeResults
]

{ #category : #accessing }
GtLRefactoringResult >> changeEntries [
	"Return the entries that list the applied changes in the groups of a report: the code change results and the Lepiter snippet change results. Both are built from snapshots, also after a failure, when they describe the changes made before the error"

	^ (self allChangeResults collect: [ :each | each llmChangeEntry ]) asArray
]

{ #category : #accessing }
GtLRefactoringResult >> changeGroupNames [
	"My changes are listed in the groups of my preview"

	preview ifNil: [ ^ #() ].
	^ preview changeGroupNames
]

{ #category : #accessing }
GtLRefactoringResult >> changesCount [
	^preview changesCount
]

{ #category : #accessing }
GtLRefactoringResult >> codeChangeResults [
	"Return the GtLCodeChangeResult objects describing the methods and classes changed by the refactoring"

	^ codeChangeResults ifNil: [ #() ]
]

{ #category : #accessing }
GtLRefactoringResult >> errorMessage [
	"Return the message of the exception raised while applying the changes, or nil"

	^ exception ifNotNil: [ :anException | anException messageText ]
]

{ #category : #accessing }
GtLRefactoringResult >> exception [
	"Return the frozen exception (a GtLExceptionDomainObject) raised while applying the changes, or nil"

	^ exception
]

{ #category : #accessing }
GtLRefactoringResult >> groupsChanges [
	^ self changeGroupNames notEmpty
]

{ #category : #views }
GtLRefactoringResult >> gtChangesFor: aView [
	"The change results (GtLCodeChangeResult and GtLLepiterSnippetChangeResult) describe what the refactoring changed in the image and in Lepiter. They are the main view; the refactoring changes (GtLRefactoringChange) that produced them are shown by #gtRefactoringChangesFor:"

	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'Code changes';
		priority: 1;
		items: [ self allChangeResults ];
		column: ''
			stencil: [ :each | each gtViewChangeIcon asElement ]
			width: 26;
		column: 'Change'
			text: [ :each | each llmChangeKind ]
			width: 160;
		column: 'Target' text: [ :each | each gtViewChangeTarget ];
		send: [ :each | each ];
		actionButtonIcon: BrGlamorousVectorIcons inspect
			tooltip: 'Inspect the preview'
			action: [ :aButton | aButton phlow spawnObject: preview ]
]

{ #category : #views }
GtLRefactoringResult >> gtErrorFor: aView [
	<gtView>
	self hasFailed ifFalse: [ ^ aView empty ].
	^ aView forward
		title: 'Error';
		priority: 0;
		object: [ exception ];
		view: #gtExceptionStackFor:
]

{ #category : #views }
GtLRefactoringResult >> gtRefactoringChangesFor: aView [
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
GtLRefactoringResult >> gtReportFor: aView [
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

{ #category : #views }
GtLRefactoringResult >> gtStatusFor: aView [
	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'Status';
		priority: 3;
		items: [ | items |
			items := OrderedCollection new.
			self refactoringName ifNotNil: [ :aName | items add: 'Refactoring' -> aName ].
			self refactoringDescription
				ifNotNil: [ :aDescription | items add: 'Description' -> aDescription ].
			items
				add: 'Status' -> self status;
				add: 'Changes count' -> self changesCount;
				add: 'Code changes' -> self codeChangeResults size.
			self lepiterChangeResults
				ifNotEmpty: [ :aCollection | items add: 'Lepiter changes' -> aCollection size ].
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
GtLRefactoringResult >> hasFailed [
	^ exception notNil
]

{ #category : #initialization }
GtLRefactoringResult >> initializePreview: aRefactoringPreview undoChange: anUndoChange codeChangeResults: aCollection lepiterChangeResults: aCollectionOfSnippetResults exception: anExceptionDomainObject [
	preview := aRefactoringPreview.
	undoChange := anUndoChange.
	codeChangeResults := aCollection asArray.
	lepiterChangeResults := aCollectionOfSnippetResults asArray.
	exception := anExceptionDomainObject
]

{ #category : #testing }
GtLRefactoringResult >> isErrorDomainObject [
	"I am a result even when applying the changes failed: I then describe the changes applied before the error"

	^ false
]

{ #category : #accessing }
GtLRefactoringResult >> lepiterChangeResults [
	"Return the GtLLepiterSnippetChangeResult objects describing the snippets added, changed or removed by the refactoring, removed descendants included. They are kept apart from the code change results, which the summaries and histories take as class and method changes"

	^ lepiterChangeResults ifNil: [ #() ]
]

{ #category : #accessing }
GtLRefactoringResult >> objectId [
	"My id in the object storage, or nil when I am not stored"

	^ objectId
]

{ #category : #accessing }
GtLRefactoringResult >> objectId: aString [
	objectId := aString
]

{ #category : #accessing }
GtLRefactoringResult >> preview [
	^preview
]

{ #category : #printing }
GtLRefactoringResult >> printOn: aStream [
	"The changes are counted as in the responses: the previewed changes"

	super printOn: aStream.
	aStream
		parenthesize: [ self refactoringName
				ifNotNil: [ :aName | 
					aStream
						nextPutAll: aName;
						nextPutAll: ', ' ].
			aStream
				nextPutAll: self status;
				nextPutAll: ', ';
				print: self changesCount;
				nextPutAll: (self changesCount = 1 ifTrue: [ ' change' ] ifFalse: [ ' changes' ]) ]
]

{ #category : #accessing }
GtLRefactoringResult >> refactoringChanges [
	"Return the GtLRefactoringChange objects of the applied preview"

	^ preview ifNil: [ #() ] ifNotNil: [ :aPreview | aPreview changes ]
]

{ #category : #accessing }
GtLRefactoringResult >> refactoringDescription [
	"Return the description of the applied refactoring with its parameters, or nil if unknown"

	^ preview ifNotNil: [ :aPreview | aPreview refactoringDescription ]
]

{ #category : #accessing }
GtLRefactoringResult >> refactoringName [
	"Return the short name of the applied refactoring, such as 'Push up method', or nil if unknown"

	^ preview ifNotNil: [ :aPreview | aPreview refactoringName ]
]

{ #category : #accessing }
GtLRefactoringResult >> report [
	"Return a report of my changes with the default display options, as my view shows it"

	^ self reportFor: GtLRefactoringResultDisplayOptions new
]

{ #category : #accessing }
GtLRefactoringResult >> reportFor: aDisplayOptions [
	"Return a report of my changes built for the display options of a tool call"

	^ GtLRefactoringResultReport refactoring: self displayOptions: aDisplayOptions
]

{ #category : #accessing }
GtLRefactoringResult >> status [
	^ self hasFailed ifTrue: [ 'failed' ] ifFalse: [ 'applied' ]
]

{ #category : #accessing }
GtLRefactoringResult >> undoChange [
	"Return the RB change that reverts the applied changes, or nil if applying them failed.
	It is the same change that was recorded in the undo history of GtRefactoryChangeManager."

	^ undoChange
]
