Class {
	#name : #GtLlmTutor,
	#superclass : #Object,
	#instVars : [
		'providerStencil',
		'instruction'
	],
	#category : #Gt4Llm
}

{ #category : #other }
GtLlmTutor class >> new [
	^ self basicNew initialize
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> actionFormatDescription [
	<gtLlmTutorFormat>
	^ GtLlmTutorFormatDescription new beRequired
		name: 'Action';
		format: 'Text';
		example: '```text
Create a draft
```'
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> actionNamed: anActionName [
	^ self instruction actionNamed: anActionName
]

{ #category : #accessing }
GtLlmTutor >> actions [
	^ instruction actions
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> addAction: anAction [
	instruction addAction: (anAction tutor: self)
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> addFormat: aComponent [
	instruction addComponent: aComponent
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> addInstructionSection: aSection [
	instruction addSection: aSection
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> chatAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new 
		name: 'Chat';
		priority: 1;
		description: 'Chat using the text field.';
		format: 'Chat: {1}';
		examples: {GtLlmTutorActionExample new markUnverified
					input: {'Action' -> 'Chat: How are you?'} asDictionary;
					output: {'Action' -> 'Chat'.
							'Text'
								-> 'As an AI model, I do not have feelings. How can I assist you today?'}
							asDictionary}
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> collectActions [
	^ (((Pragma
		allNamed: #gtLlmTutorAction
		from: self class
		to: Object) collect: #methodSelector as: Set)
		collect: [ :aSelector | (self perform: aSelector) tutor: self ])
		sorted: [ :a :b | a priority < b priority ]
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> collectFormats [
	^ ((Pragma
		allNamed: #gtLlmTutorFormat
		from: self class
		to: Object)
		collect: [ :aPragma | (self perform: aPragma methodSelector) tutor: self ])
		sorted: [ :a :b | a priority < b priority ]
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> collectSections [
	^ (Pragma
		allNamed: #gtLlmInstructionSection
		from: self class
		to: Object) collect: [ :aPragma | self perform: aPragma methodSelector ]
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> createChat [
	^ GtLlmActionChat new
		provider: (self providerStencil value: instruction);
		tutor: self
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> defaultDescription [
	^ 'You are an assistant.'
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> description [
	^ self instruction description
]

{ #category : #accessing }
GtLlmTutor >> description: anObject [
	instruction description: anObject
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> formatComponents [
	^ instruction formats
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> formatNamed: aString [
	^ instruction componentNamed: aString
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> gtInstructionFor: aView [
	<gtView>
	^ aView forward
		title: 'Instruction';
		priority: 10;
		object: [ instruction asInstructionPiece ];
		view: #gtInstructionFor:
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> initialize [
	super initialize.
	self providerStencil: self defaultProviderStencil.
	
	
	self initializeInstruction.
	
	self description: self defaultDescription
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> initializeInstruction [
	instruction := GtLlmTutorInstruction new.
	instruction
		addComponents: self collectFormats;
		addActions: self collectActions;
		addSections: self collectSections
]

{ #category : #accessing }
GtLlmTutor >> instruction [
	^ instruction
]

{ #category : #accessing }
GtLlmTutor >> onAnthropicWithModel: aModel [
	self providerStencil: (self defaultAnthropicProviderStencilWithModel: aModel)
]

{ #category : #accessing }
GtLlmTutor >> providerStencil [
	^ providerStencil
]

{ #category : #accessing }
GtLlmTutor >> providerStencil: anObject [
	providerStencil := anObject
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> recomputeActions [
	instruction replaceActions: self collectActions
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> recomputeFormats [
	instruction replaceComponents: self collectFormats
]

{ #category : #'as yet unclassified' }
GtLlmTutor >> textFormatDescription [
	<gtLlmTutorFormat>
	^ GtLlmTutorFormatDescription new
		name: 'Text';
		priority: 2;
		format: 'Text';
		example: '```text
This node contains plain text.
Multiple lines, multiple paragraphs are allowed.

*markup* may also **be used**. `Code` can be highlighted, but code blocks with three tick marks MAY NOT be used.

# Headings exist as well
```'
]
