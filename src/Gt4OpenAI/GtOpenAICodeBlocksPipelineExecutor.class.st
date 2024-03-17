Class {
	#name : #GtOpenAICodeBlocksPipelineExecutor,
	#superclass : #Object,
	#instVars : [
		'codeBlocks',
		'pipeline',
		'threadMessage'
	],
	#category : #'Gt4OpenAI-Executor'
}

{ #category : #executing }
GtOpenAICodeBlocksPipelineExecutor >> await [
	^ self future await: GtOpenAIUtilities executionConfiguration
]

{ #category : #executing }
GtOpenAICodeBlocksPipelineExecutor >> check [
	^ self check: ('.' join: self codeBlocks)
]

{ #category : #accessing }
GtOpenAICodeBlocksPipelineExecutor >> check: aString [
	^ (pipeline check: aString)
]

{ #category : #accessing }
GtOpenAICodeBlocksPipelineExecutor >> codeBlocks [
	^ codeBlocks
]

{ #category : #accessing }
GtOpenAICodeBlocksPipelineExecutor >> codeBlocks: anObject [
	codeBlocks := anObject
]

{ #category : #executing }
GtOpenAICodeBlocksPipelineExecutor >> future [
	^ [ self check ] asAsyncFuture
]

{ #category : #accessing }
GtOpenAICodeBlocksPipelineExecutor >> gtCodeBlocksFor: aView [
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
GtOpenAICodeBlocksPipelineExecutor >> pipeline: aPipeline [
	pipeline := aPipeline
]

{ #category : #accessing }
GtOpenAICodeBlocksPipelineExecutor >> threadMessage [
	^ threadMessage
]

{ #category : #accessing }
GtOpenAICodeBlocksPipelineExecutor >> threadMessage: anObject [
	threadMessage := anObject
]
