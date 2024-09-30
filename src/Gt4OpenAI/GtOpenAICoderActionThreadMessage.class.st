Class {
	#name : #GtOpenAICoderActionThreadMessage,
	#superclass : #GtOpenAIActionThreadMessage,
	#category : #'Gt4OpenAI-Tutor'
}

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> codeReview [
	^ GtLlmCodeReview new review: self textCodeBlock
]

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> compareSourceFrom: expected to: actual [
	^ (self diffSourceFrom: expected to: actual) changes isEmpty
]

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> diffSourceFrom: expected to: actual [
	^ GtDiffBuilder
		computeDifferencesFrom: expected
		to: actual
		using: GtSmaCCDiffSplitter forPharo
]

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> gtCodeFor: aView [
	<gtView>
	<gtLlmMessageView>
	self smalltalkMethodCodeBlock ifNil: [ ^ aView empty ].

	^ aView explicit
		title: 'Method';
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
			coder asExpandedOnlyElement vFitContentLimited]
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
GtOpenAICoderActionThreadMessage >> gtDiffFor: aView [
	<gtView>
	<gtLlmMessageView>
	| methodSource expected actual diff |
	self smalltalkMethodCodeBlock ifNil: [ ^ aView empty ].

	methodSource := self smalltalkMethodSource.
	expected := methodSource compiledMethod sourceCode.
	actual := methodSource methodSource.
	diff := self diffSourceFrom: expected to: actual.
	diff changes ifEmpty: [ ^ aView empty ].

	^ aView explicit
		title: 'Diff';
		priority: 2;
		stencil: [ GtDiffElementWithLabelStencil new
				fromLabelText: 'Current:';
				toLabelText: 'Change:';
				change: diff;
				styler: GtCodeDiffRBTextStyler new ]
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
	self proposedRenamesForMethod ifNil: [ ^ aView empty ].

	^ aView explicit
		title: 'Renames';
		priority: 1;
		stencil: [ | methodSource coder renames coderViewModel coderElement |
			methodSource := self smalltalkMethodSource.
			renames := self proposedRenamesForMethod proposals.
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
	self renamesCodeBlock isEmptyOrNil ifTrue: [ ^ aView empty ].

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
	self textCodeBlock isEmptyOrNil ifTrue: [ ^ aView empty ].

	^ aView textEditor
		title: 'Text';
		priority: 2;
		text: [ self textCodeBlock ];
		styler: (GtLlmMessageStyler new threadMessageViewModel: self)
]

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> proposedRenamesForMethod [
	^ self renames detect: [ :aJson | aJson isForMethod ] ifNone: [ nil ]
]

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> proposedRenamesForVariable: aName [
	^ self renames
		detect: [ :aJson | aJson isForVariable and: [ aJson original = aName ] ]
		ifNone: [ nil ]
]

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> renames [
	^ self renamesCodeBlock lines
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
	^ self contentJson at: 'Renames' ifAbsent: [ '' ]
]

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> smalltalkMethodCodeBlock [
	^ self contentJson at: 'Smalltalk method' ifAbsent: [ '' ]
]

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> smalltalkMethodSource [
	^ self smalltalkMethodCodeBlock
		ifNil: [ self ancestor smalltalkMethodSource ]
		ifNotNil: [ :aString | GtLlmMethodSource forSource: aString ]
]

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> textCodeBlock [
	^ self contentJson at: 'Text' ifAbsent: [ '' ]
]
