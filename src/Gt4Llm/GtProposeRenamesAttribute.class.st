Class {
	#name : #GtProposeRenamesAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'possibilities',
		'original',
		'renameAction'
	],
	#category : #'Gt4Llm-Coder'
}

{ #category : #accessing }
GtProposeRenamesAttribute >> doAffect: aTBrTextEditorTextualPiece in: anEditorElement [
	^ BrButton new beTinySize
		aptitude: BrGlamorousButtonWithIconAptitude;
		label: 'Renames';
		addAptitude: (BrGlamorousWithDropdownAptitude
				handle: [ BrButton new
						aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonExteriorAptitude;
						icon: BrGlamorousVectorIcons downwards;
						beTinySize ]
				content: [ self newProposalList ]);
		icon: BrGlamorousVectorIcons downwards
]

{ #category : #accessing }
GtProposeRenamesAttribute >> initialize [
	super initialize.

	self beNotOverwritableByStyler.
	self beAppend.


	self cache: self newPooledCache
]

{ #category : #accessing }
GtProposeRenamesAttribute >> newListItemElement [
	^ BrLabel new fitContent
		aptitude: BrGlamorousLabelAptitude + BrGlamorousListItemAptitude;
		when: BlClickEvent
			do: [ :anEvent | 
				| oldHasRefactoringPreview |
				oldHasRefactoringPreview := renameAction hasRefactoringPreview.
				renameAction hasRefactoringPreview: false.
				renameAction updateCompleteName: anEvent currentTarget text asString.
				anEvent currentTarget fireEvent: BrDropdownHideWish new.
				renameAction hasRefactoringPreview: oldHasRefactoringPreview ]
]

{ #category : #accessing }
GtProposeRenamesAttribute >> newProposalList [
	| aContainer aList aTitle aTitle1 aTitle2 |
	aContainer := BrVerticalPane new
			padding: (BlInsets all: 5);
			hFitContentLimited;
			vFitContentLimited.

	aTitle1 := BrLabel new
			margin: (BlInsets
					top: 0
					right: 3
					bottom: 3
					left: 3);
			text: 'Original name:';
			aptitude: (BrGlamorousLabelAptitude new
					foreground: BrGlamorousColors disabledButtonTextColor).
	aTitle2 := self newListItemElement
			id: GtWardleyMapRenameOriginalNameId;
			margin: (BlInsets
					top: 0
					right: 3
					bottom: 3
					left: 3);
			text: original asString.
	aContainer
		addChildren: {aTitle1.
				aTitle2}.

	aTitle := BrLabel new
			margin: (BlInsets
					top: 0
					right: 3
					bottom: 3
					left: 3);
			text: 'Proposed names:';
			aptitude: (BrGlamorousLabelAptitude new
					foreground: BrGlamorousColors disabledButtonTextColor).

	aList := BrSimpleList new
			margin: (BlInsets left: 3 right: 3);
			hFitContent;
			vFitContentLimited;
			items: self possibilities;
			itemStencil: [ self newListItemElement ];
			itemDataBinder: [ :anItemElement :anItem :anItemIndex | 
				anItemElement
					id: (GtWardleyMapRenameProposalId indexed: anItemIndex);
					text: anItem ].


	aContainer
		addChildren: {aTitle.
				aList}.
	^ aContainer
]

{ #category : #accessing }
GtProposeRenamesAttribute >> original [
	^ original
]

{ #category : #accessing }
GtProposeRenamesAttribute >> original: anObject [
	original := anObject
]

{ #category : #accessing }
GtProposeRenamesAttribute >> possibilities [
	^ possibilities
]

{ #category : #accessing }
GtProposeRenamesAttribute >> possibilities: anObject [
	possibilities := anObject
]

{ #category : #accessing }
GtProposeRenamesAttribute >> renameAction [
	^ renameAction
]

{ #category : #accessing }
GtProposeRenamesAttribute >> renameAction: anObject [
	renameAction := anObject
]
