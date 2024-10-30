Class {
	#name : #GtOpenAIViewActionThreadMessage,
	#superclass : #GtOpenAIActionThreadMessage,
	#category : #'Gt4OpenAI-Tutor'
}

{ #category : #accessing }
GtOpenAIViewActionThreadMessage >> gtCodeFor: aView [
	<gtView>
	<gtLlmMessageView>
	self smalltalkMethodCodeBlock isEmptyOrNil ifTrue: [ ^ aView empty ].

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
			coder asExpandedOnlyElement ]
]

{ #category : #accessing }
GtOpenAIViewActionThreadMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView explicit
		title: 'Content';
		priority: 5;
		stencil: [ GtLlmThreadMessageElement new threadMessageViewModel: self asViewModel ]
]

{ #category : #accessing }
GtOpenAIViewActionThreadMessage >> gtTextFor: aView [
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
GtOpenAIViewActionThreadMessage >> gtViewFor: aView [
	<gtView>
	<gtLlmMessageView>
	| view ast return script viewVariableName instance generatedView |
	self smalltalkMethodCodeBlock isEmptyOrNil ifTrue: [ ^ aView empty ].

	view := self smalltalkMethodSource.
	instance := self chat pipeline instance object.
	ast := GtPharoParser parse: view methodSource.
	return := (ast // GtPharoReturnNode) anyOne.
	script := '.' join: (ast body statements collect: #source).
	viewVariableName := view methodAst arguments first name.


	generatedView := OpalCompiler new
			source: script;
			receiver: instance;
			bindings: {viewVariableName -> aView};
			evaluate.

	^ generatedView
		title: 'Generated: ' , generatedView title;
		priority: -10;
		actionButtonIcon: BrGlamorousVectorIcons accept
			tooltip: 'Save method'
			action: [ instance compile: view ]
]

{ #category : #accessing }
GtOpenAIViewActionThreadMessage >> smalltalkMethodCodeBlock [
	^ self contentJson at: 'Smalltalk method' ifAbsent: [ '' ]
]

{ #category : #accessing }
GtOpenAIViewActionThreadMessage >> smalltalkMethodSource [
	^ self smalltalkMethodCodeBlock
		ifNil: [ self ancestor smalltalkMethodSource ]
		ifNotNil: [ :aBlock | GtLlmMethodSource forSource: aBlock ]
]

{ #category : #accessing }
GtOpenAIViewActionThreadMessage >> textCodeBlock [
	^ self contentJson at: 'Text' ifAbsent: [ '' ]
]
