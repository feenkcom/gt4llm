"
I describe one basic change of a refactoring preview (see GtLRefactoringPreview) for an LLM.

I keep the RB change I describe in `change`; it is not serialized. The other properties are computed from it when I am created, against the current image, so I should be created before the change is applied:
- `changeDescription`: the RB change string, e.g. 'Remove MyClass>>#foo';
- `kind`: a short label such as 'added method', 'modified method', 'removed method', 'added slot', 'removed slot', 'changed superclass', 'changed class comment', 'added class' or 'removed class';
- `target`: the method, variable, class or package affected, e.g. 'MyClass>>#foo';
- `newSource`: the method source, class definition or class comment introduced by the change, or nil for changes that carry no code, such as removals.

The kind, target and new source come from the gtLlmChangeKind, gtLlmChangeTarget and gtLlmNewSource extension methods of the RB change classes.
"
Class {
	#name : #GtLRefactoringChange,
	#superclass : #Object,
	#instVars : [
		'changeDescription',
		'newSource',
		'kind',
		'target',
		'change',
		'applied',
		'codeChangeResult'
	],
	#category : #Gt4LlmCore
}

{ #category : #'instance creation' }
GtLRefactoringChange class >> changeDescription: aDescriptionString newSource: aSourceString [
	^self new initializeChangeDescription: aDescriptionString
		newSource: aSourceString
]

{ #category : #'instance creation' }
GtLRefactoringChange class >> fromChange: aRefactoryChange [
	"Describe aRefactoryChange. The kind, target and new source are computed now,
	against the current image, so this should be called before the change is applied"

	^ self new initializeFromChange: aRefactoryChange
]

{ #category : #accessing }
GtLRefactoringChange >> appliedDiffNote [
	"Explain that the applied diff is the one of the code change result, which can contain more than my change"

	| aTarget |
	codeChangeResult ifNil: [ ^ '' ].
	aTarget := codeChangeResult isMethodChangeResult
			ifTrue: [ codeChangeResult targetMethodReference methodSignature ]
			ifFalse: [ codeChangeResult targetClassName asString ].
	^ 'Applied: the code change recorded for ' , aTarget
		, ' when the refactoring was applied. It shows everything the refactoring changed in '
		, aTarget , ', which can be more than this change.'
]

{ #category : #accessing }
GtLRefactoringChange >> change [
	"Return the RB change described by me, or nil if I was created from strings"

	^ change
]

{ #category : #accessing }
GtLRefactoringChange >> changeDescription [
	^changeDescription
]

{ #category : #descriptions }
GtLRefactoringChange >> changeDescriptionDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Change description';
		accessor: #changeDescription;
		priority: 10;
		beRequired
]

{ #category : #accessing }
GtLRefactoringChange >> codeChangeResult [
	"Return the GtLCodeChangeResult describing what my change did to the image once the preview was applied,
	or nil if the preview was not applied or my change did not lead to a code change result
	(for example a protocol change, or a change that was not applied because applying failed before it)"

	^ codeChangeResult
]

{ #category : #accessing }
GtLRefactoringChange >> currentImageDiffNote [
	^ 'Not applied yet: what this change would do, compared to the current image.'
]

{ #category : #'gt views' }
GtLRefactoringChange >> diffElementWithNote: aString diffElement: aDiffElement [
	^ BrVerticalPane new
		matchParent;
		addChild: (BrLabel new
				aptitude: (BrGlamorousLabelAptitude new
						foreground: BrGlamorousColors disabledHeaderTextColor);
				text: aString;
				hMatchParent;
				margin: (BlInsets
						top: 5
						left: 10
						bottom: 5
						right: 10));
		addChild: aDiffElement;
		yourself
]

{ #category : #'gt views' }
GtLRefactoringChange >> gtAppliedDiffFor: aView [
	"Once the preview is applied, show the diff of the code change result recorded for the method or class I changed.
	That code change covers everything the refactoring did to that method or class, so it can contain more than my change
	(for example all the slots of a class that a push up removed)"

	<gtView>
	codeChangeResult ifNil: [ ^ aView empty ].
	^ aView explicit
		title: 'Applied diff';
		priority: 10;
		stencil: [ self
				diffElementWithNote: self appliedDiffNote
				diffElement: codeChangeResult asDiffElement ];
		actionButtonIcon: BrGlamorousVectorIcons inspect
			tooltip: 'Inspect the code change'
			action: [ :aButton | aButton phlow spawnObject: codeChangeResult ]
]

{ #category : #'gt views' }
GtLRefactoringChange >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 5;
		items: [ {'Kind' -> self kind.
				'Target' -> self target.
				'Description' -> self changeDescription.
				'New source' -> self newSource.
				'Applied' -> self isApplied.
				'Code change' -> self codeChangeResult.
				'RB change' -> self change} ];
		column: 'Property'
			text: [ :each | each key ]
			width: 120;
		column: 'Value' text: [ :each | each value ifNil: [ '' ] ];
		send: [ :each | each value ];
		actionButtonIcon: BrGlamorousVectorIcons inspect
			tooltip: 'Inspect the RB change'
			action: [ :aButton | self change ifNotNil: [ :aChange | aButton phlow spawnObject: aChange ] ]
]

{ #category : #'gt views' }
GtLRefactoringChange >> gtDiffFor: aView [
	"Before the preview is applied, show what my RB change would do, computed against the current image.
	Once applied, the image already contains the change and that diff is wrong (removed slots are not found,
	added slots are duplicated), so the view is replaced by #gtAppliedDiffFor:"

	<gtView>
	self isApplied ifTrue: [ ^ aView empty ].
	(self change notNil and: [ self change respondsTo: #gtDiffChange ])
		ifFalse: [ ^ aView empty ].
	^ aView explicit
		title: 'Diff (with current image)';
		priority: 10;
		stencil: [ self
				diffElementWithNote: self currentImageDiffNote
				diffElement: (GtDiffElementWithLabelStencil new
						fromLabelText: 'Current image:';
						toLabelText: 'After this change:';
						change: self change gtDiffChange;
						styler: GtCodeDiffRBTextStyler new;
						asElement) ];
		actionButtonIcon: BrGlamorousVectorIcons inspect
			tooltip: 'Inspect the RB change'
			action: [ :aButton | aButton phlow spawnObject: self change ]
]

{ #category : #printing }
GtLRefactoringChange >> gtDisplayOn: aStream [
	self kind
		ifNotNil: [ :aKind | 
			aStream
				nextPutAll: aKind;
				nextPutAll: ': ' ].
	aStream nextPutAll: self changeDescription
]

{ #category : #accessing }
GtLRefactoringChange >> hasNewSource [
	^ newSource notNil
]

{ #category : #initialization }
GtLRefactoringChange >> initializeChangeDescription: aDescriptionString newSource: aSourceString [
	changeDescription := aDescriptionString.
	newSource := aSourceString
]

{ #category : #initialization }
GtLRefactoringChange >> initializeFromChange: aRefactoryChange [
	change := aRefactoryChange.
	changeDescription := aRefactoryChange changeString asString.
	kind := aRefactoryChange gtLlmChangeKind.
	target := aRefactoryChange gtLlmChangeTarget.
	newSource := aRefactoryChange gtLlmNewSource
]

{ #category : #accessing }
GtLRefactoringChange >> isApplied [
	"Return true once the preview I belong to was applied (even if applying it failed)"

	^ applied ifNil: [ false ]
]

{ #category : #accessing }
GtLRefactoringChange >> kind [
	"Return a short label of the kind of change, such as 'added method' or 'removed slot'"

	^ kind
]

{ #category : #descriptions }
GtLRefactoringChange >> kindDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Kind';
		accessor: #kind;
		comment: 'The kind of change, such as added method, removed method, added slot or removed class';
		priority: 20
]

{ #category : #'llm views' }
GtLRefactoringChange >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	^aDataView magritteObject: [self]
]

{ #category : #applying }
GtLRefactoringChange >> markAppliedWithCodeChangeResults: aCollectionOfCodeChangeResults [
	"The preview I belong to was applied and produced aCollectionOfCodeChangeResults.
	Keep the one describing the method or class that my change modified.
	Several of my siblings can share a code change result, for example when several slots of the same class change"

	applied := true.
	codeChangeResult := change
			ifNotNil: [ :aChange | 
				aCollectionOfCodeChangeResults
					detect: [ :each | aChange gtLlmMatchesCodeChangeResult: each ]
					ifNone: [ nil ] ]
]

{ #category : #accessing }
GtLRefactoringChange >> newSource [
	^newSource
]

{ #category : #descriptions }
GtLRefactoringChange >> newSourceDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'New source';
		accessor: #newSource;
		comment: 'The method source, class definition or class comment introduced by the change; null when the change carries no code';
		priority: 40
]

{ #category : #accessing }
GtLRefactoringChange >> target [
	"Return the method, variable, class or package affected by the change, such as 'MyClass>>#foo'"

	^ target
]

{ #category : #descriptions }
GtLRefactoringChange >> targetDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Target';
		accessor: #target;
		comment: 'The method, variable, class or package affected by the change';
		priority: 30
]
