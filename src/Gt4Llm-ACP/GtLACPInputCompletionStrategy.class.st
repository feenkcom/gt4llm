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
	^ ((self commandsFor: aText at: anIndex)
		collect: [ :command | 
			(GtReplaceSubtextCompletionAction labeled: command invocation)
				start: 0;
				end: token size;
				text: command invocation;
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
]

{ #category : #accessing }
GtLACPInputCompletionStrategy >> session: aSession [
	session := aSession
]
