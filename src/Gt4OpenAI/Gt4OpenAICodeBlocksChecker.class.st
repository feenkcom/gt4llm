Class {
	#name : #Gt4OpenAICodeBlocksChecker,
	#superclass : #Object,
	#instVars : [
		'codeBlocks',
		'chat',
		'output',
		'mergedCode',
		'maximumMessageSize',
		'pipeline',
		'checkResult'
	],
	#category : #'Gt4OpenAI-Executor'
}

{ #category : #executing }
Gt4OpenAICodeBlocksChecker >> await [
	^ self future await: Gt4OpenAIUtilities executionConfiguration
]

{ #category : #accessing }
Gt4OpenAICodeBlocksChecker >> chat [
	^ chat
]

{ #category : #accessing }
Gt4OpenAICodeBlocksChecker >> chat: anObject [
	chat := anObject
]

{ #category : #executing }
Gt4OpenAICodeBlocksChecker >> check [
	mergedCode := '.' join: self codeBlocks.
	checkResult := pipeline check: mergedCode.
	output := checkResult asString.
	output size > self maximumMessageSize
		ifTrue: [ output := output first: self maximumMessageSize ].
	self chat sendMessage: output.
	^ checkResult
]

{ #category : #accessing }
Gt4OpenAICodeBlocksChecker >> codeBlocks [
	^ codeBlocks
]

{ #category : #accessing }
Gt4OpenAICodeBlocksChecker >> codeBlocks: anObject [
	codeBlocks := anObject
]

{ #category : #executing }
Gt4OpenAICodeBlocksChecker >> future [
	^ [ self check ] asAsyncFuture
]

{ #category : #accessing }
Gt4OpenAICodeBlocksChecker >> gtCodeBlocksFor: aView [
	<gtView>
	^ aView explicit
		title: 'Code blocks';
		priority: 3;
		stencil: [ BrVerticalPane new matchParent
				addChildren: (self codeBlocks
						collect: [ :aText | 
							| aSnippetElement aSnippetViewModel aSnippet |
							aSnippet := LePharoSnippet code: aText.
							aSnippetViewModel := aSnippet asSnippetViewModel.
							aSnippetElement := aSnippetViewModel snippetView asElement.
							aSnippetElement padding: (BlInsets all: 10).
							aSnippetElement snippetViewModel: aSnippetViewModel.
							aSnippetElement ]) ]
]

{ #category : #accessing }
Gt4OpenAICodeBlocksChecker >> maximumMessageSize [
	^ maximumMessageSize
]

{ #category : #accessing }
Gt4OpenAICodeBlocksChecker >> maximumMessageSize: anObject [
	maximumMessageSize := anObject
]

{ #category : #accessing }
Gt4OpenAICodeBlocksChecker >> pipeline: aPipeline [
	pipeline := aPipeline
]
