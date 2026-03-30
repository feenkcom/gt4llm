Class {
	#name : #GtLLepiterPagesCompletionStrategy,
	#superclass : #GtStreamedCompletionStrategy,
	#instVars : [
		'candidatePools',
		'database'
	],
	#category : 'Gt4LlmCore-UI'
}

{ #category : #accessing }
GtLLepiterPagesCompletionStrategy >> completionActionStreamFor: aText at: positionInteger requested: aBoolean [
	| string first last stringToComplete |
	string := aText asString.
	first := positionInteger.
	[ first > 0 and: [ (string at: first) ~= $' ] ]
		whileTrue: [ first := first - 1 ].
	first = 0 ifTrue: [ ^ #() ].
	last := positionInteger.
	[ last <= string size and: [ (string at: last) ~= $' ] ]
		whileTrue: [ last := last + 1 ].
	stringToComplete := string copyFrom: first + 1 to: last - 1.
	^ (database asyncPagesForWord: stringToComplete)
		collect: [ :page | 
			| label |
			label := self labelFor: page title withSearch: stringToComplete.
			(GtCompositeCompletionAction labeled: label)
				addAction: (GtDeleteTextCompletionAction
						labeled: label
						from: first + 1
						to: last - 1);
				addAction: (GtInsertTextCompletionAction
						labeled: label
						completion: (page title)
						position: first
						from: first) ]
]

{ #category : #private }
GtLLepiterPagesCompletionStrategy >> database: aLepiterBase [ 
	database := aLepiterBase
]

{ #category : #testing }
GtLLepiterPagesCompletionStrategy >> hasCompletionsAt: anInteger in: aText [
	^ true
]
