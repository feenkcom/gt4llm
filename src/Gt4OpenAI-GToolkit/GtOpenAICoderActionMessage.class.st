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
GtOpenAICoderActionMessage >> diffedCode [
	^ GtDiffBuilder
		computeDifferencesFrom: self chat serializer instance contentValue
		to: self codeSnippetBlock
		using: GtSmaCCDiffSplitter forPharo
]

{ #category : #'as yet unclassified' }
GtOpenAICoderActionMessage >> diffedCodeText [
	| diff text lastIdx codeSnippetText |
	diff := self diffedCode.

	diff changes ifEmpty: [ ^ nil ].

	text := '' asRopedText.
	lastIdx := 1.
	codeSnippetText := self codeSnippetBlock asRopedText.
	(diff changes
		flatCollect: [ :aChange | 
			aChange isReplacement
				ifTrue: [ {aChange deletionChange.
						aChange insertionChange} ]
				ifFalse: [ {aChange} ] ])
		do: [ :aChange | 
			aChange isInsertion
				ifTrue: [ text := text
							, (aChange insertedObjects asRopedText
									attributes: {BlTextHighlightAttribute paint: BrGlamorousColors successBackgroundColor}).
					lastIdx := aChange stopIndex + 1 ].
			aChange isDeletion
				ifTrue: [ aChange startIndex > lastIdx
						ifTrue: [ text := text
									, (codeSnippetText
											from: lastIdx
											to: (aChange startIndex min: codeSnippetText size)) asRopedText.
							lastIdx := aChange startIndex ].
					text := text
							, (aChange deletedObjects asRopedText
									attributes: {BlTextHighlightAttribute paint: BrGlamorousColors errorBackgroundColor}) ] ].

	(text from: text size to: text size) attributes: {self acceptCodeAttribute}.

	^ text
]

{ #category : #'as yet unclassified' }
GtOpenAICoderActionMessage >> gtActionAcceptFor: anAction [
	<gtAction>
	<gtLlmAction>
	^ anAction button
		priority: 10;
		icon: BrGlamorousVectorIcons accept;
		tooltip: 'Accept code';
		action: [ :aButton | self chat serializer update: self codeSnippetBlock ]
]

{ #category : #'as yet unclassified' }
GtOpenAICoderActionMessage >> gtCodeSnippetFor: aView [
	<gtView>
	<gtLlmMessageView>
	self codeSnippetBlock isEmptyOrNil ifTrue: [ ^ aView empty ].

	^ aView explicit
		title: 'Code snippet';
		priority: 1;
		stencil: [ GtPharoSnippetCoder new
				forSource: self codeSnippetBlock;
				asExpandedOnlyElement ]
]

{ #category : #'as yet unclassified' }
GtOpenAICoderActionMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView empty
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

{ #category : #'as yet unclassified' }
GtOpenAICoderActionMessage >> gtDiffedFor: aView [
	<gtView>
	<gtLlmMessageView>
	self codeSnippetBlock isEmptyOrNil ifTrue: [ ^ aView empty ].

	^ aView diff
		title: 'Diff';
		priority: 3;
		from: self chat serializer instance contentValue;
		to: self codeSnippetBlock
]
