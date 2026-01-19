Extension { #name : #GtLlmInstructionPiece }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmInstructionPiece >> gtInstructionFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Instruction';
		priority: 1;
		text: [ self instructionString trimBoth ];
		styler: (GtLlmMessageStyler new
				threadMessageViewModel: (GtLlmNewThreadMessageViewModel new threadMessage: GtLlmNewThreadMessage new))
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmInstructionPiece >> gtTreeFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'Tree';
		priority: 2;
		items: [ {self} ];
		children: #children;
		column: 'Text' text: [:each | each gtDisplayString ];
		column: 'Type' text: [:each | (each class name removePrefix: 'GtLlmInstruction') asRopedText foreground: Color gray ] width: 100;
		expandAll
]
