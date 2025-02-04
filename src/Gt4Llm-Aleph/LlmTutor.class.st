Class {
	#name : #LlmTutor,
	#superclass : #Object,
	#instVars : [
		'providerStencil',
		'instruction'
	],
	#category : #'Gt4Llm-Aleph'
}

{ #category : #'as yet unclassified' }
LlmTutor >> actionNamed: anActionName [
	^ self format actionNamed: anActionName
]

{ #category : #accessing }
LlmTutor >> actions [
	^ instruction actions
]

{ #category : #'as yet unclassified' }
LlmTutor >> addAction: anAction [
	instruction addAction: (anAction tutor: self)
]

{ #category : #'as yet unclassified' }
LlmTutor >> addFormat: aComponent [
	instruction addComponent: aComponent
]

{ #category : #'as yet unclassified' }
LlmTutor >> chatAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Answer a chat request';
		priority: 1;
		description: 'Answers a chat request using the text field.';
		format: 'Chat request: {1}';
		examples: {GtLlmTutorActionExample new markUnverified
					input: {'Action' -> 'Chat request: How are you?'} asDictionary;
					output: {'Action' -> 'Answer a chat request'.
							'Text'
								-> 'As an AI model, I do not have feelings. How can I assist you today?'}
							asDictionary}
]

{ #category : #'as yet unclassified' }
LlmTutor >> collectActions [
	^ ((Pragma
		allNamed: #gtLlmTutorAction
		from: self class
		to: Object)
		collect: [ :aPragma | (self perform: aPragma methodSelector) tutor: self ])
		sorted: [ :a :b | a priority < b priority ]
]

{ #category : #'as yet unclassified' }
LlmTutor >> collectFormats [
	^ ((Pragma
		allNamed: #gtLlmTutorFormat
		from: self class
		to: Object)
		collect: [ :aPragma | (self perform: aPragma methodSelector) tutor: self ])
		sorted: [ :a :b | a priority < b priority ]
]

{ #category : #'as yet unclassified' }
LlmTutor >> createChat [
	^ GtLlmActionChat new
		provider: (self providerStencil value: instruction) beActionBased;
		tutor: self
]

{ #category : #accessing }
LlmTutor >> description: anObject [
	instruction description: anObject
]

{ #category : #'as yet unclassified' }
LlmTutor >> formatComponents [
	^ instruction formats
]

{ #category : #'as yet unclassified' }
LlmTutor >> formatNamed: aString [
	^ instruction componentNamed: aString
]

{ #category : #'as yet unclassified' }
LlmTutor >> gtActionsFor: aView [
	<gtView>
	^ aView forward
		title: 'Actions';
		priority: 10;
		object: [ self instruction ];
		view: #gtActionsFor:
]

{ #category : #'as yet unclassified' }
LlmTutor >> gtFormatComponentsFor: aView [
	<gtView>
	^ aView forward
		title: 'Format components';
		priority: 11;
		object: [ instruction ];
		view: #gtFormatsFor:
]

{ #category : #'as yet unclassified' }
LlmTutor >> gtInstructionFor: aView [
	<gtView>
	^ aView forward
		title: 'Instruction';
		priority: 10;
		object: [ instruction asInstructionPiece ];
		view: #gtInstructionFor:
]

{ #category : #'as yet unclassified' }
LlmTutor >> initialize [
	super initialize.

	self initializeInstruction
]

{ #category : #'as yet unclassified' }
LlmTutor >> initializeInstruction [
	instruction := LlmTutorInstruction new.
	instruction
		addComponents: self collectFormats;
		addActions: self collectActions
]

{ #category : #accessing }
LlmTutor >> instruction [
	^ instruction
]

{ #category : #accessing }
LlmTutor >> providerStencil [
	^ providerStencil
]

{ #category : #accessing }
LlmTutor >> providerStencil: anObject [
	providerStencil := anObject
]

{ #category : #'as yet unclassified' }
LlmTutor >> textFormatDescription [
	<gtLlmTutorFormat>
	^ GtLlmTutorFormatDescription new
		name: 'Text';
		priority: 2;
		format: 'Text';
		example: '```
This node contains plain text.
Multiple lines, multiple paragraphs are allowed.

*markup* may also **be used**. `Code` can be highlighted, but code blocks with three tick marks MAY NOT be used.

# Headings exist as well
```'
]
