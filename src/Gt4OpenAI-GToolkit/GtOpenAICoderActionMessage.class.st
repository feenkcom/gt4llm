Class {
	#name : #GtOpenAICoderActionMessage,
	#superclass : #GtOpenAIActionMessage,
	#category : #'Gt4OpenAI-GToolkit'
}

{ #category : #'as yet unclassified' }
GtOpenAICoderActionMessage >> acceptCodeAttribute [
	^ GtButtonAttribute new
		beAppend;
		stencil: [ | button |
			button := BrButton new
					aptitude: BrGlamorousButtonWithIconAptitude;
					icon: BrGlamorousVectorIcons accept;
					label: 'Accept proposal';
					action: [ self chat serializer update: self codeSnippetBlock ] ]
]

{ #category : #'as yet unclassified' }
GtOpenAICoderActionMessage >> codeSnippetBlock [
	^ self contentJson at: 'Code Snippet' ifAbsent: [ '' ]
]

{ #category : #'as yet unclassified' }
GtOpenAICoderActionMessage >> diffedCodeText [
	| diff text pushIdx |
	diff := GtDiffBuilder
			computeDifferencesFrom: self chat serializer instance contentValue
			to: self codeSnippetBlock
			using: GtSmaCCDiffSplitter forPharo.

	diff changes ifEmpty: [ ^ nil ].

	text := diff to asRopedText.
	pushIdx := 0.
	(diff changes
		flatCollect: [ :aChange | 
			aChange isReplacement
				ifTrue: [ {aChange deletionChange.
						aChange insertionChange} ]
				ifFalse: [ {aChange} ] ])
		do: [ :aChange | 
			aChange isInsertion
				ifTrue: [ (text from: aChange startIndex to: aChange stopIndex)
						attributes: {BlTextHighlightAttribute paint: BrGlamorousColors successBackgroundColor}.
					pushIdx := pushIdx + (aChange stopIndex - aChange startIndex) ].
			aChange isDeletion
				ifTrue: [ (text from: aChange startIndex + pushIdx to: aChange stopIndex + pushIdx)
						attributes: {GtButtonAttribute new
									beAppend;
									stencil: [ | button |
										button := BrLabel new
												vMatchParent;
												aptitude: BrGlamorousShrinkingLabelAptitude;
												text: (aChange deletedObjects asRopedText glamorousCodeFontAndSize
														attributes: {BlTextHighlightAttribute paint: BrGlamorousColors errorBackgroundColor});
												when: BlClickEvent
													do: [ :anEvent | 
														anEvent consumed: true.
														button aptitude: BrGlamorousLabelAptitude ] ]} ] ].

	(text from: text size - 1 to: text size) attributes: {self acceptCodeAttribute}.

	^ text
]

{ #category : #'as yet unclassified' }
GtOpenAICoderActionMessage >> gtCodeSnippetFor: aView [
	<gtView>
	<gtLlmMessageView>
	self codeSnippetBlock isEmptyOrNil ifTrue: [ ^ aView empty ].

	^ aView explicit
		title: 'Code snippet';
		priority: 1;
		stencil: [ GtPharoSnippetCoder new forSource: self codeSnippetBlock ]
]

{ #category : #'as yet unclassified' }
GtOpenAICoderActionMessage >> gtDiffedCodeFor: aView [
	<gtView>
	<gtLlmMessageView>
	self codeSnippetBlock isEmptyOrNil ifTrue: [ ^ aView empty ].
	self diffedCodeText ifNil: [ ^ aView empty ].

	^ aView textEditor
		title: 'Diffed code';
		priority: 2;
		aptitude: BrGlamorousCodeEditorAptitude;
		text: [ self diffedCodeText ]
]
