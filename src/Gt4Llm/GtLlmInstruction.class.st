Class {
	#name : #GtLlmInstruction,
	#superclass : #Object,
	#category : #'Gt4Llm-Instructions'
}

{ #category : #accessing }
GtLlmInstruction >> gtInstructionFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Instruction';
		priority: 1;
		text: [ self instructionString ]
]

{ #category : #accessing }
GtLlmInstruction >> instructionString [
	^ self subclassResponsibility
]
