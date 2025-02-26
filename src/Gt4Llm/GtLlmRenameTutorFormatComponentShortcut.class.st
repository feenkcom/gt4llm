Class {
	#name : #GtLlmRenameTutorFormatComponentShortcut,
	#superclass : #GtSourceCoderInlineRenameShortcut,
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmRenameTutorFormatComponentShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryShiftR
]

{ #category : #'as yet unclassified' }
GtLlmRenameTutorFormatComponentShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coderViewModel: aSourceCoderViewModel dueTo: aShortcutEvent [
	| position |
	self
		forEditor: aBrTextEditor
		selectionIntervalDo: [ :aSelectionInterval | position := aSelectionInterval last ]
		orCursorStringPositionDo: [ :aCursorTextPosition | position := aCursorTextPosition ].
	position notNil
		ifTrue: [ (aSourceCoderViewModel coder
				renameFormatComponentAt: position
				in: aSourceCoderViewModel
				from: aBrEditorElement) ifTrue: [ ^ self ] ].
	super
		performOnEditor: aBrTextEditor
		element: aBrEditorElement
		coderViewModel: aSourceCoderViewModel
		dueTo: aShortcutEvent
]
