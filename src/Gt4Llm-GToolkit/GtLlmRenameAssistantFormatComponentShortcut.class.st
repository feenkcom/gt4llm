Class {
	#name : #GtLlmRenameAssistantFormatComponentShortcut,
	#superclass : #GtSourceCoderInlineRenameShortcut,
	#category : #'Gt4Llm-GToolkit-UI'
}

{ #category : #'as yet unclassified' }
GtLlmRenameAssistantFormatComponentShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryShiftR
]

{ #category : #'as yet unclassified' }
GtLlmRenameAssistantFormatComponentShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coderViewModel: aSourceCoderViewModel dueTo: aShortcutEvent [
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
