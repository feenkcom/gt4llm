Class {
	#name : #GtOpenAIClassMessage,
	#superclass : #GtOpenAIActionMessage,
	#category : #'Gt4OpenAI-GToolkit-Coder'
}

{ #category : #accessing }
GtOpenAIClassMessage class >> leJsonV4Name [

	^ #gtOpenAIClassMessage
]

{ #category : #'as yet unclassified' }
GtOpenAIClassMessage >> classBlock [
	^ self contentJson at: 'Class' ifAbsent: [ '' ]
]

{ #category : #'as yet unclassified' }
GtOpenAIClassMessage >> codeBlock [
	^ STON
		fromString: ((self contentJson at: 'Code' ifAbsent: [ nil ]) ifNil: [ '[]' ])
]

{ #category : #'as yet unclassified' }
GtOpenAIClassMessage >> gtActionFor: aView [
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
GtOpenAIClassMessage >> gtArgumentsFor: aView [
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
GtOpenAIClassMessage >> gtChangesFor: aView [
	<gtView>
	<gtLlmMessageView>
	| codeBlock namespace |
	self isAssistantRole ifFalse: [ ^ aView empty ].
	codeBlock := self codeBlock.
	codeBlock isEmptyOrNil ifTrue: [ ^ aView empty ].

	namespace := self namespace.
	namespace changes changes ifEmpty: [ ^ aView empty ].

	^ aView forward
		title: 'Changes';
		priority: 10;
		object: [ namespace ];
		view: #gtApplyingChangesFor:
]

{ #category : #'as yet unclassified' }
GtOpenAIClassMessage >> gtCodeFor: aView [
	<gtView>
	<gtLlmMessageView>
	| codeBlock |
	codeBlock := self codeBlock.
	codeBlock isEmptyOrNil ifTrue: [ ^ aView empty ].
	self isAssistantRole not ifTrue: [ ^ aView empty ].

	^ aView explicit
		title: 'Code';
		priority: 1;
		stencil: [ | container aViewModel aClass behavior |
			container := BrVerticalPane new vFitContent hMatchParent.
			codeBlock
				do: [ :aCodeBlock | 
					aViewModel := (aCodeBlock at: 'type') = 'method'
							ifTrue: [ behavior := (aCodeBlock at: 'classSide' ifAbsent: [ false ])
										ifTrue: [ GtPharoCoderBehavior classSideNamed: (aCodeBlock at: 'class') ]
										ifFalse: [ GtPharoCoderBehavior named: (aCodeBlock at: 'class') ].
								aClass := (aCodeBlock at: 'class') asClassIfAbsent: nil.
								(GtPharoMethodCoder new
									methodBehavior: behavior;
									sourceCode: (GtCoderExplicitStringSource new source: (aCodeBlock at: 'code')))
									asCoderViewModel ]
							ifFalse: [ (GtPharoSnippetCoder forSource: (aCodeBlock at: 'code'))
									asCoderViewModel ].
					container
						addChild: (GtExpandableSourceCoderElement new
								coderViewModel: aViewModel;
								expanded: false;
								yourself) ].
			container asScrollableElement ]
]

{ #category : #'as yet unclassified' }
GtOpenAIClassMessage >> isClassDefinitionString: anObject [
	^ (RBParser
		parseRewriteExpression: '``@a subclass: ``@b
	instanceVariableNames: ``@c
	classVariableNames: ``@d
	package: ``@e')
		match: (RBParser parseExpression: anObject)
		inContext: Dictionary new
]

{ #category : #'as yet unclassified' }
GtOpenAIClassMessage >> namespace [
	| namespace codeBlock |
	namespace := RBNamespace new.
	codeBlock := self codeBlock.
	codeBlock isEmptyOrNil ifTrue: [ ^ namespace ].

	codeBlock
		do: [ :aCodeBlock | 
			| class |
			(aCodeBlock at: 'type') = 'method'
				ifTrue: [ class := namespace classNamed: (aCodeBlock at: 'class') asSymbol.
					(aCodeBlock at: 'classSide' ifAbsent: [ false ])
						ifTrue: [ class := class classSide ].
					namespace
						compile: (aCodeBlock at: 'code')
						in: class
						classified: 'llm-generated' ]
				ifFalse: [ (self isClassDefinitionString: (aCodeBlock at: 'code'))
						ifTrue: [ namespace defineClass: (aCodeBlock at: 'code') ] ] ].
	^ namespace
]
