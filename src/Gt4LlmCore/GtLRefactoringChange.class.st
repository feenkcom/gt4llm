"
I describe one basic change of a refactoring preview (see {{gtClass:GtLRefactoringPreview}}).

I keep the RB change I describe in `change`. The other properties are computed from it when I am created, against the current image, so I should be created before the change is applied:
- `changeDescription`: the RB change string, e.g. 'Remove MyClass>>#foo';
- `kind`: a short label such as 'added method', 'modified method', 'removed method', 'added slot', 'removed slot', 'changed superclass', 'changed class comment', 'added class' or 'removed class';
- `target`: the method, variable, class or package affected, e.g. 'MyClass>>#foo';
- `newSource`: the method source, class definition, class comment or snippet text introduced by the change, or nil for changes that carry no code, such as removals.

The kind, target and new source come from the gtLlmChangeKind, gtLlmChangeTarget and gtLlmNewSource extension methods of the RB change classes. A preview that lists its changes one by one writes me with {{gtMethod:GtLRefactoringChange>>#llmJsonObjectIncludingSources:}}; a preview that groups them lists my {{gtMethod:GtLRefactoringChange>>#asChangeEntry}}.
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
		'codeChangeResult',
		'matchingChange'
	],
	#category : #Gt4LlmCore
}

{ #category : #'instance creation' }
GtLRefactoringChange class >> fromChange: aRefactoryChange [
	"Describe aRefactoryChange. The kind, target and new source are computed now,
	against the current image, so this should be called before the change is applied"

	^ self new initializeFromChange: aRefactoryChange
]

{ #category : #'instance creation' }
GtLRefactoringChange class >> fromChange: aRefactoryChange matchingChange: aMatchingChange [
	"Describe aRefactoryChange, but name its target and match its code change result through aMatchingChange.
	A change nested in a class rename keeps the old class name until it is executed; aMatchingChange is the same change under the new name"

	^ self new
		initializeFromChange: aRefactoryChange
		matchingChange: aMatchingChange
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

{ #category : #converting }
GtLRefactoringChange >> asChangeEntry [
	"Return the entry that lists me in the groups of changes of a report"

	^ (self matchingChange
		ifNil: [ GtLRefactoringOtherChangeEntry new target: target asString ]
		ifNotNil: [ :aChange | aChange gtLlmNewChangeEntry ])
		kind: kind;
		newSource: newSource;
		yourself
]

{ #category : #accessing }
GtLRefactoringChange >> change [
	"Return the RB change I describe"

	^ change
]

{ #category : #accessing }
GtLRefactoringChange >> changeDescription [
	^changeDescription
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
GtLRefactoringChange >> initializeFromChange: aRefactoryChange [
	change := aRefactoryChange.
	changeDescription := aRefactoryChange changeString asString.
	kind := aRefactoryChange gtLlmChangeKind.
	target := aRefactoryChange gtLlmChangeTarget.
	newSource := aRefactoryChange gtLlmNewSource
]

{ #category : #initialization }
GtLRefactoringChange >> initializeFromChange: aRefactoryChange matchingChange: aMatchingChange [
	self initializeFromChange: aRefactoryChange.
	matchingChange := aMatchingChange.
	target := aMatchingChange gtLlmChangeTarget
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

{ #category : #converting }
GtLRefactoringChange >> llmJsonObjectIncludingSources: aBoolean [
	"Describe me in a preview that lists its changes one by one. Properties without a value are left out, and so is the new source when it is not wanted"

	| json |
	json := NeoJSONObject new.
	json at: 'changeDescription' put: changeDescription.
	kind ifNotNil: [ :aKind | json at: 'kind' put: aKind ].
	target ifNotNil: [ :aTarget | json at: 'target' put: aTarget asString ].
	(aBoolean and: [ newSource notNil ])
		ifTrue: [ json at: 'newSource' put: newSource ].
	^ json
]

{ #category : #applying }
GtLRefactoringChange >> markAppliedWithCodeChangeResults: aCollectionOfCodeChangeResults [
	"The preview I belong to was applied and produced aCollectionOfCodeChangeResults.
	Keep the one describing the method or class that my change modified.
	Several of my siblings can share a code change result, for example when several slots of the same class change"

	applied := true.
	codeChangeResult := self matchingChange
			ifNotNil: [ :aChange | 
				aCollectionOfCodeChangeResults
					detect: [ :each | aChange gtLlmMatchesCodeChangeResult: each ]
					ifNone: [ nil ] ]
]

{ #category : #accessing }
GtLRefactoringChange >> matchingChange [
	"Return the change that names my target and matches my code change result"

	^ matchingChange ifNil: [ change ]
]

{ #category : #accessing }
GtLRefactoringChange >> newSource [
	^newSource
]

{ #category : #accessing }
GtLRefactoringChange >> target [
	"Return the method, variable, class or package affected by the change, such as 'MyClass>>#foo'"

	^ target
]
