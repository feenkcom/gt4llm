Class {
	#name : #Gt4OpenAICodeBlocksExecutor,
	#superclass : #Object,
	#instVars : [
		'codeExecutor',
		'codeBlocks',
		'chat',
		'output',
		'mergedCode',
		'executionResponse',
		'maximumMessageSize'
	],
	#category : #'Gt4OpenAI-Executor'
}

{ #category : #executing }
Gt4OpenAICodeBlocksExecutor >> await [
	^ self future await: Gt4OpenAIUtilities executionConfiguration
]

{ #category : #accessing }
Gt4OpenAICodeBlocksExecutor >> chat [
	^ chat
]

{ #category : #accessing }
Gt4OpenAICodeBlocksExecutor >> chat: anObject [
	chat := anObject
]

{ #category : #accessing }
Gt4OpenAICodeBlocksExecutor >> codeBlocks [
	^ codeBlocks
]

{ #category : #accessing }
Gt4OpenAICodeBlocksExecutor >> codeBlocks: anObject [
	codeBlocks := anObject
]

{ #category : #accessing }
Gt4OpenAICodeBlocksExecutor >> codeExecutor [
	^ codeExecutor
]

{ #category : #accessing }
Gt4OpenAICodeBlocksExecutor >> codeExecutor: anObject [
	codeExecutor := anObject
]

{ #category : #executing }
Gt4OpenAICodeBlocksExecutor >> execute [
	mergedCode := '.' join: self codeBlocks.
	executionResponse := codeExecutor execute: mergedCode.
	output := executionResponse asString.
	output size > self maximumMessageSize
		ifTrue: [ output := output first: self maximumMessageSize ].
	self chat sendMessage: output.
	^ executionResponse content
]

{ #category : #executing }
Gt4OpenAICodeBlocksExecutor >> future [
	^ [ self execute ] asAsyncFuture
]

{ #category : #accessing }
Gt4OpenAICodeBlocksExecutor >> gtCodeBlocksFor: aView [
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
Gt4OpenAICodeBlocksExecutor >> maximumMessageSize [
	^ maximumMessageSize
]

{ #category : #accessing }
Gt4OpenAICodeBlocksExecutor >> maximumMessageSize: anObject [
	maximumMessageSize := anObject
]
