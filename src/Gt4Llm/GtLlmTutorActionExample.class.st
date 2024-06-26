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
	^ GtLlmInstructionSection new
		source: self;
		title: 'Example';
		body: (GtLlmCompositeInstruction new
				addItem: (GtLlmInstructionSection new
						source: self;
						title: 'Prompt';
						body: (GtLlmCompositeInstruction new
								items: {self instruction asInstruction.
										GtLlmInstructionSection new
											source: self;
											title: 'Current Wardley Map state';
											body: self input}));
				addItem: (GtLlmInstructionSection new
						source: self;
						title: 'Output';
						body: self output asInstruction))
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
