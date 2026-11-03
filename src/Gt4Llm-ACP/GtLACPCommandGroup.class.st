"
I hold a session's current advertised command snapshot, including skill commands. My views expose all entries, ordinary commands and skills, and update when the snapshot is replaced.
"
Class {
	#name : #GtLACPCommandGroup,
	#superclass : #Object,
	#traits : 'TGtGroupWithItems',
	#classTraits : 'TGtGroupWithItems classTrait',
	#instVars : [
		'items',
		'session'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #views }
GtLACPCommandGroup >> commandListFor: aView items: aBlock title: aTitle [
	| view |
	view := aView columnedList
			title: aTitle;
			priority: 0;
			items: aBlock;
			column: 'Invocation'
				text: #gtDisplayString
				width: 170;
			column: 'Description' text: #description;
			column: 'Input'
				text: #inputHint
				width: 140;
			actionUpdateButtonTooltip: 'Refresh available commands and skills'.
	session
		ifNotNil: [ view updateWhen: GtLACPCommandsChanged in: [ session announcer ] ].
	^ view
]

{ #category : #accessing }
GtLACPCommandGroup >> commands [
	^ (self items reject: #isSkill) asArray
]

{ #category : #views }
GtLACPCommandGroup >> gtAvailableFor: aView [
	<gtView>
	^ self
		commandListFor: aView
		items: [ self items ]
		title: 'Commands and skills'
]

{ #category : #views }
GtLACPCommandGroup >> gtCommandsFor: aView [
	<gtView>
	^ (self
		commandListFor: aView
		items: [ self commands ]
		title: 'Commands') priority: 1
]

{ #category : #views }
GtLACPCommandGroup >> gtSkillsFor: aView [
	<gtView>
	^ (self
		commandListFor: aView
		items: [ self skills ]
		title: 'Skills') priority: 2
]

{ #category : #accessing }
GtLACPCommandGroup >> session [
	^ session
]

{ #category : #accessing }
GtLACPCommandGroup >> session: aSession [
	session := aSession
]

{ #category : #accessing }
GtLACPCommandGroup >> skills [
	^ (self items select: #isSkill) asArray
]
