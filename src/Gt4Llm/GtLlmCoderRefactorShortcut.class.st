Class {
	#name : #GtLlmCoderRefactorShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'Gt4Llm-Coder'
}

{ #category : #accessing }
GtLlmCoderRefactorShortcut >> description [
	^ 'Asks OpenAI to refactor the method.'
]

{ #category : #accessing }
GtLlmCoderRefactorShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryShiftR
]

{ #category : #accessing }
GtLlmCoderRefactorShortcut >> name [
	^ 'Refactor (OpenAI)'
]

{ #category : #accessing }
GtLlmCoderRefactorShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coderViewModel: aCoderViewModel dueTo: aShortcutEvent [
	| aChat |
	aChat := aCoderViewModel coderModel openAITutorChat.
	aChat sendMessage: 'Propose refactoring for method'.
	(aChat whenReadyFuture
		then: [ aCoderViewModel coderModel
				currentSourceString: aChat messages first smalltalkMethodSource methodSource ])
		await
]
