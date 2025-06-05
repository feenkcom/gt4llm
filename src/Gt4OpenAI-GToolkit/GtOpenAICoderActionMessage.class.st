Class {
	#name : #GtOpenAICoderActionMessage,
	#superclass : #GtOpenAIObjectMessage,
	#category : #'Gt4OpenAI-GToolkit'
}

{ #category : #'as yet unclassified' }
GtOpenAICoderActionMessage >> gtCodeSnippetFor: aView [
	<gtView>
	<gtLlmMessageView>
	| currentSourceCode |
	self codeSnippetBlock isEmptyOrNil ifTrue: [ ^ aView empty ].

	^ aView explicit
		title: 'Code snippet';
		priority: 1;
		stencil: [ GtPharoSnippetCoder new
				forSource: self codeSnippetBlock;
				asExpandedOnlyElement ];
		actionButtonIcon: BrGlamorousVectorIcons accept
			tooltip: 'Accept'
			action: [ :b | 
				currentSourceCode := b phlow viewContent children first coderViewModel
						sourceText asString.
				self chat serializer update: currentSourceCode ]
]

{ #category : #'as yet unclassified' }
GtOpenAICoderActionMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView empty
]

{ #category : #'as yet unclassified' }
GtOpenAICoderActionMessage >> instanceClass [
	^ self chat serializer instance content behavior
]

{ #category : #'as yet unclassified' }
GtOpenAICoderActionMessage >> methodCode [
	^ self chat serializer instance content compiledMethod sourceCode
]

{ #category : #'as yet unclassified' }
GtOpenAICoderActionMessage >> selfObject [
	^ self chat serializer instance content selfObject
]
