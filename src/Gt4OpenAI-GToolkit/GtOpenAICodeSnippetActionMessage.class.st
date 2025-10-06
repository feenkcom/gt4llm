Class {
	#name : #GtOpenAICodeSnippetActionMessage,
	#superclass : #GtOpenAIObjectMessage,
	#category : #'Gt4OpenAI-GToolkit-Coder'
}

{ #category : #accessing }
GtOpenAICodeSnippetActionMessage class >> leJsonV4Name [

	^ #gtOpenAICodeSnippetActionMessage
]

{ #category : #'as yet unclassified' }
GtOpenAICodeSnippetActionMessage >> acceptCodeAttribute [
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
GtOpenAICodeSnippetActionMessage >> codeSnippetBlock [
	^ self codeBlock
		ifEmpty: [ nil ]
		ifNotEmpty: [ :snippets | 
			snippets
				detect: [ :aSnippet | aSnippet at: 'sourceSnippet' ifAbsent: [ false ] ]
				ifNone: [ nil ] ]
]

{ #category : #'as yet unclassified' }
GtOpenAICodeSnippetActionMessage >> diffedCode [
	^ GtDiffBuilder
		computeDifferencesFrom: self chat serializer instance content sourceText
				asString
		to: (self codeSnippetBlock at: 'code')
		using: GtSmaCCDiffSplitter forPharo
]

{ #category : #'as yet unclassified' }
GtOpenAICodeSnippetActionMessage >> diffedCodeText [
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
GtOpenAICodeSnippetActionMessage >> gtCodeSnippetFor: aView [
	<gtView>
	<gtLlmMessageView>
	| currentSourceCode |
	self codeSnippetBlock isEmptyOrNil ifTrue: [ ^ aView empty ].

	^ aView explicit
		title: 'Code snippet';
		priority: 0;
		stencil: [ GtPharoSnippetCoder new
				forSource: (self codeSnippetBlock at: 'code');
				asExpandedOnlyElement ];
		actionButtonIcon: BrGlamorousVectorIcons accept
			tooltip: 'Accept'
			action: [ :b | 
				currentSourceCode := b phlow viewContent children first coderViewModel
						sourceText asString.
				self chat serializer update: currentSourceCode ]
]

{ #category : #'as yet unclassified' }
GtOpenAICodeSnippetActionMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView empty
]

{ #category : #'as yet unclassified' }
GtOpenAICodeSnippetActionMessage >> gtDiffedFor: aView [
	<gtView>
	<gtLlmMessageView>
	self codeSnippetBlock isEmptyOrNil ifTrue: [ ^ aView empty ].
	self isAssistantRole not ifTrue: [ ^ aView empty ].
	
	^ aView diff
		title: 'Diff';
		priority: 3;
		from: [ self chat serializer instance content sourceText asString ];
		to: [ self codeSnippetBlock at: 'code' ]
]

{ #category : #'as yet unclassified' }
GtOpenAICodeSnippetActionMessage >> gtVariablesFor: aView [
	<gtView>
	<gtLlmMessageView>
	self variablesBlock isNil ifTrue: [ ^ aView empty ].

	^ aView columnedList
		title: 'Variables';
		priority: 2;
		items: [ self variablesBlock ];
		column: 'Name' text: [ :aDict | aDict at: 'name' ];
		column: 'Binding' text: [ :aDict | aDict at: 'value' ]
]

{ #category : #'as yet unclassified' }
GtOpenAICodeSnippetActionMessage >> instanceClass [
	^ self chat serializer instance content behavior
]

{ #category : #'as yet unclassified' }
GtOpenAICodeSnippetActionMessage >> methodCode [
	^ self chat serializer instance content compiledMethod sourceCode
]

{ #category : #'as yet unclassified' }
GtOpenAICodeSnippetActionMessage >> selfObject [
	^ self chat instance content selfObject
]

{ #category : #'as yet unclassified' }
GtOpenAICodeSnippetActionMessage >> variablesBlock [
	^ self contentJson at: 'Variables' ifAbsent: [ nil ]
]
