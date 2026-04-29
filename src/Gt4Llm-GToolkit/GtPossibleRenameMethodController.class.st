Class {
	#name : #GtPossibleRenameMethodController,
	#superclass : #GtRenameController,
	#instVars : [
		'selector',
		'someImplementor',
		'newSelectorParts',
		'currentNode',
		'moveAttributes',
		'permutations',
		'possibilities'
	],
	#category : #'Gt4Llm-GToolkit-UI'
}

{ #category : #accessing }
GtPossibleRenameMethodController >> currentNode [
	^ currentNode ifNil: [ self originalNode ]
]

{ #category : #initialization }
GtPossibleRenameMethodController >> initialize [
	super initialize.
	moveAttributes := #()
]

{ #category : #executing }
GtPossibleRenameMethodController >> installRenamer [
	| message oldAction |
	message := self currentNode.
	selector := message selector.
	(permutations isNil or: [ permutations size ~= selector numArgs ])
		ifTrue: [ permutations := (1 to: selector numArgs) asArray ].
	self someImplementor isNil ifTrue: [ ^ self ].

	newSelectorParts := selector keywords.

	oldAction := renameAction.

	renameAction := GtPossibleRenameSelectorAction
			message: message
			textualCoderViewModel: sourceCoderViewModel
			possibilities: self possibilities.
	oldAction
		ifNil: [ renameAction newSelector: message selector ]
		ifNotNil: [ renameAction newSelector: oldAction newSelector ].
	renameAction
		when: GtRenameActionAnnouncement
		do: [ :ann | 
			ann eventType = #textUpdated ifTrue: [ self updateSelector ].
			ann eventType = #cancel ifTrue: [ self cancelRefactoring ] ]
		for: self.
	renameAction install
]

{ #category : #accessing }
GtPossibleRenameMethodController >> newName [
	^ self newSelectorName
]

{ #category : #private }
GtPossibleRenameMethodController >> newSelectorName [
	^ (String
		streamContents: [ :stream | newSelectorParts do: [ :each | stream nextPutAll: each ] ])
		asSymbol
]

{ #category : #accessing }
GtPossibleRenameMethodController >> originalName [
	^ selector
]

{ #category : #accessing }
GtPossibleRenameMethodController >> possibilities [
	^ possibilities
]

{ #category : #accessing }
GtPossibleRenameMethodController >> possibilities: anObject [
	possibilities := anObject
]

{ #category : #private }
GtPossibleRenameMethodController >> refactoring [
	| implementor newSelector model refactoring isCoderMethodBeingRenamed |
	implementor := self someImplementor.
	implementor isNil ifTrue: [ ^ nil ].
	newSelector := self newSelectorName.
	(newSelector = selector and: [ permutations = (1 to: permutations size) ])
		ifTrue: [ ^ nil ].
	model := self createModel.
	isCoderMethodBeingRenamed := sourceCoderViewModel coderModel isForMethod
			and: [ sourceCoderViewModel coderModel selector = selector ].
	refactoring := (isCoderMethodBeingRenamed
			ifTrue: [ GtCoderRenameMethodRefactoring ]
			ifFalse: [ RBRenameMethodRefactoring ])
			model: model
			renameMethod: selector
			in: (model classFor: implementor)
			to: newSelector
			permutation: permutations.
	isCoderMethodBeingRenamed
		ifTrue: [ refactoring methodCoder: sourceCoderViewModel coderModel ].
	^ refactoring
]

{ #category : #accessing }
GtPossibleRenameMethodController >> refactoringName [
	^ 'Rename method'
]

{ #category : #executing }
GtPossibleRenameMethodController >> removeReorderParametersAttributes [
	moveAttributes do: [ :each | self sourceCoderViewModel removeAttribute: each ]
]

{ #category : #accessing }
GtPossibleRenameMethodController >> renamePosition [
	^ self currentNode selectorParts last stopPosition
]

{ #category : #executing }
GtPossibleRenameMethodController >> safelyExecute [
	super safelyExecute
]

{ #category : #private }
GtPossibleRenameMethodController >> someImplementor [
	^ someImplementor
		ifNil: [ (SystemNavigation default allImplementorsOf: selector)
				ifEmpty: [ nil ]
				ifNotEmpty: [ :impls | someImplementor := impls anyOne methodClass ] ]
]

{ #category : #private }
GtPossibleRenameMethodController >> swapNode: firstNode with: secondNode [
	| aNewSourceText aFirstNode aSecondNode |
	renameAction ifNotNil: [ renameAction uninstall ].
	self removeReorderParametersAttributes.
	aNewSourceText := self sourceText copy.
	firstNode startPosition < secondNode startPosition
		ifTrue: [ aFirstNode := firstNode.
			aSecondNode := secondNode ]
		ifFalse: [ aFirstNode := secondNode.
			aSecondNode := firstNode ].
	aNewSourceText := (aNewSourceText copyFrom: 1 to: aFirstNode startPosition - 1)
			, aSecondNode source asRopedText
			, (aNewSourceText
					copyFrom: aFirstNode stopPosition + 1
					to: aSecondNode startPosition - 1) , aFirstNode source asRopedText
			, (aSecondNode stopPosition = aNewSourceText size
					ifTrue: [ '' asRopedText ]
					ifFalse: [ aNewSourceText copyFrom: aSecondNode stopPosition + 1 to: aNewSourceText size ]).
	self setText: aNewSourceText.
	self updateCurrentNodeFor: aNewSourceText asString.
	self installRenamer
]

{ #category : #private }
GtPossibleRenameMethodController >> swapParameterWithNext: anInteger [
	permutations swap: anInteger with: anInteger + 1.
	self
		swapNode: (self currentNode arguments at: anInteger)
		with: (self currentNode arguments at: anInteger + 1).
	self updateSelector
]

{ #category : #private }
GtPossibleRenameMethodController >> updateCurrentNodeFor: aString [
	| method |
	method := GtPharoParser parse: aString.
	method
		withAllNodesDo: [ :each | 
			(each class = self originalNode class
				and: [ each sourceInterval = self originalNode sourceInterval ])
				ifTrue: [ ^ currentNode := each ] ].
	self error: 'Cannot find node'
]

{ #category : #executing }
GtPossibleRenameMethodController >> updateSelector [
	newSelectorParts := renameAction newSelector asSymbol keywords.
	(selector = renameAction newSelector
		and: [ permutations = (1 to: permutations size) ])
		ifTrue: [ self removeRefactoringAttribute ]
		ifFalse: [ self addRefactoringPreview ]
]
