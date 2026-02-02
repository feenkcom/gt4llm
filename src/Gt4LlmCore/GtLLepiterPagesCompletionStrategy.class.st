Class {
	#name : #GtLLepiterPagesCompletionStrategy,
	#superclass : #GtStreamedCompletionStrategy,
	#instVars : [
		'candidatePools',
		'database'
	],
	#category : #'Gt4LlmCore-UI'
}

{ #category : #accessing }
GtLLepiterPagesCompletionStrategy >> completionActionStreamFor: aText at: positionInteger requested: aBoolean [
	| currentInput |
	currentInput := aText asString.
	^ (database asyncPagesForWord: currentInput)
		collect:
			[ :page | 
			GtInsertTextCompletionAction
				labeled: (self labelFor: page title withSearch: currentInput)
				completion: (page title allButFirst: currentInput size)
				position: positionInteger
				from: positionInteger - currentInput size + 1 ]
]

{ #category : #private }
GtLLepiterPagesCompletionStrategy >> database: aLepiterBase [ 
	database := aLepiterBase
]

{ #category : #testing }
GtLLepiterPagesCompletionStrategy >> hasCompletionsAt: anInteger in: aText [
	^ true
]
