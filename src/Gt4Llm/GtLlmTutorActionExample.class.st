Class {
	#name : #GtLlmTutorActionExample,
	#superclass : #Object,
	#instVars : [
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
						body: ('```
' , self inputJson
								, '
```') asInstruction);
				addItem: (GtLlmInstructionSection new
						source: self;
						title: 'Output';
						body: ('```
' , self outputJson
								, '
```') asInstruction))
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
GtLlmTutorActionExample >> inputDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Input';
		beRequired;
		priority: 2;
		accessor: #input
]

{ #category : #accessing }
GtLlmTutorActionExample >> inputJson [
	^ STONJSON toString: self input
]

{ #category : #accessing }
GtLlmTutorActionExample >> output [
	^ output
]

{ #category : #accessing }
GtLlmTutorActionExample >> output: anObject [
	output := anObject
]

{ #category : #accessing }
GtLlmTutorActionExample >> outputDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Output';
		beRequired;
		priority: 2;
		accessor: #output
]

{ #category : #accessing }
GtLlmTutorActionExample >> outputJson [
	^ STONJSON toString: self output
]
