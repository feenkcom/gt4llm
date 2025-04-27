Class {
	#name : #GtOpenAIObjectMessage,
	#superclass : #GtOpenAIActionMessage,
	#category : #'Gt4OpenAI-GToolkit'
}

{ #category : #'as yet unclassified' }
GtOpenAIObjectMessage >> codeBlock [
	^ self contentJson at: 'Method' ifAbsent: [ '' ]
]

{ #category : #'as yet unclassified' }
GtOpenAIObjectMessage >> gtCodeFor: aView [
	<gtView>
	<gtLlmMessageView>
	self codeBlock isEmptyOrNil ifTrue: [ ^ aView empty ].

	^ aView explicit
		title: 'Code';
		priority: 1;
		stencil: [ GtExpandedOnlyCoderElement new
				coderViewModel: ((GtPharoMethodCoder
						forClass: self chat serializer instance content class
						source: self codeBlock) asCoderViewModel
						selfObject: self chat serializer instance content);
				yourself ]
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
	<gtView>
	<gtLlmMessageView>
	self codeBlock isEmptyOrNil ifTrue: [ ^ aView empty ].

	^ self viewObject
		title: 'Generated View';
		priority: 2
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
GtOpenAIObjectMessage >> viewObject [
	| parsed script viewVariableName |
	parsed := OpalCompiler new
			source: self codeBlock;
			noPattern: false;
			options: #(+ optionParseErrors + optionSkipSemanticWarnings);
			requestor: nil;
			parse.
	script := '.'
			join: (parsed body statements
					collect: [ :aStatement | 
						aStatement isReturn
							ifTrue: [ aStatement value sourceCode ]
							ifFalse: [ aStatement sourceCode ] ]).
	viewVariableName := parsed arguments first name.

	^ OpalCompiler new
		receiver: self chat serializer instance content;
		bindings: {viewVariableName -> GtPhlowEmptyView new} asDictionary;
		evaluate: script
]
