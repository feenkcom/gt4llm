Class {
	#name : #GtOpenAICoderActionThreadMessage,
	#superclass : #GtOpenAIActionThreadMessage,
	#category : #'Gt4OpenAI-Tutor'
}

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> codeReview [
	^ GtLlmCodeReview new review: self textCodeBlock code value
]

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> compareSourceFrom: expected to: actual [
	^ (GtDiffBuilder
		computeDifferencesFrom: expected
		to: actual
		using: GtCharacterGroupDiffSplitter words ignoreWhitespace) changes isEmpty
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
			coder := methodSource compiledMethod
					ifNil: [ GtPharoMethodCoder
							forClass: methodSource methodClass
							source: methodSource methodSource ]
					ifNotNil: [ :aCompiledMethod | GtPharoMethodCoder forMethod: aCompiledMethod ].
			(self
				compareSourceFrom: methodSource methodSource
				to: coder currentSourceString)
				ifFalse: [ coder currentSourceString: methodSource methodSource ].
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
GtOpenAICoderActionThreadMessage >> gtOpenInCoderActionFor: anAction [
	<gtLlmAction>
	^ anAction button
		priority: 1;
		icon: BrGlamorousVectorIcons emphasizedBrowse;
		tooltip: 'Open method in coder';
		action: [ :aButton | 
			aButton phlow
				spawnTool: (GtMethodCoderTool compiledMethod: self smalltalkMethodSource compiledMethod) ]
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
		column: 'Type' text: #type;
		column: 'Original' text: #original;
		column: 'Proposals'
			text: [ :aRename | ', ' join: aRename proposals ]
			weight: 2
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
	^ self renames detect: [ :aJson | aJson isForMethod ] ifNone: [ {} ]
]

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> proposedRenamesForVariable: aName [
	^ self renames
		detect: [ :aJson | aJson isForVariable and: [ aJson original = aName ] ]
		ifNone: [ nil ]
]

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> renames [
	^ self renamesCodeBlock code value lines
		select: #isNotEmpty
		thenCollect: [ :aLine | 
			| renameJson |
			renameJson := STONJSON fromString: aLine.
			GtOpenAICoderRename new
				type: (renameJson at: 'type');
				original: (renameJson at: 'original');
				proposals: (renameJson at: 'proposals') ]
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
GtOpenAICoderActionThreadMessage >> textCodeBlock [
	^ self codeBlocks
		detect: [ :aCodeBlock | aCodeBlock isForLanguage: 'text' ]
		ifNone: [ nil ]
]
