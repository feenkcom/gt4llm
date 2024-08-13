Class {
	#name : #GtLlmTutorActionExample,
	#superclass : #Object,
	#instVars : [
		'input',
		'output',
		'inputReferences',
		'action',
		'outputReferences'
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
	^ inputReferences, outputReferences
]

{ #category : #accessing }
GtLlmTutorActionExample >> gtInputFormatReferencesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Input format references';
		priority: 5;
		items: [ self inputReferences ];
		column: 'Name' text: #name;
		column: 'Format' text: #format
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
GtLlmTutorActionExample >> gtOutputFormatReferencesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Output format references';
		priority: 6;
		items: [ self outputReferences ];
		column: 'Name' text: #name;
		column: 'Format' text: #format
]

{ #category : #accessing }
GtLlmTutorActionExample >> initialize [
	super initialize.
	
	inputReferences := OrderedCollection new.
	outputReferences := OrderedCollection new
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
	^ STONJSON toStringPretty: self input
]

{ #category : #accessing }
GtLlmTutorActionExample >> inputReferences [
	^ inputReferences
]

{ #category : #accessing }
GtLlmTutorActionExample >> inputReferences: anObject [
	inputReferences := anObject
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
	^ STONJSON toStringPretty: self output
]

{ #category : #accessing }
GtLlmTutorActionExample >> outputReferences [
	^ outputReferences
]

{ #category : #accessing }
GtLlmTutorActionExample >> outputReferences: anObject [
	outputReferences := anObject
]

{ #category : #accessing }
GtLlmTutorActionExample >> resolveReferences [
	inputReferences := input associations
			select: [ :anAssociation | anAssociation value isNotNil ]
			thenCollect: [ :anAssociation | 
				(self action tutor formatComponentNamed: anAssociation key)
					addInputReference: self action ].
	outputReferences := output associations
			select: [ :anAssociation | anAssociation value isNotNil ]
			thenCollect: [ :anAssociation | 
				(self action tutor formatComponentNamed: anAssociation key)
					addOutputReference: self action ]
]

{ #category : #accessing }
GtLlmTutorActionExample >> verify [
	self
		assert: self output keys asSet
				= (self action tutor formatComponents collect: #name) asSet
		description: 'Keys in the example output must correspond to the action format'
]
