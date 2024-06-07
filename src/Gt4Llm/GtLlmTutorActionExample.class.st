Class {
	#name : #GtLlmTutorActionExample,
	#superclass : #Object,
	#instVars : [
		'instruction',
		'input',
		'output'
	],
	#category : #'Gt4Llm-Tutor'
}

{ #category : #accessing }
GtLlmTutorActionExample >> asInstruction [
	^ GtLlmCompositeInstruction new
		addItem: (GtLlmInstructionSection new
				source: self;
				title: 'Prompt';
				body: (GtLlmCompositeInstruction new
						items: {self instruction asInstruction.
								(String cr
									, 'State:', String cr, self input ) asInstruction}));
		addItem: (GtLlmInstructionSection new
				source: self;
				title: 'Output';
				body: (self output asInstruction))
]

{ #category : #accessing }
GtLlmTutorActionExample >> gtInstructionFor: aView [
	<gtView>
	^ aView forward
		title: 'Instruction';
		priority: 1;
		object: [ self asInstruction ];
		view: #gtInstructionFor:
]

{ #category : #accessing }
GtLlmTutorActionExample >> input [
	^ input
]

{ #category : #accessing }
GtLlmTutorActionExample >> input: anObject [
	input := anObject
]

{ #category : #accessing }
GtLlmTutorActionExample >> instruction [
	^ instruction
]

{ #category : #accessing }
GtLlmTutorActionExample >> instruction: anObject [
	instruction := anObject
]

{ #category : #accessing }
GtLlmTutorActionExample >> output [
	^ output
]

{ #category : #accessing }
GtLlmTutorActionExample >> output: anObject [
	output := anObject
]
