Class {
	#name : #GtOpenAIMessageForGT,
	#superclass : #GtOpenAIActionMessage,
	#category : #'Gt4OpenAI-GToolkit-Coder'
}

{ #category : #accessing }
GtOpenAIMessageForGT class >> leJsonV4Name [

	^ #gtOpenAIMessageForGT
]

{ #category : #'as yet unclassified' }
GtOpenAIMessageForGT >> changesContent [
	^ STON
		fromString: ((self contentJson at: 'Changes' ifAbsent: [ {} ]) ifEmpty: [ '[]' ])
]

{ #category : #'as yet unclassified' }
GtOpenAIMessageForGT >> gtActionFor: aView [
	<gtView>
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
GtOpenAIMessageForGT >> gtArgumentsFor: aView [
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
GtOpenAIMessageForGT >> gtChangesFor: aView [
	<gtView>
	<gtLlmMessageView>
	| changes namespace |
	self isAssistantRole ifFalse: [ ^ aView empty ].
	changes := self changesContent.
	changes isEmptyOrNil ifTrue: [ ^ aView empty ].

	namespace := self namespace.
	namespace changes changes ifEmpty: [ ^ aView empty ].

	^ aView forward
		title: 'Changes';
		priority: 5;
		object: [ namespace ];
		view: #gtApplyingChangesFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect tooltip: 'Inspect namespace with changes' action: [ :b | b phlow spawnObject: namespace ]
]

{ #category : #'as yet unclassified' }
GtOpenAIMessageForGT >> gtObjectFor: aView [
	<gtView>
	<gtLlmMessageView>
	self isUserRole ifFalse: [ ^ aView empty ].
	self object ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Object';
		priority: 2;
		object: [ self object ];
		view: #gtLiveFor:
]

{ #category : #'as yet unclassified' }
GtOpenAIMessageForGT >> instanceClass [
	^ self selfObject class
]

{ #category : #'as yet unclassified' }
GtOpenAIMessageForGT >> isClassDefinitionString: anObject [
	^ (RBParser
		parseRewriteExpression: '``@a subclass: ``@b
	instanceVariableNames: ``@c
	classVariableNames: ``@d
	package: ``@e')
		match: (RBParser parseExpression: anObject)
		inContext: Dictionary new
]

{ #category : #'as yet unclassified' }
GtOpenAIMessageForGT >> namespace [
	| namespace changes |
	namespace := GtRBNamespace new.
	changes := self changesContent.
	changes isEmptyOrNil ifTrue: [ ^ namespace ].

	changes
		do: [ :aCodeBlock | 
			| class codeBlockType |
			codeBlockType := aCodeBlock at: 'type'.
			codeBlockType = 'method'
				ifTrue: [ class := namespace classNamed: (aCodeBlock at: 'class') asSymbol.
					(aCodeBlock at: 'classSide' ifAbsent: [ false ])
						ifTrue: [ class := class classSide ].
					namespace
						compile: (aCodeBlock at: 'code')
						in: class
						classified: 'llm-generated' ].
			codeBlockType = 'removeMethod'
				ifTrue: [ class := namespace classNamed: (aCodeBlock at: 'class') asSymbol.
					(aCodeBlock at: 'classSide' ifAbsent: [ false ])
						ifTrue: [ class := class classSide ].
					namespace removeMethod: (aCodeBlock at: 'method') from: class ].
			codeBlockType = 'class'
				ifTrue: [ (self isClassDefinitionString: (aCodeBlock at: 'code'))
						ifTrue: [ namespace defineClass: (aCodeBlock at: 'code') ] ].
			codeBlockType = 'removeClass'
				ifTrue: [ namespace removeClassNamed: (aCodeBlock at: 'class') ].
			(codeBlockType = 'pharoSnippet'
				and: [ (aCodeBlock includesKey: 'snippetId')
						and: [ LeDatabasesRegistry default defaultLogicalDatabase
								hasSnippetWithUID: (LeUID new uidString: (aCodeBlock at: 'snippetId')) ] ])
				ifTrue: [ namespace changes
						addChange: (LeSnippetChange new
								snippet: (LeDatabasesRegistry default defaultLogicalDatabase
										snippetWithUID: (LeUID new uidString: (aCodeBlock at: 'snippetId')));
								newSource: (aCodeBlock at: 'content');
								yourself) ] ].
	^ namespace
]

{ #category : #'as yet unclassified' }
GtOpenAIMessageForGT >> object [
	^ self objectBlock
		ifEmpty: [ nil ]
		ifNotEmpty: [ :aStringOrDict | 
			(aStringOrDict isKindOf: String)
				ifTrue: [ STONJSON fromString: aStringOrDict ]
				ifFalse: [ aStringOrDict ] ]
]

{ #category : #'as yet unclassified' }
GtOpenAIMessageForGT >> objectBlock [
	^ self contentJson at: 'Object' ifAbsent: [ '' ]
]

{ #category : #'as yet unclassified' }
GtOpenAIMessageForGT >> selfObject [
	^ self chat instance content
]

{ #category : #'as yet unclassified' }
GtOpenAIMessageForGT >> viewObjectFor: aView [
	| parsed script viewVariableName |
	parsed := self class compiler
			source: self codeBlock;
			isScripting: false;
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
