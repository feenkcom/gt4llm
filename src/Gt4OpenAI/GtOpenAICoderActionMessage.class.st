Class {
	#name : #GtOpenAICoderActionMessage,
	#superclass : #GtOpenAIActionMessage,
	#category : #Gt4OpenAI
}

{ #category : #'as yet unclassified' }
GtOpenAICoderActionMessage >> codeSnippetBlock [
	^ self contentJson at: 'Code Snippet' ifAbsent: [ '' ]
]

{ #category : #'as yet unclassified' }
GtOpenAICoderActionMessage >> gtCodeSnippetFor: aView [
	<gtView>
	<gtLlmMessageView>
	self codeSnippetBlock isEmptyOrNil ifTrue: [ ^ aView empty ].

	^ aView explicit
		title: 'Code snippet';
		priority: 1;
		stencil: [ GtPharoSnippetCoder new forSource: self codeSnippetBlock ]
]
