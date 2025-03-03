Extension { #name : #GtLlmInstructionPiece }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmInstructionPiece >> gtInstructionFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Instruction';
		priority: 1;
		text: [ self instructionString ];
		styler: (GtLlmMessageStyler new
				threadMessageViewModel: (GtLlmNewThreadMessageViewModel new threadMessage: GtLlmNewThreadMessage new))
]
