Extension { #name : #GtCoderKeymapRegistry }

{ #category : #'*Gt4Llm-GToolkit' }
GtCoderKeymapRegistry >> initializeLlmShortcutCombinations [
	<gtKeymapRegistration>
	self 
		initializeShortcut: GtCoderShortcutIds default llmRenameAssistantFormatComponentShortcutId
		with: BlKeyCombination primaryShiftR
]
