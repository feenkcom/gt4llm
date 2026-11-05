"
I am the Magritte form for renaming a GtLACPSession: one title field and an accept button that sets the session's conversation title. I am used by GtLACPSession>>#gtRenameFor: and am modeled after GtGitNewBranchForm.
"
Class {
	#name : #GtLACPRenameSessionForm,
	#superclass : #Object,
	#instVars : [
		'session',
		'menuModel',
		'title'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #converting }
GtLACPRenameSessionForm >> asElement [
	^ (self asGtMagritteViewModel
		focusFirstInputField) asElement
		id: #'acp-rename-session-form';
		padding: (BlInsets all: 5);
		yourself
]

{ #category : #magritte }
GtLACPRenameSessionForm >> magritteAcceptAction [
	<magritteActionDescription>
	^ super magritteAcceptAction
		onSuccessCallback: (GtMagritteCallback new
				action: [ :aModel :aButton :aMemento :aDescription | 
					session conversationTitle: title trimBoth.
					BlTaskAction
						enqueueElement: aButton
						action: [ menuModel ifNotNil: #hideAll ] ])
]

{ #category : #magritte }
GtLACPRenameSessionForm >> magritteCancelAction [
	<magritteActionDescription>
	^ nil
]

{ #category : #accessing }
GtLACPRenameSessionForm >> menuModel: aMenuModel [
	menuModel := aMenuModel
]

{ #category : #accessing }
GtLACPRenameSessionForm >> session: aSession [
	session := aSession.
	title := aSession conversationTitle
]

{ #category : #accessing }
GtLACPRenameSessionForm >> title [
	^ title
]

{ #category : #accessing }
GtLACPRenameSessionForm >> title: aString [
	title := aString
]

{ #category : #magritte }
GtLACPRenameSessionForm >> titleDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Title';
		priority: 1;
		accessor: #title;
		beRequired;
		addCondition: [ :aString | aString trimBoth isNotEmpty ]
			labelled: 'Enter a title'
]
