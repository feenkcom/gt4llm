"
I confirm removal of a session from a registry without closing the session. My accept button dismisses the menu and removes the session only after explicit confirmation.
"
Class {
	#name : #GtLACPRemoveSessionConfirmationStencil,
	#superclass : #BrStencil,
	#instVars : [
		'registry',
		'session',
		'menuModel'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #'instance creation' }
GtLACPRemoveSessionConfirmationStencil >> create [
	^ BrVerticalPane new
		fitContent;
		id: #'acp-remove-session-confirmation';
		padding: (BlInsets all: 5);
		addChild: (BrLabel new
				aptitude: BrGlamorousLabelAptitude;
				text: ('Remove session {1} from the registry?' format: {session conversationTitle}));
		addChild: (BrLabel new
				margin: (BlInsets bottom: 5);
				aptitude: BrGlamorousLabelAptitude new glamorousRegularFont thin;
				text: 'The session remains unchanged but will no longer appear in this registry.');
		addChild: (BrButton new
				id: #'acp-remove-session-accept';
				aptitude: BrGlamorousButtonWithLabelAptitude;
				beSmallSize;
				label: 'Remove session';
				action: [ menuModel ifNotNil: #hideAll.
					registry removeSession: session ]);
		yourself
]

{ #category : #accessing }
GtLACPRemoveSessionConfirmationStencil >> menuModel: aMenu [
	menuModel := aMenu
]

{ #category : #accessing }
GtLACPRemoveSessionConfirmationStencil >> registry: aRegistry [
	registry := aRegistry
]

{ #category : #accessing }
GtLACPRemoveSessionConfirmationStencil >> session: aSession [
	session := aSession
]
