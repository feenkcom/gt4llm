"
I build the dropdown content that confirms closing a GtLACPSession: a text explaining what closing does and a button that closes the session. I am used by GtLACPSession>>#gtCloseFor: and am modeled after GtCoderRemoveClassPreviewStencil.
"
Class {
	#name : #GtLACPCloseSessionConfirmationStencil,
	#superclass : #BrStencil,
	#instVars : [
		'session',
		'menuModel'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #'api - instantiation' }
GtLACPCloseSessionConfirmationStencil >> create [
	^ BrVerticalPane new
		fitContent;
		id: #'acp-close-session-confirmation';
		addChild: self newTitleLabel;
		addChild: (self
				newDetailsLabel: 'The conversation stays visible, but you can no longer send prompts to it.');
		addChild: (self
				newDetailsLabel: 'Pending permission requests are cancelled and subagent sessions close too.');
		addChild: (self newDetailsLabel: 'The agent process stops if no other session uses it.');
		addChild: self newCloseButton;
		yourself
]

{ #category : #accessing }
GtLACPCloseSessionConfirmationStencil >> menuModel: aMenuModel [
	menuModel := aMenuModel
]

{ #category : #'instance creation' }
GtLACPCloseSessionConfirmationStencil >> newCloseButton [
	^ BrButton new
		id: #'acp-close-session-confirm';
		aptitude: BrGlamorousButtonWithLabelAptitude;
		beSmallSize;
		margin: (BlInsets all: 10);
		label: 'Close session';
		action: [ menuModel ifNotNil: [ :aMenuModel | aMenuModel hideAll ].
			session close ]
]

{ #category : #'instance creation' }
GtLACPCloseSessionConfirmationStencil >> newDetailsLabel: aString [
	^ BrLabel new
		margin: (BlInsets left: 10 right: 10);
		aptitude: BrGlamorousLabelAptitude new glamorousRegularFont thin;
		text: aString asRopedText
]

{ #category : #'instance creation' }
GtLACPCloseSessionConfirmationStencil >> newTitleLabel [
	^ BrLabel new
		margin: (BlInsets all: 10);
		aptitude: BrGlamorousLabelAptitude new glamorousRegularFont;
		text: ('Close session {1}?' format: {session conversationTitle}) asRopedText
]

{ #category : #accessing }
GtLACPCloseSessionConfirmationStencil >> session: aSession [
	session := aSession
]
