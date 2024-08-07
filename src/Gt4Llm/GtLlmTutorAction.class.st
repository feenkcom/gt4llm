Class {
	#name : #GtLlmTutorAction,
	#superclass : #Object,
	#instVars : [
		'name',
		'examples',
		'pipeline',
		'description',
		'format',
		'priority'
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
GtLlmTutorAction >> defaultPriority [
	^ 10
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
GtLlmTutorAction >> descriptionDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Description';
		beRequired;
		priority: 3;
		accessor: #description
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
GtLlmTutorAction >> examplesDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		label: 'Examples';
		priority: 5;
		accessor: #examples;
		classes: {GtLlmTutorActionExample};
		beModifiable;
		blocItemStencil: [ :anItemViewModel :anItemIndex | 
			anItemViewModel asElement
				fitContent;
				border: (BlBorder paint: BrGlamorousColors disabledButtonBorderColor width: 1);
				margin: (BlInsets
						top: 0
						right: 5
						bottom: 5
						left: 0);
				padding: (BlInsets all: 5);
				background: Color white ];
		  newItemStencil: [ GtLlmTutorActionExample new ]
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
GtLlmTutorAction >> formatDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Format';
		beRequired;
		priority: 5;
		accessor: #format
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
GtLlmTutorAction >> initialize [
	super initialize.
	
	self priority: self defaultPriority.
	self examples: OrderedCollection new
]

{ #category : #accessing }
GtLlmTutorAction >> name [
	^ name
]

{ #category : #accessing }
GtLlmTutorAction >> name: anObject [
	name := anObject.
	self format ifNil: [ self format: name ]
]

{ #category : #accessing }
GtLlmTutorAction >> nameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Name';
		beRequired;
		priority: 1;
		accessor: #name
]

{ #category : #accessing }
GtLlmTutorAction >> pipeline [
	^ pipeline
]

{ #category : #accessing }
GtLlmTutorAction >> pipeline: anObject [
	pipeline := anObject
]

{ #category : #accessing }
GtLlmTutorAction >> priority [
	^ priority
]

{ #category : #accessing }
GtLlmTutorAction >> priority: anObject [
	priority := anObject
]

{ #category : #accessing }
GtLlmTutorAction >> priorityDescription [
	<magritteDescription>
	^ MANumberDescription new
		label: 'Priority';
		priority: 2;
		accessor: #priority
]
