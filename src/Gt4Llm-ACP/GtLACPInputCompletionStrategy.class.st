"
Completes the leading slash command from the session's current commands and skills.
"
Class {
	#name : #GtLACPInputCompletionStrategy,
	#superclass : #GtStreamedCompletionStrategy,
	#instVars : [
		'session'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #completion }
GtLACPInputCompletionStrategy >> argumentCompletionActionsFor: aText at: anIndex [
	| string token command start stop prefix |
	string := aText asString.
	token := self commandTokenIn: aText.
	(token isEmpty or: [ anIndex <= token size or: [ anIndex > string size ] ])
		ifTrue: [ ^ #() ].
	command := self commandFor: aText.
	command ifNil: [ ^ #() ].
	start := token size + 1.
	[ start <= string size and: [ (string at: start) isSeparator ] ]
		whileTrue: [ start := start + 1 ].
	stop := start.
	[ stop <= string size and: [ (string at: stop) isSeparator not ] ]
		whileTrue: [ stop := stop + 1 ].
	(anIndex < (start - 1) or: [ anIndex >= stop ]) ifTrue: [ ^ #() ].
	prefix := string copyFrom: start to: anIndex.
	^ (command argumentChoices
		select: [ :choice | choice asLowercase beginsWith: prefix asLowercase ])
		collect: [ :choice | 
			(GtReplaceSubtextCompletionAction labeled: choice)
				start: start - 1;
				end: stop - 1;
				text: choice;
				yourself ]
]

{ #category : #completion }
GtLACPInputCompletionStrategy >> commandFor: aText [
	| token |
	token := self commandTokenIn: aText.
	^ session availableCommands
		detect: [ :command | command invocation = token ]
		ifNone: [ nil ]
]

{ #category : #completion }
GtLACPInputCompletionStrategy >> commandTokenIn: aText [
	| string end |
	string := aText asString.
	(string isEmpty or: [ ('/$' includes: string first) not ]) ifTrue: [ ^ '' ].
	end := string findFirst: [ :character | character isSeparator ].
	^ end = 0 ifTrue: [ string ] ifFalse: [ string first: end - 1 ]
]

{ #category : #completion }
GtLACPInputCompletionStrategy >> commandsFor: aText at: anIndex [
	| prefix skillsOnly |
	prefix := self completionPrefixAt: anIndex in: aText.
	prefix ifNil: [ ^ #() ].
	skillsOnly := aText asString first = $$.
	^ session availableCommands items
		select: [ :command | 
			(skillsOnly not or: [ command isSkill ])
				and: [ command invocation allButFirst asLowercase beginsWith: prefix asLowercase ] ]
]

{ #category : #completion }
GtLACPInputCompletionStrategy >> completionActionStreamFor: aText at: anIndex requested: isRequested [
	| token |
	token := self commandTokenIn: aText.
	anIndex > token size
		ifTrue: [ ^ (self argumentCompletionActionsFor: aText at: anIndex) asAsyncStream ].
	^ ((self commandsFor: aText at: anIndex)
		collect: [ :command | 
			| chooseArguments actionClass |
			chooseArguments := command argumentChoices notEmpty
					and: [ aText size = token size ].
			actionClass := chooseArguments
					ifTrue: [ GtLACPCommandCompletionAction ]
					ifFalse: [ GtReplaceSubtextCompletionAction ].
			(actionClass
				labeled: (command inputHint
						ifEmpty: [ command invocation ]
						ifNotEmpty: [ :hint | command invocation , ' ' , hint ]))
				start: 0;
				end: token size;
				text: command invocation , (chooseArguments ifTrue: [ ' ' ] ifFalse: [ '' ]);
				yourself ]) asAsyncStream
]

{ #category : #completion }
GtLACPInputCompletionStrategy >> completionPrefixAt: anIndex in: aText [
	| token |
	token := self commandTokenIn: aText.
	(anIndex < 1 or: [ anIndex > token size ]) ifTrue: [ ^ nil ].
	^ (token first: anIndex) allButFirst
]

{ #category : #completion }
GtLACPInputCompletionStrategy >> hasCompletionsAt: anIndex in: aText [
	^ (self commandsFor: aText at: anIndex) notEmpty
		or: [ (self argumentCompletionActionsFor: aText at: anIndex) notEmpty ]
]

{ #category : #accessing }
GtLACPInputCompletionStrategy >> session: aSession [
	session := aSession
]
