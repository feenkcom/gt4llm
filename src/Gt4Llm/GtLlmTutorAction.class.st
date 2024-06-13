Class {
	#name : #GtLlmTutorAction,
	#superclass : #Object,
	#instVars : [
		'name',
		'examples',
		'pipeline',
		'description',
		'format'
	],
	#category : #'Gt4Llm-Actions'
}

{ #category : #accessing }
GtLlmTutorAction >> asInstruction [
	^ GtLlmInstructionSection new
		source: self;
		title: self name;
		body: (GtLlmCompositeInstruction new
				addItem: self description;
				addItem: (GtLlmInstructionSection new
						source: self;
						title: 'Examples';
						body: (GtLlmCompositeInstruction new items: self examples)))
]

{ #category : #accessing }
GtLlmTutorAction >> description [
	^ description
]

{ #category : #accessing }
GtLlmTutorAction >> description: anObject [
	description := anObject
]

{ #category : #accessing }
GtLlmTutorAction >> examples [
	^ examples
]

{ #category : #accessing }
GtLlmTutorAction >> examples: anObject [
	examples := anObject
]

{ #category : #accessing }
GtLlmTutorAction >> format [
	^ format
]

{ #category : #accessing }
GtLlmTutorAction >> format: anObject [
	format := anObject
]

{ #category : #accessing }
GtLlmTutorAction >> gtDescriptionFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Description';
		text: [ self description ]
]

{ #category : #accessing }
GtLlmTutorAction >> gtExamplesFor: aView [
	<gtView>
	^ aView list
		title: 'Examples';
		items: [ self examples ]
]

{ #category : #accessing }
GtLlmTutorAction >> gtInstructionFor: aView [
	<gtView>
	^ aView forward
		title: 'Instruction';
		priority: 1;
		object: [self asInstruction ];
		view: #gtInstructionFor:
]

{ #category : #accessing }
GtLlmTutorAction >> name [
	^ name
]

{ #category : #accessing }
GtLlmTutorAction >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtLlmTutorAction >> pipeline [
	^ pipeline
]

{ #category : #accessing }
GtLlmTutorAction >> pipeline: anObject [
	pipeline := anObject
]
