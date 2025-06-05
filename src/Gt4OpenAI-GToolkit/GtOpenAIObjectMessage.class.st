Class {
	#name : #GtOpenAIObjectMessage,
	#superclass : #GtOpenAIActionMessage,
	#category : #'Gt4OpenAI-GToolkit'
}

{ #category : #'as yet unclassified' }
GtOpenAIObjectMessage >> codeBlock [
	^ STON
		fromString: ((self contentJson at: 'Code' ifAbsent: [ nil ]) ifNil: [ '[]' ])
]

{ #category : #'as yet unclassified' }
GtOpenAIObjectMessage >> gtActionFor: aView [
	<gtView>
	<gtLlmMessageView>
	| view |
	self action isEmptyOrNil ifTrue: [ ^ aView empty ].

	view := aView textEditor
			title: 'Action';
			priority: 3;
			text: [ self action ].
	self chat
		ifNotNil: [ view
				actionButtonLabel: 'Action'
					action: [ :aButton | aButton phlow spawnObject: (self chat assistant actionNamed: self action) ];
				styler: [ BlCompositeStyler new
						stylers: {GtLlmMessageStyler new threadMessageViewModel: self asViewModel.
								GtLlmThreadMessageStyler new annotations: self annotations.
								GtLlmAssistantFormatTextStyler new assistant: self chat assistant} ] ].
	^ view
]

{ #category : #'as yet unclassified' }
GtOpenAIObjectMessage >> gtArgumentsFor: aView [
	<gtView>
	<gtLlmMessageView>
	self action isEmptyOrNil ifTrue: [ ^ aView empty ].
	self arguments isEmptyOrNil ifTrue: [ ^ aView empty ].

	^ aView list
			title: 'Arguments';
			priority: 4;
			items: [ self arguments ]
]

{ #category : #'as yet unclassified' }
GtOpenAIObjectMessage >> gtCodeFor: aView [
	<gtView>
	<gtLlmMessageView>
	| codeBlock |
	codeBlock := self codeBlock.
	codeBlock isEmptyOrNil ifTrue: [ ^ aView empty ].

	^ aView explicit
		title: 'Code';
		priority: 1;
		stencil: [ | container aViewModel instance aClass instanceClass |
			container := BrVerticalPane new vFitContent hMatchParent.
			instance := self selfObject.
			instanceClass := self instanceClass.
			codeBlock
				do: [ :aCodeBlock | 
					aViewModel := (aCodeBlock at: 'type') = 'method'
							ifTrue: [ aClass := (aCodeBlock at: 'class') asClassIfAbsent: nil.
								(GtPharoMethodCoder
									forClass: ((aCodeBlock at: 'classSide' ifAbsent: [ false ])
											ifTrue: [ aClass class ]
											ifFalse: [ aClass ])
									source: (aCodeBlock at: 'code')) asCoderViewModel
									selfObject: (aClass = instanceClass ifTrue: [ instance ] ifFalse: [ nil ]) ]
							ifFalse: [ (GtPharoSnippetCoder forSource: (aCodeBlock at: 'code'))
									asCoderViewModel selfObject: instance ].
					container
						addChild: (GtExpandableSourceCoderElement new
								coderViewModel: aViewModel;
								expanded: false;
								yourself) ].
			container ]
]

{ #category : #'as yet unclassified' }
GtOpenAIObjectMessage >> gtObjectFor: aView [
	<gtView>
	<gtLlmMessageView>
	self object ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Object';
		priority: 2;
		object: [ self object ];
		view: #gtLiveFor:
]

{ #category : #'as yet unclassified' }
GtOpenAIObjectMessage >> gtViewFor: aView [
	"<gtView>"
	"<gtLlmMessageView>"
	| viewObject |
	self codeBlock isEmptyOrNil ifTrue: [ ^ aView empty ].
	viewObject := self viewObjectFor: aView.
	viewObject ifNil: [ ^ aView empty ].

	^ viewObject
		title: 'Generated View';
		priority: 2
]

{ #category : #'as yet unclassified' }
GtOpenAIObjectMessage >> instanceClass [
	^ self selfObject class
]

{ #category : #'as yet unclassified' }
GtOpenAIObjectMessage >> object [
	^ self objectBlock
		ifEmpty: [ nil ]
		ifNotEmpty: [ :aStringOrDict | 
			(aStringOrDict isKindOf: String)
				ifTrue: [ STONJSON fromString: aStringOrDict ]
				ifFalse: [ aStringOrDict ] ]
]

{ #category : #'as yet unclassified' }
GtOpenAIObjectMessage >> objectBlock [
	^ self contentJson at: 'Object' ifAbsent: [ '' ]
]

{ #category : #'as yet unclassified' }
GtOpenAIObjectMessage >> selfObject [
	^ self chat serializer instance content
]

{ #category : #'as yet unclassified' }
GtOpenAIObjectMessage >> viewObjectFor: aView [
	| parsed script viewVariableName |
	parsed := OpalCompiler new
			source: self codeBlock;
			noPattern: false;
			options: #(+ optionParseErrors + optionSkipSemanticWarnings);
			requestor: nil;
			parse.

	parsed pragmaNamed: #gtView ifAbsent: [ ^ nil ].

	script := '.'
			join: (parsed body statements
					collect: [ :aStatement | 
						aStatement isReturn
							ifTrue: [ aStatement value sourceCode ]
							ifFalse: [ aStatement sourceCode ] ]).
	viewVariableName := parsed arguments first name.

	^ OpalCompiler new
		receiver: self chat serializer instance content;
		bindings: {viewVariableName -> aView} asDictionary;
		evaluate: script
]
