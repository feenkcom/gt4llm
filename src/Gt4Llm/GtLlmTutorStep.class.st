Class {
	#name : #GtLlmTutorStep,
	#superclass : #Object,
	#instVars : [
		'name',
		'description',
		'rules',
		'pipeline'
	],
	#category : #'Gt4Llm-Examples'
}

{ #category : #accessing }
GtLlmTutorStep >> asInstruction [
	^ GtLlmInstructionSection new
		source: self;
		title: self name;
		body: (GtLlmCompositeInstruction new
				addItem: self description;
				addItem: (GtLlmInstructionList new items: self rules))
]

{ #category : #accessing }
GtLlmTutorStep >> description [
	^ description
]

{ #category : #accessing }
GtLlmTutorStep >> description: anObject [
	description := anObject
]

{ #category : #accessing }
GtLlmTutorStep >> gtInstructionsFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Instructions';
		priority: 3;
		text: [ self asInstruction instructionString ]
]

{ #category : #accessing }
GtLlmTutorStep >> gtPipelineFor: aView [
	<gtView>
	^ aView forward
		title: 'Pipeline';
		priority: 2;
		object: [self pipeline];
		view: #gtCompositionFor:
]

{ #category : #accessing }
GtLlmTutorStep >> gtSummary [
	^ {'Name' -> self name.
		'Description' -> self description.
		'Rules' -> self rules}
]

{ #category : #accessing }
GtLlmTutorStep >> gtSummaryFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Summary';
		priority: 1;
		items: [ self gtSummary ];
		column: 'Property'
			text: #key
			width: 120;
		column: 'Value' text: #value;
		send: #value;
		actionUpdateButton
]

{ #category : #accessing }
GtLlmTutorStep >> name [
	^ name
]

{ #category : #accessing }
GtLlmTutorStep >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtLlmTutorStep >> pipeline [
	^ pipeline
]

{ #category : #accessing }
GtLlmTutorStep >> pipeline: anObject [
	pipeline := anObject
]

{ #category : #accessing }
GtLlmTutorStep >> rules [
	^ rules
]

{ #category : #accessing }
GtLlmTutorStep >> rules: anObject [
	rules := anObject
]
