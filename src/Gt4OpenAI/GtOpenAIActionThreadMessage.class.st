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
GtOpenAIActionThreadMessage >> actionHeaderItem [
	<gtLlmHeaderItem: 3>
	| aFrame |
	aFrame := BrFrame new matchParent.

	self isAssistantRole ifFalse: [ ^ aFrame ].

	^ aFrame
		padding: (BlInsets left: 15 right: 15);
		addChild: (BrLabel new
				hFitContentLimited;
				vFitContent;
				aptitude: (BrGlamorousLabelAptitude new
						foreground: BrGlamorousColors disabledButtonTextColor);
				beSmallSize;
				text: self ancestor contentText lines first)
]

{ #category : #accessing }
GtOpenAIActionThreadMessage >> spacerHeaderItem [
]
