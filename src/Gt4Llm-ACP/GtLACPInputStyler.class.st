"
Styles the leading ACP invocation and attaches its session-aware completion strategy.
"
Class {
	#name : #GtLACPInputStyler,
	#superclass : #BlTextStyler,
	#instVars : [
		'completionStrategy'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #accessing }
GtLACPInputStyler >> completionStrategy [
	^ completionStrategy
]

{ #category : #styling }
GtLACPInputStyler >> privateStyle: aText [
	| token command completionEnd |
	token := completionStrategy commandTokenIn: aText.
	token ifEmpty: [ ^ aText ].
	command := completionStrategy commandFor: aText.
	completionEnd := (command notNil and: [ command argumentChoices notEmpty ])
			ifTrue: [ aText size ]
			ifFalse: [ token size ].
	(aText from: 1 to: completionEnd)
		attribute: (GtCompletionStrategyAttribute new strategy: completionStrategy).
	command ifNotNil: [ (aText from: 1 to: token size) bold ].
	^ aText
]

{ #category : #accessing }
GtLACPInputStyler >> session: aSession [
	completionStrategy := GtLACPInputCompletionStrategy new session: aSession
]
