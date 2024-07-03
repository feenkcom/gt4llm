Class {
	#name : #GtOpenAIWardleyMapActionThreadMessage,
	#superclass : #GtOpenAIThreadMessage,
	#category : #'Gt4OpenAI-Examples - Wardley Map'
}

{ #category : #accessing }
GtOpenAIWardleyMapActionThreadMessage >> action [
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
GtOpenAIWardleyMapActionThreadMessage >> actionHeaderItem [
	<gtLlmHeaderItem: 4>
	^ BrLabel new
			hFitContentLimited;
			vFitContent;
			aptitude: (BrGlamorousLabelAptitude new
					foreground: BrGlamorousColors disabledButtonTextColor);
			beSmallSize;
			text: self action
]

{ #category : #accessing }
GtOpenAIWardleyMapActionThreadMessage >> asViewModel [
	^ GtLlmActionThreadMessageViewModel new threadMessage: self
]

{ #category : #accessing }
GtOpenAIWardleyMapActionThreadMessage >> explanationCodeBlock [
	^ self codeBlocks
		detect: [ :aCodeBlock | aCodeBlock isForLanguage: 'explanation' ]
		ifNone: [ nil ]
]

{ #category : #accessing }
GtOpenAIWardleyMapActionThreadMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView explicit
		title: 'Content';
		priority: 5;
		stencil: [ GtLlmActionThreadMessageElement new threadMessageViewModel: self asViewModel ]
]

{ #category : #accessing }
GtOpenAIWardleyMapActionThreadMessage >> gtExplanationFor: aView [
	<gtView>
	<gtLlmMessageView>
	self explanationCodeBlock ifNil: [ ^ aView empty ].

	^ aView textEditor
		title: 'Explanation';
		priority: 2;
		text: [ self explanationCodeBlock code value ];
		styler: (GtLlmMessageStyler new threadMessageViewModel: self)
]

{ #category : #accessing }
GtOpenAIWardleyMapActionThreadMessage >> gtWardleyMapFor: aView [
	<gtView>
	<gtLlmMessageView>
	self mapCodeBlock ifNil: [ ^ aView empty ].

	^ aView explicit
		title: 'Map';
		priority: 1;
		stencil: [ GtWardleyMapElement new
				wardleyMapViewModel: (GtWardleyMapViewModel new
						wardleyMapModel: (GtWardleyMapParser parse: self mapCodeBlock code value) asWardleyMapModel);
				vExact: 500 ]
]

{ #category : #accessing }
GtOpenAIWardleyMapActionThreadMessage >> mapCodeBlock [
	^ self codeBlocks
		detect: [ :aCodeBlock | aCodeBlock isForLanguage: 'wardley-map' ]
		ifNone: [ nil ]
]

{ #category : #accessing }
GtOpenAIWardleyMapActionThreadMessage >> spacerHeaderItem [
	<gtLlmHeaderItem: 3>
	^ BrFrame new matchParent
]
