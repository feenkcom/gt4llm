"
I complete a command with advertised argument choices and reopen native completion at its argument position.
"
Class {
	#name : #GtLACPCommandCompletionAction,
	#superclass : #GtReplaceSubtextCompletionAction,
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #completing }
GtLACPCommandCompletionAction >> finishCompletionOn: aCompletionController moveCursor: aBoolean [
	super finishCompletionOn: aCompletionController moveCursor: aBoolean.
	aCompletionController announcer
		when: GtCompleterCompletionAccepted
		do: [ :event | 
			aCompletionController announcer unsubscribe: self.
			aCompletionController startCompletion ]
		for: self
]
