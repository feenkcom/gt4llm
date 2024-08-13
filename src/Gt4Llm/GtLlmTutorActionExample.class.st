Class {
	#name : #GtLlmTutorActionExample,
	#superclass : #Object,
	#instVars : [
		'input',
		'output',
		'formatReferences',
		'action'
	],
	#category : #'Gt4Llm-Tutor'
}

{ #category : #accessing }
GtLlmTutorActionExample >> action [
	^ action
]

{ #category : #accessing }
GtLlmTutorActionExample >> action: anObject [
	action := anObject
]

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
GtLlmTutorActionExample >> formatReferences [
	^ formatReferences
]

{ #category : #accessing }
GtLlmTutorActionExample >> gtFormatReferencesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Format references';
		priority: 5;
		items: [ self formatReferences ];
		column: 'Name' text: #name;
		column: 'Format' text: #format;
		column: 'Priority' text: #priority
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
GtLlmTutorActionExample >> initialize [
	super initialize.
	
	formatReferences := OrderedCollection new
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

{ #category : #accessing }
GtLlmTutorActionExample >> resolveReferences [
	formatReferences := input keys , output keys
			collect: [ :aName | (self action tutor formatComponentNamed: aName) addReference: self action ]
]
