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
GtOpenAICoderActionThreadMessage >> smalltalkMethodCodeBlock [
	^ self codeBlocks
		detect: [ :aCodeBlock | aCodeBlock isForLanguage: 'smalltalk-method' ]
		ifNone: [ nil ]
]

{ #category : #accessing }
GtOpenAICoderActionThreadMessage >> smalltalkMethodSource [
	^ GtLlmMethodSource forSource: self smalltalkMethodCodeBlock code value
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
