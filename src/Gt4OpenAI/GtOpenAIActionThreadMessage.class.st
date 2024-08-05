Class {
	#name : #GtOpenAIActionThreadMessage,
	#superclass : #GtOpenAIThreadMessage,
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
GtOpenAIActionThreadMessage >> action [
	| parsed |
	self isAssistantRole ifFalse: [ ^ '' ].

	parsed := LeParser parse: self contentText.

	parsed children
		do: [ :aNode | 
			((aNode isKindOf: LeCodeBlockNode) and: [ aNode isForLanguage: 'action' ])
				ifTrue: [ ^ aNode code source ] ].
	^ ''
]

{ #category : #accessing }
GtOpenAIActionThreadMessage >> gtActionFor: aView [
	<gtView>
	<gtLlmMessageView>
	self action ifEmpty: [ ^ aView empty ].

	^ aView textEditor
		title: 'Action';
		priority: 3;
		text: [ self action ]
]
