Class {
	#name : #GtOpenAICoderActionThreadMessage,
	#superclass : #GtOpenAIThreadMessage,
	#category : #'Gt4OpenAI-Tutor'
}

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> action [
	| parsed |
	self isAssistantRole ifFalse: [ ^ '' ].

	parsed := LeParser parse: self contentText.

	parsed children
		do: [ :aNode | 
			((aNode isKindOf: LeCodeBlockNode) and: [ aNode isForLanguage: 'action' ])
				ifTrue: [ ^ aNode code source ] ].
	^ ''
]

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> actionHeaderItem [
	<gtLlmHeaderItem: 4>
	^ BrLabel new
			hFitContentLimited;
			vFitContent;
			aptitude: (BrGlamorousLabelAptitude new
					foreground: BrGlamorousColors disabledButtonTextColor);
			beSmallSize;
			text: self action
]

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> codeReview [
	^ GtLlmCodeReview new review: self textCodeBlock code value
]

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> gtActionFor: aView [
	<gtView>
	<gtLlmMessageView>
	self action ifEmpty: [ ^ aView empty ].

	^ aView textEditor
		title: 'Action';
		priority: 3;
		text: [ self action ]
]

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> gtCodeFor: aView [
	<gtView>
	<gtLlmMessageView>
	self smalltalkMethodCodeBlock ifNil: [ ^ aView empty ].

	^ aView explicit
		title: 'Coder';
		priority: 1;
		stencil: [ | methodSource coder |
			methodSource := self smalltalkMethodSource.
			coder := GtPharoMethodCoder forMethod: methodSource compiledMethod.
			coder asElement ]
]

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView explicit
		title: 'Content';
		priority: 5;
		stencil: [ GtLlmThreadMessageElement new threadMessageViewModel: self asViewModel ]
]

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> gtRenamesFor: aView [
	<gtView>
	<gtLlmMessageView>
	self renamesCodeBlock ifNil: [ ^ aView empty ].
	self proposedRenamesForMethod ifEmpty: [ ^ aView empty ].

	^ aView explicit
		title: 'Renames';
		priority: 1;
		stencil: [ | methodSource coder renames coderViewModel coderElement |
			methodSource := self smalltalkMethodSource.
			renames := self proposedRenamesForMethod at: 'proposals'.
			coder := GtPharoMethodCoder forMethod: methodSource compiledMethod.
			coderViewModel := coder asCoderViewModel.
			coderElement := coderViewModel asElement.
			coderElement
				enqueueTask: (BlTaskAction new
						action: [ coder
								renameNodeProposals: (coder nodeAt: 2)
								in: coderViewModel
								for: coderElement
								withPossibilities: renames ]).
			coderElement ]
]

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> gtRenamesListFor: aView [
	<gtView>
	<gtLlmMessageView>
	self renamesCodeBlock ifNil: [ ^ aView empty ].

	^ aView columnedList
		title: 'Rename list';
		priority: 2;
		items: [ self renames ];
		column: 'Type' text: [:aJson | aJson at: 'type'];
		column: 'Original' text: [:aJson | aJson at: 'original'];
		column: 'Proposals' text: [:aJson | ', ' join: (aJson at: 'proposals') ] weight: 2
]

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> gtTextFor: aView [
	<gtView>
	<gtLlmMessageView>
	self textCodeBlock ifNil: [ ^ aView empty ].

	^ aView textEditor
		title: 'Text';
		priority: 2;
		text: [ self textCodeBlock code value ];
		styler: (GtLlmMessageStyler new threadMessageViewModel: self)
]

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> proposedRenamesForMethod [
	^ self renames
		detect: [ :aJson | (aJson at: 'type') = 'method' ]
		ifNone: [ {} ]
]

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> proposedRenamesForVariable: aName [
	^ self renames
		detect: [ :aJson | (aJson at: 'type') = 'variable' and: [ (aJson at: 'original') = aName ] ]
		ifNone: [ nil ]
]

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> renames [
	^ self renamesCodeBlock code value lines
		select: #isNotEmpty
		thenCollect: [ :aLine | STONJSON fromString: aLine ]
]

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> renamesCodeBlock [
	^ self codeBlocks
		detect: [ :aCodeBlock | aCodeBlock isForLanguage: 'renames' ]
		ifNone: [ nil ]
]

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> smalltalkMethodCodeBlock [
	^ self codeBlocks
		detect: [ :aCodeBlock | aCodeBlock isForLanguage: 'smalltalk-method' ]
		ifNone: [ nil ]
]

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> smalltalkMethodSource [
	^ self smalltalkMethodCodeBlock
		ifNil: [ self ancestor smalltalkMethodSource ]
		ifNotNil: [ :aBlock | GtLlmMethodSource forSource: aBlock code value ]
]

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> spacerHeaderItem [
	<gtLlmHeaderItem: 3>
	^ BrFrame new matchParent
]

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> textCodeBlock [
	^ self codeBlocks
		detect: [ :aCodeBlock | aCodeBlock isForLanguage: 'text' ]
		ifNone: [ nil ]
]
