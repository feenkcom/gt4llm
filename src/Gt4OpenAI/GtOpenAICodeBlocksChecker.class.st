Class {
	#name : #GtOpenAICodeBlocksChecker,
	#superclass : #Object,
	#instVars : [
		'codeBlocks',
		'chat',
		'output',
		'mergedCode',
		'pipeline',
		'checkResult'
	],
	#category : #'Gt4OpenAI-Executor'
}

{ #category : #executing }
GtOpenAICodeBlocksChecker >> await [
	^ self future await: GtOpenAIUtilities executionConfiguration
]

{ #category : #accessing }
GtOpenAICodeBlocksChecker >> chat [
	^ chat
]

{ #category : #accessing }
GtOpenAICodeBlocksChecker >> chat: anObject [
	chat := anObject
]

{ #category : #executing }
GtOpenAICodeBlocksChecker >> check [
	^ self check: ('.' join: self codeBlocks)
]

{ #category : #accessing }
GtOpenAICodeBlocksChecker >> check: aString [
	^ pipeline check: aString
]

{ #category : #accessing }
GtOpenAICodeBlocksChecker >> codeBlocks [
	^ codeBlocks
]

{ #category : #accessing }
GtOpenAICodeBlocksChecker >> codeBlocks: anObject [
	codeBlocks := anObject
]

{ #category : #executing }
GtOpenAICodeBlocksChecker >> future [
	^ [ self check ] asAsyncFuture
]

{ #category : #accessing }
GtOpenAICodeBlocksChecker >> gtCodeBlocksFor: aView [
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
GtOpenAICodeBlocksChecker >> pipeline: aPipeline [
	pipeline := aPipeline
]
